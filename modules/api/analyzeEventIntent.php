<?php
require_once './../../../config/config.php';

header('Content-Type: application/json');

$RELANDING_TOKEN = Config::RELANDING_TOKEN;
$apiKey = Config::OPENAI_API_KEY;
$modelId = 'gpt-4-turbo';
$url = "https://api.openai.com/v1/chat/completions";

$mainId = Config::MAIN_ID;

// Проверяем, что это POST-запрос и есть тело запроса
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    // echo json_encode(['error' => 'Неверный метод запроса. Ожидается POST.']);
    exit;
}

// Читаем JSON-данные из тела запроса
$rawInput = file_get_contents("php://input");
$input = json_decode($rawInput, true);

// Проверяем корректность JSON
if (json_last_error() !== JSON_ERROR_NONE) {
    // echo json_encode(['error' => 'Ошибка JSON: ' . json_last_error_msg()]);
    exit;
}

// Проверяем, переданы ли нужные данные
if (!isset($input['lawandtechToken'], $input['analysisData'])) {
    // echo json_encode(['error' => 'Отсутствуют обязательные параметры.']);
    exit;
}

// стыковка серверов ////////////////////////////////////////////
$lawandtechToken = trim($input['lawandtechToken']);
if ($lawandtechToken !== $RELANDING_TOKEN) {
    // echo json_encode(['error' => 'Неверный токен.']);
    exit;
}

// Проверяем входные данные
$analysisData = $input['analysisData'] ?? [];
// file_put_contents("debug.log", "analysisData: " . print_r($analysisData, true) . "\n", FILE_APPEND);

$message = trim($analysisData['message'] ?? '');

$data = [
    "model" => $modelId,
    "messages" => [
        [
            "role" => "system",
            "content" => "Ты — интеллектуальный ассистент по первичной классификации клиентских обращений в омниканальной CRM-системе.

            На вход ты получаешь текст обращения от клиента. На выходе — строго **JSON-объект** с классификацией.

            Твоя задача — определить следующие параметры:

            1. **ai_intent** — намерение клиента (варианты: \"order\", \"question\", \"complaint\", \"feedback\", \"cancel\", \"error\", \"spam\", \"check\", \"followup\").
            2. **ai_type** — тип события (\"new\", \"reply\", \"continued\", \"forwarded\", \"attachment\", \"other\").
            3. **ai_tone** — тональность сообщения (\"neutral\", \"positive\", \"negative\").
            4. **ai_urgency** — срочность (\"low\", \"medium\", \"high\", \"critical\").
            5. **ai_confidence** — уровень уверенности в классификации (от 0.0 до 1.0).
            6. **ai_recommended_action** — что следует сделать (\"create_lead\", \"create_ticket\", \"create_task\", \"add_comment\", \"archive\", \"manual_review\").
            7. **ai_summary** — краткая суть обращения в 1-2 предложениях (строка, на русском языке).

            Ответ строго в JSON: 
            {\"ai_intent\":\"...\", \"ai_type\":\"...\", \"ai_tone\":\"...\", \"ai_urgency\":\"...\", \"ai_confidence\":\"...\", \"ai_recommended_action\":\"...\", \"ai_summary\":\"...\"}"
        ],
        [
            "role" => "user",
            "content" => "Проанализируй сообщение: \"$message\" и верни только JSON-объект."
        ]
    ],
    "temperature" => 0.2
];

$headers = [
    "Authorization: Bearer $apiKey",
    "Content-Type: application/json"
];

// Отправляем запрос в ChatGPT
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

// file_put_contents("debug.log", "Ответ OpenAI (сырой): " . $response . "\n", FILE_APPEND);

if ($httpCode !== 200 || !$response) {
    echo json_encode(['error' => 'OpenAI request failed']);
    exit;
}

// Извлекаем контент
$decoded = json_decode($response, true);
$content = trim($decoded['choices'][0]['message']['content'] ?? '');

$parsed = json_decode($content, true);

if (!is_array($parsed) || !isset($parsed['ai_intent'])) {
    echo json_encode(['error' => 'Invalid AI response']);
    exit;
}

// Ответ
echo json_encode($parsed);
exit;