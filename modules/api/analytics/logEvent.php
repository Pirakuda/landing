<?php
// modules/public/logEvent.php

require_once __DIR__ . '/../../../database/database.php';
require_once __DIR__ . '/../../../config/config.php';

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respondError('Метод запроса должен быть POST.', 405);
}

$db = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);

try {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input) {
        respondError('Некорректные данные JSON.');
    }
    
    $action = $input['action'] ?? $input['event_type'] ?? '';
    $eventData = $input['event_data'] ?? $input;
    
    // Проверяем на ботов
    $sessionId = $eventData['session_id'] ?? null;
    if (!$sessionId || strpos($sessionId, 'bot_') === 0) {
        respondSuccess(['type' => 'bot', 'processed' => false]);
    }
    
    // Обрабатываем событие
    $result = processAnalyticsEvent($db, $action, $eventData);
    respondSuccess($result);
    
} catch (Exception $e) {
    error_log("Error in logEvent.php: " . $e->getMessage());
    respondError('Внутренняя ошибка сервера.');
}

/**
 * Обработка аналитического события
 */
function processAnalyticsEvent($db, $action, $eventData) {
    $sessionId = $eventData['session_id'] ?? null;
    $visitorId = $eventData['visitor_id'] ?? null;
    
    if (!$sessionId || !$visitorId) {
        return ['type' => 'invalid_session', 'processed' => false];
    }
    
    // Добавляем событие в буфер
    $bufferId = addEventToBuffer($db, $sessionId, $action, $eventData);
    
    // Обновляем сессию в зависимости от типа события
    switch ($action) {
        case 'section_view':
            updateSessionForSectionView($db, $sessionId, $eventData);
            break;
        case 'section_transition':
            updateSessionForTransition($db, $sessionId, $eventData);
            break;
        case 'session_end':
            updateSessionForEnd($db, $sessionId, $eventData);
            break;
    }
    
    return [
        'type' => $action,
        'buffer_id' => $bufferId,
        'processed' => true
    ];
}

/**
 * Добавление события в буфер
 */
function addEventToBuffer($db, $sessionId, $eventType, $eventData) {
    try {
        // Сохраняем событие в буфер для последующей синхронизации
        $db->query(
            "INSERT INTO analytics_events_buffer (session_id, event_type, event_data, created_at) 
             VALUES (?, ?, ?, NOW())",
            [$sessionId, $eventType, json_encode($eventData, JSON_UNESCAPED_UNICODE)]
        );
        
        return $db->getLastInsertId();
        
    } catch (Exception $e) {
        error_log("Error adding event to buffer: " . $e->getMessage());
        return null;
    }
}

/**
 * Обновление сессии при просмотре раздела
 */
function updateSessionForSectionView($db, $sessionId, $eventData) {
    try {
        $sectionUrl = $eventData['section_url'] ?? '';
        
        $db->query(
            "UPDATE web_sessions 
             SET last_activity = NOW(), 
                 exit_page = ?,
                 page_views = page_views + 1,
                 total_sections = total_sections + 1,
                 bounce = 0
             WHERE session_id = ?",
            [$sectionUrl, $sessionId]
        );
        
    } catch (Exception $e) {
        error_log("Error updating session for section view: " . $e->getMessage());
    }
}

/**
 * Обновление сессии при переходе между разделами
 */
function updateSessionForTransition($db, $sessionId, $eventData) {
    try {
        $timeSpent = intval($eventData['time_spent'] ?? 0);
        $newSection = $eventData['section_url'] ?? '';
        
        $db->query(
            "UPDATE web_sessions 
             SET session_duration = session_duration + ?,
                 exit_page = ?,
                 last_activity = NOW()
             WHERE session_id = ?",
            [$timeSpent, $newSection, $sessionId]
        );
        
    } catch (Exception $e) {
        error_log("Error updating session for transition: " . $e->getMessage());
    }
}

/**
 * Обновление сессии при завершении
 */
function updateSessionForEnd($db, $sessionId, $eventData) {
    try {
        $finalTime = intval($eventData['final_time_spent'] ?? 0);
        $exitPage = $eventData['final_section'] ?? '';
        
        $db->query(
            "UPDATE web_sessions 
             SET session_duration = session_duration + ?,
                 exit_page = ?,
                 last_activity = NOW()
             WHERE session_id = ?",
            [$finalTime, $exitPage, $sessionId]
        );
        
    } catch (Exception $e) {
        error_log("Error updating session for end: " . $e->getMessage());
    }
}

function respondSuccess($data = []) {
    echo json_encode([
        'success' => true,
        'data' => $data,
        'timestamp' => time()
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

function respondError($message, $code = 400) {
    http_response_code($code);
    echo json_encode([
        'success' => false,
        'error' => $message,
        'timestamp' => time()
    ], JSON_UNESCAPED_UNICODE);
    exit();
}