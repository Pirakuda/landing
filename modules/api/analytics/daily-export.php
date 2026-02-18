<?php
// modules/public/logEvent.php

require_once __DIR__ . '/../../../database/database.php';
require_once __DIR__ . '/../../../config/config.php';

header('Content-Type: application/json; charset=utf-8');

// Проверяем метод запроса
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit();
}

// Проверяем токен домена
$token = $_SERVER['HTTP_X_DOMAIN_TOKEN'] ?? '';
if ($token !== Config::DOMAIN_TOKEN) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid token']);
    exit();
}

$db = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);

try {
    $input = json_decode(file_get_contents('php://input'), true);
    $date = $input['date'] ?? date('Y-m-d', strtotime('-1 day'));
    $exportType = $input['export_type'] ?? 'full';
    
    $exportData = [];
    
    if ($exportType === 'full') {
        // Полный экспорт - сессии и события
        $sessions = $db->fetchAll(
            "SELECT * FROM web_sessions 
             WHERE DATE(created_at) = ? AND is_bot = 0
             ORDER BY created_at ASC",
            [$date]
        );
        
        $events = $db->fetchAll(
            "SELECT eb.*, ws.visitor_id 
             FROM analytics_events_buffer eb
             LEFT JOIN web_sessions ws ON eb.session_id = ws.session_id
             WHERE DATE(eb.created_at) = ?
             ORDER BY eb.created_at ASC",
            [$date]
        );
        
        $exportData = [
            'sessions' => $sessions,
            'events' => $events,
            'total_records' => count($sessions) + count($events)
        ];
        
        // Помечаем события как синхронизированные
        $db->query(
            "UPDATE analytics_events_buffer 
             SET synced_at = NOW() 
             WHERE DATE(created_at) = ? AND synced_at IS NULL",
            [$date]
        );
        
    } else {
        // Только агрегированные данные
        $stats = $db->fetch(
            "SELECT * FROM local_daily_stats WHERE date = ?",
            [$date]
        );
        
        $exportData = ['local_stats' => $stats];
    }
    
    echo json_encode([
        'success' => true,
        'date' => $date,
        'export_type' => $exportType,
        'data' => $exportData
    ], JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    error_log("Export error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Export failed']);
}