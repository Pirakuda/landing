<?php
// /scripts/Analytics.php - Исправленная версия без агрессивной фильтрации ботов

class Analytics {
    private $db;
    private $domain;
    private $language;
    private $organizationId;
    
    public function __construct(Database $db, string $domain, string $language = 'de', int $organizationId = 141) {
        $this->db = $db;
        $this->domain = $domain;
        $this->language = $language;
        $this->organizationId = $organizationId;
    }
    
    /**
     * Инициализирует сессию с упрощенной проверкой ботов
     */
    public function initSession(): array {
        try {
            $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
            $ipAddress = $this->getRealIpAddress();
            
            // Упрощенная проверка на очевидных ботов
            if ($this->isObviousBot($userAgent)) {
                return $this->createBotSession();
            }
            
            // Проверяем согласие на cookies
            $cookiesAccepted = isset($_COOKIE['cookies_accepted']) && $_COOKIE['cookies_accepted'] === 'true';
            
            if (!$cookiesAccepted) {
                return $this->createAnonymousSession();
            }
            
            // Создаем полную сессию для пользователей
            return $this->createFullSession();
            
        } catch (Exception $e) {
            error_log("Analytics initSession error: " . $e->getMessage());
            return $this->createFallbackSession();
        }
    }
    
    /**
     * УПРОЩЕННАЯ проверка на ботов - только очевидные случаи
     */
    private function isObviousBot(string $userAgent): bool {
        // Проверяем только явных ботов
        $obviousBots = [
            '/googlebot/i', '/bingbot/i', '/yandexbot/i', '/facebookexternalhit/i',
            '/twitterbot/i', '/whatsapp/i', '/telegrambot/i',
            '/curl\//i', '/wget/i', '/python-requests/i',
            '/spider/i', '/crawler/i', '/scraper/i'
        ];
        
        foreach ($obviousBots as $pattern) {
            if (preg_match($pattern, $userAgent)) {
                return true;
            }
        }
        
        // Пустой или слишком короткий User-Agent
        if (empty($userAgent) || strlen($userAgent) < 5) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Создает сессию для бота (не сохраняем в БД)
     */
    private function createBotSession(): array {
        return [
            'session_id' => 'bot_' . uniqid(),
            'visitor_id' => 'bot_' . md5($_SERVER['HTTP_USER_AGENT'] ?? ''),
            'device_type' => 'bot',
            'language' => $this->language,
            'is_anonymous' => true,
            'is_bot' => true
        ];
    }
    
    /**
     * Создает анонимную сессию (без cookies)
     */
    private function createAnonymousSession(): array {
        return [
            'session_id' => null,
            'visitor_id' => null,
            'device_type' => $this->detectDeviceType(),
            'language' => $this->language,
            'is_anonymous' => true,
            'is_bot' => false
        ];
    }
    
    /**
     * Создает полную сессию с согласием на cookies
     */
    private function createFullSession(): array {
        $sessionId = $this->getOrCreateSessionId();
        $visitorId = $this->getOrCreateVisitorId();
        
        // Определяем, возвращающийся ли пользователь
        $isReturning = $this->isReturningVisitor($visitorId);
        
        // Собираем данные сессии
        $sessionData = [
            'organization_id' => $this->organizationId,
            'session_id' => $sessionId,
            'visitor_id' => $visitorId,
            'ip_address' => $this->getRealIpAddress(),
            'user_agent' => substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 1000),
            'device_type' => $this->detectDeviceType(),
            'browser' => $this->detectBrowser(),
            'os' => $this->detectOS(),
            'language' => $this->detectLanguage(),
            'referrer' => $_SERVER['HTTP_REFERER'] ?? null,
            'utm_source' => $_GET['utm_source'] ?? null,
            'utm_medium' => $_GET['utm_medium'] ?? null,
            'utm_campaign' => $_GET['utm_campaign'] ?? null,
            'utm_content' => $_GET['utm_content'] ?? null,
            'utm_term' => $_GET['utm_term'] ?? null,
            'landing_page' => $_SERVER['REQUEST_URI'] ?? '/',
            'source' => $this->detectTrafficSource(),
            'is_returning' => $isReturning,
            'page_views' => 1,
            'session_duration' => 0,
            'total_sections' => 0,
            'bounce' => 1,
            'is_bot' => 0,
            'created_at' => date('Y-m-d H:i:s'),
            'last_activity' => date('Y-m-d H:i:s')
        ];
        
        // Сохраняем сессию в БД
        $this->saveOrUpdateSession($sessionData);
        
        return [
            'session_id' => $sessionId,
            'visitor_id' => $visitorId,
            'device_type' => $sessionData['device_type'],
            'language' => $sessionData['language'],
            'is_anonymous' => false,
            'is_bot' => false
        ];
    }
    
    private function createFallbackSession(): array {
        return [
            'session_id' => 'fallback_' . uniqid(),
            'visitor_id' => 'fallback_' . uniqid(),
            'device_type' => 'unknown',
            'language' => $this->language,
            'is_anonymous' => true,
            'is_bot' => false
        ];
    }
    
    private function getOrCreateSessionId(): string {
        if (isset($_COOKIE['analytics_session_id'])) {
            $sessionId = $_COOKIE['analytics_session_id'];
            if ($this->isSessionValid($sessionId)) {
                return $sessionId;
            }
        }
        
        $sessionId = 'sess_' . uniqid() . '_' . time();
        setcookie('analytics_session_id', $sessionId, time() + 1800, '/'); // 30 мин
        return $sessionId;
    }
    
    private function getOrCreateVisitorId(): string {
        if (isset($_COOKIE['analytics_visitor_id'])) {
            return $_COOKIE['analytics_visitor_id'];
        }
        
        $visitorId = 'visitor_' . uniqid() . '_' . time();
        setcookie('analytics_visitor_id', $visitorId, time() + (365 * 24 * 60 * 60 * 2), '/'); // 2 года
        return $visitorId;
    }
    
    private function isSessionValid(string $sessionId): bool {
        try {
            $result = $this->db->fetch(
                "SELECT last_activity FROM web_sessions 
                 WHERE session_id = ? AND organization_id = ?
                 ORDER BY last_activity DESC LIMIT 1",
                [$sessionId, $this->organizationId]
            );
            
            if (!$result) return false;
            
            $lastActivity = strtotime($result['last_activity']);
            $now = time();
            
            return ($now - $lastActivity) < 1800; // 30 минут
            
        } catch (Exception $e) {
            return false;
        }
    }
    
    private function isReturningVisitor(string $visitorId): bool {
        try {
            $result = $this->db->fetch(
                "SELECT id FROM web_sessions 
                 WHERE visitor_id = ? AND organization_id = ?
                 AND created_at < DATE_SUB(NOW(), INTERVAL 1 DAY) 
                 LIMIT 1",
                [$visitorId, $this->organizationId]
            );
            
            return !empty($result);
            
        } catch (Exception $e) {
            return false;
        }
    }
    
    private function saveOrUpdateSession(array $sessionData): void {
        try {
            $existing = $this->db->fetch(
                "SELECT id FROM web_sessions 
                 WHERE session_id = ? AND organization_id = ?",
                [$sessionData['session_id'], $this->organizationId]
            );
            
            if ($existing) {
                $this->db->query(
                    "UPDATE web_sessions 
                     SET last_activity = NOW(), page_views = page_views + 1, bounce = 0
                     WHERE session_id = ? AND organization_id = ?",
                    [$sessionData['session_id'], $this->organizationId]
                );
            } else {
                $fields = implode(', ', array_keys($sessionData));
                $placeholders = str_repeat('?,', count($sessionData) - 1) . '?';
                
                $this->db->query(
                    "INSERT INTO web_sessions ({$fields}) VALUES ({$placeholders})",
                    array_values($sessionData)
                );
            }
            
        } catch (Exception $e) {
            error_log("Error saving session: " . $e->getMessage());
        }
    }
    
    // Вспомогательные методы детекции
    private function detectDeviceType(): string {
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        
        if (preg_match('/tablet|ipad/i', $userAgent)) return 'tablet';
        if (preg_match('/mobile|android|iphone|phone/i', $userAgent)) return 'mobile';
        
        return 'desktop';
    }
    
    private function detectBrowser(): string {
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        
        if (strpos($userAgent, 'Chrome') !== false) return 'Chrome';
        if (strpos($userAgent, 'Firefox') !== false) return 'Firefox';
        if (strpos($userAgent, 'Safari') !== false) return 'Safari';
        if (strpos($userAgent, 'Edge') !== false) return 'Edge';
        if (strpos($userAgent, 'Opera') !== false) return 'Opera';
        
        return 'Other';
    }
    
    private function detectOS(): string {
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        
        if (strpos($userAgent, 'Windows') !== false) return 'Windows';
        if (strpos($userAgent, 'Mac') !== false) return 'MacOS';
        if (strpos($userAgent, 'Linux') !== false) return 'Linux';
        if (strpos($userAgent, 'Android') !== false) return 'Android';
        if (strpos($userAgent, 'iPhone') !== false) return 'iOS';
        
        return 'Other';
    }
    
    private function detectLanguage(): string {
        $acceptLanguage = $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? '';
        
        if (strpos($acceptLanguage, 'de') === 0) return 'de';
        if (strpos($acceptLanguage, 'en') === 0) return 'en';
        if (strpos($acceptLanguage, 'ru') === 0) return 'ru';
        
        return $this->language;
    }
    
    private function detectTrafficSource(): string {
        $referrer = $_SERVER['HTTP_REFERER'] ?? '';
        
        if (empty($referrer)) return 'direct';
        
        $host = parse_url($referrer, PHP_URL_HOST);
        
        if (strpos($host, 'google') !== false) return 'google';
        if (strpos($host, 'yandex') !== false) return 'yandex';
        if (strpos($host, 'bing') !== false) return 'bing';
        if (strpos($host, 'facebook') !== false) return 'social';
        if (strpos($host, 'vk.com') !== false) return 'social';
        if (strpos($host, 'instagram') !== false) return 'social';
        
        return 'referral';
    }
    
    private function getRealIpAddress(): string {
        $ipKeys = ['HTTP_X_FORWARDED_FOR', 'HTTP_X_REAL_IP', 'HTTP_CLIENT_IP', 'REMOTE_ADDR'];
        
        foreach ($ipKeys as $key) {
            if (!empty($_SERVER[$key])) {
                $ips = explode(',', $_SERVER[$key]);
                $ip = trim($ips[0]);
                
                if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)) {
                    return $ip;
                }
            }
        }
        
        return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
    }
}