<?php
/**
 * /internal/ping — smoke endpoint for HMAC-protected server-to-server channel.
 *
 * Routed by .htaccess: /internal/ping → /modules/internal/ping.php
 * Verifies HMAC, returns 200 JSON on success or canonical 400/403 on failure.
 */

require_once __DIR__ . '/hmac-verifier.php';

$data = verifyIncomingRequest();   // halts on invalid HMAC

header('Content-Type: application/json');
echo json_encode([
    'ok' => true,
    'message' => 'HMAC verified',
    'received_domain' => $data['domain'] ?? null,
    'timestamp' => time(),
]);
