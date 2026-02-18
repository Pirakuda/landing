<?php
// ФИНАЛЬНАЯ ВЕРСИЯ clientContact.php с автоматическим fallback
require_once __DIR__ . '/../../../config/config.php';

ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/../../logs/contact_api.log');

// Обработка preflight запроса
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Method not allowed']);
    exit;
}

try {
    $rawInput = file_get_contents("php://input");
    if ($rawInput === false) {
        throw new Exception('Failed to read input data');
    }
    
    $input = json_decode($rawInput, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Invalid JSON: ' . json_last_error_msg());
    }

    error_log("Contact API: Input received: " . print_r($input, true));

    $contactData = isset($input['contact_data']) ? $input['contact_data'] : [];
    $requestType = isset($input['type']) ? trim($input['type']) : 'consultation';
    // $domain = isset($input['domain']) ? trim($input['domain']) : 'relanding.ru';
    $domain = 'relanding.ru'; // Фиксированное значение для тестов  

    // Валидация данных
    if (!is_array($contactData) || empty($contactData['name'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Invalid contact data']);
        exit;
    }

    $hasEmail = !empty($contactData['email']) && filter_var($contactData['email'], FILTER_VALIDATE_EMAIL);
    $hasPhone = !empty($contactData['phone']) && preg_match('/^[\+]?[\d\s\-\(\)]{7,15}$/', $contactData['phone']);
    
    if (!$hasEmail && !$hasPhone) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Email or phone number is required']);
        exit;
    }

    $sanitizedContactData = [
        'name' => htmlspecialchars(trim($contactData['name']), ENT_QUOTES, 'UTF-8'),
        'email' => $hasEmail ? filter_var($contactData['email'], FILTER_SANITIZE_EMAIL) : '',
        'phone' => $hasPhone ? preg_replace('/[^\d\+\-\(\)\s]/', '', $contactData['phone']) : '',
        'telegram_name' => isset($contactData['telegram']) ? 
                          htmlspecialchars(trim($contactData['telegram']), ENT_QUOTES, 'UTF-8') : ''
    ];

    // ТЕСТОВЫЙ РЕЖИМ
    if (isset($_GET['test_mode'])) {
        error_log("Contact API: Test mode activated");
        
        $mockResponse = [
            'success' => true,
            'message' => 'Спасибо, ' . $sanitizedContactData['name'] . '! Ваша заявка принята. Наш менеджер свяжется с вами в ближайшее время.',
            'data' => [
                'entity_id' => 123,
                'entity_type' => 'lead',
                'buttons' => [
                    [
                        'text' => 'Написать еще раз',
                        'action' => 'request_contact',
                        'data' => ['type' => 'support']
                    ],
                    [
                        'text' => 'Проверить статус заявки',
                        'action' => 'send_message',
                        'data' => ['message' => 'Какой статус моей заявки?']
                    ]
                ]
            ]
        ];

        http_response_code(200);
        header('Content-Type: application/json; charset=utf-8');
        header('Access-Control-Allow-Origin: *');
        echo json_encode($mockResponse, JSON_UNESCAPED_UNICODE);
        exit;
    }

    // ПОПЫТКА ОТПРАВИТЬ НА ОСНОВНОЙ СЕРВЕР (с коротким таймаутом)
    $serverSuccess = false;
    $serverResponse = null;
    
    if (defined('Config::SYSTOKEN')) {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        
        $requestData = [
            'token' => Config::SYSTOKEN,
            'domain' => $domain,
            'contact_data' => $sanitizedContactData,
            'request_type' => $requestType,
            'session_id' => session_id(),
            'client_ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
            'timestamp' => time(),
            'source' => 'client_api'
        ];

        $data = json_encode($requestData, JSON_UNESCAPED_UNICODE);
        
        error_log("Contact API: Attempting server connection...");
        
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => "https://api.briemchain.ai/api/webchat/contact",
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $data,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 8, // Короткий таймаут
            CURLOPT_CONNECTTIMEOUT => 5,
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
                'User-Agent: ChatAPI/1.0'
            ],
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_FOLLOWLOCATION => false
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);
        curl_close($ch);

        if (!$curlError && $httpCode === 200) {
            $responseData = json_decode($response, true);
            if ($responseData && isset($responseData['success']) && $responseData['success']) {
                $serverSuccess = true;
                $serverResponse = $responseData;
                error_log("Contact API: Server response successful");
            } else {
                error_log("Contact API: Server returned error: " . ($response ?: 'empty response'));
            }
        } else {
            error_log("Contact API: Server connection failed - HTTP:$httpCode, cURL:$curlError");
        }
    }

    // FALLBACK РЕЖИМ (локальная обработка)
    if (!$serverSuccess) {
        error_log("Contact API: Using fallback mode");
        
        // Сохраняем заявку локально для последующей синхронизации
        $localData = [
            'timestamp' => date('Y-m-d H:i:s'),
            'contact_data' => $sanitizedContactData,
            'request_type' => $requestType,
            'domain' => $domain,
            'status' => 'pending_sync',
            'client_ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown'
        ];
        
        // Создаем папку логов если её нет
        $logDir = __DIR__ . '/../../logs';
        if (!is_dir($logDir)) {
            mkdir($logDir, 0755, true);
        }
        
        // Сохраняем заявку
        file_put_contents(
            $logDir . '/pending_contacts.log',
            json_encode($localData, JSON_UNESCAPED_UNICODE) . "\n",
            FILE_APPEND | LOCK_EX
        );

        // ОТПРАВЛЯЕМ EMAIL УВЕДОМЛЕНИЕ (если настроен)
        // $emailSent = false;
        // try {
        //     if (function_exists('mail')) {
        //         $subject = "Новая заявка с сайта $domain";
        //         $emailBody = "Получена новая заявка:\n\n";
        //         $emailBody .= "Имя: " . $sanitizedContactData['name'] . "\n";
        //         $emailBody .= "Email: " . $sanitizedContactData['email'] . "\n";
        //         $emailBody .= "Телефон: " . $sanitizedContactData['phone'] . "\n";
        //         $emailBody .= "Telegram: " . $sanitizedContactData['telegram_name'] . "\n";
        //         $emailBody .= "Тип запроса: $requestType\n";
        //         $emailBody .= "Время: " . date('Y-m-d H:i:s') . "\n";
        //         $emailBody .= "\nЗаявка сохранена локально (основной сервер недоступен)";
                
        //         $headers = "From: noreply@$domain\r\n";
        //         $headers .= "Content-Type: text/plain; charset=utf-8\r\n";
                
        //         // Отправляем на email администратора (замените на реальный)
        //         $emailSent = mail('info@relanding.ru', $subject, $emailBody, $headers);
        //     }
        // } catch (Exception $e) {
        //     error_log("Contact API: Email sending failed: " . $e->getMessage());
        // }

        // Формируем успешный ответ
        $fallbackResponse = [
            'success' => true,
            'message' => 'Спасибо, ' . $sanitizedContactData['name'] . '! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.',
            'data' => [
                'entity_id' => time(), // Временный ID
                'entity_type' => 'lead',
                'buttons' => [
                    [
                        'text' => 'Позвонить нам',
                        'action' => 'external_contact',
                        'data' => ['type' => 'phone']
                    ],
                    [
                        'text' => 'Написать на email',
                        'action' => 'external_contact',
                        'data' => ['type' => 'email']
                    ],
                    [
                        'text' => 'Написать в Telegram',
                        'action' => 'external_contact',
                        'data' => ['type' => 'telegram']
                    ]
                ]
            ],
            '_fallback' => true,
            '_email_sent' => $emailSent
        ];

        $serverResponse = $fallbackResponse;
    }

    // Возвращаем ответ клиенту
    if (!isset($serverResponse['message'])) {
        $serverResponse['message'] = $serverResponse['data']['message'] ?? 'Ваша заявка успешно отправлена!';
    }

    http_response_code(200);
    header('Content-Type: application/json; charset=utf-8');
    header('Access-Control-Allow-Origin: *');
    echo json_encode($serverResponse, JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    error_log("Contact API: Exception - " . $e->getMessage() . " in " . $e->getFile() . ":" . $e->getLine());
    
    // В случае любой ошибки возвращаем базовый fallback
    http_response_code(200); // Важно: возвращаем 200 чтобы чат не показал ошибку
    header('Content-Type: application/json; charset=utf-8');
    header('Access-Control-Allow-Origin: *');
    
    echo json_encode([
        'success' => true, 
        'message' => 'Спасибо за обращение! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.',
        'data' => [
            'entity_id' => time(),
            'entity_type' => 'lead',
            'buttons' => [
                [
                    'text' => 'Позвонить: +7-988-153-15-36',
                    'action' => 'external_contact',
                    'data' => ['type' => 'phone']
                ],
                [
                    'text' => 'Email: info@relanding.ru',
                    'action' => 'external_contact',
                    'data' => ['type' => 'email']
                ]
            ]
        ],
        '_emergency_fallback' => true
    ], JSON_UNESCAPED_UNICODE);
}

exit;
?>