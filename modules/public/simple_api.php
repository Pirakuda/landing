<?php
// test_simple_api.php

echo "=== Тест простого API ===\n";

$url = "https://relanding.ru/modules/public/simple_api.php";

$ch = curl_init();
curl_setopt_array($ch, [
    CURLOPT_URL => $url,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => 'date_from=2025-08-14&date_to=2025-08-16',
    CURLOPT_HTTPHEADER => [
        'Content-Type: application/x-www-form-urlencoded',
        'User-Agent: Analytics-Worker/1.0'
    ],
    CURLOPT_TIMEOUT => 30,
    CURLOPT_SSL_VERIFYPEER => false,
    CURLOPT_SSL_VERIFYHOST => false
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);
curl_close($ch);

echo "HTTP код: $httpCode\n";
echo "cURL ошибка: " . ($curlError ?: "нет") . "\n";

if ($curlError) {
    echo "❌ Ошибка cURL: $curlError\n";
    exit;
}

if ($httpCode !== 200) {
    echo "❌ HTTP ошибка: $httpCode\n";
    echo "Ответ: $response\n";
    exit;
}

$data = json_decode($response, true);
if (!$data) {
    echo "❌ Невалидный JSON\n";
    echo "Ответ: $response\n";
    exit;
}

if ($data['success']) {
    echo "✅ API работает!\n";
    echo "📊 Сессий: " . $data['sessions_count'] . "\n";
    
    if ($data['sessions_count'] > 0) {
        echo "📄 Первая сессия:\n";
        $first = $data['sessions'][0];
        echo "  ID: {$first['id']}\n";
        echo "  Session ID: {$first['session_id']}\n";
        echo "  Дата: {$first['created_at']}\n";
        echo "  Устройство: {$first['device_type']}\n";
        
        echo "\n🎉 ГОТОВО! Можно тестировать воркер!\n";
    }
} else {
    echo "❌ API ошибка: " . $data['error'] . "\n";
}