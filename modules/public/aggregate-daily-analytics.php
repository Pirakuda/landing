<?php
// /cron/aggregate-daily-analytics.php

require_once __DIR__ . '/../../database/database.php';
require_once __DIR__ . '/../../config/config.php';

$db = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);
$yesterday = date('Y-m-d', strtotime('-1 day'));

echo "Starting daily aggregation for {$yesterday}...\n";

try {
    // Агрегируем сессии
    $sessionStats = $db->fetch(
        "SELECT 
            COUNT(DISTINCT session_id) as total_sessions,
            COUNT(DISTINCT visitor_id) as unique_visitors,
            AVG(session_duration) as avg_session_duration,
            SUM(CASE WHEN device_type = 'desktop' THEN 1 ELSE 0 END) as desktop_views,
            SUM(CASE WHEN device_type = 'mobile' THEN 1 ELSE 0 END) as mobile_views,
            SUM(CASE WHEN device_type = 'tablet' THEN 1 ELSE 0 END) as tablet_views,
            SUM(page_views) as total_pageviews,
            (SUM(CASE WHEN bounce = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) as bounce_rate
         FROM web_sessions 
         WHERE DATE(created_at) = ? AND is_bot = 0",
        [$yesterday]
    );
    
    // Топ разделы из событий
    $topSections = $db->fetchAll(
        "SELECT 
            JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.section_url')) as section_url,
            COUNT(*) as total_views,
            COUNT(DISTINCT session_id) as unique_visitors,
            AVG(CAST(JSON_EXTRACT(event_data, '$.time_spent') AS SIGNED)) as avg_time_spent,
            SUM(CAST(JSON_EXTRACT(event_data, '$.time_spent') AS SIGNED)) as total_time_spent
         FROM analytics_events_buffer eb
         WHERE event_type IN ('section_view', 'section_transition')
         AND DATE(created_at) = ?
         AND JSON_EXTRACT(event_data, '$.section_url') IS NOT NULL
         GROUP BY JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.section_url'))
         ORDER BY total_views DESC LIMIT 10",
        [$yesterday]
    );
    
    // Обработка случая, когда нет данных
    if (!$sessionStats) {
        $sessionStats = [
            'total_sessions' => 0,
            'unique_visitors' => 0,
            'avg_session_duration' => 0,
            'desktop_views' => 0,
            'mobile_views' => 0,
            'tablet_views' => 0,
            'total_pageviews' => 0,
            'bounce_rate' => 0
        ];
    }
    
    if (!$topSections) {
        $topSections = [];
    }
    
    // Сохраняем агрегированные данные
    $db->query(
        "INSERT INTO local_daily_stats (
            date, total_sessions, unique_visitors, total_pageviews, avg_session_duration,
            desktop_views, mobile_views, tablet_views, top_sections, bounce_rate
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            total_sessions = VALUES(total_sessions),
            unique_visitors = VALUES(unique_visitors),
            total_pageviews = VALUES(total_pageviews),
            avg_session_duration = VALUES(avg_session_duration),
            desktop_views = VALUES(desktop_views),
            mobile_views = VALUES(mobile_views),
            tablet_views = VALUES(tablet_views),
            top_sections = VALUES(top_sections),
            bounce_rate = VALUES(bounce_rate)",
        [
            $yesterday,
            $sessionStats['total_sessions'],
            $sessionStats['unique_visitors'],
            $sessionStats['total_pageviews'],
            round($sessionStats['avg_session_duration'] ?? 0, 2),
            $sessionStats['desktop_views'],
            $sessionStats['mobile_views'],
            $sessionStats['tablet_views'],
            json_encode($topSections, JSON_UNESCAPED_UNICODE),
            round($sessionStats['bounce_rate'] ?? 0, 2)
        ]
    );
    
    // Очистка старых буферных данных (старше 7 дней)
    $cleanupDate = date('Y-m-d', strtotime('-7 days'));
    $cleanupResult = $db->query(
        "DELETE FROM analytics_events_buffer 
         WHERE DATE(created_at) < ? AND synced_at IS NOT NULL",
        [$cleanupDate]
    );
    
    // Очистка старых сессий (старше 60 дней)
    $sessionCleanupDate = date('Y-m-d', strtotime('-60 days'));
    $sessionCleanupResult = $db->query(
        "DELETE FROM web_sessions 
         WHERE DATE(created_at) < ?",
        [$sessionCleanupDate]
    );
    
    // Логируем результаты
    echo "Aggregation completed successfully!\n";
    echo "Date: {$yesterday}\n";
    echo "Total sessions: " . $sessionStats['total_sessions'] . "\n";
    echo "Unique visitors: " . $sessionStats['unique_visitors'] . "\n";
    echo "Total pageviews: " . $sessionStats['total_pageviews'] . "\n";
    echo "Average session duration: " . round($sessionStats['avg_session_duration'] ?? 0, 2) . " seconds\n";
    echo "Bounce rate: " . round($sessionStats['bounce_rate'] ?? 0, 2) . "%\n";
    echo "Top sections found: " . count($topSections) . "\n";
    
    if ($cleanupResult) {
        echo "Cleaned up old buffer events (older than {$cleanupDate})\n";
    }
    
    if ($sessionCleanupResult) {
        echo "Cleaned up old sessions (older than {$sessionCleanupDate})\n";
    }
    
    // Проверяем на потенциальные проблемы
    if ($sessionStats['total_sessions'] == 0) {
        echo "WARNING: No sessions found for {$yesterday}. Check if analytics is working properly.\n";
    }
    
    if (count($topSections) == 0) {
        echo "WARNING: No section views found for {$yesterday}. Check event tracking.\n";
    }
    
    // Отчет по устройствам
    $totalDeviceViews = $sessionStats['desktop_views'] + $sessionStats['mobile_views'] + $sessionStats['tablet_views'];
    if ($totalDeviceViews > 0) {
        echo "Device breakdown:\n";
        echo "  Desktop: " . $sessionStats['desktop_views'] . " (" . round(($sessionStats['desktop_views'] / $totalDeviceViews) * 100, 1) . "%)\n";
        echo "  Mobile: " . $sessionStats['mobile_views'] . " (" . round(($sessionStats['mobile_views'] / $totalDeviceViews) * 100, 1) . "%)\n";
        echo "  Tablet: " . $sessionStats['tablet_views'] . " (" . round(($sessionStats['tablet_views'] / $totalDeviceViews) * 100, 1) . "%)\n";
    }
    
    // Топ разделы в логе
    if (count($topSections) > 0) {
        echo "Top sections:\n";
        foreach (array_slice($topSections, 0, 5) as $i => $section) {
            echo "  " . ($i + 1) . ". " . $section['section_url'] . " (" . $section['total_views'] . " views, " . round($section['avg_time_spent'] ?? 0, 1) . "s avg)\n";
        }
    }
    
} catch (Exception $e) {
    echo "ERROR during aggregation: " . $e->getMessage() . "\n";
    echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
    
    // Логируем ошибку в файл
    error_log("Analytics aggregation error for {$yesterday}: " . $e->getMessage());
    
    exit(1); // Код ошибки для cron
}

echo "\nAggregation process completed at " . date('Y-m-d H:i:s') . "\n";
echo str_repeat('-', 50) . "\n";
?>