-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Авг 27 2025 г., 14:57
-- Версия сервера: 8.0.42-33
-- Версия PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `cy13096_site`
--

DELIMITER $$
--
-- Процедуры
--
$$

--
-- Функции
--
$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `analytics_events`
--

CREATE TABLE IF NOT EXISTS `analytics_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `session_id` varchar(64) DEFAULT NULL,
  `event_type` enum('click','scroll','form_submit','download','video_play','conversion','custom') NOT NULL,
  `event_category` varchar(100) DEFAULT NULL,
  `event_action` varchar(100) DEFAULT NULL,
  `event_label` varchar(255) DEFAULT NULL,
  `event_value` decimal(10,2) DEFAULT NULL,
  `event_data` json DEFAULT NULL,
  `page_slug` varchar(255) DEFAULT NULL,
  `element_id` varchar(100) DEFAULT NULL,
  `element_class` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_visitor_id` (`visitor_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_organization_id` (`organization_id`),
  KEY `idx_created_date` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS `anonymous_analytics` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) NOT NULL,
  `event_type` varchar(50) NOT NULL DEFAULT 'section_view',
  `event_date` date NOT NULL,
  `device_type` varchar(50) DEFAULT 'unknown',
  `language` varchar(10) DEFAULT 'ru',
  `page_url` varchar(500) DEFAULT NULL,
  `events_count` int DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_daily_record` (`domain`(191),`event_date`,`page_url`(191),`device_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client_config`
--

CREATE TABLE IF NOT EXISTS `client_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain` (`domain`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `client_config`
--

INSERT INTO `client_config` (`id`, `organization_id`, `domain`, `token`, `is_active`, `created_at`) VALUES
(1, 143, 'relanding.de', '40ca43cee89000063b14faecd67429fa', 1, '2025-08-17 15:39:35');

-- --------------------------------------------------------

--
-- Структура таблицы `contents`
--

CREATE TABLE IF NOT EXISTS `contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `page_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cost` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sec_cost` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `benefits` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtitle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_content` text COLLATE utf8mb4_unicode_ci,
  `delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_link_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_link_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_sec_btn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_btn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `service_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'ru',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `m_promo` text COLLATE utf8mb4_unicode_ci,
  `m_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `m_text_content` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
)



CREATE TABLE IF NOT EXISTS `legal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_order` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `levels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_id` int DEFAULT NULL,
  `display_order` int DEFAULT '0',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `scr_full` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
)


CREATE TABLE IF NOT EXISTS `media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'IMAGE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `m_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL,
  `slug` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_order` int DEFAULT '0',
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `page_views` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(64) NOT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `page_slug` varchar(255) NOT NULL,
  `page_title` varchar(255) DEFAULT NULL,
  `page_url` text NOT NULL,
  `time_on_page` int DEFAULT '0',
  `scroll_depth` int DEFAULT '0',
  `exit_intent` tinyint(1) DEFAULT '0',
  `viewed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_visitor_id` (`visitor_id`),
  KEY `idx_page_slug` (`page_slug`),
  KEY `idx_viewed_date` (`viewed_at`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `render_cache` (
  `id` bigint UNSIGNED NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `page_slug` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ru',
  `device_type` enum('mobile','desktop') COLLATE utf8mb4_general_ci NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_record` (`domain`,`page_slug`,`language`,`device_type`),
  KEY `idx_domain_page_slug` (`domain`,`page_slug`,`language`,`device_type`)
)


CREATE TABLE IF NOT EXISTS `render_main_cache` (
  `id` bigint UNSIGNED NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `language` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ru',
  `socialMedia` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `legal` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `navStructure` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_record` (`domain`,`language`)
)

CREATE TABLE IF NOT EXISTS `render_theme_cache` (
  `id` bigint UNSIGNED NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `language` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ru',
  `device_type` enum('mobile','desktop') COLLATE utf8mb4_general_ci NOT NULL,
  `theme` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_record` (`domain`,`language`,`device_type`)
)

-- --------------------------------------------------------

--
-- Структура таблицы `screens`
--

CREATE TABLE IF NOT EXISTS `screens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `display_order` int DEFAULT '0',
  `site_id` int NOT NULL,
  `level_id` int NOT NULL,
  `style_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_rating` tinyint(1) DEFAULT '0',
  `img_pos` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'left-50',
  `text_pos` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'right',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=643 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `screen_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `screen_id` int NOT NULL,
  `content_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=500 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `screen_media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `screen_id` int NOT NULL,
  `media_id` int NOT NULL,
  `display_order` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=681 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `screen_style` (
  `id` int NOT NULL,
  `cost_sec_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cost_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promo_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promo_size` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title_size` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `benefits_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtitle_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_bg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_sec_btn_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_sec_btn_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_btn_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_act_btn_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `segment_theme_mapping`
--

CREATE TABLE IF NOT EXISTS `segment_theme_mapping` (
  `id` int NOT NULL,
  `segment_id` int NOT NULL,
  `theme_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `segment_theme_mapping`
--

INSERT INTO `segment_theme_mapping` (`id`, `segment_id`, `theme_id`) VALUES
(0, 1, 2),
(0, 3, 2),
(0, 5, 2),
(0, 7, 2),
(0, 8, 2),
(0, 11, 2),
(0, 13, 2),
(0, 15, 2),
(0, 17, 2),
(0, 2, 3),
(0, 4, 3),
(0, 6, 3),
(0, 9, 3),
(0, 10, 3),
(0, 12, 3),
(0, 14, 3),
(0, 16, 3),
(0, 18, 3),
(0, 1, 4),
(0, 3, 4),
(0, 5, 4),
(0, 7, 4),
(0, 8, 4),
(0, 11, 4),
(0, 13, 4),
(0, 15, 4),
(0, 17, 4);

-- --------------------------------------------------------

--
-- Структура таблицы `sites`
--

CREATE TABLE IF NOT EXISTS `sites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('landing','site') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'landing',
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'Brand',
  `slogan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'Slogan',
  `developer_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `developer_link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone1` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `version` int NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `social_media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_order` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `themes`
--

CREATE TABLE IF NOT EXISTS `themes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `page_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#444',
  `canvas_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#444',
  `canvas_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'circle',
  `bg_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `header_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#444',
  `header_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `popup_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#ddd',
  `popup_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '#444',
  `is_default` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lev_title_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#444',
  `lev_title_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#444',
  `menu_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `menu_cur_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#c4d3e3',
  `menu_hover_bg` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#dde3ea',
  `act_btn_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `act_btn_bg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'linear-gradient(135deg, #5b88b2, #122c4f)',
  `act_sec_btn_bg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'linear-gradient(135deg, #fff, #eee)',
  `act_sec_btn_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `text_bg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'linear-gradient(135deg, #122c4f, #5b88b2)',
  `full_text_bg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'linear-gradient(135deg, #fff, #eee)',
  `cost_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `full_cost_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `cost_sec_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `full_cost_sec_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `promo_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `full_promo_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#0b5daa',
  `title_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `full_title_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `benefits_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `full_benefits_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `subtitle_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `full_subtitle_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `text_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#eee',
  `full_text_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  `nav_btn_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#075197',
  `nav_cur_btn_color` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#122c4f',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_segments` (
  `id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user_segments`
--

INSERT INTO `user_segments` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'desktop_new_anonymous_direct', 'Анонимные пользователи десктопа из прямого трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(2, 'mobile_new_anonymous_direct', 'Анонимные пользователи мобильных устройств из прямого трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(3, 'desktop_new_anonymous_organic', 'Анонимные пользователи десктопа из органического трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(4, 'mobile_new_anonymous_organic', 'Анонимные пользователи мобильных устройств из органического трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(5, 'desktop_new_anonymous_social', 'Анонимные пользователи десктопа из социальных сетей', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(6, 'mobile_new_anonymous_social', 'Анонимные пользователи мобильных устройств из социальных сетей', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(7, 'desktop_new_direct', 'Новые пользователи десктопа из прямого трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(8, 'desktop_returning_direct', 'Повторные пользователи десктопа из прямого трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(9, 'mobile_new_direct', 'Новые пользователи мобильных устройств из прямого трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(10, 'mobile_returning_direct', 'Повторные пользователи мобильных устройств из прямого трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(11, 'desktop_new_organic', 'Новые пользователи десктопа из органического трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(12, 'mobile_new_organic', 'Новые пользователи мобильных устройств из органического трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(13, 'desktop_new_social', 'Новые пользователи десктопа из социальных сетей', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(14, 'mobile_new_social', 'Новые пользователи мобильных устройств из социальных сетей', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(15, 'desktop_returning_organic', 'Повторные пользователи десктопа из органического трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(16, 'mobile_returning_organic', 'Повторные пользователи мобильных устройств из органического трафика', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(17, 'desktop_returning_social', 'Повторные пользователи десктопа из социальных сетей', '2025-04-18 17:34:12', '2025-04-18 17:34:12'),
(18, 'mobile_returning_social', 'Повторные пользователи мобильных устройств из социальных сетей', '2025-04-18 17:34:12', '2025-04-18 17:34:12');

-- --------------------------------------------------------

--
-- Структура таблицы `user_sessions`
--

CREATE TABLE IF NOT EXISTS `user_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int DEFAULT NULL,
  `session_id` varchar(64) DEFAULT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `is_anonymous` tinyint(1) DEFAULT '0',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text,
  `country` varchar(2) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `language` varchar(10) DEFAULT 'ru',
  `device_type` enum('desktop','mobile','tablet') DEFAULT 'desktop',
  `browser` varchar(50) DEFAULT NULL,
  `os` varchar(50) DEFAULT NULL,
  `screen_resolution` varchar(20) DEFAULT NULL,
  `source` varchar(50) DEFAULT 'direct',
  `utm_source` varchar(100) DEFAULT NULL,
  `utm_medium` varchar(100) DEFAULT NULL,
  `utm_campaign` varchar(100) DEFAULT NULL,
  `utm_content` varchar(100) DEFAULT NULL,
  `utm_term` varchar(100) DEFAULT NULL,
  `referrer` text,
  `landing_page` varchar(255) DEFAULT NULL,
  `exit_page` varchar(255) DEFAULT NULL,
  `segment_id` int DEFAULT NULL,
  `is_returning` tinyint(1) DEFAULT '0',
  `page_views` int DEFAULT '1',
  `session_duration` int DEFAULT '0',
  `bounce` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_activity` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_visitor_id` (`visitor_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_date` (`created_at`),
  KEY `idx_last_activity` (`last_activity`),
  KEY `idx_source` (`source`),
  KEY `idx_device_type` (`device_type`),
  KEY `idx_is_returning` (`is_returning`),
  KEY `idx_org_date` (`organization_id`,`created_at`),
  KEY `idx_session_visitor` (`session_id`,`visitor_id`),
  KEY `idx_date_device` (`created_at`,`device_type`)
) ENGINE=InnoDB AUTO_INCREMENT=493 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `visitor_geography` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `country_code` varchar(2) DEFAULT NULL,
  `country_name` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `isp` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip_address` (`ip_address`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_country_code` (`country_code`),
  KEY `idx_city` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER $$
--
-- События
--
CREATE DEFINER=`cy13096`@`localhost` EVENT `analytics_cleanup_event` ON SCHEDULE EVERY 1 MONTH STARTS '2025-08-18 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL CleanOldAnalyticsData()$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
