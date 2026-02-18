<?php

require_once __DIR__ . '/../../config/config.php';

// $mainId = Config::MAIN_ID;

$systemToken = Config::SYSTOKEN;
$apiUrl = "https://lawandtech.ru/modules/api/website/set_websiteFeedback.php";

// Получаем `JSON`-данные
$rawInput = file_get_contents("php://input");
$input = json_decode($rawInput, true);
$honeypot = isset($input['honeypot']) ? $input['honeypot'] : '';

if (!empty($honeypot)) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Bot detected']);
    exit;
}

// base variable
$name = isset($input['name']) ? $input['name'] : '';
$email = isset($input['email']) ? $input['email'] : '';
$phone = isset($input['phone']) ? $input['phone'] : '';
$message = isset($input['message']) ? $input['message'] : '';

// secondary variable
$cadastralNumber = isset($input['cadastral_number']) ? $input['cadastral_number'] : '';
$address = isset($input['address']) ? $input['address'] : '';
$landPurpose = isset($input['land_purpose']) ? $input['land_purpose'] : '';
$contactTime = isset($input['contact_time']) ? $input['contact_time'] : '';

$data = json_encode([
    'token' => $systemToken,
    'honeypot' => $honeypot,
    'name' => $name,
    'email' => $email,
    'phone' => $phone,
    'message' => $message,
    'cadastralNumber' => $cadastralNumber,
    'address' => $address,
    'landPurpose' => $landPurpose,
    'contactTime' => $contactTime,
    'source' => 'sikamo.ru' // указываем источник
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

header('Content-Type: application/json');
echo $response;
exit();

// file_put_contents(__DIR__ . "/curl_log.txt", "Ответ API: " . $response, FILE_APPEND);
