<?php
require_once __DIR__ . '/../../../config/config.php';

// Увеличиваем время выполнения для этого скрипта
set_time_limit(30);

// Обработка preflight запроса
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    http_response_code(200);
    exit;
}

// Проверка метода запроса
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Method not allowed']);
    exit;
}

try {
    $apiUrl = "https://api.briemchain.ai/api/webchat/message";

    // Получаем JSON-данные
    $rawInput = file_get_contents("php://input");
    $input = json_decode($rawInput, true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Invalid JSON']);
        exit;
    }

    // Валидация обязательных полей
    $message = isset($input['message']) ? trim($input['message']) : '';

    if (empty($message)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Message is required']);
        exit;
    }

    // Простая валидация длины сообщения
    if (mb_strlen($message, 'UTF-8') > 1000) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Message too long']);
        exit;
    }

    // ИСПРАВЛЕНО: Получаем session_id более надежно
    session_start();
    $sessionId = session_id();
    
    // Используем данные из запроса если есть, иначе fallback
    $requestSessionId = $input['session_id'] ?? $sessionId;
    $visitorId = $input['visitor_id'] ?? ('visitor_' . time() . '_' . rand(1000, 9999));

    // Подготавливаем данные для отправки на основной сервер
    $requestData = [
        'token' => Config::SYSTOKEN,
        'domain' => 'relanding.ru',
        'message' => $message,
        'session_id' => $requestSessionId,
        'visitor_id' => $visitorId,
        'page_slug' => $input['page_slug'] ?? 'glavnaya',
        'device_type' => $input['device_type'] ?? 'desktop',
        'language' => $input['language'] ?? 'ru',
        'client_ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
        'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
        'timestamp' => time()
    ];

    $data = json_encode($requestData);

    // ИСПРАВЛЕНО: Улучшенные настройки cURL с обработкой таймаутов
    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $apiUrl,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => $data,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 20, // Увеличили таймаут
        CURLOPT_CONNECTTIMEOUT => 8, // Увеличили таймаут соединения
        CURLOPT_HTTPHEADER => [
            'Content-Type: application/json',
            'User-Agent: ChatAPI/1.0',
            'Content-Length: ' . strlen($data)
        ],
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_FOLLOWLOCATION => false,
        CURLOPT_MAXREDIRS => 0,
        // Добавляем retry логику на уровне cURL
        CURLOPT_FRESH_CONNECT => true,
        CURLOPT_FORBID_REUSE => false
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    $curlErrno = curl_errno($ch);
    curl_close($ch);

    if ($curlError) {
        error_log("cURL Error details: " . $curlError);
        throw new Exception('Connection error: ' . $curlError);
    }

    if ($httpCode !== 200) {
        error_log("Server returned HTTP " . $httpCode);
        throw new Exception('Main server returned HTTP ' . $httpCode);
    }

    // Валидируем ответ от основного сервера
    $responseData = json_decode($response, true);
    if ($responseData === null || json_last_error() !== JSON_ERROR_NONE) {
        error_log("Invalid JSON response: " . substr($response, 0, 200));
        throw new Exception('Invalid JSON response from main server');
    }

    // ИСПРАВЛЕНО: Передаем ответ как есть
    http_response_code(200);
    header('Content-Type: application/json; charset=utf-8');
    header('Access-Control-Allow-Origin: *');
    echo $response;
    
} catch (Exception $e) {
    // Логирование ошибки с дополнительной информацией
    $errorDetails = [
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'input_data' => $input ?? null,
        'timestamp' => date('Y-m-d H:i:s')
    ];
    error_log("Chat Message API Error: " . json_encode($errorDetails));
    
    // ИСПРАВЛЕНО: Улучшенный fallback ответ в зависимости от типа ошибки
    http_response_code(200);
    header('Content-Type: application/json; charset=utf-8');
    header('Access-Control-Allow-Origin: *');
    
    $fallbackMessage = 'К сожалению, сейчас я временно недоступен. Пожалуйста, свяжитесь с нашим менеджером для получения помощи.';
    $fallbackButtons = [
        [
            'text' => 'Связаться с менеджером',
            'action' => 'request_contact',
            'data' => ['type' => 'consultation', 'required_fields' => ['name', 'email']]
        ],
        [
            'text' => 'Заказать звонок',
            'action' => 'request_contact', 
            'data' => ['type' => 'callback', 'required_fields' => ['name', 'phone']]
        ],
        [
            'text' => 'Написать на email',
            'action' => 'external_contact',
            'data' => ['type' => 'email']
        ]
    ];

    // Определяем тип ошибки для более точного ответа
    if (strpos($e->getMessage(), 'timeout') !== false || strpos($e->getMessage(), 'Connection') !== false) {
        $fallbackMessage = 'Превышено время ожидания ответа сервера. Попробуйте позже или свяжитесь с нами напрямую.';
    } elseif (strpos($e->getMessage(), 'HTTP 5') !== false) {
        $fallbackMessage = 'Сервер временно недоступен. Мы работаем над устранением проблемы.';
    }
    
    echo json_encode([
        'success' => true,
        'message' => $fallbackMessage,
        'intent' => 'technical_error', 
        'needs_escalation' => true,
        'contact_required' => ['email'],
        'buttons' => $fallbackButtons,
        'error_type' => 'server_unavailable',
        'debug' => [
            'error_summary' => substr($e->getMessage(), 0, 100),
            'fallback_used' => true
        ]
    ], JSON_UNESCAPED_UNICODE);
}
?>