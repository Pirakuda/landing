<?php
function chatLog(string $message, string $level = 'INFO'): void {
    $logEntry = [
        'timestamp' => date('Y-m-d H:i:s'),
        'level' => $level,
        'message' => $message,
        'ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown'
    ];

    $logFile = $_SERVER['DOCUMENT_ROOT'] . '/logs/test_' . date('Y-m-d') . '.log';
    
    if (!is_dir(dirname($logFile))) {
        mkdir(dirname($logFile), 0755, true);
    }

    file_put_contents(
        $logFile, 
        json_encode($logEntry) . PHP_EOL, 
        FILE_APPEND | LOCK_EX
    );
}

chatLog('Test log entry');
echo 'Log written';
?>