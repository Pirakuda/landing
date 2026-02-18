<?php
require_once __DIR__ . '/../../config/config.php';
//require_once __DIR__ . '/../modules/core/send_functions.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$mainId = Config::MAIN_ID;
$systemToken = Config::SYSTOKEN;

$apiUrl = "https://lawandtech.ru/modules/api/website/get_countComment.php";
$data = json_encode([
    'token' => $systemToken,
    'source' => 'site.com' // Явно указываем источник
]);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $apiUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_TIMEOUT, 10);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);
curl_close($ch);

if ($httpCode !== 200) {
    echo json_encode(['success' => false, 'message' => "Ошибка API: HTTP $httpCode" . ($curlError ? " - $curlError" : "")]);
    exit();
}

$decodedResponse = json_decode($response, true);
if (!$decodedResponse) {
    echo json_encode(['success' => false, 'message' => 'Невалидный JSON в ответе: ' . json_last_error_msg()]);
    exit();
}

echo $response;
exit();