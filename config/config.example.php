<?php
class Config {
    // const DATABASE root@localhost 
    // const SERVERNAME = "localhost";
    // const USERNAME = "cy13096_briem";
    // const PASSWORD = "kdjs239hhnGK&%6()AKGDyx";
    // const DBNAME = "cy13096_briem";

    const SERVERNAME = "localhost";
    const USERNAME = "admin";
    const PASSWORD = "1234567";
    const DBNAME = "relanding_db";

    const SITE_USERNAME = "";
    const SITE_PASSWORD = "";
    const SITE_DBNAME = "";

    const JWT_SECRET = "";

    // TELEGRAM BOT
    const SYSTOKEN = "";
    const ORGANIZATION_ID = 141;

    // переменные чата
    const CHAT_LOG_DIR = __DIR__ . '/../logs/';
    const CHAT_ENABLE_LOGGING = true;
    const CHAT_LOG_LEVEL = 'DEBUG';
    const ALLOWED_ORIGINS = ['*'];

    const CHAT_MAX_MESSAGE_LENGTH = 1000;
    const CHAT_RATE_LIMIT_MESSAGES = 5;
    const CHAT_RATE_LIMIT_MINUTES = 10;
}

// Функция для логирования
function chatLog(string $message, string $level = 'INFO'): void {
    if (!Config::CHAT_ENABLE_LOGGING) {
        return;
    }

    $logLevels = ['DEBUG' => 0, 'INFO' => 1, 'WARNING' => 2, 'ERROR' => 3];
    $currentLevel = $logLevels[Config::CHAT_LOG_LEVEL] ?? 1;
    $messageLevel = $logLevels[$level] ?? 1;

    if ($messageLevel < $currentLevel) {
        return;
    }

    $logEntry = [
        'timestamp' => date('Y-m-d H:i:s'),
        'level' => $level,
        'message' => $message,
        'ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
        'user_agent' => substr($_SERVER['HTTP_USER_AGENT'] ?? 'unknown', 0, 200)
    ];

    $logFile = Config::CHAT_LOG_DIR . 'chat_' . date('Y-m-d') . '.log';
    
    if (!is_dir(Config::CHAT_LOG_DIR)) {
        if (!mkdir(Config::CHAT_LOG_DIR, 0755, true)) {
            error_log("Failed to create log directory: " . Config::CHAT_LOG_DIR);
            return;
        }
    }

    if (!is_writable(Config::CHAT_LOG_DIR)) {
        error_log("Log directory not writable: " . Config::CHAT_LOG_DIR);
        return;
    }

    file_put_contents(
        $logFile, 
        json_encode($logEntry) . PHP_EOL, 
        FILE_APPEND | LOCK_EX
    );
}

// Функция для установки CORS заголовков
function setCorsHeaders(): void {
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    if (in_array('*', Config::ALLOWED_ORIGINS) || in_array($origin, Config::ALLOWED_ORIGINS)) {
        header('Access-Control-Allow-Origin: ' . ($origin ?: '*'));
    }
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
    header('Access-Control-Allow-Credentials: true');
    header('Content-Type: application/json; charset=utf-8');
}

