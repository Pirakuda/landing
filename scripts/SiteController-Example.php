<?php
/**
 * SiteController - класс для управления структурой сайта и пользовательскими сессиями
 */
class SiteController {
    private $db;
    private $siteId;
    private $segmentId;
    private $session;
    private $mediaData = [];
    private $contentData = [];
    private $language;
    private $pageSlug;
    private $screenSlug;
    private $siteType;
    private $cachedPages = null;

    public function __construct(Database $db, $domain) {
        $this->db = $db;
        $this->siteId = 29; // $this->getSiteIdByDomain($domain);
        $this->parseUrl();
        $this->session = $this->initSession();
        $this->segmentId = $this->determineUserSegment();
    }

    private function getSiteIdByDomain($domain) {
        $site = $this->db->fetch(
            "SELECT id, type FROM sites WHERE domain = ? AND is_active = 1 LIMIT 1",
            [$domain]
        );
        if (!$site) {
            throw new Exception("Active site version not found for domain: $domain");
        }
        $this->siteType = $site['type'];
        return $site['id'];
    }

    private function getSiteType() {
        return $this->siteType;
    }

    private function parseUrl() {
        // Получаем REQUEST_URI и удаляем параметры запроса (?key=value)
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $uri = trim($uri, '/');
        error_log("Raw URI: $uri");

        // Определяем базовый путь (подкаталог)
        $basePath = defined('BASE_PATH') ? BASE_PATH : 'test';
        error_log("Base path: $basePath");

        // Удаляем базовый путь из URI, если он присутствует
        if ($basePath && strpos($uri, $basePath) === 0) {
            $uri = substr($uri, strlen($basePath));
            $uri = trim($uri, '/');
            error_log("URI after removing base path: $uri");
        }

        $parts = explode('/', $uri);
        $this->language = 'ru';
        $this->pageSlug = null;
        $this->screenSlug = null;

        if (count($parts) === 1 && !empty($parts[0])) {
            $this->pageSlug = $parts[0];
        } elseif (count($parts) === 2) {
            $this->pageSlug = $parts[0];
            $this->screenSlug = $parts[1];
        } elseif (count($parts) === 3) {
            $this->language = $parts[0];
            $this->pageSlug = $parts[1];
            $this->screenSlug = $parts[2];
        }

        $this->pageSlug = 'glavnaya';
        $this->screenSlug = 'obzor';
    }

    private function initSession() {
        $cookiesAccepted = isset($_COOKIE['cookies_accepted']) && $_COOKIE['cookies_accepted'] === 'true';
        if ($cookiesAccepted && isset($_COOKIE['session_id'])) {
            $sessionId = $_COOKIE['session_id'];
            $session = $this->db->fetch(
                "SELECT * FROM user_sessions WHERE session_id = ?", 
                [$sessionId]
            );
            if ($session) {
                $this->db->query(
                    "UPDATE user_sessions SET last_activity = NOW(), is_returning = 1 WHERE id = ?",
                    [$session['id']]
                );
                return $session;
            }
        }

        $ipAddress = $_SERVER['REMOTE_ADDR'];
        $userAgent = $_SERVER['HTTP_USER_AGENT'];
        $language = $this->language;
        $deviceType = $this->detectDeviceType();
        $source = $_GET['utm_source'] ?? 'direct';

        if (!$cookiesAccepted) {
            return $this->createAnonymousSession($ipAddress, $userAgent, $language, $deviceType, $source);
        }

        $sessionId = bin2hex(random_bytes(32));
        $this->db->query(
            "INSERT INTO user_sessions (session_id, ip_address, user_agent, language, device_type, source)
            VALUES (?, ?, ?, ?, ?, ?)",
            [$sessionId, $ipAddress, $userAgent, $language, $deviceType, $source]
        );

        $insertedId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];
        setcookie('session_id', $sessionId, [
            'expires' => time() + 30 * 24 * 60 * 60,
            'path' => '/',
            'domain' => '',
            'secure' => isset($_SERVER['HTTPS']),
            'httponly' => true,
            'samesite' => 'Lax'
        ]);

        return $this->db->fetch("SELECT * FROM user_sessions WHERE id = ?", [$insertedId]);
    }

    private function createAnonymousSession($ipAddress, $userAgent, $language, $deviceType, $source) {
        $anonymousId = md5($ipAddress . $userAgent);
        $anonymousSession = $this->db->fetch(
            "SELECT * FROM user_sessions 
            WHERE ip_address = ? AND user_agent = ? AND session_id IS NULL
            ORDER BY last_activity DESC 
            LIMIT 1",
            [$ipAddress, $userAgent]
        );

        if ($anonymousSession) {
            $this->db->query(
                "UPDATE user_sessions SET last_activity = NOW() WHERE id = ?",
                [$anonymousSession['id']]
            );
            return $anonymousSession;
        }

        $this->db->query(
            "INSERT INTO user_sessions (session_id, ip_address, user_agent, language, device_type, source, is_anonymous)
            VALUES (NULL, ?, ?, ?, ?, ?, 1)",
            [$ipAddress, $userAgent, $language, $deviceType, $source]
        );

        $insertedId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];
        return $this->db->fetch("SELECT * FROM user_sessions WHERE id = ?", [$insertedId]);
    }

    private function detectDeviceType() {
        // $userAgent = $_SERVER['HTTP_USER_AGENT'];
        // if (preg_match('/(android|iphone|ipad|ipod|blackberry|windows phone)/i', $userAgent)) {
        //     return 'mobile';
        // }
        // return 'desktop';

        return 'desktop';
    }

    private function determineUserSegment() {
        $deviceType = $this->session['device_type'];
        $language = $this->session['language'];
        $isReturning = $this->session['is_returning'] ?? 0;
        $source = $this->session['source'] ?? 'direct';
        $isAnonymous = $this->session['is_anonymous'] ?? 0;

        $segmentConditions = [];
        if ($deviceType == 'mobile') {
            $segmentConditions[] = "name LIKE '%mobile%'";
        } else {
            $segmentConditions[] = "name LIKE '%desktop%'";
        }

        if (!$isAnonymous) {
            if ($isReturning) {
                $segmentConditions[] = "name LIKE '%returning%'";
            } else {
                $segmentConditions[] = "name LIKE '%new%'";
            }
        } else {
            $segmentConditions[] = "name LIKE '%new%'";
        }

        if ($source == 'organic') {
            $segmentConditions[] = "name LIKE '%organic%'";
        } elseif ($source == 'social') {
            $segmentConditions[] = "name LIKE '%social%'";
        }

        if ($isAnonymous) {
            $segmentConditions[] = "name LIKE '%anonymous%'";
        }

        $query = "SELECT id FROM user_segments WHERE " . implode(" AND ", $segmentConditions) . " LIMIT 1";
        $segment = $this->db->fetch($query);
        $segmentId = $segment ? $segment['id'] : 1;

        if (!$isAnonymous && isset($this->session['id']) && $this->session['id'] > 0) {
            $this->db->query(
                "UPDATE user_sessions SET segment_id = ? WHERE id = ?",
                [$segmentId, $this->session['id']]
            );
        }

        return $segmentId;
    }

    private function getTheme() {
        $theme = $this->db->fetch(
            "SELECT t.* FROM themes t
            JOIN segment_theme_mapping stm ON t.id = stm.theme_id
            WHERE stm.segment_id = ? AND t.site_id = ?
            LIMIT 1",
            [$this->segmentId, $this->siteId]
        );

        if (!$theme) {
            $theme = $this->db->fetch(
                "SELECT * FROM themes 
                WHERE site_id = ? AND is_default = 1
                LIMIT 1",
                [$this->siteId]
            );
        }

        return $theme ?: [];
    }

    private function getSocialMedia() {
        return $this->db->fetchAll(
            "SELECT name, url 
             FROM social_media 
             WHERE site_id = ? 
             ORDER BY display_order",
            [$this->siteId]
        );
    }

    private function getLegal() {
        return $this->db->fetchAll(
            "SELECT name, url 
             FROM legal 
             WHERE site_id = ? 
             ORDER BY display_order",
            [$this->siteId]
        );
    }

    private function getScreens($levelId, $deviceType) {
        $query = "SELECT s.id, s.slug, s.img_pos, s.text_pos, s.has_rating, s.style_id, s.display_order,
                        c.id AS content_id, c.page_title, c.meta_title, c.meta,
                        c.cost, c.sec_cost, 
                        c.promo, c.m_promo, c.title AS content_title,
                        c.benefits, c.subtitle, c.text_content, c.m_text_content,
                        c.delivery, c.page_act_link_title, c.page_act_link_path,
                        c.page_act_sec_btn, c.page_act_btn, c.service_name
                FROM screens s
                LEFT JOIN screen_contents sc ON s.id = sc.screen_id
                LEFT JOIN contents c ON sc.content_id = c.id
                WHERE s.level_id = ?
                ORDER BY s.display_order";
        
        return $this->db->fetchAll($query, [$levelId]) ?? [];
    }

    private function getMedia($screenId, $deviceType) {
        $media = $this->db->fetchAll(
            "SELECT m.id, m.type, m.path, m.m_path, m.alt
            FROM screen_media sm
            JOIN media m ON sm.media_id = m.id
            WHERE sm.screen_id = ?
            ORDER BY sm.display_order",
            [$screenId]
        ) ?? [];

        $mediaData = [];
        foreach ($media as $m) {
            $mediaId = (string)$m['id'];
            $mediaData[$mediaId] = [
                'type' => $m['type'],
                'path' => $deviceType === 'mobile' && !empty($m['m_path']) ? $m['m_path'] : $m['path'],
                'name' => $m['alt']
            ];
        }
        
        return $mediaData;
    }

    private function getContent($screen, $deviceType) {
        if (!$screen['content_id']) {
            return null;
        }

        $contentId = (string)$screen['content_id'];
        $content = [
            'type' => 'text',
            'page_title' => $screen['page_title'],
            'meta_title' => $screen['meta_title'],
            'meta' => $screen['meta'] && json_decode($screen['meta'], true) !== null ? json_decode($screen['meta'], true) : [],
            'cost' => $screen['cost'],
            'secCost' => $screen['sec_cost'],
            'promo' => $deviceType === 'mobile' ? null : $screen['promo'],
            'title' => $screen['content_title'],
            'benefits' => $deviceType === 'mobile' ? null : $screen['benefits'],
            'subtitle' => $deviceType === 'mobile' ? null : $screen['subtitle'],
            'text' => $deviceType === 'mobile' && !empty($screen['m_text_content']) ? $screen['m_text_content'] : $screen['text_content'],
            'delivery' => $screen['delivery'],
            'pageActLinkTitle' => $screen['page_act_link_title'],
            'pageActLinkPath' => $screen['page_act_link_path'],
            'pageSecActBtn' => $screen['page_act_sec_btn'],
            'pageActBtn' => $screen['page_act_btn'],
            'serviceName' => $screen['service_name']
        ];

        return ['textId' => $contentId, 'data' => $content];
    }

    public function getPageStructure(): array {
        $site = $this->db->fetch(
            "SELECT id, domain, type, brand, slogan, developer_name, developer_link, phone1
            FROM sites 
            WHERE id = ? AND is_active = 1 
            LIMIT 1",
            [$this->siteId]
        );
        if (!$site) {
            error_log("Site not found for site_id: {$this->siteId}");
            throw new Exception("Active site version not found for siteId: {$this->siteId}");
        }
        $siteId = $site['id'];

        // Получаем страницу по slug или первую страницу, если slug не определен
        $pageQuery = $this->pageSlug !== null 
            ? "SELECT id, name, slug FROM pages WHERE site_id = ? AND slug = ? AND is_visible = 1 LIMIT 1" 
            : "SELECT id, name, slug FROM pages WHERE site_id = ? AND is_visible = 1 ORDER BY display_order ASC LIMIT 1";

        $pageParams = $this->pageSlug !== null ? [$siteId, $this->pageSlug] : [$siteId];
        $page = $this->db->fetch($pageQuery, $pageParams);

        // Если страница не найдена по slug, берем первую по порядку
        if (!$page && $this->pageSlug !== null) {
            $page = $this->db->fetch(
                "SELECT id, name, slug FROM pages WHERE site_id = ? ORDER BY display_order ASC LIMIT 1",
                [$siteId]
            );
        }

        // Проверка наличия страниц
        if (!$page) {
            error_log("No pages found for site_id: $siteId");
            throw new Exception("No pages found for siteId: $siteId");
        }

        $pageSlug = $page['slug'];
        $pageId = $page['id'];

        $levels = $this->db->fetchAll(
            "SELECT id, title, slug, meta_title, meta, scr_full, display_order
             FROM levels 
             WHERE page_id = ? 
             ORDER BY display_order",
            [$pageId]
        ) ?? [];

        // Проверка device_type
        $deviceType = $this->session['device_type'] ?? 'desktop';
        if (!in_array($deviceType, ['mobile', 'desktop'])) {
            error_log("Invalid device_type: {$deviceType}, defaulting to desktop");
            $deviceType = 'desktop';
        }

        $deviceType = 'desktop';

        $styles = [];
        $this->mediaData = [];
        $this->contentData = [];
        $activeLevel = 0;

        if ($this->screenSlug && !preg_match('/^[a-zA-Z0-9_-]+$/', $this->screenSlug)) {
            $this->screenSlug = null;
        }

        foreach ($levels as $levIndex => &$level) {
            $level['screens'] = $this->getScreens($level['id'], $deviceType);
            $isLevFull = !empty($level['scr_full']) && $level['scr_full'] === 'full';
            $level['activeScreen'] = 0;

            if ($this->screenSlug) {
                if (!$isLevFull) {
                    if ($level['slug'] === $this->screenSlug) {
                        $activeLevel = $levIndex;
                    }
                } else {
                    foreach ($level['screens'] as $index => &$screen) {
                        if ($screen['slug'] === $this->screenSlug) {
                            $activeLevel = $levIndex;
                            $level['activeScreen'] = $index;
                            break;
                        }
                    }
                }
            }

            foreach ($level['screens'] as $index => &$screen) {
                // загрузка персональных стилей экранов
                if (!empty($screen['style_id']) && !isset($styles[$screen['style_id']])) {
                    $style = $this->db->fetch(
                        "SELECT id, cost_sec_color, cost_color, promo_color, promo_size, 
                                title_color, title_size, benefits_color, subtitle_color, 
                                text_bg, text_color, delivery_color, 
                                page_act_sec_btn_bg, page_act_sec_btn_color, 
                                page_act_btn_bg, page_act_btn_color
                         FROM screen_style
                         WHERE id = ?",
                        [$screen['style_id']]
                    );
                    if ($style) {
                        $styles[$screen['style_id']] = [
                            'cost_color' => $style['cost_color'],
                            'cost_sec_color' => $style['cost_sec_color'],
                            'promo_color' => $style['promo_color'],
                            'promo_size' => $style['promo_size'],
                            'title_color' => $style['title_color'],
                            'title_size' => $style['title_size'],
                            'benefits_color' => $style['benefits_color'],
                            'subtitle_color' => $style['subtitle_color'],
                            'text_bg' => $style['text_bg'],
                            'text_color' => $style['text_color'],
                            'delivery_color' => $style['delivery_color'],
                            'page_act_sec_btn_bg' => $style['page_act_sec_btn_bg'],
                            'page_act_sec_btn_color' => $style['page_act_sec_btn_color'],
                            'page_act_btn_bg' => $style['page_act_btn_bg'],
                            'page_act_btn_color' => $style['page_act_btn_color']
                        ];
                    } else {
                        error_log("Style not found for style_id: {$screen['style_id']}");
                    }
                }

                // Загрузка медиа
                $screen['dataIds'] = [];
                $mediaData = $this->getMedia($screen['id'], $deviceType);
                foreach ($mediaData as $mediaId => $data) {
                    $screen['dataIds'][] = $mediaId;
                    $this->mediaData[$mediaId] = $data;
                }

                // Загрузка контента
                $content = $this->getContent($screen, $deviceType);
                if ($content) {
                    $screen['textId'] = $content['textId'];
                    $this->contentData[$content['textId']] = $content['data'];
                }

                $screen['rating'] = $screen['has_rating'] ? 'true' : 'false';
                $screen['style_id'] = (string)$screen['style_id'];
                unset($screen['id'], $screen['content_id'], $screen['m_promo'], $screen['m_text_content']);
            }
            unset($screen);
        }
        unset($level);

        $theme = $this->getTheme();

        $pageStructure = [
            'domain' => $site['domain'],
            'type' => $site['type'],
            'deviceType' => $deviceType,
            'brand' => $site['brand'],
            'slogan' => $site['slogan'],
            'developerName' => $site['developer_name'],
            'developerLink' => $site['developer_link'],
            'canvasType' => $theme['canvas_type'],
            'bgUrl' => $theme['bg_url'],
            'phone1' => $site['phone1'],
            'levels' => array_map(function ($level) {
                return [
                    'title' => $level['title'],
                    'slug' => $level['slug'],
                    'meta_title' => $level['meta_title'],
                    'meta' => $level['meta'] && json_decode($level['meta'], true) !== null ? json_decode($level['meta'], true) : [],
                    'scrFull' => $level['scr_full'],
                    'activeScreen' => $level['activeScreen'],
                    'screens' => $level['screens']
                ];
            }, $levels),
            'activeLevel' => $activeLevel,
            'page_slug' => $pageSlug
        ];

        $pageStructure += $styles + $this->mediaData + $this->contentData;

        return $pageStructure;
    }

    /**
     * Формирование структуры навигационного меню
     * @return array Структура меню
     */
    public function getNavStructure(): array {
        $navStructure = [];
    
        // Получение всех страниц для активного сайта
        $pages = $this->getPages();
    
        if (empty($pages)) {
            error_log("No pages found for site_id: {$this->siteId}");
            return $navStructure;
        }
    
        $isFirstPage = true; // Флаг для первой страницы
    
        foreach ($pages as $page) {
            $pageName = $page['name'];
            $pageSlug = $page['slug'];
    
            // Устанавливаем активную страницу: либо по pageSlug, либо первую, если pageSlug = null
            $isActive = ($this->pageSlug !== null) 
                ? ($pageSlug === $this->pageSlug)
                : ($isFirstPage);
    
            $navStructure[$pageName] = [
                'slug' => $pageSlug,
                'is_active' => $isActive,
                'type' => $this->siteType,
                'items' => []
            ];
    
            // Получение уровней для страницы
            $levels = $this->db->fetchAll(
                "SELECT id, title, slug, scr_full
                 FROM levels 
                 WHERE page_id = ? AND is_visible = 1
                 ORDER BY display_order",
                [$page['id']]
            ) ?? [];
    
            foreach ($levels as $level) {
                $levelTitle = $level['title'];
                $isLevFull = !empty($level['scr_full']) && $level['scr_full'] === 'full';
                $navStructure[$pageName]['items'][$levelTitle] = [
                    'level_slug' => $level['slug'],
                    'is_full' => $isLevFull
                ];
    
                if (!$isLevFull) {
                    // Для уровней без scr_full используем title и slug из levels
                    $navStructure[$pageName]['items'][$levelTitle]['title'] = $levelTitle;
                    $navStructure[$pageName]['items'][$levelTitle]['slug'] = $level['slug'];
                } else {
                    // Для уровней с scr_full = 'full' создаём массив screens
                    $navStructure[$pageName]['items'][$levelTitle]['screens'] = [];
                    $screens = $this->db->fetchAll(
                        "SELECT s.slug, c.page_title
                         FROM screens s
                         LEFT JOIN screen_contents sc ON s.id = sc.screen_id
                         LEFT JOIN contents c ON sc.content_id = c.id
                         WHERE s.level_id = ? AND s.is_visible = 1
                         ORDER BY s.display_order",
                        [$level['id']]
                    ) ?? [];
    
                    foreach ($screens as $screen) {
                        // Используем page_title из contents, если есть, иначе title уровня
                        $screenTitle = $screen['page_title'] ?? $levelTitle;
                        $navStructure[$pageName]['items'][$levelTitle]['screens'][] = [
                            'title' => $screenTitle,
                            'slug' => $screen['slug']
                        ];
                    }
                }
            }
    
            $isFirstPage = false; // Сбрасываем флаг после первой страницы
        }
    
        return $navStructure;
    }

    /**
     * Кэширование страниц для оптимизации запросов
     * @return array Список страниц
     */
    private function getPages(): array {
        if ($this->cachedPages === null) {
            $this->cachedPages = $this->db->fetchAll(
                "SELECT id, name, slug
                 FROM pages 
                 WHERE site_id = ? AND is_visible = 1
                 ORDER BY display_order",
                [$this->siteId]
            ) ?? [];
        }
        return $this->cachedPages;
    }

    public function getRenderData(): array {
        return [
            'themes' => $this->getTheme(),
            'socialMedia' => $this->getSocialMedia(),
            'legal' => $this->getLegal()
        ];
    }
}