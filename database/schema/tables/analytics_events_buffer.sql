-- Буфер аналитических событий (новая таблица)
CREATE TABLE analytics_events_buffer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    session_id VARCHAR(100) NOT NULL,
    event_type ENUM('section_view', 'session_end') NOT NULL DEFAULT 'section_view',
    event_data JSON NOT NULL COMMENT 'Данные события в JSON формате',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    synced_at TIMESTAMP NULL COMMENT 'Время синхронизации с центральным сервером',
    sync_attempts INT DEFAULT 0 COMMENT 'Количество попыток синхронизации',
    
    INDEX idx_session (session_id),
    INDEX idx_synced (synced_at),
    INDEX idx_created_at (created_at),
    INDEX idx_event_type (event_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Буфер событий аналитики';
