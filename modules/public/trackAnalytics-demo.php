<?php
// КЛИЕНТСКИЙ СЕРВЕР (relanding.ru)
// /modules/public/trackAnalytics.php - ИСПРАВЛЕННАЯ ВЕРСИЯ

require_once __DIR__ . '/../../database/database.php';
require_once __DIR__ . '/../../config/config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Method not allowed']);
    exit;
}

try {
    $db = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);
    
    $rawInput = file_get_contents("php://input");
    $input = json_decode($rawInput, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Invalid JSON');
    }
    
    $eventType = $input['event_type'] ?? null;
    $eventData = $input['event_data'] ?? [];
    $domain = $input['domain'] ?? $_SERVER['HTTP_HOST'] ?? 'unknown';
    
    if (!$eventType || !is_array($eventData)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Invalid event data']);
        exit;
    }
    
    // Обрабатываем разные типы событий
    $result = false;
    switch ($eventType) {
        case 'page_view':
            $result = handlePageView($db, $eventData, $domain);
            break;
        case 'page_duration':
            $result = handlePageDuration($db, $eventData);
            break;
        case 'conversion':
            $result = handleConversion($db, $eventData);
            break;
        case 'session_end':
            $result = handleSessionEnd($db, $eventData);
            break;
        default:
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Unknown event type']);
            exit;
    }
    
    if ($result) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Failed to process event']);
    }
    
} catch (Exception $e) {
    error_log('Analytics tracking error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Internal server error']);
}

/**
 * Обрабатывает просмотр страницы
 */
function handlePageView(Database $db, array $eventData, string $domain): bool {
    try {
        $sessionId = $eventData['session_id'] ?? null;
        $visitorId = $eventData['visitor_id'] ?? null;
        $pageSlug = $eventData['page_slug'] ?? null;
        $pageTitle = $eventData['page_title'] ?? null;
        
        if (!$visitorId || !$pageSlug) {
            return false;
        }
        
        // Проверяем, что это не дублирующий просмотр
        $existing = $db->fetch(
            "SELECT id FROM page_views 
             WHERE visitor_id = ? AND page_slug = ? 
             AND viewed_at > DATE_SUB(NOW(), INTERVAL 5 SECOND)
             LIMIT 1",
            [$visitorId, $pageSlug]
        );
        
        if ($existing) {
            return true; // Не дублируем
        }
        
        // Записываем просмотр страницы
        $success = $db->query(
            "INSERT INTO page_views (session_id, visitor_id, page_slug, page_title, page_url)
             VALUES (?, ?, ?, ?, ?)",
            [
                $sessionId,
                $visitorId,
                $pageSlug,
                $pageTitle,
                $_SERVER['REQUEST_URI'] ?? '/' . $pageSlug
            ]
        );
        
        // Обновляем статистику сессии
        if ($success && $sessionId) {
            $db->query(
                "UPDATE user_sessions SET
                    page_views = page_views + 1,
                    bounce = CASE WHEN page_views = 0 THEN 1 ELSE 0 END,
                    last_activity = NOW()
                 WHERE session_id = ?",
                [$sessionId]
            );
        }
        
        // Записываем в общий лог событий
        recordAnalyticsEvent($db, 'page_view', $visitorId, $sessionId, [
            'page_slug' => $pageSlug,
            'page_title' => $pageTitle,
            'domain' => $domain
        ]);
        
        return $success !== false;
        
    } catch (Exception $e) {
        error_log('handlePageView error: ' . $e->getMessage());
        return false;
    }
}

/**
 * Обрабатывает обновление времени на странице
 */
function handlePageDuration(Database $db, array $eventData): bool {
    try {
        $sessionId = $eventData['session_id'] ?? null;
        $visitorId = $eventData['visitor_id'] ?? null;
        $pageSlug = $eventData['page_slug'] ?? null;
        $timeOnPage = (int)($eventData['time_on_page'] ?? 0);
        
        if (!$visitorId || !$pageSlug || $timeOnPage < 1) {
            return false;
        }
        
        // Обновляем время на последней просмотренной странице
        $success = $db->query(
            "UPDATE page_views SET time_on_page = ? 
             WHERE visitor_id = ? AND page_slug = ? 
             ORDER BY viewed_at DESC LIMIT 1",
            [$timeOnPage, $visitorId, $pageSlug]
        );
        
        // Обновляем общую длительность сессии
        if ($success && $sessionId) {
            $totalDuration = $db->fetch(
                "SELECT SUM(time_on_page) as total FROM page_views 
                 WHERE session_id = ? OR visitor_id = ?",
                [$sessionId, $visitorId]
            );
            
            $db->query(
                "UPDATE user_sessions SET session_duration = ? WHERE session_id = ?",
                [$totalDuration['total'] ?? 0, $sessionId]
            );
        }
        
        return $success !== false;
        
    } catch (Exception $e) {
        error_log('handlePageDuration error: ' . $e->getMessage());
        return false;
    }
}

/**
 * Обрабатывает завершение сессии
 */
function handleSessionEnd(Database $db, array $eventData): bool {
    try {
        $sessionId = $eventData['session_id'] ?? null;
        $visitorId = $eventData['visitor_id'] ?? null;
        $finalPage = $eventData['final_page'] ?? null;
        $finalTimeOnPage = (int)($eventData['final_time_on_page'] ?? 0);
        $totalSessionTime = (int)($eventData['total_session_time'] ?? 0);
        
        if (!$visitorId) {
            return false;
        }
        
        // Обновляем время на последней странице
        if ($finalPage && $finalTimeOnPage > 0) {
            $db->query(
                "UPDATE page_views SET time_on_page = ? 
                 WHERE visitor_id = ? AND page_slug = ? 
                 ORDER BY viewed_at DESC LIMIT 1",
                [$finalTimeOnPage, $visitorId, $finalPage]
            );
        }
        
        // Обновляем общую статистику сессии
        if ($sessionId) {
            // Устанавливаем exit_page
            $db->query(
                "UPDATE user_sessions SET 
                    exit_page = ?,
                    session_duration = GREATEST(session_duration, ?),
                    last_activity = NOW()
                 WHERE session_id = ?",
                [$finalPage, $totalSessionTime, $sessionId]
            );
        }
        
        // Записываем событие завершения сессии
        return recordAnalyticsEvent($db, 'session_end', $visitorId, $sessionId, [
            'final_page' => $finalPage,
            'total_time' => $totalSessionTime,
            'final_time_on_page' => $finalTimeOnPage
        ]);
        
    } catch (Exception $e) {
        error_log('handleSessionEnd error: ' . $e->getMessage());
        return false;
    }
}

/**
 * Записывает событие в локальный лог аналитики (КЛИЕНТСКИЙ СЕРВЕР)
 */
function recordAnalyticsEvent(Database $db, string $eventType, string $visitorId, ?string $sessionId, array $eventData): bool {
    try {
        // Получаем organization_id из токена или конфига
        $token = Config::SYSTOKEN ?? null;
        $orgId = Config::ORGANIZATION_ID ?? null;
        
        $success = $db->query(
            "INSERT INTO analytics_events (organization_id, visitor_id, session_id, event_type, event_data, page_slug)
             VALUES (?, ?, ?, ?, ?, ?)",
            [
                $orgId,
                $visitorId,
                $sessionId,
                $eventType,
                json_encode($eventData, JSON_UNESCAPED_UNICODE),
                $eventData['page_slug'] ?? null
            ]
        );
        
        return $success !== false;
        
    } catch (Exception $e) {
        error_log('recordAnalyticsEvent error: ' . $e->getMessage());
        return false;
    }
}
