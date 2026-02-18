<?php
// modules/public/getSessionData.php - ИСПРАВЛЕННАЯ ВЕРСИЯ

require_once __DIR__ . '/../../database/database.php';
require_once __DIR__ . '/../../config/config.php';

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// CORS preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    $db = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);
    
    // Получаем параметр timestamp для инкрементальной загрузки
    $lastProcessedTime = intval($_GET['since'] ?? 0);
    
    // ✅ ИСПРАВЛЕНО: улучшенный запрос с фильтрацией ботов
    $botFilter = getBotFilterConditions();
    
    $query = "
        SELECT 
            us.session_id,
            us.visitor_id,
            us.ip_address,
            us.user_agent,
            us.country,
            us.region,
            us.city,
            us.language,
            us.device_type,
            us.browser,
            us.os,
            us.screen_resolution,
            us.source,
            us.utm_source,
            us.utm_medium,
            us.utm_campaign,
            us.utm_content,
            us.utm_term,
            us.referrer,
            us.landing_page,
            us.exit_page,
            us.is_returning,
            us.page_views,
            us.session_duration,
            us.bounce,
            UNIX_TIMESTAMP(us.created_at) as session_start,
            UNIX_TIMESTAMP(us.last_activity) as session_end,
            
            -- Данные из page_views если таблица существует
            GROUP_CONCAT(
                CONCAT(pv.page_slug, ':', pv.time_on_page) 
                ORDER BY pv.viewed_at 
                SEPARATOR '|'
            ) as page_data
            
        FROM user_sessions us
        LEFT JOIN page_views pv ON us.session_id = pv.session_id
        WHERE {$botFilter}
          AND UNIX_TIMESTAMP(us.last_activity) > ?
        GROUP BY us.session_id
        ORDER BY us.last_activity DESC
        LIMIT 1000
    ";
    
    $sessions = $db->fetchAll($query, [$lastProcessedTime]);
    
    // ✅ ДОБАВЛЕНО: обработка данных страниц
    foreach ($sessions as &$session) {
        if (!empty($session['page_data'])) {
            $pages = [];
            $pageDataArray = explode('|', $session['page_data']);
            foreach ($pageDataArray as $pageData) {
                if (strpos($pageData, ':') !== false) {
                    list($slug, $time) = explode(':', $pageData, 2);
                    $pages[] = [
                        'page_slug' => $slug,
                        'time_on_page' => intval($time)
                    ];
                }
            }
            $session['pages'] = $pages;
        } else {
            $session['pages'] = [];
        }
        unset($session['page_data']);
    }
    
    // ✅ ДОБАВЛЕНО: анонимная аналитика если есть данные
    $anonymousData = getAnonymousData($db, $lastProcessedTime);
    
    $response = [
        'success' => true,
        'sessions_count' => count($sessions),
        'sessions' => $sessions,
        'anonymous_data' => $anonymousData,
        'server_time' => time(),
        'last_processed' => $lastProcessedTime
    ];
    
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    error_log("Error in getSessionData: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Internal server error',
        'message' => 'Failed to fetch session data'
    ]);
}

/**
 * Условия фильтрации ботов
 */
function getBotFilterConditions(): string {
    $conditions = [
        "us.user_agent NOT REGEXP '(?i)(bot|crawler|spider|scraper|curl|wget|python|java|http|libwww|lwp)'",
        "us.user_agent NOT REGEXP '(?i)(uptime|monitor|check|pingdom|site24x7|gtmetrix|pagespeed)'",
        "us.user_agent NOT REGEXP '(?i)(semrush|ahrefs|mj12|dotbot|screaming.frog)'",
        "us.user_agent NOT REGEXP '(?i)(facebook|twitter|linkedin|telegram|whatsapp|vkshare)'",
        "us.user_agent NOT LIKE '%HeadlessChrome%'",
        "us.device_type != 'bot'",
        "us.device_type IN ('desktop', 'mobile', 'tablet')",
        "us.visitor_id NOT LIKE 'bot_%'",
        "us.visitor_id IS NOT NULL",
        "us.visitor_id != ''",
        "LENGTH(us.user_agent) > 10",
        "us.session_id IS NOT NULL",
        "us.session_id != ''",
        "NOT (us.page_views > 100 AND us.session_duration < 60)",
        "us.session_duration < 28800",
        "us.session_duration >= 0"
    ];
    
    return implode(' AND ', $conditions);
}

/**
 * Получение анонимных данных
 */
function getAnonymousData(Database $db, int $lastProcessedTime): array {
    try {
        $since = date('Y-m-d H:i:s', $lastProcessedTime);
        
        return $db->fetchAll("
            SELECT 
                domain,
                event_type,
                event_date,
                device_type,
                language,
                page_url,
                events_count,
                updated_at
            FROM anonymous_analytics 
            WHERE updated_at > ?
            ORDER BY updated_at DESC
            LIMIT 500
        ", [$since]);
        
    } catch (Exception $e) {
        error_log("Error getting anonymous data: " . $e->getMessage());
        return [];
    }
}
?>