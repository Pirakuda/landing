-- Агрегированная локальная статистика (новая таблица)
CREATE TABLE local_daily_stats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL,
    total_sessions INT DEFAULT 0 COMMENT 'Всего сессий',
    unique_visitors INT DEFAULT 0 COMMENT 'Уникальных посетителей',
    total_pageviews INT DEFAULT 0 COMMENT 'Всего просмотров страниц',
    avg_session_duration DECIMAL(10,2) DEFAULT 0 COMMENT 'Средняя длительность сессии (сек)',
    desktop_views INT DEFAULT 0,
    mobile_views INT DEFAULT 0,
    tablet_views INT DEFAULT 0,
    top_sections JSON COMMENT 'Топ разделов с метриками в JSON',
    bounce_rate DECIMAL(5,2) DEFAULT 0 COMMENT 'Показатель отказов (%)',
    
    UNIQUE KEY unique_date (date),
    INDEX idx_date (date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ежедневная агрегированная статистика';
