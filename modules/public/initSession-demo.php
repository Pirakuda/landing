<?php
// /modules/public/initSession.php - КЛИЕНТСКИЙ СЕРВЕР
// Endpoint для инициализации аналитических сессий

require_once __DIR__ . '/../../database/database.php';
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../Analytics.php';

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Обработка preflight-запросов
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Метод запроса должен быть POST']);
    exit();
}

try {
    // Инициализация базы данных
    $db = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);
    
    // Получаем данные запроса
    $rawInput = file_get_contents("php://input");
    $input = json_decode($rawInput, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Ошибка JSON: ' . json_last_error_msg());
    }
    
    // Определяем домен и язык
    $domain = $_SERVER['HTTP_HOST'] ?? 'unknown';
    $language = $input['language'] ?? detectLanguage();
    
    // Инициализируем Analytics
    $analytics = new Analytics($db, $domain, $language);
    
    // Создаем или получаем сессию
    $session = $analytics->initSession();
    
    if (!$session) {
        throw new Exception('Не удалось инициализировать сессию');
    }
    
    // Логируем просмотр страницы
    $pageSlug = $input['page'] ?? '/';
    $pageTitle = $input['title'] ?? null;
    
    $analytics->logPageView($session, $pageSlug, $pageTitle);
    
    // Логируем дополнительные данные если есть
    if (!empty($input['screen_resolution'])) {
        $analytics->logEvent($session, 'session_data', [
            'screen_resolution' => $input['screen_resolution'],
            'timezone' => $input['timezone'] ?? null,
            'referrer' => $input['referrer'] ?? null
        ]);
    }
    
    // Возвращаем данные сессии
    echo json_encode([
        'success' => true,
        'session' => [
            'id' => $session['id'],
            'session_id' => $session['session_id'],
            'visitor_id' => $session['visitor_id'],
            'is_anonymous' => (bool)$session['is_anonymous'],
            'is_returning' => (bool)$session['is_returning'],
            'language' => $session['language'],
            'device_type' => $session['device_type']
        ],
        'timestamp' => date('Y-m-d H:i:s')
    ], JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    error_log("Session init error: " . $e->getMessage());
    
    echo json_encode([
        'success' => false,
        'message' => 'Ошибка инициализации сессии: ' . $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}

/**
 * Определяет язык пользователя
 */
function detectLanguage(): string {
    $acceptLanguage = $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? '';
    
    if (strpos($acceptLanguage, 'ru') !== false) {
        return 'ru';
    }
    if (strpos($acceptLanguage, 'en') !== false) {
        return 'en';
    }
    if (strpos($acceptLanguage, 'de') !== false) {
        return 'de';
    }
    
    return 'ru'; // По умолчанию
}