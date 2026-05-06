<?php
/**
 * HMAC verifier for inbound /internal/* requests from BriemChainAI server.
 *
 * Spec: CHANNELS-MODULE-DOC-v1_0.md §9.1 (canonical).
 * Deployed to: /var/www/briemchain.ai/modules/internal/hmac-verifier.php (TASK-L001b).
 *
 * Required Config:: constants (config/config.php):
 *   - Config::DOMAIN              (string, e.g. "briemchain.ai")
 *   - Config::BCAI_CHANNEL_ID     (int|string, e.g. 51)
 *   - Config::BCAI_CHANNEL_SECRET (string, e.g. "bc_secret_a1b2c3...")
 *
 * Usage in any /internal/* endpoint:
 *   require_once __DIR__ . '/hmac-verifier.php';
 *   $data = verifyIncomingRequest();   // halts with HTTP error on failure
 *   // ... use $data ...
 *
 * Error responses (verbatim per §9.1):
 *   400 Missing fields | Invalid JSON
 *   403 Timestamp expired | Invalid signature | Domain mismatch
 */

require_once __DIR__ . '/../../config/config.php';

if (!function_exists('verifyIncomingRequest')) {

    /**
     * Verify HMAC signature on incoming request, return decoded body or halt.
     *
     * @return array  Decoded JSON body on success.
     */
    function verifyIncomingRequest(): array
    {
        // 1. Read required headers (defensive: handle both $_SERVER and getallheaders).
        $channelIdHeader = $_SERVER['HTTP_X_CHANNEL_ID']  ?? '';
        $timestampHeader = $_SERVER['HTTP_X_TIMESTAMP']   ?? '';
        $signatureHeader = $_SERVER['HTTP_X_SIGNATURE']   ?? '';
        // X-Server-Id is informational per §9.1 — not verified, not logged with secrets.

        if ($channelIdHeader === '' || $timestampHeader === '' || $signatureHeader === '') {
            hmac_respond_error(400, 'Missing fields', 'missing-headers', null, 0);
        }

        // 2. Read raw body.
        $body = file_get_contents('php://input');
        if ($body === false || $body === '') {
            hmac_respond_error(400, 'Missing fields', 'empty-body', $timestampHeader, 0);
        }
        $bodyLen = strlen($body);

        // 3. Decode JSON.
        $data = json_decode($body, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            hmac_respond_error(400, 'Invalid JSON', 'invalid-json', $timestampHeader, $bodyLen);
        }

        // 4. Required body field: domain.
        if (!isset($data['domain']) || !is_string($data['domain']) || $data['domain'] === '') {
            hmac_respond_error(400, 'Missing fields', 'missing-domain', $timestampHeader, $bodyLen);
        }

        // 5. Anti-replay: |now - ts| <= 60 sec.
        $ts = intval($timestampHeader);
        if (abs(time() - $ts) > 60) {
            hmac_respond_error(403, 'Timestamp expired', 'replay-window', $timestampHeader, $bodyLen);
        }

        // 6. Channel-id sanity check (defense in depth — masked as Invalid signature).
        if ((string)$channelIdHeader !== (string)Config::BCAI_CHANNEL_ID) {
            hmac_respond_error(403, 'Invalid signature', 'channel-mismatch', $timestampHeader, $bodyLen);
        }

        // 7. HMAC verification (timing-safe).
        $expected = hash_hmac('sha256', $body . $timestampHeader, Config::BCAI_CHANNEL_SECRET);
        if (!hash_equals($expected, $signatureHeader)) {
            hmac_respond_error(403, 'Invalid signature', 'hmac-mismatch', $timestampHeader, $bodyLen);
        }

        // 8. Domain check.
        if ($data['domain'] !== Config::DOMAIN) {
            hmac_respond_error(403, 'Domain mismatch', 'domain-mismatch', $timestampHeader, $bodyLen);
        }

        return $data;
    }

    /**
     * Send error response and exit. Logs short reason code only — no secrets, no signature, no body.
     */
    function hmac_respond_error(int $status, string $message, string $code, ?string $timestamp, int $bodyLen): void
    {
        error_log(sprintf(
            'hmac-verifier: %d %s [code=%s ts=%s body_len=%d remote=%s]',
            $status,
            $message,
            $code,
            $timestamp ?? '-',
            $bodyLen,
            $_SERVER['REMOTE_ADDR'] ?? '-'
        ));
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode(['error' => $message]);
        exit;
    }
}
