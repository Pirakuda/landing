<?php
require_once __DIR__ . '/../../../database/database.php';
require_once __DIR__ . '/../../../config/config.php';

$mainId = Config::MAIN_ID;
$telegramToken = Config::BOTTOKEN;

try {
    $db = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
    exit;
}

// Проверяем метод запроса
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method must be POST']);
    exit;
}

// получение и декодирование данных ///////////////////////////////////////////////////
// Ограничиваем размер входных данных (например, 1MB)
$rawInput = file_get_contents("php://input", false, null, 0, 1048576);
if ($rawInput === false) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Input too large or unreadable']);
    exit;
}
$input = json_decode($rawInput, true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'JSON error: ' . json_last_error_msg()]);
    exit;
}

// Функция фильтрации данных
function sanitizeInput($input) {
    return htmlspecialchars(strip_tags(trim((string)$input)), ENT_QUOTES, 'UTF-8');
}

// Функция валидации телефона
function validatePhone($phone) {
    if (empty($phone)) return null;
    
    // Убираем все нечисловые символы кроме + и пробелов
    $cleanPhone = preg_replace('/[^\d+\s()-]/', '', $phone);
    
    // Проверяем базовый формат (от 7 до 15 цифр)
    if (preg_match('/^\+?[\d\s()-]{7,15}$/', $cleanPhone)) {
        return $cleanPhone;
    }
    
    return false;
}

// Читаем и валидируем данные
$token = $input['token'] ?? null;
if (!$token) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Token is required']);
    exit;
}

$honeypot = sanitizeInput($input['honeypot'] ?? '');
if (!empty($honeypot)) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Bot detected']);
    exit;
}

$message = sanitizeInput($input['message'] ?? '');
if (empty($message)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Message cannot be empty']);
    exit;
}

$name = sanitizeInput($input['name'] ?? '');
$rawPhone = $input['phone'] ?? null;
$phone = validatePhone($rawPhone);
if ($rawPhone && $phone === false) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid phone format']);
    exit;
}

$telegramName = sanitizeInput($input['telegram_name'] ?? null);
$rawEmail = $input['email'] ?? null;

if (!filter_var($rawEmail, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid email']);
    exit;
}

$email = filter_var($rawEmail, FILTER_SANITIZE_EMAIL);
$sourceValue = sanitizeInput($input['source'] ?? 'unknown');
$sourceValue = preg_replace('/^https?:\/\//i', '', rtrim($sourceValue, '/'));

// Проверяем организацию
$org = $db->fetch("SELECT id, level FROM organizations WHERE token = :token", ['token' => $token]);
if (!$org) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Invalid organization token']);
    exit;
}

$orgId = $org['id'];
$orgLevel = $org['level'];

try {
    $db->beginTransaction();

    if ($orgLevel === 'basic') {
        // бот на минималках
        require_once __DIR__ . '/../../core/base_entity_functions.php';

        $cadastralNumber = sanitizeInput($input['cadastralNumber'] ?? '');
        $address = sanitizeInput($input['address'] ?? '');
        $landPurpose = sanitizeInput($input['landPurpose'] ?? '');
        $contactTime = sanitizeInput($input['contactTime'] ?? '');

        // отправка директору
        if (!ceoNotifyAssignedUser(
            $db, 
            $orgId, 
            $name, 
            $email, 
            $phone, 
            $message, 
            $cadastralNumber,
            $address,
            $landPurpose,
            $contactTime
        )) {
            throw new Exception('Failed to notify CEO');
        }
    } else {
        // расширенная версия бота - полный функционал
        require_once __DIR__ . '/../../core/client_functions.php';
        require_once __DIR__ . '/../../core/worker/worker_checkEventOption.php';
        require_once __DIR__ . '/../../core/worker/worker_autoreplyOption.php';
        require_once __DIR__ . '/../../core/worker/worker_aiActionOption.php';
        require_once __DIR__ . '/../../core/worker/worker_assignToEntityOption.php';
        
        // Создание/получение клиента
        $clientId = createOrGetClient($db, $orgId, $name, $email, $phone, $telegramName);
        if (!$clientId) {
            throw new Exception('Failed to create or get client');
        }

        // // Создание события
        $eventId = createEvent($db, [
            'source_type' => 'websiteForm',
            'source_value' => $sourceValue,
            'from_name' => $name,
            'from_contact' => $email,
            'client_id' => $clientId,
            'organization_id' => $orgId,
            'subject' => 'Заявка с сайта',
            'message' => $message,
            'preferred_channel' => 'email',
        ]);

        if (!$eventId) {
            throw new Exception('Failed to create event');
        }

        // получаем телеграмм-токен для уведомлений сотрудников
        $telegramToken = $db->fetch("SELECT bot_token FROM organizations WHERE id = ?", [$orgId])['bot_token'];
        if (!$telegramToken) {
            throw new Exception('Failed to get telegramm-token');
        }
        
        // Проверка наличие сущности
        if (!checkEventContext($db, $orgId, $telegramToken, $eventId, $clientId)) {
            error_log("Ошибка при проверке события на наличия сущности, событие #$eventId");
        }

        // ИИ-классификация события
        if (!analyzeEventIntent($db, $orgId, $telegramToken, $eventId, $message)) {
            error_log("Ошибка при классификации события #$eventId");
        }

        // Генерация ИИ-автоответа
        $autoReplay = createAutoreply($db, $orgId, $telegramToken, $eventId);

        // Создание сущности на основе ИИ-анализа
        if (!processAiAction($db, $orgId, $telegramToken, $eventId)) {
            error_log("Ошибка при создании сущности #$eventId");
        }

        // Назначение сотрудника с отправкой уведомления
        if (!assignHandlerToEntity($db, $orgId, $telegramToken, $eventId)) {
            error_log("Ошибка при назначении ответственного сотрудника #$eventId");
        }
    }

    // Безопасная запись дополнительных полей
    $baseFields = ['name', 'email', 'phone', 'telegram_name', 'message'];
    $skipFields = ['token', 'honeypot', 'source'];
    $excludeFields = array_flip(array_merge($baseFields, $skipFields));
    foreach ($input as $key => $value) {
        if (!isset($excludeFields[$key]) && !empty($value)) {
            $fieldName = sanitizeInput($key);
            $fieldValue = sanitizeInput($value);
            if (strlen($fieldName) <= 100 && strlen($fieldValue) <= 1000) {
                $db->query(
                    "INSERT INTO form_fields (event_id, field_name, field_value) VALUES (?, ?, ?)",
                    [$eventId, $fieldName, $fieldValue]
                );
            }
        }
    }

    // Подтверждаем транзакцию
    $db->commit();
    echo json_encode(['success' => true, 'message' => $autoReplay]);
} catch (Exception $e) {
    $db->rollback();
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
} finally {
    $db->close();
}

