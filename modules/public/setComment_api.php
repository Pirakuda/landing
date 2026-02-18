<?php
require_once __DIR__ . '/../../config/config.php';
//require_once __DIR__ . '/../core/send_functions.php';

$mainId = Config::MAIN_ID;

$systemToken = Config::SYSTOKEN;
$apiUrl = "https://lawandtech.ru/modules/api/website/set_comment.php";

$rawInput = file_get_contents("php://input");
$input = json_decode($rawInput, true);

$rating = isset($input['rating']) ? $input['rating'] : null;
$name = isset($input['name']) ? $input['name'] : 'Гость';
$message = isset($input['message']) ? $input['message'] : null;

$data = json_encode([
    'token' => $systemToken,
    'rating' => $rating,
    'name' => $name,
    'message' => $message,
    'source' => 'site.com' // Явно указываем источник
]);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $apiUrl);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json'
]);

$response = curl_exec($ch);

if (curl_errno($ch)) {
    echo json_encode(['success' => false, 'message' => 'Ошибка cURL: ' . curl_error($ch)]);
    exit();
}

curl_close($ch);

// 📌 Логируем ответ API
// file_put_contents(__DIR__ . "/curl_log.txt", "Ответ API: " . $response, FILE_APPEND);

header('Content-Type: application/json');
echo $response;
exit();
