-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Авг 30 2025 г., 17:00
-- Версия сервера: 8.0.42-33
-- Версия PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `cy13096_briem`
--

-- --------------------------------------------------------

--
-- Структура таблицы `analytics_daily_reports`
--

CREATE TABLE IF NOT EXISTS `analytics_daily_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `domain` varchar(255) NOT NULL,
  `report_date` date NOT NULL,
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_org_domain_date` (`organization_id`,`domain`,`report_date`),
  KEY `idx_organization_id` (`organization_id`),
  KEY `idx_report_date` (`report_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `analytics_processing_log`
--

CREATE TABLE IF NOT EXISTS `analytics_processing_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_processed_time` int NOT NULL,
  `records_processed` int DEFAULT '0',
  `processed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_domain` (`organization_id`,`domain`),
  KEY `processed_at` (`processed_at`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `analytics_processing_log`
--

INSERT INTO `analytics_processing_log` (`id`, `organization_id`, `domain`, `last_processed_time`, `records_processed`, `processed_at`) VALUES
(1, 141, 'relanding.ru', 1756544822, 0, '2025-08-30 09:07:02');

-- --------------------------------------------------------

--
-- Структура таблицы `attachments`
--

CREATE TABLE IF NOT EXISTS `attachments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `organization_id` int NOT NULL,
  `related_type` varchar(50) DEFAULT NULL,
  `related_id` int DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `file_url` text NOT NULL,
  `content_type` varchar(100) DEFAULT NULL,
  `file_size` int DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `uploaded_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_org_related` (`organization_id`,`related_type`,`related_id`),
  KEY `idx_filename` (`filename`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `business_facts`
--

CREATE TABLE IF NOT EXISTS `business_facts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `source_id` int DEFAULT NULL,
  `page_slug` varchar(128) DEFAULT NULL,
  `fact_key` varchar(64) DEFAULT NULL,
  `fact_value` json DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `business_facts`
--

INSERT INTO `business_facts` (`id`, `organization_id`, `source_id`, `page_slug`, `fact_key`, `fact_value`, `valid_from`, `valid_until`, `is_active`, `created_at`) VALUES
(1, 141, 90, 'glavnaya', 'company_name', '\"BriemChainAI\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(2, 141, 90, 'glavnaya', 'ecosystem_products', '[\"AI-сайт\", \"AI-лендинг\", \"AI-CRM\", \"AI-продвижение\", \"AI-экосистема\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(3, 141, 90, 'glavnaya', 'main_benefit', '\"Прибыль в 3 раза больше через синергию 4 AI-продуктов\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(4, 141, 90, 'glavnaya', 'target_market', '\"агентства недвижимости Краснодара\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(5, 141, 90, 'glavnaya', 'unique_value', '\"единственная система с полным циклом AI-автоматизации\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(6, 141, 90, 'glavnaya', 'ai_website_price_setup', '{\"max\": 300000, \"min\": 180000, \"currency\": \"RUB\", \"description\": \"настройка\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(7, 141, 90, 'glavnaya', 'ai_website_price_monthly', '{\"value\": 25000, \"currency\": \"RUB\", \"description\": \"ежемесячная поддержка\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(8, 141, 90, 'glavnaya', 'ai_website_combo_offer', '{\"price\": 50000, \"currency\": \"RUB\", \"description\": \"AI-Website + AI-Promotion в месяц, 1 месяц бесплатно\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(9, 141, 90, 'glavnaya', 'ai_website_loading_speed', '{\"value\": \"0.3 секунды\", \"vs_market\": \"против 2-6 секунд\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(10, 141, 90, 'glavnaya', 'ai_website_seo_pages', '{\"count\": \"100+\", \"description\": \"SEO-разделов под районы Краснодара\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(11, 141, 90, 'glavnaya', 'ai_website_visibility', '{\"percentage\": \"80%\", \"description\": \"видимости в поиске с первых дней\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(12, 141, 90, 'glavnaya', 'ai_website_traffic_growth', '{\"period\": \"за 14 дней\", \"multiplier\": \"3-5 раз\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(13, 141, 90, 'glavnaya', 'ai_website_organic_leads', '{\"percentage\": \"50-80%\", \"description\": \"лидов из поиска без рекламы\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(14, 141, 90, 'glavnaya', 'ai_landing_price_single', '{\"max\": 120000, \"min\": 85000, \"currency\": \"RUB\", \"description\": \"за 1 лендинг\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(15, 141, 90, 'glavnaya', 'ai_landing_price_monthly', '{\"value\": 15000, \"currency\": \"RUB\", \"description\": \"поддержка лендинга\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(16, 141, 90, 'glavnaya', 'ai_landing_discount', '{\"condition\": \"на 2+ лендинга\", \"percentage\": 10, \"price_per_landing\": 75000}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(17, 141, 90, 'glavnaya', 'ai_landing_conversion', '{\"rate\": \"15-25%\", \"vs_market\": \"против 3-5% обычных лендингов\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(18, 141, 90, 'glavnaya', 'ai_landing_launch_time', '{\"days\": \"5-7\", \"vs_market\": \"против 4 недель\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(19, 141, 90, 'glavnaya', 'ai_landing_leads_increase', '{\"condition\": \"при том же бюджете\", \"percentage\": \"+30-50%\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(20, 141, 90, 'glavnaya', 'ai_landing_roi_period', '{\"days\": 30, \"description\": \"окупаемость\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(21, 141, 90, 'glavnaya', 'ai_core_price_setup', '{\"max\": 350000, \"min\": 220000, \"currency\": \"RUB\", \"description\": \"настройка\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(22, 141, 90, 'glavnaya', 'ai_core_price_basic', '{\"value\": 25000, \"currency\": \"RUB\", \"description\": \"базовый тариф до 5 сотрудников\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(23, 141, 90, 'glavnaya', 'ai_core_price_standard', '{\"value\": 35000, \"currency\": \"RUB\", \"description\": \"стандарт до 10 сотрудников\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(24, 141, 90, 'glavnaya', 'ai_core_price_premium', '{\"value\": 65000, \"currency\": \"RUB\", \"description\": \"премиум до 20+ сотрудников\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(25, 141, 90, 'glavnaya', 'ai_core_processing_time', '{\"minutes\": 2, \"vs_standard\": \"против 2 часов обычной обработки\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(26, 141, 90, 'glavnaya', 'ai_core_lead_loss', '{\"our\": \"0-5%\", \"market\": \"30%\", \"description\": \"потери заявок\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(27, 141, 90, 'glavnaya', 'ai_core_channels', '[\"сайт\", \"Авито\", \"ЦИАН\", \"WhatsApp\", \"Telegram\", \"ВКонтакте\", \"телефония\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(28, 141, 90, 'glavnaya', 'ai_core_leads_increase', '{\"count\": \"+30-50\", \"period\": \"обращений в месяц\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(29, 141, 90, 'glavnaya', 'ai_promotion_seo_only', '{\"max\": 65000, \"min\": 35000, \"currency\": \"RUB\", \"description\": \"только SEO\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(30, 141, 90, 'glavnaya', 'ai_promotion_full', '{\"max\": 95000, \"min\": 55000, \"currency\": \"RUB\", \"description\": \"SEO + контент\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(31, 141, 90, 'glavnaya', 'ai_promotion_free_month', '{\"savings\": \"до 95000 рублей\", \"condition\": \"при покупке AI-Website/AI-Landing\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(32, 141, 90, 'glavnaya', 'ai_promotion_keywords', '{\"count\": \"1200+\", \"description\": \"ключевых запросов по недвижимости Краснодара\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(33, 141, 90, 'glavnaya', 'ai_promotion_competitors', '{\"count\": \"50+\", \"description\": \"конкурентов под мониторингом\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(34, 141, 90, 'glavnaya', 'ai_promotion_clients', '{\"count\": \"+25-40\", \"period\": \"новых клиентов ежемесячно\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(35, 141, 90, 'glavnaya', 'ai_promotion_roi', '{\"period\": \"окупается за 3 дня\", \"percentage\": \"4000-8000%\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(36, 141, 90, 'glavnaya', 'package_start_price', '{\"setup\": 280000, \"yearly\": 820000, \"monthly\": 45000, \"currency\": \"RUB\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(37, 141, 90, 'glavnaya', 'package_start_includes', '[\"AI-сайт\", \"AI-CRM базовый\", \"AI-продвижение 3 мес\", \"до 10 сотрудников\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(38, 141, 90, 'glavnaya', 'package_start_target', '\"малые агентства 5-10 сотрудников\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(39, 141, 90, 'glavnaya', 'package_profi_price', '{\"setup\": 520000, \"yearly\": 1540000, \"monthly\": 85000, \"currency\": \"RUB\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(40, 141, 90, 'glavnaya', 'package_profi_includes', '[\"AI-сайт\", \"3 AI-лендинг\", \"AI-CRM полный\", \"AI-продвижение\", \"до 20 сотрудников\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(41, 141, 90, 'glavnaya', 'package_profi_target', '\"средние агентства 10-20 сотрудников\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(42, 141, 90, 'glavnaya', 'package_profi_result', '\"+40% выручки за 6 месяцев\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(43, 141, 90, 'glavnaya', 'package_empire_price', '{\"setup\": 750000, \"yearly\": 2190000, \"monthly\": 120000, \"currency\": \"RUB\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(44, 141, 90, 'glavnaya', 'package_empire_includes', '[\"AI-сайт корпоративный\", \"5 AI-лендинг\", \"AI-CRM unlimited\", \"AI-продвижение агрессивное\", \"BI-отчеты\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(45, 141, 90, 'glavnaya', 'package_empire_target', '\"крупные агентства 20+ сотрудников\"', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(46, 141, 90, 'glavnaya', 'ecosystem_synergy', '{\"formula\": \"1+1+1+1=10\", \"description\": \"синергия 4 AI-продуктов\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(47, 141, 90, 'glavnaya', 'ecosystem_profit_growth', '{\"multiplier\": \"в 3 раза\", \"description\": \"рост прибыли через синергию\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(48, 141, 90, 'glavnaya', 'ecosystem_launch_time', '{\"days\": 28, \"description\": \"полный запуск экосистемы\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(49, 141, 90, 'glavnaya', 'ecosystem_roi', '{\"period\": \"за 6-8 месяцев\", \"percentage\": \"400%\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(50, 141, 90, 'glavnaya', 'krasnodar_districts', '[\"ФМР (семьи с детьми)\", \"ЦМР (молодые специалисты)\", \"КМР (инвесторы)\", \"Прикубанский\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(51, 141, 90, 'glavnaya', 'krasnodar_seasons', '{\"autumn\": \"новостройки\", \"spring\": \"загородная недвижимость\", \"summer\": \"курортная\", \"winter\": \"квартиры и коммерческая\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(52, 141, 90, 'glavnaya', 'krasnodar_integrations', '[\"Авито\", \"ЦИАН\", \"Домклик\", \"Яндекс.Недвижимость\", \"банки Краснодара\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(53, 141, 90, 'glavnaya', 'current_offers', '[\"Скидка до 50% до 30 июля 2025\", \"2 месяца без абонплаты\", \"VIP-поддержка 6 мес\", \"Trade-in до 15%\"]', '2025-07-30', NULL, 1, '2025-08-12 13:29:28'),
(54, 141, 90, 'glavnaya', 'trade_in_website', '{\"discount\": \"15%\", \"description\": \"скидка за старый сайт\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(55, 141, 90, 'glavnaya', 'trade_in_landing', '{\"discount\": \"10%\", \"description\": \"скидка за старый лендинг\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(56, 141, 90, 'glavnaya', 'special_savings', '{\"max\": 897500, \"min\": 260000, \"currency\": \"RUB\", \"description\": \"общая экономия при покупке пакета\"}', '2025-07-30', NULL, 1, '2025-08-12 13:29:28'),
(57, 141, 90, 'glavnaya', 'technical_uptime', '{\"percentage\": \"99.9%\", \"description\": \"гарантированное время работы\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(58, 141, 90, 'glavnaya', 'technical_backup', '{\"frequency\": \"каждые 6 часов\", \"description\": \"резервные копии\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(59, 141, 90, 'glavnaya', 'technical_support', '{\"availability\": \"24/7\", \"response_time\": \"в течение 2 часов\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(60, 141, 90, 'glavnaya', 'legal_compliance', '{\"standard\": \"152-ФЗ\", \"description\": \"полное соответствие законодательству РФ\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(61, 141, 90, 'glavnaya', 'cost_savings_total', '{\"vs\": \"штат маркетологов\", \"amount\": \"до 715000\", \"period\": \"в месяц\", \"currency\": \"RUB\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(62, 141, 90, 'glavnaya', 'revenue_increase', '{\"amount\": \"3-7 млн\", \"period\": \"дополнительная прибыль в год\", \"currency\": \"RUB\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(63, 141, 90, 'glavnaya', 'payback_period', '{\"max_days\": 180, \"min_days\": 30, \"description\": \"срок окупаемости в зависимости от пакета\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(64, 141, 90, 'glavnaya', 'contact_response_time', '{\"hours\": 2, \"description\": \"время ответа на обращения\"}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(65, 141, 90, 'glavnaya', 'demo_available', '{\"formats\": [\"онлайн презентация 30-45 мин\", \"очная встреча 1-1.5 часа\", \"тестовый доступ 7 дней\"], \"personalization\": true}', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(66, 141, 90, 'glavnaya', 'implementation_stages', '[\"анализ и подготовка\", \"разработка и настройка\", \"тестирование\", \"запуск и обучение\"]', '2025-01-01', NULL, 1, '2025-08-12 13:29:28'),
(67, 141, 90, 'glavnaya', 'ai_website_description', '\"Умные корпоративные сайты с AI-оптимизацией\"', NULL, NULL, 1, '2025-08-13 07:09:40'),
(68, 141, 90, 'glavnaya', 'ai_landing_description', '\"Продающие лендинги с AI-персонализацией\"', NULL, NULL, 1, '2025-08-13 07:09:40'),
(69, 141, 90, 'glavnaya', 'ai_crm_description', '\"CRM-система с AI-автоматизацией через Telegram\"', NULL, NULL, 1, '2025-08-13 07:09:40'),
(70, 141, 90, 'glavnaya', 'ai_promotion_description', '\"Комплексное продвижение с AI-аналитикой\"', NULL, NULL, 1, '2025-08-13 07:09:40'),
(71, 141, 90, 'glavnaya', 'ai_crm_price_setup', '{\"max\": 300000, \"min\": 150000, \"currency\": \"RUB\", \"description\": \"настройка AI-CRM системы\"}', NULL, NULL, 1, '2025-08-13 07:15:25'),
(72, 141, 90, 'glavnaya', 'ai_crm_price_basic', '{\"value\": 25000, \"currency\": \"RUB\", \"description\": \"базовый тариф AI-CRM\"}', NULL, NULL, 1, '2025-08-13 07:15:25'),
(73, 141, 90, 'glavnaya', 'ai_crm_price_premium', '{\"value\": 75000, \"currency\": \"RUB\", \"description\": \"премиум тариф AI-CRM\"}', NULL, NULL, 1, '2025-08-13 07:15:25'),
(74, 141, 90, 'glavnaya', 'ai_crm_features_basic', '[\"обработка заявок\", \"telegram уведомления\", \"базовая аналитика\"]', NULL, NULL, 1, '2025-08-13 07:15:25'),
(75, 141, 90, 'glavnaya', 'ai_crm_features_premium', '[\"полная автоматизация\", \"AI-аналитика\", \"интеграции\", \"персональный менеджер\"]', NULL, NULL, 1, '2025-08-13 07:15:25');

-- --------------------------------------------------------

--
-- Структура таблицы `business_profiles`
--

CREATE TABLE IF NOT EXISTS `business_profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `services` text COLLATE utf8mb4_general_ci NOT NULL,
  `contact_info` text COLLATE utf8mb4_general_ci NOT NULL,
  `faq` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `business_profiles`
--

INSERT INTO `business_profiles` (`id`, `organization_id`, `description`, `services`, `contact_info`, `faq`, `created_at`) VALUES
(18, 141, '? *Добро пожаловать в BriemChainAI!* ?\\\\n\\\\nBriemChainAI — это революционная *модульная система* для управления организациями. ?\\\\n\\\\n? Создавайте *умные организации* и автоматизируйте бизнес-процессы.\\\\n? Управляйте командой, добавляйте сотрудников и делегируйте задачи в одно касание. \\\\n✅ Создать свою организацию `/createOrg', '', '', NULL, '2025-04-09 16:40:54'),
(19, 142, 'Welcome to BriemSales!', '', '', NULL, '2025-04-09 17:03:11'),
(25, 147, 'Welcome to Sikamo!', '', '', NULL, '2025-05-19 18:59:02');

-- --------------------------------------------------------

--
-- Структура таблицы `chat_intents`
--

CREATE TABLE IF NOT EXISTS `chat_intents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(64) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `trigger_patterns` json DEFAULT NULL,
  `required_terms` json DEFAULT NULL,
  `forbidden_terms` json DEFAULT NULL,
  `priority` tinyint DEFAULT '0',
  `fallback_action` varchar(32) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `chat_intents`
--

INSERT INTO `chat_intents` (`id`, `code`, `title`, `trigger_patterns`, `required_terms`, `forbidden_terms`, `priority`, `fallback_action`, `created_at`) VALUES
(1, 'pricing', 'Вопросы о ценах', '[\"стоит\", \"цена\", \"стоимость\", \"сколько\", \"тариф\", \"прайс\", \"руб\", \"рублей\", \"бюджет\"]', '[]', '[]', 9, 'create_lead', '2025-08-12 14:11:52'),
(2, 'consultation', 'Консультации по продуктам', '[\"консультация\", \"расскажите\", \"объясните\", \"что такое\", \"как работает\", \"подробнее\"]', '[]', '[]', 8, 'callback_request', '2025-08-12 14:11:52'),
(3, 'purchase_intent', 'Намерение покупки', '[\"хочу\", \"нужно\", \"заказать\", \"купить\", \"интересует\", \"приобрести\", \"взять\"]', '[]', '[]', 10, 'create_lead', '2025-08-12 14:11:52'),
(4, 'roi_question', 'Вопросы ROI и эффективности', '[\"окупаемость\", \"эффективность\", \"результат\", \"прибыль\", \"экономия\", \"roi\", \"выгода\", \"сэкономим\", \"увеличится\", \"инвестиции\"]', '[]', '[]', 9, 'create_lead', '2025-08-12 14:11:52'),
(5, 'timeline', 'Сроки внедрения', '[\"сроки\", \"время\", \"дней\", \"месяцев\", \"когда\", \"быстро\", \"внедрите\", \"запуск\", \"реализация\"]', '[]', '[]', 7, 'create_lead', '2025-08-12 14:11:52'),
(6, 'technical_support', 'Техподдержка', '[\"поддержка\", \"проблема\", \"ошибка\", \"не работает\", \"помощь\"]', '[\"поддержка\", \"проблема\", \"ошибка\"]', '[]', 8, 'create_ticket', '2025-08-12 14:11:52'),
(7, 'demo_request', 'Запрос демо', '[\"демо\", \"показать\", \"посмотреть\", \"презентация\", \"тест\", \"попробовать\", \"продемонстрировать\"]', '[]', '[]', 9, 'callback_request', '2025-08-12 14:11:52'),
(8, 'general_info', 'Общая информация', '[\"продукты\", \"услуги\", \"что предлагаете\", \"ваша экосистема\", \"ai решения\", \"что у вас есть\", \"чем занимаетесь\", \"продуктовая линейка\"]', '[]', '[]', 5, 'none', '2025-08-12 14:11:52'),
(9, 'website_questions', 'Вопросы по сайт', '[\"сайт\", \"website\", \"загрузка\", \"seo\", \"страниц\", \"отличия\", \"различия\", \"особенность\", \"эффективность\"]', '[\"сайт\"]', '[]', 8, 'create_lead', '2025-08-12 14:11:52'),
(10, 'landing_questions', 'Вопросы по AI-Landing', '[\"лендинг\", \"landing\", \"конверсия\", \"новостройки\"]', '[\"лендинг\"]', '[]', 8, 'create_lead', '2025-08-12 14:11:52'),
(11, 'core_questions', 'Вопросы по AI-Core', '[\"crm\", \"core\", \"автоматизация\", \"заявки\", \"telegram\", \"обработка\", \"каналы\", \"авито\", \"циан\", \"минуты\"]', '[]', '[]', 8, 'create_lead', '2025-08-12 14:11:52'),
(12, 'promotion_questions', 'Вопросы по AI-Promotion', '[\"продвижение\", \"promotion\", \"seo\", \"клиенты\", \"yandex\"]', '[\"продвижение\"]', '[]', 8, 'create_lead', '2025-08-12 14:11:52'),
(13, 'package_questions', 'Вопросы по пакетам', '[\"пакет\", \"экосистема\", \"полная\", \"автоматизация\", \"старт\", \"профи\", \"империя\", \"комплекс\", \"разница\", \"сотрудников\"]', '[]', '[]', 9, 'create_lead', '2025-08-12 14:11:52'),
(14, 'krasnodar_specifics', 'Краснодарская специфика', '[\"краснодар\", \"фмр\", \"цмр\", \"кмр\", \"районы\", \"регион\", \"недвижимости\", \"рынок\", \"знаете\"]', '[]', '[]', 6, 'none', '2025-08-12 14:11:52'),
(16, 'crm_pricing', 'Вопросы по ценам AI-CRM', '[\"crm\", \"цр м\", \"система управления\", \"автоматизация\", \"telegram бот\"]', '[\"цена\", \"стоит\", \"сколько\", \"тариф\", \"стоимость\"]', '[\"сайт\", \"лендинг\", \"продвижение\"]', 8, 'create_lead', '2025-08-13 07:15:57');

-- --------------------------------------------------------

--
-- Структура таблицы `clients`
--

CREATE TABLE IF NOT EXISTS `clients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `telegram_id` bigint DEFAULT NULL,
  `telegram_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_telegram_id` (`telegram_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `clients`
--

INSERT INTO `clients` (`id`, `telegram_id`, `telegram_name`, `name`, `email`, `phone`, `created_at`) VALUES
(55, NULL, NULL, 'Клиент из чата', NULL, NULL, '2025-08-12 14:48:54'),
(56, NULL, NULL, 'Клиент из чата', NULL, NULL, '2025-08-12 14:55:32'),
(57, NULL, 'Kiomata', 'Вальтер', 'web4vip@zoho.com', NULL, '2025-08-12 19:12:32'),
(58, NULL, NULL, 'Яндекс Дистрибуция', 'partners@distribution.yandex.ru', NULL, '2025-08-15 13:14:08'),
(59, NULL, NULL, 'Роман', 'isicahif@indeedseo.ru', NULL, '2025-08-15 13:14:18'),
(60, NULL, NULL, 'Noreply', 'noreply@relanding.ru', NULL, '2025-08-15 13:14:28');

-- --------------------------------------------------------

--
-- Структура таблицы `client_organization`
--

CREATE TABLE IF NOT EXISTS `client_organization` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `organization_id` int NOT NULL,
  `role` enum('customer','partner','supplier') NOT NULL DEFAULT 'customer',
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_client_org` (`client_id`,`organization_id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `client_organization`
--

INSERT INTO `client_organization` (`id`, `client_id`, `organization_id`, `role`, `status`, `created_at`) VALUES
(49, 57, 141, 'customer', 'active', '2025-08-12 19:12:32'),
(50, 58, 141, 'customer', 'active', '2025-08-15 13:14:08'),
(51, 59, 141, 'customer', 'active', '2025-08-15 13:14:18'),
(52, 60, 141, 'customer', 'active', '2025-08-15 13:14:28');

-- --------------------------------------------------------

--
-- Структура таблицы `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `target_type` enum('lead','ticket','task') COLLATE utf8mb4_general_ci NOT NULL,
  `target_id` int NOT NULL,
  `message` text COLLATE utf8mb4_general_ci NOT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `client_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`,`target_id`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_created_by` (`created_by`),
  KEY `fk_comments_client` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `comments`
--

INSERT INTO `comments` (`id`, `event_id`, `target_type`, `target_id`, `message`, `created_by`, `created_at`, `client_id`) VALUES
(14, 159, 'lead', 125, 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Walter Briem\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 13.08.2025 16:04:35\n', NULL, '2025-08-13 16:04:35', 57),
(15, 160, 'lead', 125, 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 15.08.2025 15:30:18\n', NULL, '2025-08-15 15:30:21', 57),
(16, 161, 'lead', 125, 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 15.08.2025 16:03:20\n', NULL, '2025-08-15 16:03:30', 57),
(17, 165, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-09 19:09:50\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:14:40', 60),
(18, 166, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: \r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-09 21:18:58\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:14:48', 60),
(19, 167, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 14:22:02\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:14:56', 60),
(20, 168, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 14:27:09\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:06', 60),
(21, 169, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:46:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:12', 60),
(22, 170, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:46:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:14', 60),
(23, 171, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:49:01\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:22', 60),
(24, 172, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:49:01\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:22', 60),
(25, 173, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:24:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:30', 60),
(26, 174, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:24:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:31', 60),
(27, 175, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:26:15\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:38', 60),
(28, 176, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:26:15\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:40', 60),
(29, 178, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:30:20\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:48', 60),
(30, 177, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:30:20\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:48', 60),
(31, 180, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:46:11\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:55', 60),
(32, 179, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:46:11\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:15:55', 60),
(33, 182, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:52:56\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:02', 60),
(34, 181, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:52:56\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:03', 60),
(35, 183, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:58:12\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:09', 60),
(36, 184, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:58:12\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:10', 60),
(37, 185, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:33:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:17', 60),
(38, 186, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:33:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:17', 60),
(39, 187, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:41:36\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:27', 60),
(40, 188, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:41:36\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:27', 60),
(41, 190, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: \r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:47:17\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:35', 60),
(42, 189, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: \r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:47:17\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:36', 60),
(43, 191, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:17:06\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:44', 60),
(44, 192, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:17:06\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:48', 60),
(45, 193, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:32:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:54', 60),
(46, 194, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:32:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:16:55', 60),
(47, 195, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:48:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:01', 60),
(48, 196, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:48:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:04', 60),
(49, 197, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:56:19\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:10', 60),
(50, 198, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:56:19\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:12', 60),
(51, 199, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:04:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:19', 60),
(52, 200, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:04:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:20', 60),
(53, 201, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:46:27\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:29', 60),
(54, 202, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:46:27\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:31', 60),
(55, 203, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 12:55:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:37', 60),
(56, 204, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 12:55:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:38', 60),
(57, 205, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 14:17:16\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:47', 60),
(58, 206, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 14:17:16\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:48', 60),
(59, 208, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:21:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:56', 60),
(60, 207, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:21:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:17:56', 60),
(61, 210, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:24:13\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:03', 60),
(62, 209, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:24:13\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:04', 60),
(63, 211, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 22:47:10\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:12', 60),
(64, 212, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 22:47:10\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:13', 60),
(65, 213, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:23:54\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:21', 60),
(66, 214, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:23:54\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:22', 60),
(67, 216, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:25:18\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:30', 60),
(68, 215, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:25:18\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:30', 60),
(69, 218, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:16:37\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:37', 60),
(70, 217, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:16:37\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:37', 60),
(71, 220, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:28:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:45', 60),
(72, 219, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:28:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:46', 60),
(73, 221, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:55:44\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:53', 60),
(74, 222, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:55:44\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:18:54', 60),
(75, 223, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 16:03:28\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:19:01', 60),
(76, 224, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 16:03:28\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-15 16:19:02', 60),
(77, 225, 'lead', 125, 'Здравствуйте, расскажите про ваши сайты, что позволяет им попадать в топ в поиске', NULL, '2025-08-15 16:33:13', 57),
(78, 226, 'lead', 125, 'проверка почты лавантека', NULL, '2025-08-15 17:47:17', 57),
(79, 227, 'lead', 125, 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 17.08.2025 19:23:11\n', NULL, '2025-08-17 19:23:22', 57),
(80, 228, 'lead', 125, 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 18.08.2025 17:14:25\n', NULL, '2025-08-18 17:14:41', 57),
(81, 229, 'lead', 125, 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 18.08.2025 18:29:30\n', NULL, '2025-08-18 18:29:56', 57),
(82, 230, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-17 19:23:19\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-19 07:00:21', 60),
(83, 231, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-18 17:14:20\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-19 07:00:32', 60),
(84, 232, 'lead', 128, 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-18 18:29:18\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', NULL, '2025-08-19 07:00:50', 60);

-- --------------------------------------------------------

--
-- Структура таблицы `conversation_feedback`
--

CREATE TABLE IF NOT EXISTS `conversation_feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int DEFAULT NULL,
  `session_id` varchar(64) DEFAULT NULL,
  `question` text,
  `intent_detected` varchar(64) DEFAULT NULL,
  `template_used` int DEFAULT NULL,
  `ai_response` text,
  `user_rating` tinyint DEFAULT NULL,
  `user_comment` text,
  `converted` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `conversation_feedback`
--

INSERT INTO `conversation_feedback` (`id`, `organization_id`, `session_id`, `question`, `intent_detected`, `template_used`, `ai_response`, `user_rating`, `user_comment`, `converted`, `created_at`) VALUES
(1, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит лендинг', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 14:59:55'),
(2, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'расскажи про особенность ваших сайтов', 'website_questions', NULL, 'Наши сайты обладают уникальными особенностями, которые позволяют им эффективно привлекать внимание и генерировать лиды. Во-первых, мы предлагаем оптимизацию SEO для {{ai_website_seo_pages}} под различные районы Краснодарского края, что обеспечивает высокую видимость в поисковых системах. Во-вторых, скорость загрузки страниц составляет {{ai_website_loading_speed}}, что значительно улучшает пользовательский опыт и снижает показатель отказов. Наконец, благодаря нашим технологиям, вы можете ожидать рост трафика на сайте до {{ai_website_traffic_growth}} и увеличение органических лидов до {{ai_website_organic_leads}}. Мы уверены, что такие характеристики сделают ваш сайт конкурентоспособным на рынке.', NULL, NULL, 0, '2025-08-12 15:00:32'),
(3, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит заказать у вас сайт', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 15:05:20'),
(4, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'расскажи про ИИ-CRM', 'core_questions', NULL, 'AI-Core предлагает интегрированное решение для управления отношениями с клиентами (CRM), использующее технологии искусственного интеллекта. Оно включает в себя автоматизацию процессов, анализ данных клиентов и предсказательную аналитику, что позволяет улучшить взаимодействие с клиентами и повысить эффективность продаж. \n\n- **Цена**: Установка AI-Core стоит {{ai_core_price_setup}}, а тарифы варьируются от {{ai_core_price_basic}} до {{ai_core_price_premium}}. \n- **Обработка**: Время обработки данных составляет {{ai_core_processing_time}}. \n- **Каналы**: AI-Core поддерживает различные каналы взаимодействия с клиентами, включая {{ai_core_channels}}.', NULL, NULL, 0, '2025-08-12 15:05:46'),
(5, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'что лучше сайт или лендинг, с чего стоит начать', 'pricing', NULL, 'Для начала, если у вас ограниченный бюджет и вы хотите быстро запустить рекламные кампании, рекомендуем начать с AI-LANDING. Он позволяет получить высокую конверсию и быстрое время запуска. Однако, если вы планируете долгосрочное присутствие в интернете и хотите привлекать трафик, лучше инвестировать в AI-WEBSITE, который обеспечит SEO-оптимизацию и рост трафика. Рекомендуем провести подробную консультацию, чтобы определить ваши конкретные потребности и цели.', NULL, NULL, 0, '2025-08-12 15:07:21'),
(6, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит лендинг', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 16:55:08'),
(7, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'AI-лендинг, сколько стоит', 'pricing', NULL, 'AI-лендинг стоит {{ai_landing_price_single}} ₽. Если вам нужна подробная консультация с рекомендацией, пожалуйста, дайте знать!', NULL, NULL, 0, '2025-08-12 16:55:51'),
(8, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит ИИ-CRM', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 17:14:31'),
(9, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'AI-Core сколько стоит', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 17:14:52'),
(10, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит лендинг', 'pricing', NULL, 'Стоимость лендинга составляет от 85 000 до 120 000 ₽. Рекомендуем провести подробную консультацию, чтобы определить оптимальное решение для ваших нужд.', NULL, NULL, 0, '2025-08-12 17:15:22'),
(11, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит crm', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 17:16:44'),
(12, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит сайт', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 17:17:03'),
(13, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'что значит омниканальная система', 'core_questions', NULL, 'Омниканальная система — это подход к взаимодействию с клиентами, который обеспечивает бесшовное и согласованное общение через различные каналы. В случае AI-Core BriemChainAI, это означает, что вы можете взаимодействовать с клиентами через сайт, Авито, ЦИАН, WhatsApp, Telegram, ВКонтакте и телефонию, обеспечивая при этом единый опыт и интеграцию всех этих каналов для повышения эффективности обработки запросов.', NULL, NULL, 0, '2025-08-12 17:26:26'),
(14, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит сайт', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-12 18:15:30'),
(15, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит AI-website', 'pricing', NULL, 'AI-website стоит от 180 000 до 300 000 ₽ за настройку, с последующей поддержкой за 25 000 ₽ в месяц.', NULL, NULL, 0, '2025-08-12 18:17:04'),
(16, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'расскажи в чем особенность AI-website', 'package_questions', NULL, 'AI-Website представляет собой корпоративный веб-сайт, который предлагает более широкие возможности по сравнению с обычными лендингами. Он включает в себя интеграцию с AI-Core для управления контентом и аналитикой, а также поддерживает более сложные функции, такие как пользовательские интерфейсы и дополнительные инструменты для взаимодействия с клиентами. Данный продукт подходит для компаний, стремящихся к более профессиональному и масштабируемому онлайн-присутствию.', NULL, NULL, 0, '2025-08-12 18:17:59'),
(17, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'в материалах на сайте сказано что у ваших лендингов конверсия до 25%, каким образом это достигается', 'landing_questions', NULL, 'Конверсия наших AI-Landing достигается благодаря использованию передовых технологий искусственного интеллекта, которые позволяют оптимизировать контент и дизайн страницы под целевую аудиторию. Мы анализируем поведение пользователей и применяем A/B тестирование, что позволяет выявить наиболее эффективные элементы. Кроме того, лендинги адаптируются под разные устройства и платформы, что улучшает пользовательский опыт. Это в свою очередь способствует увеличению конверсии до 25%, что значительно выше среднего показателя по рынку.', NULL, NULL, 0, '2025-08-12 18:19:33'),
(18, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'расскажи про AI-Core', 'core_questions', NULL, 'AI-Core - это инновационная платформа для автоматизации обработки запросов и управления данными, предлагающая различные тарифные планы с ценами от 220 000 до 350 000 ₽, а также дополнительные тарифы от 25 000 до 65 000 ₽ в месяц. Основное преимущество AI-Core заключается в высокой скорости обработки данных: он обрабатывает информацию за 2 минуты, что в 60 раз быстрее, чем стандартные методы, требующие 2 часов. Платформа поддерживает множество каналов для взаимодействия, включая сайт, Авито, ЦИАН, WhatsApp, Telegram, ВКонтакте и телефонию. Это делает AI-Core универсальным инструментом для бизнеса, стремящегося оптимизировать свои процессы и улучшить эффективность.', NULL, NULL, 0, '2025-08-12 18:26:07'),
(19, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'AI-Promotion сколько стоит', 'pricing', NULL, 'AI-Promotion стоит от 35 000 до 65 000 ₽/мес за SEO и от 55 000 до 95 000 ₽/мес за полный пакет. Рекомендую провести подробную консультацию для выбора наиболее подходящего пакета.', NULL, NULL, 0, '2025-08-12 18:28:42'),
(20, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит сайт', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-13 04:54:52'),
(21, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит AI-Website', 'pricing', NULL, 'AI-Website стоит от 180 000 до 300 000 ₽. Рекомендуем провести подробную консультацию для выбора подходящего пакета.', NULL, NULL, 0, '2025-08-13 04:55:23'),
(22, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит сайт', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-13 04:59:27'),
(23, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит сайт', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-13 05:03:27'),
(24, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'в чем особенность ваших сайтов', 'website_questions', NULL, 'Наши сайты обладают уникальными особенностями, такими как: специализированные SEO-разделы под различные районы Краснодара, что позволяет эффективно привлекать целевую аудиторию; высокая скорость загрузки страниц (0.3 секунды), что значительно улучшает пользовательский опыт; и быстрая реализация проекта - всего 14 дней. Мы также предлагаем адаптивный дизайн и возможность поддержки сайта за дополнительную ежемесячную плату.', NULL, NULL, 0, '2025-08-13 05:03:53'),
(25, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит сайт', 'pricing', NULL, 'Для создания AI-сайта стоимость составляет от 180 000 до 300 000 ₽ в зависимости от настроек. Рекомендуем провести подробную консультацию для выбора оптимального варианта, учитывая ваши потребности.', NULL, NULL, 0, '2025-08-13 06:53:48'),
(26, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит лендинг', 'pricing', NULL, 'Цена AI-лендинга составляет от 85 000 до 120 000 ₽. Рекомендуется уточнить детали и обсудить ваши потребности для наиболее точной оценки.', NULL, NULL, 0, '2025-08-13 06:54:06'),
(27, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит продвижение', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-13 06:54:22'),
(28, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'какие пакеты у вас есть', 'package_questions', NULL, 'У нас есть три пакета: AI-СТАРТ, AI-ПРОФИ и AI-ИМПЕРИЯ. Каждый пакет предлагает различные услуги и возможности. Также мы предлагаем синергию 4 AI-продуктов, которая может помочь увеличить вашу прибыль.', NULL, NULL, 0, '2025-08-13 06:55:47'),
(29, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'расскажи про AI-старт', 'package_questions', NULL, 'Пакет AI-СТАРТ предлагает базовое решение для бизнеса, включающее AI-сайт, базовую AI-CRM и AI-продвижение на 3 месяца. Он подходит для компаний до 10 сотрудников, что делает его идеальным для стартапов или небольших компаний. Стоимость установки составляет 280,000 рублей, а ежегодная подписка — 820,000 рублей или 45,000 рублей в месяц. Синергия с другими AI-продуктами может привести к росту прибыли, так как интеграция с более мощными решениями может повысить эффективность и результативность бизнеса.', NULL, NULL, 0, '2025-08-13 06:56:17'),
(30, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'назови ваши продукты', 'general_info', NULL, '1. AI-сайт: Умные корпоративные сайты с AI-оптимизацией - от 180 000 до 300 000 ₽\n2. AI-лендинг: Продающие лендинги с AI-персонализацией - от 85 000 до 120 000 ₽\n3. AI-CRM: CRM-система с AI-автоматизацией через Telegram - от 150 000 ₽\n4. AI-продвижение: Комплексное продвижение с AI-аналитикой - от 35 000 до 65 000 ₽-от 55 000 до 95 000 ₽', NULL, NULL, 0, '2025-08-13 07:09:59'),
(31, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит crm', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-13 07:10:39'),
(32, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит CRM', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-13 07:11:09'),
(33, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит AI-CRM', 'pricing', NULL, 'подробная консультация с рекомендацией', NULL, NULL, 0, '2025-08-13 07:11:24'),
(34, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'сколько стоит crm', 'pricing', NULL, 'Настройка AI-CRM стоит от 150 000 до 300 000 ₽. Тарифы варьируются от 25 000 до 75 000 ₽ в месяц. Базовый тариф включает обработку заявок, telegram уведомления и базовую аналитику, в то время как премиум тариф предлагает полную автоматизацию, AI-аналитику, интеграции и персонального менеджера.', NULL, NULL, 0, '2025-08-13 07:16:35'),
(35, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'что ты можешь рассказать про вашу crm, в чем ее особенность', 'core_questions', NULL, 'Наша AI-CRM BriemChainAI предлагает уникальные возможности для автоматизации процессов управления взаимоотношениями с клиентами. Основные особенности включают: \n1. **Цена**: Стоимость системы варьируется от 220 000 до 350 000 ₽, с дополнительными тарифами от 25 000 до 65 000 ₽ в месяц.\n2. **Скорость обработки**: Наша система обрабатывает запросы за 2 минуты, что значительно быстрее стандартного времени обработки в 2 часа.\n3. **Многообразие каналов**: AI-CRM поддерживает интеграцию с различными каналами коммуникации, такими как сайт, Авито, ЦИАН, WhatsApp, Telegram, ВКонтакте и телефония. Это позволяет централизовать взаимодействие с клиентами и улучшить качество обслуживания.\n\nЭти особенности делают нашу CRM идеальным выбором для бизнеса, стремящегося к эффективному управлению клиентскими отношениями и повышению производительности.', NULL, NULL, 0, '2025-08-13 07:17:28'),
(36, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'расскажи про цены на продукты', 'general_info', NULL, 'Вот полный обзор всех 4 продуктов нашей AI-экосистемы:\n\n1. **AI-сайт**: Умные корпоративные сайты с AI-оптимизацией - от 180 000 до 300 000 ₽\n2. **AI-лендинг**: Продающие лендинги с AI-персонализацией - от 85 000 до 120 000 ₽\n3. **AI-CRM**: CRM-система с AI-автоматизацией через Telegram - от 150 000 ₽\n4. **AI-продвижение**: Комплексное продвижение с AI-аналитикой - от 35 000 до 65 000 ₽ (или от 55 000 до 95 000 ₽ в зависимости от пакета).\n\nПожалуйста, выберите, что вас интересует, и я расскажу подробнее!', NULL, NULL, 0, '2025-08-13 07:28:16'),
(37, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'дай расценки на ваши продукты', 'general_info', NULL, '1. AI-сайт: Умные корпоративные сайты с AI-оптимизацией - от 180 000 до 300 000 ₽\n2. AI-лендинг: Продающие лендинги с AI-персонализацией - от 85 000 до 120 000 ₽\n3. AI-CRM: CRM-система с AI-автоматизацией через Telegram - от 150 000 ₽\n4. AI-продвижение: Комплексное продвижение с AI-аналитикой - от 35 000 до 65 000 ₽', NULL, NULL, 0, '2025-08-13 10:00:40'),
(38, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'можешь рассчитать ROI', 'roi_question', NULL, 'Для расчета ROI (возврат на инвестиции) используем следующую формулу: ROI = (Прибыль - Инвестиции) / Инвестиции * 100%. В вашем случае ROI составляет 400%, что означает, что на каждый вложенный доллар вы получаете 4 доллара прибыли. Например, если инвестиции составляют 10000 долларов, то прибыль будет 40000 долларов. Таким образом, ROI = (40000 - 10000) / 10000 * 100% = 400%.', NULL, NULL, 0, '2025-08-13 11:54:11'),
(39, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'привет, расскажи про ваши сайты, в чем их отличие, как вы добиваетесь топовых позиций в поиске и как быстро сайт попадает в топ 5 поиска Яндекс', 'website_questions', NULL, 'Наши AI-сайты предлагают уникальные решения для различных целевых аудиторий в Краснодаре, включая семьи с детьми, молодых специалистов и инвесторов. Мы обеспечиваем качественную SEO-оптимизацию с учетом специфики каждого района, что позволяет нам достигать высоких позиций в поисковых системах. Загрузка сайта происходит за 0.3 секунды, что значительно улучшает пользовательский опыт. Мы достигаем результатов в топах поиска Яндекс в среднем за 14 дней и обеспечиваем стабильность позиций от 50% до 80%. Основное отличие заключается в индивидуальном подходе к каждому проекту и постоянной оптимизации контента.', NULL, NULL, 0, '2025-08-13 12:02:32'),
(40, 141, '15b2e5ca15bbf246aca298f547c89e49', 'Привет, расскажи про ваши сайты', 'website_questions', NULL, 'Наши AI-сайты предлагают уникальные решения для бизнеса с акцентом на SEO-оптимизацию и скорость загрузки. Стоимость разработки начинается от 180 000 до 300 000 ₽, с ежемесячной поддержкой за 25 000 ₽. Мы создаем SEO-разделы, адаптированные под различные районы Краснодара, включая ФМР, ЦМР, КМР и Прикубанский. Сайты загружаются за 0.3 секунды и дают результаты в течение 14 дней с конверсией от 50% до 80%. Если вас интересует более подробная информация, я могу помочь вам создать заявку.', NULL, NULL, 0, '2025-08-13 13:03:06'),
(41, 141, '15b2e5ca15bbf246aca298f547c89e49', 'Расскажи о вашей компании', 'package_questions', NULL, 'Наша компания предлагает три основных пакета услуг: AI-СТАРТ, AI-ПРОФИ и AI-ИМПЕРИЯ. Каждый пакет включает в себя набор AI-продуктов, которые помогают вашему бизнесу расти и развиваться. Пакет AI-СТАРТ предназначен для небольших команд до 10 сотрудников и включает в себя AI-сайт, базовую AI-CRM и трехмесячное AI-продвижение. Пакет AI-ПРОФИ подходит для компаний до 20 сотрудников и включает в себя более расширенные функции, такие как 3 AI-лендинга и полный доступ к AI-CRM. Пакет AI-ИМПЕРИЯ предлагает корпоративный AI-сайт, 5 AI-лендингов и неограниченный доступ к AI-CRM, а также агрессивное AI-продвижение и BI-отчеты для глубокого анализа данных. Все пакеты могут работать в синергии, что приводит к росту прибыли через объединение возможностей четырех AI-продуктов, обеспечивая максимальные результаты для вашего бизнеса.', NULL, NULL, 0, '2025-08-13 13:15:40'),
(42, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'какой ROI с использованием вашей системы', 'roi_question', NULL, 'ROI экосистемы составляет 400%. Это означает, что на каждый вложенный доллар вы получаете 4 доллара в виде прибыли. Например, если вы инвестируете 10,000 долларов, ваша ожидаемая прибыль составит 40,000 долларов.', NULL, NULL, 0, '2025-08-13 14:10:17'),
(43, 141, '06198dc525159b089b5dd24d130df5cf', 'Я могу использовать вашу crm отдельно', 'core_questions', NULL, 'Да, вы можете использовать нашу AI-CRM отдельно. Она предоставляет полный функционал для обработки лидов и взаимодействия с клиентами через различные каналы, такие как сайт, Авито, ЦИАН, WhatsApp, Telegram, ВКонтакте и телефония. Если вам нужны дополнительные детали или хотите создать лид, пожалуйста, дайте знать!', NULL, NULL, 0, '2025-08-13 16:16:20'),
(44, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'какие пакеты у вас есть', 'package_questions', NULL, 'У нас есть три пакета: AI-СТАРТ, AI-ПРОФИ и AI-ИМПЕРИЯ. Каждый пакет предлагает разные возможности и ресурсы в зависимости от ваших потребностей. Также мы предлагаем синергию 4 AI-продуктов, что может привести к росту прибыли вашей компании.', NULL, NULL, 0, '2025-08-15 12:16:18'),
(45, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'какие решения у вас есть для агентства из 10 человек, у нас в работе 100 объектов недвижимости', 'krasnodar_specifics', NULL, 'Мы можем предложить региональную экспертизу, включая анализ рынка и трендов, а также помощь в интеграции с платформами для продвижения ваших объектов. Это поможет вам более эффективно управлять 100 объектами недвижимости и привлекать целевых клиентов.', NULL, NULL, 0, '2025-08-15 13:43:35'),
(46, 141, 'b42a5ff399fd8f349ca1a1fd98e9dae0', 'расскажи про сайты', 'website_questions', NULL, 'AI-сайт BriemChainAI предлагает создание сайтов с ценой от 180 000 до 300 000 ₽, а также абонентскую плату в 25 000 ₽ в месяц. Сайты имеют оптимизацию под SEO для различных районов Краснодара, включая ФМР (семьи с детьми), ЦМР (молодые специалисты), КМР (инвесторы) и Прикубанский. Время загрузки страниц составляет всего 0.3 секунды, а результат выполнения проекта достигается за 14 дней с эффективностью 50-80%.', NULL, NULL, 0, '2025-08-17 16:50:11'),
(47, 141, 'sess_68a8c1922c78f_1755890066', 'привет, расскажи про ваши сайты', 'website_questions', NULL, 'Наши AI-сайты предлагают уникальные решения для бизнеса с акцентом на SEO и быструю загрузку. Цена на создание сайта варьируется от 180 000 до 300 000 ₽, с последующей поддержкой за 25 000 ₽ в месяц. Мы создаём SEO-разделы, ориентированные на различные целевые аудитории в Краснодаре: ФМР (семьи с детьми), ЦМР (молодые специалисты), КМР (инвесторы) и Прикубанский. Время загрузки сайта составляет всего 0.3 секунды, а результаты видны уже в течение 14 дней, с эффективностью от 50% до 80%. Если у вас есть дополнительные вопросы или вы хотите обсудить детали, дайте знать!', NULL, NULL, 0, '2025-08-22 19:14:51'),
(48, 141, 'sess_68ab711a7aaa0_1756066074', 'какие сайты у вас есть', 'website_questions', NULL, 'У нас есть AI-сайт с возможностью создания специализированных SEO-разделов для разных районов Краснодара, который загружается за 0.3 секунды и предлагает результаты в течение 14 дней. Цена варьируется от 180 000 до 300 000 ₽ с дополнительной подпиской 25 000 ₽/мес.', NULL, NULL, 0, '2025-08-24 20:08:15'),
(49, 141, 'sess_68abe8c25ed07_1756096706', 'расскажи про лендинги', 'landing_questions', NULL, 'AI-лендинги – это современные веб-страницы, созданные с использованием технологий искусственного интеллекта, которые значительно повышают эффективность привлечения клиентов. Они имеют ряд преимуществ по сравнению с обычными лендингами. Во-первых, их стоимость варьируется от 85 000 до 120 000 ₽, с возможностью получения скидки 10%. Во-вторых, конверсия AI-лендингов составляет 15-25%, что значительно выше, чем 3-5% у традиционных лендингов. Запуск таких страниц занимает всего 5-7 дней, в то время как на создание обычного лендинга может уйти около 4 недель. Кроме того, AI-лендинги обеспечивают отличную окупаемость (ROI), что делает их выгодным вложением для бизнеса.', NULL, NULL, 0, '2025-08-25 04:38:49'),
(50, 141, 'sess_68acbdd8e81e0_1756151256', 'расскажи про вашу crm', 'core_questions', NULL, 'Наша AI-CRM BriemChainAI предлагает современные решения для автоматизации управления клиентскими отношениями. Она стоит от 220 000 до 350 000 ₽, а также имеет тарифы от 25 000 до 65 000 ₽ в месяц. Основное преимущество нашей системы — это высокая скорость обработки заявок: всего 2 минуты вместо стандартных 2 часов. CRM поддерживает интеграцию с различными каналами, включая сайт, Авито, ЦИАН, WhatsApp, Telegram, ВКонтакте и телефонию, что позволяет вам эффективно управлять коммуникацией с клиентами.', NULL, NULL, 0, '2025-08-25 19:48:00'),
(51, 141, 'sess_68af4e56f1628_1756319318', 'расскажи про crm', 'core_questions', NULL, 'Спасибо за ваш вопрос. Наш специалист свяжется с вами в ближайшее время для персональной консультации.', NULL, NULL, 0, '2025-08-27 18:29:30');

-- --------------------------------------------------------

--
-- Структура таблицы `events`
--

CREATE TABLE IF NOT EXISTS `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) DEFAULT NULL,
  `source_type` enum('email','phone','socialMedia','websiteComments','websiteForm','websiteChat','websiteReviews','chat','other') NOT NULL,
  `source_value` varchar(255) NOT NULL,
  `from_name` varchar(255) DEFAULT NULL,
  `from_contact` varchar(128) DEFAULT NULL,
  `client_id` int DEFAULT NULL,
  `organization_id` int DEFAULT NULL,
  `subject` text,
  `message` mediumtext,
  `received_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_first_contact` tinyint(1) DEFAULT '1',
  `preferred_channel` enum('email','telegram','sms','chat','webhook','phone') DEFAULT NULL,
  `related_type` varchar(20) DEFAULT NULL,
  `related_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_organization_id` (`organization_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_related` (`related_type`,`related_id`),
  KEY `idx_events_duplicate_check` (`client_id`,`received_at`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `events`
--

INSERT INTO `events` (`id`, `external_id`, `source_type`, `source_value`, `from_name`, `from_contact`, `client_id`, `organization_id`, `subject`, `message`, `received_at`, `is_first_contact`, `preferred_channel`, `related_type`, `related_id`) VALUES
(158, NULL, 'websiteChat', 'relanding.ru', 'Вальтер', 'web4vip@zoho.com', 57, 141, 'Запрос консультации через веб-чат', 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 12.08.2025 22:12:32\n', '2025-08-12 19:12:32', 1, 'telegram', 'lead', 125),
(159, NULL, 'websiteChat', 'relanding.ru', 'Walter Briem', 'web4vip@zoho.com', 57, 141, 'Запрос консультации через веб-чат', 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Walter Briem\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 13.08.2025 16:04:35\n', '2025-08-13 13:04:35', 1, 'telegram', 'comment', 14),
(160, NULL, 'websiteChat', 'relanding.ru', 'Вальтер', 'web4vip@zoho.com', 57, 141, 'Запрос консультации через веб-чат', 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 15.08.2025 15:30:18\n', '2025-08-15 12:30:20', 1, 'telegram', 'comment', 15),
(161, NULL, 'websiteChat', 'relanding.ru', 'Вальтер', 'web4vip@zoho.com', 57, 141, 'Запрос консультации через веб-чат', 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 15.08.2025 16:03:20\n', '2025-08-15 13:03:24', 1, 'telegram', 'comment', 16),
(162, ' <175035275796.82313.16130475373143856376@di-prod-yp-7.sas.yp-c.yandex.net>', 'email', 'partners@distribution.yandex.ru', 'Яндекс Дистрибуция', 'partners@distribution.yandex.ru', 58, 141, 'Уведомление о прекращении соглашения', '<!DOCTYPE html>\r\n<html lang=\"en\">\r\n    <head>\r\n        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n        <title></title>\r\n    </head>\r\n    <body>\r\n        \r\n        <table align=\"center\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#f6f5f4;font-family:Arial,sans-serif;font-size:14px;\" width=\"770px\">\r\n        \r\n            <tbody>\r\n                <tr>\r\n                    \r\n                    <td style=\"padding-top:60px;padding-right:70px;padding-bottom:60px;padding-left:70px;\">\r\n                    \r\n                        \r\n                            <a href=\"https://distribution.yandex.ru/\" target=\"_blank\" style=\"color: #018ad2; text-decoration: none;\">\r\n                                <img alt=\"\" style=\"margin-left:60px;margin-bottom:15px;\" src=\"https://cdnnj6q5rec2niueczxo.cdn.yandex.net/emails/logo_old_ru.png\">\r\n                            </a>\r\n                        \r\n                        \r\n                        <table align=\"center\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-color:#d2edf9;border-width:2px;border-style:solid;background-color:#fff;padding-top:25px;padding-right:30px;padding-bottom:50px;padding-left:30px;\" width=\"100%\">\r\n                        \r\n                            <tbody>\r\n                                <tr>\r\n                                    \r\n                                    <td style=\"padding:0 30px 0 30px;\">\r\n                                    \r\n                                        \r\n    <table>\r\n        <tbody>\r\n            <tr>\r\n                <td/>\r\n                <td style=\"width: 240px\">\r\n                    <p style=\"font-family:Arial,sans-serif;font-size:16px;line-height:24px;margin-bottom:0;\">От: \r\n\r\nООО &quot;Яндекс&quot;\r\n\r\n    (ОГРН 1027700229193, ИНН 7736207543, КПП 997750001)\r\n\r\n\r\n    \r\n        <br>Место нахождения: 119021, Россия, г. Москва, ул. Льва Толстого, д. 16\r\n        (далее - \"Заказчик\")\r\n    \r\n\r\n</p>\r\n                    \r\n                </td>\r\n            </tr>\r\n            <tr>\r\n                <td colspan=\"2\">\r\n                    \r\n                        <p style=\"font-family:Arial,sans-serif;font-size:16px;line-height:24px;margin-top:30px;margin-bottom:30px;text-align:center;\">\r\n                            <strong style=\"text-transform: uppercase;\">Уведомление о прекращении соглашения</strong>\r\n                        </p>\r\n                    \r\n                    \r\n\r\n<p style=\"font-family:Arial,sans-serif;font-size:16px;line-height:24px;margin-top:30px;margin-bottom:30px;text-align:justify;\">\r\n    Настоящим уведомляем вас о прекращении Соглашения о порядке распространения продуктов Яндекса в тестовом режиме, доступного по адресу <a href=\"https://yandex.ru/legal/distribution_test_agreement/\">https://yandex.ru/legal/distribution_test_agreement/</a> («Соглашение»), на основании пункта 7.3.3 Соглашения.\r\n</p>\r\n\r\n                    <p style=\"font-family:Arial,sans-serif;font-size:16px;line-height:24px;margin-top:10px;margin-bottom:20px;\">\r\n                    \r\n                        По всем возникающим вопросам вы можете обратиться в службу поддержки: <a href=\"https://yandex.ru/support/distr/support.html\">https://yandex.ru/support/distr/support.html</a>.\r\n                    \r\n                    </p>\r\n                </td>\r\n            </tr>\r\n        </tbody>\r\n    </table>\r\n    <p style=\"font-family:Arial,sans-serif;font-size:16px;line-height:24px;margin-top:10px;margin-bottom:0;\">\r\n        С уважением,<br>\r\n        \r\n            <strong>ООО &quot;Яндекс&quot;</strong><br>\r\n            Савиновский Артем, генеральный директор.\r\n        \r\n    </p>\r\n\r\n                                    </td>\r\n                                </tr>\r\n                            </tbody>\r\n                        </table>\r\n                    </td>\r\n                </tr>\r\n            </tbody>\r\n        </table>\r\n    </body>\r\n</html>', '2025-08-15 13:14:04', 1, 'email', 'lead', 126),
(163, '<1752577008.35548.2AfOh5ZXwP@indeedseo.ru>', 'email', 'isicahif@indeedseo.ru', 'Роман', 'isicahif@indeedseo.ru', 59, 141, 'Партнёрство в маркетинговых проектах – ведущий/лицо — Роман Будников', 'Здравствуйте!\n\nПредлагаем рассмотреть сотрудничество с телеведущим Первого канала Романом Будниковым (программы «Доброе утро», «Фазенда») — как медийным лицом, спикером и голосом для рекламных и коммуникационных проектов.\n\n🎙 Варианты участия:\n— Съёмки рекламных видео и интеграций\n— Озвучка (видео, аудио, digital)\n— Соведущий мероприятий, презентаций\n— Персонализированные обращения и видеокампании\n\nХаризматичный, узнаваемый голос и тёплый стиль общения Романа усиливают доверие к бренду — особенно в сложных и эмоциональных темах.\n\nГотовы оперативно предложить формат под конкретного клиента.\n\nКонтакты:  \n📞 +7 (985)9994971\n✉️ 9994971@gmail.com\nRomanBudnikov.com\n\nС уважением,  \nКоманда Романа Будникова', '2025-08-15 13:14:14', 1, 'email', 'lead', 127),
(164, '<E1ukltI-00E2zu-7Q@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-09 18:53:52\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:14:23', 1, 'email', 'lead', 128),
(165, '<E1ukm8k-00H6ZS-AD@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-09 19:09:50\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:14:32', 1, 'email', 'comment', 17),
(166, '<E1uko9i-005az2-PN@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: \r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-09 21:18:58\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:14:40', 1, 'email', 'comment', 18),
(167, '<E1ul47m-003Vii-Hg@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 14:22:02\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:14:48', 1, 'email', 'comment', 19),
(168, '<E1ul4Cj-004aXY-L6@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 14:27:09\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:14:56', 1, 'email', 'comment', 20),
(169, '<E1ul6Nd-000wPS-5M@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:46:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:03', 1, 'email', 'comment', 21),
(170, '<E1ul6Nd-000wPS-5M@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:46:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:06', 1, 'email', 'comment', 22),
(171, '<E1ul6Q1-001WvM-4D@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:49:01\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:14', 1, 'email', 'comment', 23),
(172, '<E1ul6Q1-001WvM-4D@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 16:49:01\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:14', 1, 'email', 'comment', 24),
(173, '<E1ul6xs-00A356-35@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:24:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:23', 1, 'email', 'comment', 25),
(174, '<E1ul6xs-00A356-35@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:24:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:23', 1, 'email', 'comment', 26),
(175, '<E1ul703-00AhEG-FG@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:26:15\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:30', 1, 'email', 'comment', 27),
(176, '<E1ul703-00AhEG-FG@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:26:15\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:31', 1, 'email', 'comment', 28),
(177, '<E1ul740-00Bg5l-5w@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:30:20\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:38', 1, 'email', 'comment', 30),
(178, '<E1ul740-00Bg5l-5w@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:30:20\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:40', 1, 'email', 'comment', 29),
(179, '<E1ul7JL-00GxIm-Ss@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:46:11\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:48', 1, 'email', 'comment', 32),
(180, '<E1ul7JL-00GxIm-Ss@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:46:11\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:48', 1, 'email', 'comment', 31),
(181, '<E1ul7Ps-002Qcu-Pa@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:52:56\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:56', 1, 'email', 'comment', 34),
(182, '<E1ul7Ps-002Qcu-Pa@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:52:56\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:15:56', 1, 'email', 'comment', 33),
(183, '<E1ul7Uz-004HTL-0G@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:58:12\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:02', 1, 'email', 'comment', 35),
(184, '<E1ul7Uz-004HTL-0G@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 17:58:12\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:03', 1, 'email', 'comment', 36),
(185, '<E1ul837-00Bgh1-82@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:33:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:10', 1, 'email', 'comment', 37),
(186, '<E1ul837-00Bgh1-82@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:33:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:09', 1, 'email', 'comment', 38),
(187, '<E1ul8Ay-00D2xP-Gg@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:41:36\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:18', 1, 'email', 'comment', 39),
(188, '<E1ul8Ay-00D2xP-Gg@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:41:36\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:17', 1, 'email', 'comment', 40),
(189, '<E1ul8GT-00EAB5-2b@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: \r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:47:17\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:28', 1, 'email', 'comment', 42),
(190, '<E1ul8GT-00EAB5-2b@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: \r\nТелефон: 015259465402\r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 18:47:17\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:28', 1, 'email', 'comment', 41),
(191, '<E1ul8jK-002w5Z-J4@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:17:06\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:35', 1, 'email', 'comment', 43),
(192, '<E1ul8jK-002w5Z-J4@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:17:06\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:36', 1, 'email', 'comment', 44),
(193, '<E1ul8yG-00626C-39@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:32:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:45', 1, 'email', 'comment', 45),
(194, '<E1ul8yG-00626C-39@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:32:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:48', 1, 'email', 'comment', 46),
(195, '<E1ul9Dk-009Lyd-Pc@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:48:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:54', 1, 'email', 'comment', 47),
(196, '<E1ul9Dk-009Lyd-Pc@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:48:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:16:56', 1, 'email', 'comment', 48),
(197, '<E1ul9LH-00Aeji-KP@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:56:19\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:02', 1, 'email', 'comment', 49),
(198, '<E1ul9LH-00Aeji-KP@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 19:56:19\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:05', 1, 'email', 'comment', 50),
(199, '<E1ul9TE-00C3nO-PT@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:04:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:10', 1, 'email', 'comment', 51),
(200, '<E1ul9TE-00C3nO-PT@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:04:32\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:13', 1, 'email', 'comment', 52),
(201, '<E1ulA7n-002JuP-79@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:46:27\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:20', 1, 'email', 'comment', 53),
(202, '<E1ulA7n-002JuP-79@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-10 20:46:27\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:20', 1, 'email', 'comment', 54),
(203, '<E1ulPFa-001raq-Hj@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 12:55:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:30', 1, 'email', 'comment', 55),
(204, '<E1ulPFa-001raq-Hj@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 12:55:29\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:31', 1, 'email', 'comment', 56),
(205, '<E1ulQWi-001PMk-4u@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 14:17:16\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:38', 1, 'email', 'comment', 57),
(206, '<E1ulQWi-001PMk-4u@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 14:17:16\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:40', 1, 'email', 'comment', 58),
(207, '<E1ulTP3-009Xlh-1p@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:21:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:48', 1, 'email', 'comment', 60),
(208, '<E1ulTP3-009Xlh-1p@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:21:33\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:48', 1, 'email', 'comment', 59),
(209, '<E1ulTRd-00AEgl-SU@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:24:13\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:56', 1, 'email', 'comment', 62),
(210, '<E1ulTRd-00AEgl-SU@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 17:24:13\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:17:57', 1, 'email', 'comment', 61),
(211, '<E1ulYUA-006ACu-9X@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 22:47:10\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:04', 1, 'email', 'comment', 63),
(212, '<E1ulYUA-006ACu-9X@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-11 22:47:10\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:04', 1, 'email', 'comment', 64),
(213, '<E1ulkIV-00A6Pn-Br@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:23:54\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:12', 1, 'email', 'comment', 65),
(214, '<E1ulkIV-00A6Pn-Br@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:23:54\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:14', 1, 'email', 'comment', 66),
(215, '<E1ulkJt-00AMV1-Cn@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:25:18\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:21', 1, 'email', 'comment', 68),
(216, '<E1ulkJt-00AMV1-Cn@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-12 11:25:18\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:22', 1, 'email', 'comment', 67),
(217, '<E1umtML-00D4y9-WC@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:16:37\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:30', 1, 'email', 'comment', 70),
(218, '<E1umtML-00D4y9-WC@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:16:37\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:30', 1, 'email', 'comment', 69),
(219, '<E1umtXM-00FHva-BL@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:28:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:38', 1, 'email', 'comment', 72),
(220, '<E1umtXM-00FHva-BL@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:28:00\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:38', 1, 'email', 'comment', 71),
(221, '<E1umtyC-003SyZ-Jv@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:55:44\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:46', 1, 'email', 'comment', 73),
(222, '<E1umtyC-003SyZ-Jv@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 15:55:44\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:46', 1, 'email', 'comment', 74),
(223, '<E1umu5g-0053ge-4C@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 16:03:28\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:54', 1, 'email', 'comment', 75),
(224, '<E1umu5g-0053ge-4C@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-15 16:03:28\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-15 13:18:54', 1, 'email', 'comment', 76),
(225, '<198adee9e4d.fcf63343235368.4651617071149873926@zoho.com>', 'email', 'web4vip@zoho.com', 'web4vip', 'web4vip@zoho.com', 57, 141, 'Test WorkerEmail', 'Здравствуйте, расскажите про ваши сайты, что позволяет им попадать в топ в поиске', '2025-08-15 13:33:05', 1, 'email', 'comment', 77),
(226, '<198ae320840.f4e79c6a241778.194457993023716617@zoho.com>', 'email', 'web4vip@zoho.com', 'web4vip', 'web4vip@zoho.com', 57, 141, 'тест лавантек', 'проверка почты лавантека', '2025-08-15 14:47:05', 1, 'email', 'comment', 78),
(227, NULL, 'websiteChat', 'relanding.ru', 'Вальтер', 'web4vip@zoho.com', 57, 141, 'Запрос консультации через веб-чат', 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 17.08.2025 19:23:11\n', '2025-08-17 16:23:16', 1, 'telegram', 'comment', 79),
(228, NULL, 'websiteChat', 'relanding.ru', 'Вальтер', 'web4vip@zoho.com', 57, 141, 'Запрос консультации через веб-чат', 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 18.08.2025 17:14:25\n', '2025-08-18 14:14:34', 1, 'telegram', 'comment', 80),
(229, NULL, 'websiteChat', 'relanding.ru', 'Вальтер', 'web4vip@zoho.com', 57, 141, 'Запрос консультации через веб-чат', 'Контакт получен через веб-чат с полным контекстом диалога.\n\nТип запроса: Консультация\nИмя клиента: Вальтер\nEmail: web4vip@zoho.com\n\nПРЯМОЕ ОБРАЩЕНИЕ:\nКлиент обратился напрямую без предварительного диалога.\n\nВремя обращения: 18.08.2025 18:29:30\n', '2025-08-18 15:29:37', 1, 'telegram', 'comment', 81),
(230, '<E1ungAB-00H63D-3c@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-17 19:23:19\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-19 04:00:07', 1, 'email', 'comment', 82),
(231, '<E1uo0cu-00Gzkf-Iu@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-18 17:14:20\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-19 04:00:22', 1, 'email', 'comment', 83),
(232, '<E1uo1nS-00Dgfj-Gi@vh440.timeweb.ru>', 'email', 'noreply@relanding.ru', 'Клиент', 'noreply@relanding.ru', 60, 141, 'Новая заявка с сайта relanding.ru', 'Получена новая заявка:\r\n\r\nИмя: Вальтер\r\nEmail: web4vip@zoho.com\r\nТелефон: \r\nTelegram: Kiomata\r\nТип запроса: consultation\r\nВремя: 2025-08-18 18:29:18\r\n\r\nЗаявка сохранена локально (основной сервер недоступен)', '2025-08-19 04:00:33', 1, 'email', 'comment', 84);

-- --------------------------------------------------------

--
-- Структура таблицы `event_ai_analysis`
--

CREATE TABLE IF NOT EXISTS `event_ai_analysis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `ai_type` enum('new','reply','continued','forwarded','attachment','other') COLLATE utf8mb4_general_ci DEFAULT 'new',
  `ai_intent` enum('order','question','complaint','feedback','cancel','error','spam','check','followup') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ai_tone` enum('positive','neutral','negative') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ai_urgency` enum('low','medium','high','critical') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ai_confidence` float DEFAULT NULL,
  `ai_recommended_action` enum('create_lead','create_ticket','create_task','add_comment','archive','manual_review') COLLATE utf8mb4_general_ci DEFAULT 'manual_review',
  `ai_summary` text COLLATE utf8mb4_general_ci,
  `processed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_event` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `event_ai_analysis`
--

INSERT INTO `event_ai_analysis` (`id`, `event_id`, `ai_type`, `ai_intent`, `ai_tone`, `ai_urgency`, `ai_confidence`, `ai_recommended_action`, `ai_summary`, `processed_at`) VALUES
(76, 161, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:03:29'),
(77, 162, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:14:12'),
(78, 163, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:14:22'),
(79, 164, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:14:32'),
(80, 165, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:14:40'),
(81, 166, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:14:48'),
(82, 167, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:14:56'),
(83, 168, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:06'),
(84, 169, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:12'),
(85, 170, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:14'),
(86, 171, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:22'),
(87, 172, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:22'),
(88, 173, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:30'),
(89, 174, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:31'),
(90, 175, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:38'),
(91, 176, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:40'),
(92, 178, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:48'),
(93, 177, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:48'),
(94, 179, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:55'),
(95, 180, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:15:55'),
(96, 182, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:02'),
(97, 181, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:03'),
(98, 183, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:09'),
(99, 184, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:10'),
(100, 185, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:17'),
(101, 186, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:17'),
(102, 188, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:27'),
(103, 187, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:27'),
(104, 190, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:34'),
(105, 189, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:35'),
(106, 191, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:44'),
(107, 192, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:47'),
(108, 193, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:53'),
(109, 194, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:16:55'),
(110, 195, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:01'),
(111, 196, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:04'),
(112, 197, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:10'),
(113, 198, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:12'),
(114, 199, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:19'),
(115, 200, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:20'),
(116, 201, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:29'),
(117, 202, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:31'),
(118, 203, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:37'),
(119, 204, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:38'),
(120, 205, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:47'),
(121, 206, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:48'),
(122, 208, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:56'),
(123, 207, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:17:56'),
(124, 209, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:03'),
(125, 210, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:03'),
(126, 211, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:12'),
(127, 212, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:13'),
(128, 213, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:21'),
(129, 214, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:22'),
(130, 216, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:30'),
(131, 215, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:30'),
(132, 218, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:37'),
(133, 217, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:37'),
(134, 220, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:45'),
(135, 219, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:46'),
(136, 221, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:53'),
(137, 222, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:18:53'),
(138, 223, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:19:01'),
(139, 224, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:19:02'),
(140, 225, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 16:33:13'),
(141, 226, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-15 17:47:17'),
(142, 227, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-17 19:23:22'),
(143, 228, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-18 17:14:39'),
(144, 229, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-18 18:29:44'),
(145, 230, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-19 07:00:18'),
(146, 231, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-19 07:00:32'),
(147, 232, 'new', 'question', 'neutral', 'medium', 0.6, 'create_lead', 'Базовый анализ запроса типа: consultation', '2025-08-19 07:00:50');

-- --------------------------------------------------------

--
-- Структура таблицы `event_logs`
--

CREATE TABLE IF NOT EXISTS `event_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `actor` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `details` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `faq_candidates`
--

CREATE TABLE IF NOT EXISTS `faq_candidates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `question` text COLLATE utf8mb4_general_ci NOT NULL,
  `answer_suggestion` text COLLATE utf8mb4_general_ci,
  `lang` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','approved','merged','rejected') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `idx_status_lang` (`status`,`lang`),
  KEY `idx_page_slug` (`page_slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `faq_entries`
--

CREATE TABLE IF NOT EXISTS `faq_entries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `question` text COLLATE utf8mb4_general_ci NOT NULL,
  `answer` text COLLATE utf8mb4_general_ci NOT NULL,
  `lang` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `merged_to` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  `organization_id` int NOT NULL,
  `source_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_page_slug` (`page_slug`),
  KEY `merged_to` (`merged_to`),
  KEY `fk_faq_source` (`source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `faq_entries`
--

INSERT INTO `faq_entries` (`id`, `page_slug`, `question`, `answer`, `lang`, `merged_to`, `created_at`, `updated_at`, `is_active`, `organization_id`, `source_id`) VALUES
(1, 'glavnaya', 'С чего начать оформление документации на строительство в Сочи?', 'Рекомендуем начать с бесплатной первичной консультации, на которой мы проанализируем ваши документы, ситуацию с участком и определим оптимальный путь решения задачи. На первой встрече вы получите представление об объеме необходимых работ, предварительные сроки и стоимость. Это поможет вам принять обоснованное решение до начала затратных мероприятий.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(2, 'glavnaya', 'Какие особенности оформления недвижимости именно в Сочи?', 'Сочи имеет множество специфических ограничений: олимпийское наследие, статус курортной зоны, сейсмическая активность, сложный горный рельеф, приаэродромные территории, зоны затопления и охранные зоны. Каждый район города имеет свои нюансы зонирования и требований к застройке. Знание этих особенностей критично для успешного оформления документации, поэтому важно работать со специалистами, имеющими опыт именно в Сочи.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(3, 'glavnaya', 'Сколько времени занимает полный цикл оформления документации?', 'Сроки зависят от сложности проекта и типа недвижимости. В среднем полный цикл занимает 3-5 месяцев для частных домов и до 8-14 месяцев для коммерческих объектов. Мы указываем точные сроки в договоре с финансовой ответственностью за их нарушение и гарантируем оптимальные временные рамки благодаря параллельному выполнению взаимосвязанных процессов.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(4, 'glavnaya', 'Какие преимущества комплексного подхода перед заказом отдельных услуг?', 'Комплексный подход дает экономию до 20% бюджета и сокращает общие сроки на 30-40%. Вы получаете единую команду специалистов и единый центр ответственности, отсутствие противоречий между документами из разных источников, согласованность всех этапов работы и минимальное личное участие в процессе. Важно, что вся документация готовится с учетом последующих этапов, что исключает переделки и дублирование работ.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(5, 'glavnaya', 'Можно ли легализовать уже построенный объект без разрешительной документации?', 'Да, в большинстве случаев это возможно. У нас есть успешный опыт легализации сложных объектов, включая те, что построены без предварительных согласований. Мы разработали эффективные алгоритмы решения подобных ситуаций с использованием законных механизмов. Главное — начать процесс легализации как можно раньше, не дожидаясь претензий со стороны контролирующих органов.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(6, 'glavnaya', 'Как происходит оплата услуг?', 'Мы используем систему поэтапной оплаты по результатам. Оплата привязана к конкретным достигнутым результатам, что снижает ваши финансовые риски. Первоначальный платеж обычно составляет 20-30% от общей стоимости, основная часть оплачивается по мере выполнения ключевых этапов, а финальный платеж — после полного достижения результата. Ценообразование прозрачное, без скрытых платежей.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(7, 'glavnaya', 'Что включает предварительная оценка рисков?', 'На этапе предварительной оценки мы проводим бесплатный анализ имеющейся документации, проверяем правовой статус участка или объекта, изучаем градостроительные ограничения и выявляем потенциальные проблемы до начала основных работ. Это позволяет определить наиболее эффективную стратегию, предложить альтернативные варианты решения и дать прозрачную оценку шансов на успех по каждому из них.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(8, 'glavnaya', 'Требуется ли мое личное присутствие в государственных органах?', 'Нет, мы берем на себя 100% взаимодействия с государственными органами. Наши специалисты представляют ваши интересы во всех инстанциях без вашего личного присутствия благодаря налаженным отношениям с ключевыми специалистами во всех согласующих органах. Вам достаточно консультироваться с нами по телефону, а большинство документов можно подписать электронно.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(9, 'glavnaya', 'Что происходит после завершения основных работ?', 'После завершения основного объема работ и получения всех необходимых документов мы предлагаем постпроектное сопровождение, которое включает консультационную поддержку, помощь в решении возникающих вопросов, мониторинг изменений в законодательстве, влияющих на ваш объект, и оперативное реагирование на запросы контролирующих органов. Это обеспечивает долгосрочную юридическую защиту вашей недвижимости.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(10, 'glavnaya', 'Что делать, если мой случай особенно сложный?', 'Мы специализируемся на решении сложных случаев, когда другие отказываются. У нас есть успешный опыт легализации сложных объектов, практика работы с объектами в зонах с особыми условиями и наработанные алгоритмы решения типовых сложных ситуаций. На первичной консультации мы оценим сложность вашего случая и предложим оптимальную стратегию решения.', 'ru', NULL, '2025-05-03 15:36:27', '2025-05-03 15:36:27', 1, 147, 89),
(11, 'uslugi', 'Какие документы нужны для начала работ?', 'Для начала работы в зависимости от вида услуг потребуются базовые документы: правоустанавливающие документы на объект недвижимости (выписка из ЕГРН, свидетельство о праве собственности), паспортные данные собственника, а также документы, относящиеся к конкретной услуге. Точный перечень документов мы предоставим на первичной консультации после выяснения деталей вашей ситуации.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(12, 'uslugi', 'Сколько времени занимает оформление различных документов?', 'Сроки зависят от типа услуги:\nЮридическая экспертиза документов — 3-5 рабочих дней\nПерераспределение земельных участков — 1-2 месяца\nМежевание и кадастровые работы — 2-4 недели\nПолучение заключения Росавиации — 30-45 дней\nСогласование строительства ИЖС — 1-1,5 месяца\nПодготовка проектной документации — от 1 до 3 месяцев', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(13, 'uslugi', 'Могу ли я оформить земельный участок под своим домом, если дом уже построен?', 'Да, законодательство предоставляет собственникам зданий преимущественное право на оформление земли под ними. Мы поможем вам реализовать это право даже в сложных случаях. Процедура включает определение оптимальной площади участка, подготовку схемы расположения, согласование в администрации и оформление права собственности или аренды.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(14, 'uslugi', 'Что такое \"прирезка\" земельного участка и кто может ее сделать?', '\"Прирезка\" (официально — перераспределение земельных участков) — это законный способ увеличения площади вашего участка за счет прилегающих государственных или муниципальных земель. Воспользоваться этой процедурой могут собственники земельных участков при соблюдении ряда условий: участок должен иметь установленные границы, а прирезка должна соответствовать градостроительным регламентам. Мы оценим возможность перераспределения для вашего конкретного случая.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(15, 'uslugi', 'Как проверить, попадает ли участок в приаэродромную территорию?', 'Для определения нахождения участка в приаэродромной территории аэропорта Сочи мы проводим анализ его местоположения с использованием специализированных геоинформационных систем и официальных данных Росавиации. На первичной консультации мы можем предварительно оценить, находится ли ваш участок в одной из подзон приаэродромной территории и какие ограничения по высотности на нем действуют.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(16, 'uslugi', 'Что включает профессиональный расчет площади, необходимой для обслуживания здания?', 'Расчет включает анализ нормативных требований к размещению зданий в Сочи, учет функционального назначения объекта, технических особенностей (инженерные коммуникации, подъездные пути, парковки), фактического использования территории и перспектив развития. По результатам вы получаете обоснованное заключение с оптимальной площадью участка, которое принимается всеми согласующими инстанциями.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(17, 'uslugi', 'Какое оборудование используется для геодезических работ?', 'Мы используем современное высокоточное геодезическое оборудование: электронные тахеометры Leica и Trimble, GPS/ГЛОНАСС-приемники с точностью позиционирования до 3-5 мм, лазерные дальномеры и нивелиры. Для создания 3D-моделей местности применяются профессиональные лазерные сканеры. В труднодоступных местах используем специализированные БПЛА для аэрофотосъемки с геопривязкой.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(18, 'uslugi', 'Как узнать, какое строительство возможно на моем участке?', 'Для определения возможностей строительства на участке мы проводим анализ градостроительной документации: определяем территориальную зону по Правилам землепользования и застройки, проверяем разрешенные виды использования и предельные параметры (высота, процент застройки, отступы). Также выявляем наличие ограничений (охранные зоны, зоны затопления, приаэродромная территория). По результатам вы получите полное представление о том, что можно строить на вашем участке.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(19, 'uslugi', 'Что делать, если я уже построил дом без уведомления о начале строительства?', 'В такой ситуации мы проводим анализ соответствия построенного дома градостроительным регламентам и разрабатываем стратегию легализации. Во многих случаях возможно оформление уведомления об окончании строительства с подготовкой всех необходимых документов. Если имеются отклонения от параметров, мы предложим варианты решения ситуации, включая возможность внесения изменений в проект или получения разрешения на отклонение от предельных параметров.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(20, 'uslugi', 'Что включает экспертное заключение о зонах затопления?', 'Заключение содержит подробную оценку рисков затопления и подтопления участка на основе гидрологического анализа, изучения топографических особенностей, анализа уровня грунтовых вод и исторических данных о паводках. Документ включает карты потенциально опасных зон, расчетные уровни затопления при различных сценариях, рекомендации по инженерной защите и выводы о возможности безопасного строительства. Заключение имеет юридическую силу и принимается органами власти и страховыми компаниями.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(21, 'uslugi', 'Возможно ли изменить вид разрешенного использования земельного участка в Сочи?', 'Да, изменение вида разрешенного использования (ВРИ) возможно, но процедура зависит от конкретной ситуации. Если новый ВРИ входит в перечень основных или условно разрешенных видов для вашей территориальной зоны, мы поможем оформить изменение. Если требуемый ВРИ не предусмотрен для вашей зоны, может потребоваться более сложная процедура внесения изменений в Правила землепользования и застройки. На первичной консультации мы оценим возможность и сложность изменения ВРИ в вашем конкретном случае.', 'ru', NULL, '2025-05-03 16:32:47', '2025-05-03 16:32:47', 1, 147, 89),
(22, 'kompleksnye-resheniya', 'В чем преимущество комплексного подхода перед заказом отдельных услуг?', 'Комплексный подход дает экономию до 20% бюджета и сокращает сроки оформления на 30-40%. Это возможно благодаря параллельному выполнению взаимосвязанных задач, отсутствию дублирования работ и единому центру ответственности. Важное преимущество — отсутствие противоречий в документах, так как все материалы готовятся одной командой и согласованы между собой.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(23, 'kompleksnye-resheniya', 'Сколько времени занимает полный цикл оформления документации?', 'Сроки зависят от типа объекта и категории клиента:\nДля частных застройщиков: 3-5 месяцев\nДля коммерческих проектов: 8-14 месяцев\nДля муниципальных объектов: зависит от типа проекта, в среднем 6-12 месяцев\nДля инвестиционных объектов: от 1 до 3 месяцев для анализа, далее по индивидуальному плану', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(24, 'kompleksnye-resheniya', 'Какие услуги входят в комплексное решение?', 'Состав комплексного решения адаптируется под конкретный тип клиента и проекта. Но в целом включает юридическую проверку и сопровождение, геодезические и кадастровые работы, подготовку и согласование необходимой документации, сопровождение в государственных органах, получение необходимых разрешений и подготовку документов для регистрации прав. Полный перечень услуг представлен в соответствующем разделе для каждой категории клиентов.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(25, 'kompleksnye-resheniya', 'Нужно ли моё личное присутствие в процессе оформления?', 'Нет, мы берем на себя 100% бюрократических процедур. Вам достаточно консультироваться с нами по телефону, а большинство документов можно подписать электронно. В процессе работы с вами взаимодействует персональный менеджер проекта, который координирует работу всех специалистов и является вашим единым контактным лицом.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(26, 'kompleksnye-resheniya', 'Как происходит оплата услуг?', 'Мы используем гибкую систему оплаты с поэтапным внесением средств:\nДля частных застройщиков: 30% при заключении договора, 40% после получения уведомления о соответствии, 30% после регистрации прав\nДля коммерческих проектов: 20% при заключении договора, поэтапно по достижении контрольных точек, 20% после ввода в эксплуатацию\nДля муниципальных проектов: возможна адаптация под бюджетное финансирование с поэтапной оплатой\nДля инвесторов: зависит от типа услуг, для крупных проектов возможна привязка к успешности реализации стратегии', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(27, 'kompleksnye-resheniya', 'Что делать, если мой объект уже построен без необходимых разрешений?', 'У нас есть успешный опыт легализации объектов, построенных без предварительных согласований. Мы разработали эффективные алгоритмы решения подобных ситуаций с использованием законных механизмов. В большинстве случаев нам удается добиться полной легализации без необходимости существенных изменений объекта. Главное — начать процесс легализации как можно раньше, не дожидаясь претензий со стороны контролирующих органов.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(28, 'kompleksnye-resheniya', 'Какие документы необходимо предоставить для начала работы?', 'Для начала работы понадобятся базовые документы: правоустанавливающие документы на земельный участок/объект, паспортные данные собственника, документы о планируемом строительстве (если есть). Более подробный перечень документов предоставляется после бесплатной предварительной консультации в зависимости от типа проекта и поставленных задач.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(29, 'kompleksnye-resheniya', 'Работаете ли вы со сложными случаями?', 'Да, мы специализируемся на решении сложных случаев, когда другие отказываются. Особо сложными считаются ситуации с расхождениями между документами и фактическими параметрами строений, проблемы с определением границ на крутых склонах, строительство в зонах с особыми условиями использования. Для каждого такого случая разрабатывается индивидуальная стратегия решения.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(30, 'kompleksnye-resheniya', 'Есть ли гарантия успешного оформления?', 'Мы берем на себя ответственность за весь процесс и гарантируем результат по договору. Наш показатель успешного решения задач клиентов составляет 96%. В тех редких случаях, когда первоначальная цель оказывается недостижимой из-за объективных законодательных ограничений, мы всегда находим альтернативные решения, позволяющие максимально реализовать интересы клиента.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(31, 'kompleksnye-resheniya', 'Как определяется окончательная стоимость услуг?', 'Точная стоимость определяется после бесплатной предварительной консультации с учетом особенностей вашего проекта. Влияющие факторы: тип и масштаб объекта, текущее состояние документации, наличие потенциальных проблем и ограничений, требуемый набор услуг и сроки выполнения. В разделе \"Сроки и стоимость\" приведены ориентировочные диапазоны цен для разных категорий проектов.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(32, 'kompleksnye-resheniya', 'Какие объекты вы сопровождаете в Сочи?', 'Мы работаем со всеми типами объектов недвижимости в Сочи: индивидуальные жилые дома, коммерческие здания (гостиницы, торговые центры, офисные здания), социальные и инфраструктурные объекты, земельные участки различного назначения. Наши специалисты имеют опыт работы во всех четырех районах Сочи (Центральный, Хостинский, Адлерский, Лазаревский) с учетом специфики каждого из них.', 'ru', NULL, '2025-05-03 16:35:20', '2025-05-03 16:35:20', 1, 147, 89),
(33, 'proverka-uchastka', 'Зачем проводить проверку участка, если есть выписка из ЕГРН?', 'Выписка из ЕГРН содержит только базовую информацию и не отражает множество ограничений и рисков. Например, в ней не указываются градостроительные ограничения, зоны с особыми условиями использования территорий, перспективы развития прилегающих территорий. Наша проверка выявляет все эти факторы, которые могут существенно влиять на возможность использования участка и его стоимость.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(34, 'proverka-uchastka', 'Сколько времени занимает проверка участка?', 'Стандартная проверка занимает 5 рабочих дней. Для срочных случаев предусмотрена ускоренная проверка за 48 часов (с доплатой 30%). Базовую проверку можно провести за 3 рабочих дня, а расширенная и VIP-проверки занимают 7 и 10 рабочих дней соответственно.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(35, 'proverka-uchastka', 'Какая информация нужна от меня для проведения проверки?', 'Минимально необходимая информация – кадастровый номер участка или его точный адрес, а также ваши планы по его использованию. Дополнительно полезно предоставить имеющиеся документы (выписку из ЕГРН, правоустанавливающие документы и т.д.), но это не обязательно – мы самостоятельно запросим необходимые сведения.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(36, 'proverka-uchastka', 'Могу ли я присутствовать при осмотре участка?', 'Да, вы можете присутствовать при выезде наших специалистов на участок. Это даже рекомендуется, так как позволит вам получить предварительные комментарии на месте и задать дополнительные вопросы.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(37, 'proverka-uchastka', 'Что делать, если проверка выявила серьезные проблемы с участком?', 'В зависимости от характера проблем мы предложим несколько вариантов действий: от отказа от покупки до переговоров о снижении цены или разработки стратегии по устранению ограничений. В некоторых случаях мы можем предложить юридическое сопровождение для решения выявленных проблем.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(38, 'proverka-uchastka', 'Отличается ли проверка для разных районов Сочи?', 'Да, каждый район Сочи имеет свою специфику. Например, в Центральном и Хостинском районах больше исторических ограничений и охранных зон, в Адлерском – приаэродромные ограничения, а в Лазаревском – много природоохранных территорий. Наши специалисты знают особенности каждого района и учитывают их при проверке.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(39, 'proverka-uchastka', 'Можно ли проверить участок, который еще не выставлен на продажу?', 'Да, мы можем провести предварительную проверку по открытым источникам информации. Однако для полноценного анализа потребуется согласие собственника, так как некоторые данные доступны только ему.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(40, 'proverka-uchastka', 'Имеет ли ваше заключение юридическую силу?', 'Да, наше заключение имеет юридическую силу и может быть использовано при переговорах с продавцом или даже в суде в случае возникновения споров. Мы несем ответственность за достоверность предоставляемой информации.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(41, 'proverka-uchastka', 'Как проводится проверка участка с уже построенным домом?', 'В этом случае дополнительно проверяется законность постройки, соответствие параметров дома разрешенным показателям, наличие необходимых согласований и технической документации. Также анализируется возможность узаконивания построек, если они возведены с нарушениями.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(42, 'proverka-uchastka', 'Проводите ли вы проверку для участков за пределами Сочи?', 'Да, мы работаем не только в Сочи, но и в других населенных пунктах Краснодарского края. Однако наша основная экспертиза сосредоточена именно на специфике Сочи с его уникальными условиями и ограничениями.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(43, 'proverka-uchastka', 'Что показывает анализ инженерных коммуникаций?', 'Мы определяем наличие и доступность инженерных сетей (электричество, вода, газ, канализация), оцениваем возможность и примерную стоимость подключения, выявляем наличие охранных зон коммуникаций на участке, которые могут ограничивать застройку.', 'ru', NULL, '2025-05-03 16:37:15', '2025-05-03 16:37:15', 1, 147, 89),
(45, 'glavnaya', 'Что такое AI-экосистема и чем она отличается от обычных решений?', 'AI-экосистема — это комплексное решение из 4 взаимосвязанных продуктов: AI-Website, AI-Landing, AI-Core и AI-Promotion. Главное отличие в синергии — все компоненты работают как единый организм, усиливая друг друга. Например, AI-Core собирает данные клиентов, AI-Promotion использует их для создания персонализированного контента, а AI-Website показывает этот контент нужной аудитории.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(46, 'glavnaya', 'Могу ли я купить только один продукт или обязательно всю экосистему?', 'Каждый продукт можно приобрести отдельно, но максимальную эффективность вы получите только при комплексном внедрении. Отдельные продукты дают рост на 20-40%, а полная экосистема — в 3 раза больше прибыли благодаря синергетическим эффектам.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(47, 'glavnaya', 'Сколько времени занимает полное внедрение AI-экосистемы?', 'Полная интеграция всех 4 компонентов занимает 28 дней. Поэтапно: AI-Website (14 дней), AI-Landing (5-7 дней), AI-Core (2 дня), AI-Promotion (7 дней). Вы начинаете получать первые результаты уже через неделю.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(48, 'glavnaya', 'Подходит ли AI-экосистема для небольших агентств?', 'Да, система масштабируется под любой размер агентства. Для команды из 5-10 человек это возможность конкурировать с крупными игроками. Для больших агентств — способ автоматизировать рутину и масштабироваться без пропорционального роста затрат.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(49, 'glavnaya', 'Чем AI-Website отличается от обычного сайта?', 'AI-Website создает 100+ SEO-страниц против 10-20 у обычного сайта. Система автоматически генерирует контент под популярные запросы, анализирует поведение пользователей и подстраивает структуру. Результат — видимость в поиске 80% против 5-15% у обычных сайтов.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(50, 'glavnaya', 'Как быстро сайт попадает в топ Яндекса?', 'Благодаря AI-оптимизации и готовой SEO-структуре, сайт попадает в топ-5 по основным запросам в течение 4-6 недель. Это в 3-4 раза быстрее, чем у конкурентов.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(51, 'glavnaya', 'Можно ли интегрировать AI-Website с существующими системами?', 'Да, сайт интегрируется с популярными CRM, порталами недвижимости (Авито, ЦИАН, Домклик), банковскими системами для ипотеки. Все настраивается автоматически.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(52, 'glavnaya', 'Что произойдет с моим текущим сайтом?', 'Мы предлагаем trade-in — скидку до 15% за ваш существующий сайт. Все ценные данные и SEO-история переносятся на новый AI-Website без потери позиций.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(53, 'glavnaya', 'Почему конверсия AI-Landing выше обычного лендинга?', 'AI-Landing анализирует поведение каждого посетителя и показывает персонализированный контент. Например, семьям с детьми показываем дома в ФМР, молодым специалистам — квартиры в ЦМР. Плюс загрузка за 0.3 секунды против 2-4 секунд у конкурентов.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(54, 'glavnaya', 'Можно ли создать несколько лендингов под разные услуги?', 'Да, AI-система создает 10+ сегментированных страниц: под новостройки, вторичку, аренду, разные районы. Каждая страница оптимизирована под свою целевую аудиторию.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(55, 'glavnaya', 'Как происходит A/B-тестирование лендингов?', 'AI автоматически тестирует разные элементы: заголовки, кнопки, изображения, формы. Система выбирает наиболее эффективные варианты без вашего участия. Результаты видны в Telegram-отчетах.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(56, 'glavnaya', 'Подходит ли AI-Landing для рекламных кампаний?', 'Идеально подходит. Высокая конверсия (15-25%) снижает стоимость лида в 2-3 раза. Быстрая загрузка улучшает показатель качества в Яндекс.Директ и Google Ads.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(57, 'glavnaya', 'Как AI-Core обрабатывает заявки с разных источников?', 'Система автоматически собирает заявки с сайта, Авито, ЦИАН, ВКонтакте, WhatsApp, телефонных звонков. AI анализирует каждое обращение и создает лид, тикет или задачу в зависимости от типа запроса.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(58, 'glavnaya', 'Как происходит распределение заявок между риелторами?', 'AI-агент учитывает специализацию (новостройки, вторичка, аренда), текущую загрузку, историю работы с клиентом и географические предпочтения. Например, заявку на коттедж в пригороде получит риелтор, специализирующийся на загородной недвижимости.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(59, 'glavnaya', 'Можно ли интегрировать AI-Core с нашей текущей CRM?', 'Да, система интегрируется с популярными CRM через API. Если у вас специфическая система, наши разработчики создадут индивидуальную интеграцию.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(60, 'glavnaya', 'Как команда работает через Telegram?', 'Каждый сотрудник получает персонализированный интерфейс в Telegram. Уведомления о новых заявках, задачи, напоминания, отчеты — всё приходит в удобном формате. Можно отвечать клиентам, обновлять статусы, получать аналитику.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(61, 'glavnaya', 'Как AI-Promotion находит покупателей для объектов?', 'Система анализирует поисковые запросы в реальном времени, определяет популярные районы и типы недвижимости. Затем создает персонализированные описания объектов и продвигает их по релевантным запросам.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(62, 'glavnaya', 'Что входит в автоматическое создание контента?', 'AI генерирует описания объектов, SEO-тексты для сайта, посты для социальных сетей, email-рассылки. Контент создается с учетом популярных запросов и предпочтений целевой аудитории.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(63, 'glavnaya', 'Как часто обновляется продвижение?', 'Система работает 24/7, анализируя тренды и корректируя стратегию продвижения. Еженедельно вы получаете отчеты в Telegram с результатами и рекомендациями.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(64, 'glavnaya', 'Можно ли контролировать процесс продвижения?', 'Да, через Telegram-бот вы видите все активности: какие объекты продвигаются, по каким запросам, какие результаты. Можете устанавливать приоритеты для конкретных объектов.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(65, 'glavnaya', 'Какая стоимость полной AI-экосистемы?', 'Стоимость зависит от размера агентства и текущих систем. Базовый пакет от 180 000 руб/мес. При покупке полной экосистемы действует скидка до 50%, plus trade-in за существующие системы.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(66, 'glavnaya', 'Как быстро окупается инвестиция?', 'Средняя окупаемость 4-6 месяцев. Экономия на персонале (300-500 тыс/мес) плюс рост прибыли (3-7 млн/мес) дают ROI 400-800% в первый год.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(67, 'glavnaya', 'Есть ли гарантия результата?', 'Да, мы гарантируем увеличение конверсии на 30% в первые 3 месяца. Если результат не достигнут — возвращаем деньги или продолжаем работать бесплатно до достижения показателей.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(68, 'glavnaya', 'Какие есть варианты оплаты?', 'Доступна рассрочка на 12 месяцев без переплаты. Также можно начать с одного продукта и постепенно добавлять остальные со скидкой на интеграцию.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(69, 'glavnaya', 'Соответствует ли система требованиям 152-ФЗ?', 'Да, полное соответствие российскому законодательству. Все данные хранятся на серверах в РФ, автоматически генерируются согласия на обработку персональных данных.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(70, 'glavnaya', 'Как организована техподдержка?', 'Техподдержка 24/7 через Telegram и email. Время реакции на критические проблемы — до 1 часа. Бесплатные обновления и улучшения системы.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(71, 'glavnaya', 'Что если система выйдет из строя?', 'Гарантируем 99.9% uptime. Резервные копии создаются каждые 6 часов. В случае сбоя система восстанавливается автоматически за 15-30 минут.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(72, 'glavnaya', 'Нужно ли обучать сотрудников?', 'Система интуитивно понятна, но мы проводим бесплатное обучение команды. Также предоставляем видеоуроки и инструкции. Освоение займет 1-2 дня.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(73, 'glavnaya', 'Учитывает ли система особенности рынка Краснодара?', 'Да, в базе 1200+ ключевых запросов по недвижимости Краснодара. Система знает популярные районы (ФМР, ЦМР, КМР), сезонность, миграционные потоки, ценовые сегменты.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(74, 'glavnaya', 'Есть ли интеграция с местными партнерами?', 'Настроены интеграции с краснодарскими банками, застройщиками, управляющими компаниями. Система автоматически подгружает актуальную информацию об объектах и ипотечных программах.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(75, 'glavnaya', 'Как система адаптируется под сезонность?', 'AI анализирует сезонные тренды: весной продвигает загородную недвижимость, летом — курортную, зимой — квартиры в городе. Автоматически корректирует приоритеты продвижения.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(76, 'glavnaya', 'Что будет в первую неделю после запуска?', 'AI-Website начнет индексироваться в Яндексе, AI-Landing покажет первые конверсии, AI-Core обработает заявки, AI-Promotion запустит продвижение. Ожидайте 20-30% роста обращений.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(77, 'glavnaya', 'Как измерить эффективность системы?', 'Еженедельные отчеты в Telegram показывают: количество лидов, конверсии, позиции в поиске, ROI по каналам. Также доступна детальная аналитика через веб-интерфейс.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(78, 'glavnaya', 'Можно ли увидеть демо перед покупкой?', 'Да, мы проводим персонализированную демонстрацию на примере вашего агентства. Покажем, как система будет работать конкретно с вашими объектами и клиентами.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(79, 'glavnaya', 'Что делать, если результаты не устраивают?', 'Первые 30 дней — период адаптации с бесплатными корректировками. Если через 3 месяца результаты не достигнуты — полный возврат средств согласно договору.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(80, 'glavnaya', 'Готов заказать AI-экосистему. Что дальше?', 'Свяжитесь с нами для консультации. Проведем анализ вашего агентства, подберем оптимальную конфигурацию, рассчитаем стоимость с учетом скидок и trade-in. Запуск в течение 28 дней.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90),
(81, 'glavnaya', 'Можно ли начать с одного продукта?', 'Да, рекомендуем начать с AI-Website или AI-Core в зависимости от приоритетов. Через 2-3 месяца можно добавить остальные компоненты со скидкой на интеграцию.', 'ru', NULL, '2025-07-17 13:00:00', '2025-07-17 13:00:00', 1, 141, 90);

-- --------------------------------------------------------

--
-- Структура таблицы `form_fields`
--

CREATE TABLE IF NOT EXISTS `form_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `field_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `field_value` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `invite`
--

CREATE TABLE IF NOT EXISTS `invite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invitee_nick` varchar(255) NOT NULL,
  `invitee_name` varchar(255) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `organization_id` int NOT NULL,
  `organization_name` varchar(255) NOT NULL,
  `inviter_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `leads`
--

CREATE TABLE IF NOT EXISTS `leads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `client_id` int DEFAULT NULL,
  `assigned_to` int DEFAULT NULL,
  `status` enum('new','in_progress','waiting','closed') DEFAULT 'new',
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_client_id` (`client_id`),
  KEY `fk_leads_assigned_to` (`assigned_to`),
  KEY `idx_leads_client_status` (`client_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `leads`
--

INSERT INTO `leads` (`id`, `event_id`, `client_id`, `assigned_to`, `status`, `description`, `created_at`, `updated_at`) VALUES
(125, 158, 57, 43, 'new', 'Лид создан из веб-чата', '2025-08-12 19:12:33', '2025-08-12 19:12:33'),
(126, 162, 58, 43, 'new', 'Лид создан из веб-чата', '2025-08-15 13:14:12', '2025-08-15 13:14:13'),
(127, 163, 59, 43, 'new', 'Лид создан из веб-чата', '2025-08-15 13:14:22', '2025-08-15 13:14:23'),
(128, 164, 60, 43, 'new', 'Лид создан из веб-чата', '2025-08-15 13:14:32', '2025-08-15 13:14:32');

-- --------------------------------------------------------

--
-- Структура таблицы `notification_log`
--

CREATE TABLE IF NOT EXISTS `notification_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `telegram_id` bigint NOT NULL,
  `entity_type` enum('lead','ticket','task') COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` int NOT NULL,
  `notification_type` enum('new_entity','comment','update') COLLATE utf8mb4_unicode_ci DEFAULT 'new_entity',
  `summary_confidence` decimal(3,2) DEFAULT '0.00',
  `summary_tags` text COLLATE utf8mb4_unicode_ci,
  `response_time` int DEFAULT NULL,
  `clicked_action` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `responded_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_org_date` (`organization_id`,`sent_at`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_telegram` (`telegram_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `notification_log`
--

INSERT INTO `notification_log` (`id`, `organization_id`, `telegram_id`, `entity_type`, `entity_id`, `notification_type`, `summary_confidence`, `summary_tags`, `response_time`, `clicked_action`, `sent_at`, `responded_at`) VALUES
(1, 141, 6594349857, 'lead', 119, 'new_entity', 0.80, 'недвижимость,ИИ-CRM,оптимизация,консультация,потенциальный клиент', NULL, NULL, '2025-08-11 14:01:42', NULL),
(2, 141, 6594349857, 'lead', 120, 'new_entity', 0.80, 'лендинг,новый клиент,запрос информации', NULL, NULL, '2025-08-11 14:20:46', NULL),
(3, 141, 6594349857, 'lead', 121, 'new_entity', 0.80, 'консультация,новый клиент,средняя срочность', NULL, NULL, '2025-08-11 14:21:38', NULL),
(4, 141, 6594349857, 'lead', 122, 'new_entity', 0.80, 'консультация,управление недвижимостью,ИИ-CRM,новый клиент', NULL, NULL, '2025-08-11 14:48:36', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `organizations`
--

CREATE TABLE IF NOT EXISTS `organizations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `chat_id` bigint DEFAULT NULL,
  `terms_url` varchar(255) DEFAULT NULL,
  `privacy_url` varchar(255) DEFAULT NULL,
  `token` varchar(32) DEFAULT NULL,
  `bot_token` varchar(255) DEFAULT NULL,
  `model_id` varchar(100) DEFAULT NULL,
  `auto_reply_mode` enum('auto','manual') NOT NULL DEFAULT 'manual',
  `assignment_mode` enum('auto','manual') NOT NULL DEFAULT 'manual',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `level` enum('basic','pro') NOT NULL DEFAULT 'basic',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_chat_id` (`chat_id`),
  KEY `idx_org_name` (`name`),
  KEY `idx_org_level` (`level`,`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `organizations`
--

INSERT INTO `organizations` (`id`, `name`, `chat_id`, `terms_url`, `privacy_url`, `token`, `bot_token`, `model_id`, `auto_reply_mode`, `assignment_mode`, `created_at`, `level`, `is_active`) VALUES
(141, 'BriemChainAI', NULL, NULL, NULL, '40ca43cee89000063b14faecd67429fa', '7801536447:AAEQjvJ58bqk-TxIBqKlnMc5rG_EaQ-k9P0', NULL, 'manual', 'manual', '2025-04-09 15:52:29', 'pro', 1),
(142, 'BriemSales', NULL, NULL, NULL, NULL, '7698904153:AAEW6ofOnhXNSAkkwtn7rKRwUdzJA4yt2dY', NULL, 'manual', 'manual', '2025-04-09 16:58:29', 'basic', 0),
(147, 'Sikamo', NULL, NULL, NULL, '1750cb22935297415f0a9ba4d9f84a24', '8113308988:AAGnZ9oUubSD5nnSSF9IY45JW6Vs6wyMcBE', NULL, 'manual', 'manual', '2025-05-03 09:14:18', 'basic', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `organization_sources`
--

CREATE TABLE IF NOT EXISTS `organization_sources` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `source_type` enum('email','phone','social','website','chat','telegram','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `source_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `config` json DEFAULT NULL,
  `is_confirmed` tinyint(1) DEFAULT '0',
  `confirm_token` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `source_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `source_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `has_api` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_source` (`organization_id`,`source_type`,`source_value`),
  KEY `idx_source_type_active` (`source_type`,`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `organization_sources`
--

INSERT INTO `organization_sources` (`id`, `organization_id`, `source_type`, `source_value`, `role`, `config`, `is_confirmed`, `confirm_token`, `source_name`, `source_url`, `is_active`, `has_api`) VALUES
(69, 141, 'email', 'support@relanding.ru', 'support-web-development-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(70, 141, 'email', 'sales@relanding.ru', 'sales-web-development-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(71, 141, 'email', 'billing@relanding.ru', 'billing-web-development-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(72, 141, 'email', 'noreply@relanding.ru', 'noreply-web-development-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(73, 141, 'email', 'info@lawandtech.ru', 'general-legal-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(74, 141, 'email', 'support@lawandtech.ru', 'support-legal-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(75, 141, 'email', 'sales@lawandtech.ru', 'sales-legal-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(76, 141, 'email', 'billing@lawandtech.ru', 'billing-legal-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(77, 141, 'email', 'noreply@lawandtech.ru', 'noreply-legal-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(82, 141, 'website', 'relanding.de', NULL, NULL, 0, NULL, 'Website relanding.de', 'relanding.de', 1, 0),
(83, 141, 'website', 'relanding.es', NULL, NULL, 0, NULL, 'Website relanding.es', 'relanding.es', 1, 0),
(88, 141, 'email', 'info@relanding.ru', 'general-web-development-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"auto\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0),
(89, 147, 'website', 'sikamo.ru', NULL, NULL, 1, NULL, 'Website sikamo.ru', 'sikamo.ru', 1, 0),
(90, 141, 'website', 'relanding.ru', NULL, NULL, 1, NULL, 'Website relanding.ru', 'relanding.ru', 1, 1),
(91, 141, 'website', 'lawandtech.ru', NULL, NULL, 1, NULL, 'Website lawandtech.ru', 'lawandtech.ru', 1, 0),
(92, 147, 'email', 'info@sikamo.ru', 'general-ru', '{\"imapHost\": \"imap.timeweb.ru\", \"imapPort\": \"993\", \"password\": \"5vvAyIzDw8+pKKfl6tybRDo6dExVM01JMWtqdlhuaVJGY01xVEY4dz09\", \"smtpHost\": \"smtp.timeweb.ru\", \"smtpPort\": \"587\"}', 1, NULL, NULL, NULL, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `org_comments`
--

CREATE TABLE IF NOT EXISTS `org_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `source_id` int NOT NULL,
  `author_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT 'Гость',
  `author_email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_general_ci,
  `rating` tinyint(1) DEFAULT NULL,
  `user_ip` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sentiment` enum('positive','neutral','negative','spam') COLLATE utf8mb4_general_ci DEFAULT 'neutral',
  `status` enum('pending','approved','rejected','spam') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `is_published` tinyint(1) DEFAULT '0',
  `telegram_message_id` bigint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `source_id` (`source_id`),
  KEY `idx_org_source` (`organization_id`,`source_id`),
  KEY `idx_status` (`status`),
  KEY `idx_sentiment` (`sentiment`)
) ;

--
-- Дамп данных таблицы `org_comments`
--

INSERT INTO `org_comments` (`id`, `organization_id`, `source_id`, `author_name`, `author_email`, `message`, `rating`, `user_ip`, `sentiment`, `status`, `is_published`, `telegram_message_id`, `created_at`, `updated_at`) VALUES
(145, 141, 90, 'Антон К.', NULL, 'Отличный лендинг, стильный дизайн, быстрая загрузка!', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-01-14 01:34:17', '2025-03-09 04:05:53'),
(146, 141, 90, 'Елена.', NULL, 'После аудита сайт стал работать быстрее.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-02-14 04:23:12', '2025-03-09 04:06:03'),
(147, 141, 90, 'Дмитрий', NULL, 'Крутая анимация и адаптивный интерфейс.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-02-24 09:31:02', '2025-03-09 04:06:14'),
(148, 141, 90, 'Алексей', NULL, 'Быстро сделали юридические документы.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-02-04 01:23:06', '2025-03-09 04:06:24'),
(149, 141, 90, 'Мария Т', NULL, 'Продуманный шаблон, ничего лишнего.', 3, NULL, 'neutral', 'approved', 1, NULL, '2025-03-01 11:43:10', '2025-03-09 04:06:34'),
(150, 141, 90, 'Игорь Н.', NULL, 'SEO-оптимизация помогла сайту выйти в топ.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-02-28 06:34:14', '2025-03-09 04:06:47'),
(151, 141, 90, 'Сергей Л.', NULL, 'Добавили чат-бота, всё работает отлично.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-03-01 09:54:19', '2025-03-09 04:06:57'),
(152, 141, 90, 'Владимир.', NULL, 'Нашли скрытые ошибки, исправили быстро.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-02-12 05:54:23', '2025-03-09 04:07:08'),
(153, 141, 90, 'Ольга.', NULL, 'Настроили оплату, всё удобно и просто.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-02-26 01:54:28', '2025-03-09 04:07:19'),
(154, 141, 90, 'Роман.', NULL, 'Отличная поддержка, оперативно решают задачи.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-03-03 10:50:17', '2025-03-09 04:07:30'),
(155, 141, 91, 'Алексей', NULL, 'Отличный сервис! Помогли быстро разобраться с юридическими нюансами пользовательского соглашения.', 5, NULL, 'positive', 'approved', 1, NULL, '2025-02-15 09:53:07', '2025-03-09 04:04:03'),
(156, 141, 91, 'Мария', NULL, 'Обратились за аудитом политики конфиденциальности. Все сделали грамотно и в срок!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-03-01 02:25:31', '2025-03-09 04:04:15'),
(157, 141, 91, 'Дмитрий Ковалев', NULL, 'Понравился подход LawandTech. Ответили на все вопросы по защите контента.', 4, NULL, 'positive', 'approved', 1, NULL, '2025-02-24 01:35:12', '2025-03-09 04:04:30'),
(158, 141, 91, 'Елена', NULL, 'Немного затянули с ответом, но консультация была полезной.', 3, NULL, 'neutral', 'approved', 1, NULL, '2025-02-08 02:25:12', '2025-03-09 04:04:41'),
(159, 141, 91, 'Игорь М.', NULL, 'Не очень понравился формат отчетов. Ожидал более подробной информации.', 2, NULL, 'negative', 'pending', 0, NULL, '2025-02-10 06:10:22', '2025-03-09 04:04:54'),
(160, 141, 91, 'Сергей Л.', NULL, 'Составили для нас качественный договор-оферту. Спасибо за профессионализм!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-02-24 09:47:42', '2025-03-09 04:05:05'),
(161, 141, 91, 'Андрей Васильев', NULL, 'Благодаря их работе наш сайт теперь полностью соответствует законодательству.', 5, NULL, 'positive', 'approved', 1, NULL, '2025-02-10 08:45:10', '2025-03-09 04:05:15'),
(162, 141, 91, 'Анна К.', NULL, 'Оказали помощь в регистрации товарного знака. Немного дорого, но сервис на уровне.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-02-03 01:55:32', '2025-03-09 04:05:23'),
(163, 141, 91, 'Наталья', NULL, 'Консультация была полезной, но хотелось бы больше примеров из практики.', 3, NULL, 'neutral', 'approved', 1, NULL, '2025-03-03 00:54:12', '2025-03-09 04:05:33'),
(164, 141, 91, 'Владимир О.', NULL, 'Рассказали, как избежать проблем с блокировками. Рекомендую!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-02-26 03:45:42', '2025-03-09 04:05:42'),
(165, 141, 91, 'Вадим', NULL, 'Оперативно работают ребята, провели аудит на соответствие закону, устранили ошибки, респект', 5, '2a03:6f00:1::5ec6:df4a', 'neutral', 'approved', 1, NULL, '2025-03-26 06:31:02', '2025-03-26 06:32:14'),
(166, 147, 89, 'Ирина П.', NULL, 'Обратились за геологическим заключением для строительства дома в Сочи — всё сделали чётко и в срок. Рекомендуем!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-05-03 11:59:45', '2025-05-03 11:59:45'),
(167, 147, 89, 'Сергей В.', NULL, 'Помогли получить разрешение на строительство в Имеретинке. Все документы оформили быстро, без лишней бюрократии.', 5, NULL, 'positive', 'approved', 1, NULL, '2025-05-03 11:59:45', '2025-05-03 11:59:45'),
(168, 147, 89, 'Александр Н.', NULL, 'Хорошая консультация по кадастровым вопросам. Объяснили, что и как сделать, теперь точно знаю, куда двигаться.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-05-03 11:59:45', '2025-05-03 11:59:45'),
(169, 147, 89, 'Максим Д.', NULL, 'Обратился для проверки участка перед покупкой в Хостинском районе. Специалисты выявили ограничения по высотности из-за приаэродромной территории, что спасло от серьезных проблем в будущем. Профессиональный подход!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-01-15 07:22:33', '2025-01-15 07:22:33'),
(170, 147, 89, 'Елена К.', NULL, 'Заказывала комплексное оформление документации для частного дома под ключ. Все этапы от межевания до получения адреса прошли гладко. Сэкономила массу времени и нервов.', NULL, '5', 'positive', 'approved', 1, NULL, '2025-01-28 11:45:12', '2025-01-28 11:45:12'),
(171, 147, 89, 'Андрей В.', NULL, 'Помогли с перераспределением земельного участка (\"прирезкой\"). Добавили почти 4 сотки к участку в Адлере. Все согласования с администрацией прошли успешно.', 5, NULL, 'positive', 'approved', 1, NULL, '2025-02-05 06:17:25', '2025-02-05 06:17:25'),
(172, 147, 89, 'Ольга М.', NULL, 'Обращалась за градостроительным анализом участка в Центральном районе. Получила исчерпывающую информацию о возможностях использования территории с учетом ПЗЗ и Генплана. Рекомендую!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-02-18 13:33:47', '2025-02-18 13:33:47'),
(173, 147, 89, 'Дмитрий С.', NULL, 'Возникли проблемы с оформлением земли под существующим зданием. Компания успешно решила вопрос, хотя до этого обращался в две другие фирмы безрезультатно. Настоящие профессионалы своего дела!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-03-02 08:05:39', '2025-03-02 08:05:39'),
(174, 147, 89, 'Марина Т.', NULL, 'Заказывала топографическую съемку участка в горной местности Красной Поляны. Работы выполнены с высокой точностью благодаря современному оборудованию. Результатом довольна.', 4, NULL, 'positive', 'approved', 1, NULL, '2025-03-11 10:29:54', '2025-03-11 10:29:54'),
(175, 147, 89, 'Константин Р.', NULL, 'Сопровождение получения согласования Росавиации для строительства в приаэродромной зоне. Решили вопрос, который казался почти нерешаемым. Высокий профессионализм!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-03-24 12:42:18', '2025-03-24 12:42:18'),
(176, 147, 89, 'Наталья Ж.', NULL, 'Обратилась за оформлением уведомлений о строительстве ИЖС. Процесс прошел гладко, все этапы были четко разъяснены. Спасибо за помощь!', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-04-02 07:51:33', '2025-04-02 07:51:33'),
(177, 147, 89, 'Игорь Л.', NULL, 'Компания разработала полный комплект проектной документации для нашего гостевого дома с учетом сейсмики и сложного рельефа. Отличная работа!', NULL, '5', 'positive', 'approved', 1, NULL, '2025-04-09 09:38:47', '2025-04-09 09:38:47'),
(178, 147, 89, 'Анна П.', NULL, 'Получила экспертное заключение о нахождении участка в зоне затопления. Анализ был проведен очень тщательно, с выездом на участок и детальным гидрологическим исследованием.', 5, NULL, 'positive', 'approved', 1, NULL, '2025-04-15 11:27:01', '2025-04-15 11:27:01'),
(179, 147, 89, 'Владимир К.', NULL, 'Заказывал комплексный анализ земельного участка перед покупкой в Лазаревском районе. Выявили несоответствие фактических границ документам, что спасло от потенциального земельного спора. Благодарен за профессионализм!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-04-23 06:33:42', '2025-04-23 06:33:42'),
(180, 147, 89, 'Светлана Д.', NULL, 'Обратилась по рекомендации для решения вопроса с оформлением земли под нашим кафе. Все документы подготовили оперативно, прошли все инстанции без проблем. Теперь можем спокойно развивать бизнес.', NULL, '5', 'positive', 'approved', 1, NULL, '2025-04-30 13:55:19', '2025-04-30 13:55:19'),
(181, 147, 89, 'Артем М.', NULL, 'Заказывал расчет оптимальной площади земельного участка для эксплуатации здания. Очень грамотно подошли к вопросу, учли все нормативы и сэкономили средства на содержании лишней территории.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-05-06 08:19:57', '2025-05-06 08:19:57'),
(182, 147, 89, 'Кирилл Н.', NULL, 'Помогли оформить документацию по планировке территории под малоэтажный жилой комплекс. Проект успешно прошел все согласования с первого раза. Сотрудничеством очень доволен!', 5, NULL, 'positive', 'approved', 1, NULL, '2025-05-12 10:42:05', '2025-05-12 10:42:05'),
(183, 147, 89, 'Юлия В.', NULL, 'Компания проводила юридический анализ документов на землю, выявили несколько скрытых обременений, о которых продавец умолчал. Сэкономили мне не только деньги, но и годы потенциальных судебных разбирательств.', 5, NULL, 'positive', 'approved', 1, NULL, '2025-05-16 07:07:31', '2025-05-16 07:07:31'),
(228, 147, 89, '', NULL, '', 5, '2a03:6f00:6:1::bce1:1797', 'neutral', 'approved', 1, NULL, '2025-05-27 12:27:16', '2025-05-27 12:37:50'),
(229, 141, 90, 'Елена Воронова', NULL, 'Заказали AI-сайт для нашего агентства. Понравилось, что сделали быстро - за 2 недели. Сайт действительно загружается моментально, клиенты это отмечают. Количество обращений через сайт выросло примерно на 20-30%. Управление через Telegram очень удобно для нашей команды.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-03-11 21:00:00', '2025-07-17 08:29:06'),
(230, 141, 90, 'Михаил Р.', NULL, 'Сделали нам лендинг с AI-технологиями. Конверсия реально выросла - было около 4%, стало 12-15%. Особенно понравилось, что под каждый район Краснодара есть отдельные страницы. Клиенты стали чаще оставлять заявки.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-03-24 21:00:00', '2025-07-17 08:29:06'),
(231, 141, 90, 'Анна Петрова', NULL, 'Внедрили AI-Core для обработки заявок. Теперь все заявки с разных площадок попадают в одну систему. Риелторы работают через Telegram, очень удобно. Время обработки заявки сократилось в разы - теперь отвечаем клиентам за 5-10 минут.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-04-07 21:00:00', '2025-07-17 08:29:06'),
(232, 141, 90, 'Дмитрий Соколов', NULL, 'Заказали AI-продвижение для нашего агентства. Объекты стали чаще находить в Яндексе. Автоматическое создание описаний для объектов экономит много времени. Отчеты в Telegram приходят каждую неделю - видно динамику.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-04-18 21:00:00', '2025-07-17 08:29:06'),
(233, 141, 90, 'Светлана К.', NULL, 'Веб-студия сделала нам современный сайт с AI-функциями. Очень довольны дизайном и функциональностью. Каталог объектов стал намного удобнее, фильтры работают отлично. Клиенты легко находят нужную недвижимость.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-05-01 21:00:00', '2025-07-17 08:29:06'),
(234, 141, 90, 'Игорь Волков', NULL, 'Внедрили автоматизацию с Telegram-ботом. Теперь вся команда видит заявки в реальном времени. Распределение между риелторами происходит автоматически. Порядок в работе наконец-то навели.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-05-13 21:00:00', '2025-07-17 08:29:06'),
(235, 141, 90, 'Марина Новикова', NULL, 'AI-лендинг действительно работает. Раньше из 100 посетителей заявку оставляли 3-4 человека, теперь 10-12. Особенно хорошо конвертируются страницы по новостройкам ФМР. Довольны результатом.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-05-26 21:00:00', '2025-07-17 08:29:06'),
(236, 141, 90, 'Олег Михайлов', NULL, 'Сделали полную интеграцию AI-экосистемы. Сайт попал в топ-5 Яндекса по основным запросам уже через месяц. Заявок стало больше на 40-50%. Система действительно работает как единый организм - всё связано и автоматизировано.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-06-04 21:00:00', '2025-07-17 08:29:06'),
(237, 141, 90, 'Татьяна Белова', NULL, 'Заказали AI-сайт с большим количеством страниц под разные районы. Трафик из поиска вырос заметно. Теперь нас находят по запросам \"квартиры ЦМР\", \"дома КМР\" и другим. Органический трафик составляет уже 60% от общего.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-06-15 21:00:00', '2025-07-17 08:29:06'),
(238, 141, 90, 'Александр Попов', NULL, 'Внедрили CRM с AI-обработкой. Заявки с Авито, ЦИАН и нашего сайта теперь попадают в одну систему. Риелторы получают уведомления в Telegram с полной информацией о клиенте. Очень удобно.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-06-27 21:00:00', '2025-07-17 08:29:06'),
(239, 141, 90, 'Наталья Краснова', NULL, 'Полная AI-экосистема работает уже 2 месяца. Результаты превзошли ожидания - прибыль выросла на 35%. Все процессы автоматизированы, команда работает эффективнее. Управление через Telegram очень удобное.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-07-08 21:00:00', '2025-07-17 08:29:06'),
(240, 141, 90, 'Сергей Лебедев', NULL, 'AI-продвижение помогло нашим объектам попасть в топ поиска. Особенно заметен рост по запросам коттеджей в пригороде. Контент создается автоматически, что экономит время маркетологов.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-04-02 21:00:00', '2025-07-17 08:29:06'),
(241, 141, 90, 'Юлия Смирнова', NULL, 'Сделали современный лендинг с AI-элементами. Загрузка действительно быстрая, посетители не уходят. Форма заявки работает отлично, клиенты легко оставляют контакты. Конверсия выросла с 5% до 18%.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-04-20 21:00:00', '2025-07-17 08:29:06'),
(242, 141, 90, 'Владимир Козлов', NULL, 'Веб-студия создала отличный сайт с AI-функциями. Каталог недвижимости стал намного удобнее. Клиенты могут легко найти квартиры по своим параметрам. Интеграция с Telegram для команды - просто находка.', 5, NULL, 'neutral', 'approved', 1, NULL, '2025-05-09 21:00:00', '2025-07-17 08:29:06'),
(243, 141, 90, 'Людмила Морозова', NULL, 'AI-экосистема работает второй месяц. Сайт стабильно в топе Яндекса, лендинги показывают хорошую конверсию около 20%. Заявки обрабатываются быстро благодаря CRM. Общий рост клиентской базы на 30%.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-06-17 21:00:00', '2025-07-17 08:29:06'),
(244, 141, 90, 'Андрей Федоров', NULL, 'Внедрили полную автоматизацию агентства. Все инструменты работают слаженно. Особенно понравилось, что управление идет через один Telegram-бот. Эффективность команды выросла, клиентов стало больше.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-06-30 21:00:00', '2025-07-17 08:29:06'),
(245, 141, 90, 'Екатерина Волкова', NULL, 'AI-сайт сделан качественно. Много страниц под разные запросы по недвижимости Краснодара. Поисковики индексируют хорошо. Трафик растет постепенно, уже заметен результат через месяц работы.', 4, NULL, 'neutral', 'approved', 1, NULL, '2025-03-14 21:00:00', '2025-07-17 08:29:06'),
(248, 141, 90, 'Иван', NULL, 'класс ман', NULL, '2a03:6f00:1::5ec6:df4a', 'neutral', 'pending', 0, NULL, '2025-07-23 07:40:46', '2025-07-23 07:40:46');

-- --------------------------------------------------------

--
-- Структура таблицы `outbox`
--

CREATE TABLE IF NOT EXISTS `outbox` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `recipient_type` enum('email','telegram','sms','chat','webhook') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `recipient` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `sender` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sender_type` enum('email','telegram','sms','webhook') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subject` text COLLATE utf8mb4_general_ci,
  `body` text COLLATE utf8mb4_general_ci,
  `generated_by` enum('ai','human') COLLATE utf8mb4_general_ci DEFAULT 'ai',
  `status` enum('sent','queued','failed') COLLATE utf8mb4_general_ci DEFAULT 'queued',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `client_id` int DEFAULT NULL,
  `organization_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`),
  KEY `fk_outbox_client` (`client_id`),
  KEY `fk_outbox_organization` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `prompt_profiles`
--

CREATE TABLE IF NOT EXISTS `prompt_profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `source_id` int DEFAULT NULL,
  `page_slug` varchar(128) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `lang` enum('ru','de','en') DEFAULT 'ru',
  `tone` varchar(64) DEFAULT 'профессиональный',
  `brand_voice` text,
  `static_data` json DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `source_id` (`source_id`),
  KEY `idx_org_source_page` (`organization_id`,`source_id`,`page_slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `prompt_profiles`
--

INSERT INTO `prompt_profiles` (`id`, `organization_id`, `source_id`, `page_slug`, `title`, `lang`, `tone`, `brand_voice`, `static_data`, `is_active`, `created_at`) VALUES
(1, 141, 90, 'glavnaya', 'BriemChainAI - Эксперт по AI-экосистеме недвижимости', 'ru', 'экспертный консультант с системным мышлением', 'Ты - ведущий эксперт по AI-автоматизации агентств недвижимости в Краснодаре. \r\n\r\nТВОЯ ЭКСПЕРТИЗА:\r\n• Глубокое понимание всех 5 продуктов экосистемы: AI-сайт, AI-лендинг, AI-CRM, AI-продвижение + комплексные пакеты\r\n• Знание синергетических эффектов: как продукты усиливают друг друга\r\n• Региональная экспертиза по рынку недвижимости Краснодара\r\n• Способность рассчитать ROI и подобрать оптимальное решение\r\n\r\nСТИЛЬ ОБЩЕНИЯ:\r\n• Говоришь конкретными цифрами и результатами\r\n• Объясняешь сложные AI-технологии простым языком  \r\n• Показываешь не просто продукты, а системные решения\r\n• Фокусируешься на бизнес-результатах клиента\r\n• Используешь региональные инсайты для убедительности\r\n\r\nПОДХОД К КОНСУЛЬТАЦИИ:\r\n• Всегда определяешь размер агентства для выбора решения\r\n• Выявляешь основные боли: трафик/конверсия/автоматизация/продвижение\r\n• Показываешь как экосистема решает проблемы комплексно\r\n• Рассчитываешь персональный ROI с учетом специфики недвижимости\r\n• Акцентируешь синергию продуктов и быструю окупаемость\r\n\r\nРЕГИОНАЛЬНЫЕ ЗНАНИЯ:\r\n• Понимаешь специфику районов ФМР/ЦМР/КМР/Прикубанский\r\n• Знаешь сезонные тренды рынка недвижимости Краснодара\r\n• Владеешь информацией о местных порталах и интеграциях\r\n• Учитываешь ценовые сегменты и целевую аудиторию региона\r\n\r\nЦЕЛЬ: Не просто продать продукт, а стать trusted advisor, который поможет агентству вырасти в 3 раза через AI-автоматизацию.', '{\"products_count\": 5, \"ecosystem_focus\": true, \"target_audience\": \"агентства недвижимости\", \"key_differentiator\": \"синергия AI-продуктов\", \"regional_expertise\": \"Краснодар\", \"consultation_approach\": \"системное решение под размер бизнеса\"}', 1, '2025-08-12 13:55:35');

-- --------------------------------------------------------

--
-- Структура таблицы `prompt_templates`
--

CREATE TABLE IF NOT EXISTS `prompt_templates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `source_id` int DEFAULT NULL,
  `page_slug` varchar(128) DEFAULT NULL,
  `intent_id` int NOT NULL,
  `version` varchar(16) DEFAULT 'v1',
  `system_prompt` mediumtext,
  `few_shots` json DEFAULT NULL,
  `output_format` json DEFAULT NULL,
  `guardrails` text,
  `default_action` varchar(32) DEFAULT NULL,
  `priority` tinyint DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `conversion_rate` decimal(5,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `source_id` (`source_id`),
  KEY `intent_id` (`intent_id`),
  KEY `idx_org_source_page_intent` (`organization_id`,`source_id`,`page_slug`,`intent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `prompt_templates`
--

INSERT INTO `prompt_templates` (`id`, `organization_id`, `source_id`, `page_slug`, `intent_id`, `version`, `system_prompt`, `few_shots`, `output_format`, `guardrails`, `default_action`, `priority`, `is_active`, `conversion_rate`, `created_at`) VALUES
(9, 141, 90, 'glavnaya', 1, '1', 'Ты эксперт-консультант {{company_name}} по AI-автоматизации агентств недвижимости в Краснодаре.\r\n\r\n? НАШИ AI-ПРОДУКТЫ:\r\n\r\n1️⃣ AI-САЙТ:\r\n- Настройка: {{ai_website_price_setup}} ₽\r\n- Поддержка: {{ai_website_price_monthly}} ₽/мес\r\n- Загрузка: {{ai_website_loading_speed}}\r\n- SEO: {{ai_website_seo_pages}}\r\n- Трафик: {{ai_website_traffic_growth}}\r\n\r\n2️⃣ AI-ЛЕНДИНГ:\r\n- Цена: {{ai_landing_price_single}} ₽\r\n- Конверсия: {{ai_landing_conversion}}\r\n- Запуск: {{ai_landing_launch_time}}\r\n\r\n3️⃣ AI-CRM:\r\n- Настройка: {{ai_crm_price_setup}} ₽\r\n- Тарифы: {{ai_crm_price_basic}}-{{ai_crm_price_premium}} ₽/мес\r\n- Базовый: {{ai_crm_features_basic}}\r\n- Премиум: {{ai_crm_features_premium}}\r\n\r\n4️⃣ AI-ПРОДВИЖЕНИЕ:\r\n- SEO: {{ai_promotion_seo_only}} ₽/мес\r\n- Полный: {{ai_promotion_full}} ₽/мес\r\n\r\n5️⃣ ПАКЕТЫ:\r\n- AI-СТАРТ: {{package_start_price}} \r\n- AI-ПРОФИ: {{package_profi_price}}\r\n- AI-ИМПЕРИЯ: {{package_empire_price}}\r\n\r\n? СПЕЦПРЕДЛОЖЕНИЯ: {{current_offers}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nОтвечай конкретными ценами из базы фактов. Если спрашивают про CRM - называй цены AI-CRM с разбивкой по тарифам.\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"подробная консультация с ценами AI-CRM и рекомендацией тарифа\",\r\n  \"action\": \"create_lead\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', 'Отвечай только ценами из базы фактов', 'create_lead', 10, 1, 0.00, '2025-08-12 14:12:21'),
(10, 141, 90, 'glavnaya', 2, '1', 'Ты технический консультант {{company_name}}.\r\n\r\nПРОДУКТЫ:\r\n? AI-сайт: {{ai_website_seo_pages}}, загрузка {{ai_website_loading_speed}}\r\n? AI-лендинг: конверсия {{ai_landing_conversion}}, запуск {{ai_landing_launch_time}}\r\n? AI-CRM: обработка {{ai_core_processing_time}}, каналы {{ai_core_channels}}\r\n? AI-продвижение: {{ai_promotion_clients}}, ROI {{ai_promotion_roi}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"техническая консультация\",\r\n  \"action\": \"callback_request\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', '', 'callback_request', 8, 1, 0.00, '2025-08-12 14:12:21'),
(11, 141, 90, 'glavnaya', 3, '1', 'Ты менеджер по продажам {{company_name}}.\r\n\r\nСИНЕРГИЯ ЭКОСИСТЕМЫ: {{ecosystem_synergy}} = {{ecosystem_profit_growth}}\r\n\r\nПАКЕТЫ:\r\n? AI-СТАРТ: {{package_start_price}} ({{package_start_target}})\r\n? AI-ПРОФИ: {{package_profi_price}} ({{package_profi_target}})\r\n? AI-ИМПЕРИЯ: {{package_empire_price}} ({{package_empire_target}})\r\n\r\nАКЦИИ: {{current_offers}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"продающая презентация с ROI\",\r\n  \"action\": \"create_lead\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', '', 'create_lead', 10, 1, 0.00, '2025-08-12 14:12:21'),
(12, 141, 90, 'glavnaya', 4, '1', 'Ты финансовый аналитик {{company_name}}.\r\n\r\nЭФФЕКТИВНОСТЬ:\r\n• ROI экосистемы: {{ecosystem_roi}}\r\n• Дополнительная прибыль: {{revenue_increase}}\r\n• Экономия: {{cost_savings_total}}\r\n• Окупаемость: {{payback_period}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"расчет ROI с цифрами\",\r\n  \"action\": \"create_lead\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', '', 'create_lead', 9, 1, 0.00, '2025-08-12 14:12:21'),
(13, 141, 90, 'glavnaya', 5, '1', 'Ты проект-менеджер {{company_name}}.\r\n\r\nСРОКИ:\r\n• AI-лендинг: {{ai_landing_launch_time}}\r\n• AI-сайт: 14 дней\r\n• AI-CRM: 48 часов\r\n• Полная экосистема: {{ecosystem_launch_time}}\r\n\r\nЭТАПЫ: {{implementation_stages}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"план внедрения с этапами\",\r\n  \"action\": \"create_lead\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', '', 'create_lead', 7, 1, 0.00, '2025-08-12 14:12:21'),
(14, 141, 90, 'glavnaya', 6, '1', 'Ты специалист техподдержки {{company_name}}.\r\n\r\nПОДДЕРЖКА:\r\n• Режим: {{technical_support}}\r\n• Время ответа: {{contact_response_time}}\r\n• Uptime: {{technical_uptime}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"решение с SLA\",\r\n  \"action\": \"create_ticket\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', '', 'create_ticket', 9, 1, 0.00, '2025-08-12 14:12:21'),
(15, 141, 90, 'glavnaya', 7, '1', 'Ты демо-специалист {{company_name}}.\r\n\r\nДЕМО ФОРМАТЫ: {{demo_available}}\r\n\r\nКРАСНОДАР: {{krasnodar_districts}}, {{krasnodar_seasons}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"приглашение на демо\",\r\n  \"action\": \"callback_request\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', '', 'callback_request', 9, 1, 0.00, '2025-08-12 14:12:21'),
(16, 141, 90, 'glavnaya', 8, '1', 'Ты главный консультант {{company_name}}.\r\n\r\nНАША AI-ЭКОСИСТЕМА:\r\n? AI-сайт: {{ai_website_description}} - {{ai_website_price_setup}}\r\n? AI-лендинг: {{ai_landing_description}} - {{ai_landing_price_single}}\r\n? AI-CRM: {{ai_crm_description}} - от 150 000 ₽\r\n? AI-продвижение: {{ai_promotion_description}} - {{ai_promotion_seo_only}}-{{ai_promotion_full}}\r\n\r\nПАКЕТЫ: {{package_start_price}}, {{package_profi_price}}, {{package_empire_price}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nОтвечай полным списком всех 4 продуктов с названиями и ценами, потом предложи выбрать что интересует.\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"полный обзор всех 4 продуктов с правильными названиями\",\r\n  \"action\": \"none\",\r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', '', 'none', 5, 1, 0.00, '2025-08-12 14:12:21'),
(17, 141, 90, 'glavnaya', 9, '1', 'Эксперт по AI-сайт {{company_name}}.\r\n\r\nAI-сайт:\r\n- Цена: {{ai_website_price_setup}} + {{ai_website_price_monthly}}/мес\r\n- {{ai_website_seo_pages}} под {{krasnodar_districts}}\r\n- Загрузка: {{ai_website_loading_speed}}\r\n- Результат: {{ai_website_traffic_growth}}, {{ai_website_organic_leads}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON: {\"answer\": \"детали AI-сайт\", \"action\": \"create_lead\", \"confidence\": \"high\"}', NULL, NULL, NULL, 'create_lead', 8, 1, 0.00, '2025-08-12 14:12:44'),
(18, 141, 90, 'glavnaya', 10, '1', 'Эксперт по AI-лендинг {{company_name}}.\r\n\r\nAI-лендинг:\r\n- Цена: {{ai_landing_price_single}} (скидка {{ai_landing_discount}})\r\n- Конверсия: {{ai_landing_conversion}}\r\n- Запуск: {{ai_landing_launch_time}}\r\n- ROI: {{ai_landing_roi_period}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON: {\"answer\": \"детали AI-лендинг\", \"action\": \"create_lead\", \"confidence\": \"high\"}', NULL, NULL, NULL, 'create_lead', 8, 1, 0.00, '2025-08-12 14:12:44'),
(19, 141, 90, 'glavnaya', 11, '1', 'Эксперт по AI-CRM {{company_name}}.\r\n\r\nAI-CRM:\r\n- Цена: {{ai_core_price_setup}} + тарифы {{ai_core_price_basic}}-{{ai_core_price_premium}}\r\n- Обработка: {{ai_core_processing_time}}\r\n- Каналы: {{ai_core_channels}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON: {\"answer\": \"детали AI-CRM\", \"action\": \"create_lead\", \"confidence\": \"high\"}', NULL, NULL, NULL, 'create_lead', 8, 1, 0.00, '2025-08-12 14:12:44'),
(20, 141, 90, 'glavnaya', 12, '1', 'Эксперт по AI-продвижение {{company_name}}.\r\n\r\nAI-продвижение:\r\n- Цена: {{ai_promotion_seo_only}}-{{ai_promotion_full}}\r\n- Результат: {{ai_promotion_clients}}, ROI {{ai_promotion_roi}}\r\n- База: {{ai_promotion_keywords}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON: {\"answer\": \"детали AI-продвижение\", \"action\": \"create_lead\", \"confidence\": \"high\"}', NULL, NULL, NULL, 'create_lead', 8, 1, 0.00, '2025-08-12 14:12:44'),
(21, 141, 90, 'glavnaya', 13, '1', 'Эксперт по пакетам {{company_name}}.\r\n\r\nПАКЕТЫ:\r\n- AI-СТАРТ: {{package_start_price}} - {{package_start_includes}}\r\n- AI-ПРОФИ: {{package_profi_price}} - {{package_profi_includes}}\r\n- AI-ИМПЕРИЯ: {{package_empire_price}} - {{package_empire_includes}}\r\n\r\nСИНЕРГИЯ: {{ecosystem_synergy}} = {{ecosystem_profit_growth}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON: {\"answer\": \"сравнение пакетов с синергией\", \"action\": \"create_lead\", \"confidence\": \"high\"}', NULL, NULL, NULL, 'create_lead', 9, 1, 0.00, '2025-08-12 14:12:44'),
(22, 141, 90, 'glavnaya', 14, '1', 'Региональный эксперт {{company_name}} по Краснодару.\r\n\r\nКРАСНОДАР:\r\n- Районы: {{krasnodar_districts}}\r\n- Сезонность: {{krasnodar_seasons}}\r\n- Интеграции: {{krasnodar_integrations}}\r\n- База: {{ai_promotion_keywords}}\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON: {\"answer\": \"региональная экспертиза\", \"action\": \"none\", \"confidence\": \"high\"}', NULL, NULL, NULL, 'none', 6, 1, 0.00, '2025-08-12 14:12:44'),
(23, 141, 90, 'glavnaya', 16, '1', 'Ты эксперт по AI-CRM системам {{company_name}}.\r\n\r\n? AI-CRM - ПОЛНАЯ АВТОМАТИЗАЦИЯ ЧЕРЕЗ TELEGRAM:\r\n\r\n? СТОИМОСТЬ:\r\n- Настройка: {{ai_crm_price_setup}} ₽\r\n- Базовый тариф: {{ai_crm_price_basic}} ₽/мес\r\n- Премиум тариф: {{ai_crm_price_premium}} ₽/мес\r\n\r\n? БАЗОВЫЙ ВКЛЮЧАЕТ:\r\n{{ai_crm_features_basic}}\r\n\r\n? ПРЕМИУМ ВКЛЮЧАЕТ:\r\n{{ai_crm_features_premium}}\r\n\r\n⚡ РЕЗУЛЬТАТ:\r\n- Автоматизация 80% рутинных задач\r\n- Увеличение конверсии в 2-3 раза  \r\n- Экономия 4-6 часов в день каждого менеджера\r\n- Полный контроль всех каналов связи\r\n\r\n? РЕКОМЕНДАЦИЯ:\r\nДля агентств до 10 сотрудников → Базовый\r\nДля агентств 10+ сотрудников → Премиум\r\n\r\nВОПРОС: \"{{user_question}}\"\r\n\r\nJSON:\r\n{\r\n  \"answer\": \"детальный разбор AI-CRM с ценами и рекомендацией тарифа\",\r\n  \"action\": \"create_lead\", \r\n  \"confidence\": \"high\"\r\n}', '[]', '{}', 'Называй точные цены из фактов', 'create_lead', 9, 1, 0.00, '2025-08-13 07:16:15');

-- --------------------------------------------------------

--
-- Структура таблицы `queue_tasks`
--

CREATE TABLE IF NOT EXISTS `queue_tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `script_name` varchar(50) NOT NULL,
  `request_id` int NOT NULL,
  `organization_id` int NOT NULL,
  `status` enum('waiting','processing','completed','failed') DEFAULT 'waiting',
  `priority` enum('high','medium','low') DEFAULT 'medium',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_queue_composite` (`status`,`priority`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `queue_tasks`
--

INSERT INTO `queue_tasks` (`id`, `script_name`, `request_id`, `organization_id`, `status`, `priority`, `created_at`) VALUES
(172, 'checkEventContext', 126, 141, '', 'high', '2025-08-15 13:14:13'),
(173, 'checkEventContext', 127, 141, '', 'high', '2025-08-15 13:14:23'),
(174, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:14:32'),
(175, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:14:40'),
(176, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:14:48'),
(177, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:14:56'),
(178, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:06'),
(179, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:13'),
(180, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:14'),
(181, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:23'),
(182, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:23'),
(183, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:30'),
(184, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:31'),
(185, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:38'),
(186, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:40'),
(187, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:48'),
(188, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:48'),
(189, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:56'),
(190, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:15:56'),
(191, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:02'),
(192, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:03'),
(193, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:09'),
(194, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:10'),
(195, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:17'),
(196, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:17'),
(197, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:28'),
(198, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:28'),
(199, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:35'),
(200, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:36'),
(201, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:45'),
(202, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:48'),
(203, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:54'),
(204, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:16:56'),
(205, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:02'),
(206, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:05'),
(207, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:10'),
(208, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:12'),
(209, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:20'),
(210, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:20'),
(211, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:29'),
(212, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:31'),
(213, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:37'),
(214, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:40'),
(215, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:48'),
(216, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:48'),
(217, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:56'),
(218, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:17:57'),
(219, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:04'),
(220, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:04'),
(221, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:12'),
(222, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:14'),
(223, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:21'),
(224, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:22'),
(225, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:30'),
(226, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:30'),
(227, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:37'),
(228, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:38'),
(229, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:46'),
(230, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:46'),
(231, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:54'),
(232, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:18:54'),
(233, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:19:01'),
(234, 'checkEventContext', 128, 141, '', 'high', '2025-08-15 13:19:02'),
(235, 'checkEventContext', 125, 141, '', 'high', '2025-08-15 13:33:14'),
(236, 'checkEventContext', 125, 141, '', 'high', '2025-08-15 14:47:19'),
(237, 'analytics_refresh', 141, 141, '', 'high', '2025-08-16 15:16:00'),
(238, 'analytics_refresh', 141, 141, '', 'high', '2025-08-16 15:33:30'),
(239, 'analytics_refresh', 141, 141, '', 'high', '2025-08-16 15:33:43'),
(240, 'analytics_refresh', 141, 141, '', 'high', '2025-08-16 15:52:52'),
(241, 'analytics_refresh', 141, 141, '', 'high', '2025-08-16 16:27:04'),
(242, 'analytics_refresh', 141, 141, '', 'high', '2025-08-16 16:48:05'),
(243, 'analytics_refresh', 141, 141, '', 'high', '2025-08-16 19:41:51'),
(244, 'checkEventContext', 128, 141, '', 'high', '2025-08-19 04:00:22'),
(245, 'checkEventContext', 128, 141, '', 'high', '2025-08-19 04:00:32'),
(246, 'checkEventContext', 128, 141, '', 'high', '2025-08-19 04:00:56');

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`id`, `role_name`) VALUES
(131, 'Account Manager'),
(121, 'Admin'),
(169, 'Affiliate Manager'),
(165, 'Animator'),
(171, 'Automation Specialist'),
(153, 'Beauty Specialist'),
(120, 'CEO'),
(127, 'CFO'),
(157, 'Chef'),
(124, 'CIO'),
(158, 'Cleaning'),
(126, 'CMO'),
(134, 'Community Manager'),
(163, 'Content Manager'),
(123, 'COO'),
(162, 'Copywriter'),
(125, 'CTO'),
(164, 'Designer'),
(145, 'Developer'),
(148, 'Driver'),
(144, 'Engineer'),
(135, 'Event Manager'),
(147, 'Finance'),
(155, 'Fitness Instructor'),
(136, 'Fleet Manager'),
(122, 'HR'),
(146, 'Legal Consultant'),
(149, 'Logisics'),
(128, 'Manager'),
(138, 'Marketing'),
(154, 'Massage Therapist'),
(156, 'Mechanic'),
(159, 'Medical Specialist'),
(168, 'Online Tutor'),
(167, 'Photographer'),
(141, 'PPC'),
(142, 'PR'),
(132, 'Product Manager'),
(130, 'Project Manager'),
(152, 'Receptionist'),
(137, 'Sales'),
(150, 'Security'),
(139, 'SEO'),
(151, 'Service Provider'),
(140, 'SMM'),
(170, 'Streaming Host'),
(129, 'Support Manager'),
(161, 'Tailor'),
(160, 'Tattoo Artist'),
(143, 'Tech Support'),
(133, 'Training Manager'),
(166, 'Videographer');

-- --------------------------------------------------------

--
-- Структура таблицы `tasks`
--

CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `docs_link` varchar(255) DEFAULT NULL,
  `assigned_to` int DEFAULT NULL,
  `auto_assigned` tinyint(1) DEFAULT '0',
  `created_by` varchar(50) DEFAULT 'user',
  `status` enum('open','in_progress','under_review','completed','cancelled') NOT NULL DEFAULT 'open',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `client_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tasks_event_id` (`event_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_tasks_status` (`status`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `term_synonyms`
--

CREATE TABLE IF NOT EXISTS `term_synonyms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `canonical` varchar(64) DEFAULT NULL,
  `synonyms` text,
  `context` varchar(64) DEFAULT NULL,
  `lang` enum('ru','de','en') DEFAULT 'ru',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `term_synonyms`
--

INSERT INTO `term_synonyms` (`id`, `canonical`, `synonyms`, `context`, `lang`, `created_at`) VALUES
(1, 'сайт', 'ai-website,веб-сайт,интернет-сайт,портал,ресурс,площадка', 'ai_website', 'ru', '2025-08-12 13:38:37'),
(2, 'лендинг', 'ai-landing,посадочная страница,одностраничник,landing page', 'ai_landing', 'ru', '2025-08-12 13:38:37'),
(3, 'crm', 'ai-core,система,автоматизация,црм,si-ar-em', 'ai_core', 'ru', '2025-08-12 13:38:37'),
(4, 'продвижение', 'ai-promotion,реклама,маркетинг,раскрутка,промоушен', 'ai_promotion', 'ru', '2025-08-12 13:38:37'),
(5, 'автоматизация', 'автоматика,роботизация,ai,ии,искусственный интеллект', 'automation', 'ru', '2025-08-12 13:38:37'),
(6, 'умный', 'ai,интеллектуальный,smart,смарт,искусственный', 'ai', 'ru', '2025-08-12 13:38:37'),
(7, 'бот', 'робот,чат-бот,телеграм-бот,автоответчик', 'bot', 'ru', '2025-08-12 13:38:37'),
(8, 'roi', 'окупаемость,рентабельность,доходность,возврат инвестиций,эффективность', 'roi', 'ru', '2025-08-12 13:38:37'),
(9, 'конверсия', 'превращение,преобразование,отклик,результативность', 'conversion', 'ru', '2025-08-12 13:38:37'),
(10, 'трафик', 'посетители,посещения,визиты,переходы,клики', 'traffic', 'ru', '2025-08-12 13:38:37'),
(11, 'лиды', 'заявки,обращения,клиенты,потенциальные покупатели,leads', 'leads', 'ru', '2025-08-12 13:38:37'),
(12, 'краснодар', 'краснодарский край,кубань,юг россии', 'region', 'ru', '2025-08-12 13:38:37'),
(13, 'фмр', 'федеральный микрорайон,фед микрорайон', 'district', 'ru', '2025-08-12 13:38:37'),
(14, 'цмр', 'центральный микрорайон,центр микрорайон', 'district', 'ru', '2025-08-12 13:38:37'),
(15, 'кмр', 'карасунский микрорайон,карасунский', 'district', 'ru', '2025-08-12 13:38:37'),
(16, 'новостройка', 'новое строительство,новый дом,первичная недвижимость,первичка', 'property_type', 'ru', '2025-08-12 13:38:37'),
(17, 'вторичка', 'вторичная недвижимость,вторичный рынок,б/у недвижимость', 'property_type', 'ru', '2025-08-12 13:38:37'),
(18, 'авито', 'avito,avito.ru', 'portal', 'ru', '2025-08-12 13:38:37'),
(19, 'циан', 'cian,cian.ru', 'portal', 'ru', '2025-08-12 13:38:37'),
(20, 'домклик', 'domclick,домклик.ру', 'portal', 'ru', '2025-08-12 13:38:37'),
(21, 'яндекс недвижимость', 'yandex недвижимость,яндекс.недвижимость', 'portal', 'ru', '2025-08-12 13:38:37'),
(22, 'старт', 'ai-старт,базовый,начальный,стартовый', 'package', 'ru', '2025-08-12 13:38:37'),
(23, 'профи', 'ai-профи,профессиональный,средний,полный', 'package', 'ru', '2025-08-12 13:38:37'),
(24, 'империя', 'ai-империя,максимальный,корпоративный,премиум', 'package', 'ru', '2025-08-12 13:38:37'),
(25, 'загрузка', 'скорость загрузки,быстродействие,производительность', 'performance', 'ru', '2025-08-12 13:38:37'),
(26, 'uptime', 'аптайм,время работы,доступность,стабильность', 'technical', 'ru', '2025-08-12 13:38:37'),
(27, 'интеграция', 'подключение,синхронизация,связка,объединение', 'integration', 'ru', '2025-08-12 13:38:37'),
(28, 'api', 'апи,программный интерфейс,interface', 'technical', 'ru', '2025-08-12 13:38:37'),
(29, 'агентство', 'риелторское агентство,компания недвижимости,фирма', 'business', 'ru', '2025-08-12 13:38:37'),
(30, 'риелтор', 'риэлтор,агент,специалист,менеджер', 'role', 'ru', '2025-08-12 13:38:37'),
(31, 'клиент', 'покупатель,заказчик,потребитель,пользователь', 'client', 'ru', '2025-08-12 13:38:37'),
(32, 'сделка', 'продажа,покупка,операция,транзакция', 'transaction', 'ru', '2025-08-12 13:38:37'),
(33, 'быстро', 'срочно,оперативно,скоро,в короткие сроки', 'time', 'ru', '2025-08-12 13:38:37'),
(34, 'месяц', '30 дней,ежемесячно,в месяц,за месяц', 'time', 'ru', '2025-08-12 13:38:37'),
(35, 'год', '12 месяцев,ежегодно,в год,за год', 'time', 'ru', '2025-08-12 13:38:37'),
(36, 'бюджет', 'стоимость,цена,затраты,инвестиции', 'finance', 'ru', '2025-08-12 13:38:37'),
(37, 'экономия', 'сбережения,снижение затрат,оптимизация', 'finance', 'ru', '2025-08-12 13:38:37'),
(38, 'прибыль', 'доход,выручка,заработок,profit', 'finance', 'ru', '2025-08-12 13:38:37'),
(39, 'скидка', 'дисконт,льгота,акция,специальное предложение', 'finance', 'ru', '2025-08-12 13:38:37'),
(40, 'поддержка', 'техподдержка,помощь,сервис,обслуживание', 'support', 'ru', '2025-08-12 13:38:37'),
(41, 'обучение', 'инструктаж,курсы,тренинг,подготовка', 'training', 'ru', '2025-08-12 13:38:37'),
(42, 'настройка', 'конфигурация,установка,внедрение', 'setup', 'ru', '2025-08-12 13:38:37'),
(43, 'лучший', 'топовый,превосходный,отличный,качественный', 'quality', 'ru', '2025-08-12 13:38:37'),
(44, 'уникальный', 'эксклюзивный,единственный,особенный', 'quality', 'ru', '2025-08-12 13:38:37'),
(45, 'надежный', 'стабильный,проверенный,безопасный', 'quality', 'ru', '2025-08-12 13:38:37'),
(46, 'конкурент', 'соперник,другие компании,альтернатива', 'competition', 'ru', '2025-08-12 13:38:37'),
(47, 'преимущество', 'плюс,достоинство,выгода,benefit', 'advantage', 'ru', '2025-08-12 13:38:37'),
(48, 'отличие', 'разница,особенность,различие', 'difference', 'ru', '2025-08-12 13:38:37'),
(49, 'заказать', 'купить,приобрести,оформить,получить', 'action', 'ru', '2025-08-12 13:38:37'),
(50, 'попробовать', 'протестировать,испытать,проверить', 'action', 'ru', '2025-08-12 13:38:37'),
(51, 'узнать', 'выяснить,разузнать,получить информацию', 'action', 'ru', '2025-08-12 13:38:37'),
(52, 'сравнить', 'сопоставить,сверить,проанализировать', 'action', 'ru', '2025-08-12 13:38:37'),
(53, 'проблема', 'трудность,сложность,вызов,боль', 'emotion', 'ru', '2025-08-12 13:38:37'),
(54, 'решение', 'выход,способ,метод,вариант', 'emotion', 'ru', '2025-08-12 13:38:37'),
(55, 'успех', 'достижение,результат,победа', 'emotion', 'ru', '2025-08-12 13:38:37'),
(56, 'уверенность', 'гарантия,надежность,стабильность', 'emotion', 'ru', '2025-08-12 13:38:37');

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int DEFAULT NULL,
  `client_id` int DEFAULT NULL,
  `status` enum('open','in_progress','on_hold','resolved','closed') COLLATE utf8mb4_general_ci DEFAULT 'open',
  `priority` enum('low','medium','high','critical') COLLATE utf8mb4_general_ci DEFAULT 'medium',
  `assigned_to` int DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_assigned_to` (`assigned_to`),
  KEY `idx_tickets_client_status` (`client_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `telegram_id` bigint NOT NULL,
  `telegram_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `language` varchar(5) DEFAULT 'orig',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `password_hash` varchar(64) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `telegram_id`, `telegram_name`, `name`, `email`, `language`, `created_at`, `password_hash`, `timezone`) VALUES
(43, 6594349857, 'Pirakuda', 'Walter', NULL, 'orig', '2025-02-28 18:17:10', NULL, NULL),
(53, 7557836585, 'Sikamo', 'Islam', NULL, 'orig', '2025-05-27 10:01:42', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `user_organization_roles`
--

CREATE TABLE IF NOT EXISTS `user_organization_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `organization_id` int NOT NULL,
  `level` enum('senior','middle','junior') DEFAULT 'junior',
  `addition` varchar(20) DEFAULT NULL,
  `workload` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `receives_site_analytics` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_org` (`user_id`,`organization_id`),
  UNIQUE KEY `user_id` (`user_id`,`organization_id`),
  KEY `organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `user_organization_roles`
--

INSERT INTO `user_organization_roles` (`id`, `user_id`, `organization_id`, `level`, `addition`, `workload`, `created_at`, `receives_site_analytics`) VALUES
(78, 43, 141, 'senior', NULL, 0, '2025-04-09 15:52:29', 1),
(79, 43, 142, 'middle', NULL, 0, '2025-04-09 16:58:29', 0),
(89, 43, 147, 'middle', NULL, 0, '2025-05-03 09:14:18', 0),
(91, 53, 147, 'middle', NULL, 0, '2025-05-27 10:01:42', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `user_roles`
--

CREATE TABLE IF NOT EXISTS `user_roles` (
  `user_org_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_org_id`,`role_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `user_roles`
--

INSERT INTO `user_roles` (`user_org_id`, `role_id`) VALUES
(91, 120),
(78, 121),
(79, 121),
(89, 121),
(91, 121),
(78, 124),
(78, 125),
(78, 130),
(78, 132),
(78, 139),
(78, 143),
(78, 145);

-- --------------------------------------------------------

--
-- Структура таблицы `user_sessions`
--

CREATE TABLE IF NOT EXISTS `user_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `session_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visitor_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_anonymous` tinyint(1) DEFAULT '0',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'ru',
  `device_type` enum('desktop','mobile','tablet','bot') COLLATE utf8mb4_unicode_ci DEFAULT 'desktop',
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `os` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `screen_resolution` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'direct',
  `utm_source` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_medium` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_campaign` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_content` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_term` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referrer` text COLLATE utf8mb4_unicode_ci,
  `landing_page` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exit_page` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `segment_id` int DEFAULT NULL,
  `is_returning` tinyint(1) DEFAULT '0',
  `page_views` int DEFAULT '1',
  `session_duration` int DEFAULT '0',
  `bounce` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_activity` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_org_date` (`organization_id`,`created_at`),
  KEY `idx_session_visitor` (`session_id`,`visitor_id`),
  KEY `idx_visitor_date` (`visitor_id`,`created_at`),
  KEY `idx_device_source` (`device_type`,`source`),
  KEY `idx_date_only` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user_sessions`
--

INSERT INTO `user_sessions` (`id`, `organization_id`, `session_id`, `visitor_id`, `is_anonymous`, `ip_address`, `user_agent`, `country`, `region`, `city`, `language`, `device_type`, `browser`, `os`, `screen_resolution`, `source`, `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, `utm_term`, `referrer`, `landing_page`, `exit_page`, `segment_id`, `is_returning`, `page_views`, `session_duration`, `bounce`, `created_at`, `last_activity`) VALUES
(1, 141, 'anon_6', 'dbc71d15b789c87cca01748e96ebd4cc6a78aa40075102ad03134df6230cfd1d', 1, '170.106.35.187', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 21:07:48', '2025-08-21 18:25:40'),
(2, 141, 'anon_8', '96916b1822770399f4f395fcf5c9a44566079a06107421f27c905980b027ab70', 1, '141.8.142.33', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 21:13:26', '2025-08-21 18:25:40'),
(3, 141, 'anon_9', 'ca92dc63222162c51fd57cb30fdf753dbc01b3267ba96125bd52669c47188acc', 1, '43.164.197.224', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/sravnenie-ai-systema-vs-konkurenty', '/sravnenie-ai-systema-vs-konkurenty', NULL, 0, 1, 0, 1, '2025-08-17 21:23:13', '2025-08-21 18:25:40'),
(4, 141, 'anon_10', '6dcb67315c871a24dceaad28bf2f71df09961efc0478f7f867ad9ffcf6625a8d', 1, '43.166.128.86', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, '.%5C', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/.%5C/ai-website-nedvizhimosti', '/.%5C/ai-website-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 21:32:36', '2025-08-21 18:25:40'),
(5, 141, 'anon_11', 'd343badbfba122b9ef39334a43af47a3a6dc4bd5db514203c16e6afbcd03edae', 1, '43.166.239.145', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, '.%5C', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/.%5C/kak-rabotaet-vnedrenie-ai-systemy', '/.%5C/kak-rabotaet-vnedrenie-ai-systemy', NULL, 0, 1, 0, 1, '2025-08-17 21:41:33', '2025-08-21 18:25:40'),
(6, 141, 'anon_12', '813e98cc2ea150c18e8a55a5957f7d401bcbaf386d508a02d7c2ce6b54779f6f', 1, '43.130.40.120', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-promotion-nedvizhimosti', '/ai-promotion-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 21:51:41', '2025-08-21 18:25:40'),
(7, 141, 'anon_15', '2993938e945cda5eae48f7f7a905cd3d02462b8918873686323630d3fcca90dd', 1, '43.135.182.95', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/poluchit-ai-ekosistemu-nedvizhimosti', '/poluchit-ai-ekosistemu-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 22:01:34', '2025-08-21 18:25:40'),
(8, 141, 'anon_16', '253dac981d496f939bcfc937b9dcc911ced83104a733e9aad42a1626a4429063', 1, '194.50.16.252', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2.1 Safari/605.1.65', NULL, NULL, NULL, '_profiler', 'desktop', 'Safari', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/_profiler/open?file=app/config/parameters.yml', '/_profiler/open?file=app/config/parameters.yml', NULL, 0, 1, 0, 1, '2025-08-17 22:47:21', '2025-08-21 18:25:40'),
(9, 141, 'anon_34', 'ee3e098023349e8a3be6aae51b0557a564b68c86fdce9cf97b72b0863f4f7e6f', 1, '194.50.16.252', 'Mozilla/5.0 (CentOS; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'profiler', 'desktop', 'Chrome', 'Linux', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/profiler/open?file=app/config/parameters.yml', '/profiler/open?file=app/config/parameters.yml', NULL, 0, 1, 0, 1, '2025-08-17 22:48:37', '2025-08-21 18:25:40'),
(10, 141, 'anon_35', '67c7d9ba0836e08c63d7ad6da14aa289e52592257ebfacd340b4c0bc6e645e66', 1, '49.51.72.236', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/poluchit-ai-ekosistemu-nedvizhimosti', '/poluchit-ai-ekosistemu-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 23:01:30', '2025-08-21 18:25:40'),
(11, 141, 'anon_37', '9cbf620c539abb0f97d79a12983271576e0c7f0ac6d957a399526088b47570cc', 1, '212.118.43.65', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 23:05:32', '2025-08-21 18:25:40'),
(12, 141, 'anon_38', '5eb28c73babf62ec9691e777d76110e8ccf8a18e0a0f09ad6a525d11a3a4d23d', 1, '103.139.190.16', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 23:05:36', '2025-08-21 18:25:40'),
(13, 141, 'anon_39', '53da64b99fe2978f5dcdb9a84ee04758efd6ea045483415d19728a128f74a6ad', 1, '103.139.190.16', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 23:05:38', '2025-08-21 18:25:40'),
(14, 141, 'anon_40', '5de9ad19aa0037214b7c81e73e4a2840ffcfdf0141d89f1e4ef43b440933a4c6', 1, '43.159.144.16', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, '.%5C', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/.%5C/it-problemy-agentstva-nedvizhimosti', '/.%5C/it-problemy-agentstva-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 23:15:57', '2025-08-21 18:25:40'),
(15, 141, 'anon_62', '059bd9fdcb7de8f8f2c7be373b3f579a6341b0edd6fe655a716bd76ec5c75854', 1, '49.51.33.159', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-lending-nedvizhimosti', '/ai-lending-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-17 23:35:22', '2025-08-21 18:25:40'),
(16, 141, 'anon_63', 'e1c1feb9d4249ca92a0aae7aaea00af52304838b7b1c1432c395292f73a28a68', 1, '43.157.174.69', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/kak-rabotaet-vnedrenie-ai-systemy', '/kak-rabotaet-vnedrenie-ai-systemy', NULL, 0, 1, 0, 1, '2025-08-17 23:44:38', '2025-08-21 18:25:40'),
(17, 141, 'anon_64', '743fb00c1ecb576d324ee24293137d7d51b543aae4a35aa2e246263d8ba68a0c', 1, '43.130.228.73', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, '.%5C', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/.%5C/ai-core-avtomatizaciya', '/.%5C/ai-core-avtomatizaciya', NULL, 0, 1, 0, 1, '2025-08-17 23:55:06', '2025-08-21 18:25:40'),
(18, 141, 'anon_65', 'bc6201fdea1dde8eb1f802c4882df469ca911300d0773b1ab87eb9ab2f13579e', 1, '150.109.119.38', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, '.%5C', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/.%5C/ai-promotion-nedvizhimosti', '/.%5C/ai-promotion-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 00:06:25', '2025-08-21 18:25:40'),
(19, 141, 'anon_75', 'b6e449204a3e14bbb7973cad90cf0e4fde02228eda23e721f95440a035127745', 1, '5.255.253.48', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 08:13:41', '2025-08-21 18:25:40'),
(20, 141, 'anon_84', 'fb9806e80296455cc061807c23003327523bb9f9e8f2f5bb9e44e0f02c41e5a7', 1, '124.156.157.91', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 11:07:06', '2025-08-21 18:25:40'),
(21, 141, 'anon_86', '5125db7b46c0c469dcae63f4d3b8f23e5a3b0ed79768fa68e24d01d9a361a9b7', 1, '175.24.181.155', 'Mozilla/5.0 (Linux; Android 10; LIO-AN00 Build/HUAWEILIO-AN00; wv) MicroMessenger Weixin QQ AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2692 MMWEBSDK/200901 Mobile Safari/537.36', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 11:19:37', '2025-08-21 18:25:40'),
(22, 141, 'anon_90', '6ace70066a8b2b2a10712605aba69eab9f3c4f0b25b3f32471224719d4dcbf28', 1, '141.8.142.41', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 13:11:11', '2025-08-21 18:25:40'),
(23, 141, 'anon_94', '7a4c347b200c371f02b302d30a866c2a6d7d57d1bc9861ebf72665578638ffb7', 1, '74.125.208.168', 'Mozilla/5.0 (Linux; Android 11; moto g power (2022)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36 Chrome-Lighthouse', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 14:24:05', '2025-08-21 18:25:40'),
(24, 141, 'anon_96', '7b62a190171f0161a69f66d89344c40111430d16c8ea4f2f85dc1c3529f9e86e', 1, '74.125.208.168', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Chrome-Lighthouse', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 14:24:18', '2025-08-21 18:25:40'),
(25, 141, 'anon_97', 'ae4f8f84bae5b288fa03d43b39a1510cad1bc66c22767521cb85f9646bdbd002', 1, '66.102.9.106', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Chrome-Lighthouse', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 2, 0, 0, '2025-08-18 14:24:27', '2025-08-21 18:25:40'),
(26, 141, 'anon_98', '1470dd9be74b8fb72cafebfba864da8cae13c96b68f3a0e2fefddba55aa467fc', 1, '66.249.93.234', 'Mozilla/5.0 (Linux; Android 11; moto g power (2022)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36 Chrome-Lighthouse', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 2, 0, 0, '2025-08-18 14:24:27', '2025-08-21 18:25:40'),
(27, 141, 'anon_99', '6c4e91ab7a5f0d5e3d759a6612dcfec5dc8726198cf27bd426da64ca0e40de57', 1, '66.249.93.225', 'Mozilla/5.0 (Linux; Android 11; moto g power (2022)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Mobile Safari/537.36 Chrome-Lighthouse', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 14:24:49', '2025-08-21 18:25:40'),
(28, 141, 'anon_107', 'd0ed0e8e4f94033aad0e81cfaf936c27b907ed574825ca358ee68157fc3618e9', 1, '77.238.230.6', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 15:24:35', '2025-08-21 18:25:40'),
(29, 141, 'anon_109', 'facbd3febb0e94b11c59000f5f12d7c02c6d7c2a34fd6fc18c4a60a179c5e243', 1, '118.89.121.172', 'Mozilla/5.0 (Linux; Android 10; LIO-AN00 Build/HUAWEILIO-AN00; wv) MicroMessenger Weixin QQ AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2692 MMWEBSDK/200901 Mobile Safari/537.36', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://www.relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 15:26:33', '2025-08-21 18:25:40'),
(30, 141, 'anon_111', 'ee9ce49aee290efb73987a036786c923e592a935f896b3879ee675b26d6158be', 1, '138.197.32.92', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 15:30:57', '2025-08-21 18:25:40'),
(31, 141, 'anon_116', '39f787f0224e7bd2125a3f2876fc0ca7fc69ef00e8c22e1b604ddd70a9b9d05b', 1, '35.233.227.241', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/wordpress', '/wordpress', NULL, 0, 1, 0, 1, '2025-08-18 16:09:27', '2025-08-21 18:25:40'),
(32, 141, 'anon_118', '7d5bf13373b398de332b6181e846622dffd779817fab175fa8ae5d7e463a54bd', 1, '89.110.80.171', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 16:32:14', '2025-08-21 18:25:40'),
(33, 141, 'anon_119', '1d8ce721e142fccb918e6d58f8c79a7e85a41b21d709d44c1449bb55a6c2bf3d', 1, '202.158.27.154', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 16:32:20', '2025-08-21 18:25:40'),
(34, 141, 'anon_120', '39bc9f7f69d6a851aaecb7efb370ca376e18007bf41bd9ac944617c3ae81a4bb', 1, '202.158.27.154', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 16:32:25', '2025-08-21 18:25:40'),
(35, 141, 'anon_123', 'c38be96e6104a833a6d6599f3946cb28d92841eecd7635078f06c2dd6cf05d46', 1, '5.255.253.38', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 6, 8, 0, '2025-08-18 17:04:54', '2025-08-21 18:25:40'),
(36, 141, 'anon_127', 'ef75a1408d9cb132d32fad56503a49332af290b06cf4fb141aa69824238d11f1', 1, '210.1.107.132', 'Mozilla/5.0 (Windows NT 6.2; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/89.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Safari', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 17:43:22', '2025-08-21 18:25:40'),
(37, 141, 'anon_129', '16cd990a475c7001b4dc7069cc425e7e183c350d4ee923ca1ac33558f8bfaa12', 1, '101.33.81.73', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 17:59:06', '2025-08-21 18:25:40'),
(38, 141, 'anon_134', '47f44517003f9348d9b3fc8129e58de18d16bda24042917fbd7568004991e864', 1, '89.222.100.4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/feed/', '/feed/', NULL, 0, 1, 0, 1, '2025-08-18 18:19:35', '2025-08-21 18:25:40'),
(39, 141, 'anon_136', '17383029c16c5504512cf34051f7891b3783866fddc557dbef488f8a44a53905', 1, '94.181.165.225', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36 OpenWave/97.4.2043.44', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 19:48:58', '2025-08-21 18:25:40'),
(40, 141, 'anon_143', 'b73693961295b0c1cf5b0effd9a77a23e4433534cb5c8f5ce08cfe27c1c2c584', 1, '185.245.104.75', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 20:38:43', '2025-08-21 18:25:40'),
(41, 141, 'anon_144', '655b2ba0a7e29469e18ea71c2b93a842f93cc17b2c29e164b817dfaecc366ffa', 1, '180.210.160.14', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 20:38:45', '2025-08-21 18:25:40'),
(42, 141, 'anon_145', '97011eb1030ac650fedc594f101ba9925df2d879ae476ad2bb09d8c533c89a38', 1, '180.210.160.14', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 20:38:48', '2025-08-21 18:25:40'),
(43, 141, 'anon_150', '65dec30215d356f445bb5b8f4a4c2e9156df242b893767bd3d8c4073aefbbed6', 1, '94.181.165.225', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-18 23:57:26', '2025-08-21 18:25:40'),
(44, 141, 'anon_152', '3c9ff8426d223da9416f57cdaad0910ec659817fb9eb67a47a809950b05caf63', 1, '185.39.19.43', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 00:00:15', '2025-08-21 18:25:40'),
(45, 141, 'anon_160', '9c808ff07bc251def80f6db14e3f5cc9184f6aafd7ae9051c330f6be7138f392', 1, '185.39.19.43', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 02:10:56', '2025-08-21 18:25:40'),
(46, 141, 'anon_161', '106a1a846aa8b1de38136128c8b6bf2397c1664b961b957346b2f1e84cef5aa7', 1, '35.233.227.241', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/wordpress', '/wordpress', NULL, 0, 1, 0, 1, '2025-08-19 02:24:16', '2025-08-21 18:25:40'),
(47, 141, 'anon_163', '9a15cc2ef207b0d2ba386fe712154bd6d2fe80eb319cf09e0caed6de30b53562', 1, '212.34.146.152', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 02:44:07', '2025-08-21 18:25:40'),
(48, 141, 'anon_164', 'c0196f596de521e9d6e5c5cdd90214c352eae6ffef506f9d283ca84b8e08fe03', 1, '116.212.137.118', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 02:44:10', '2025-08-21 18:25:40'),
(49, 141, 'anon_165', '2d53f55c9886319f86ad0e4e1a7c6f89e4c96a1cd12c9b23a96127dab682ea0b', 1, '116.212.137.118', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 02:44:13', '2025-08-21 18:25:40'),
(50, 141, 'anon_187', '214c3a220a774bb776ed8c551c002602d3111084e900b26efaf6aae96a4cebb5', 1, '43.157.172.39', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 04:13:13', '2025-08-21 18:25:40'),
(51, 141, 'anon_189', '07be58c318e7a006ce729b147baca757ab9669b421106e7dae3c72ee411c9114', 1, '195.2.81.171', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 04:38:40', '2025-08-21 18:25:40'),
(52, 141, 'anon_190', '55e82254d2f0c7acf3fe01707ed8430896ceb197d86a9913820576d897d4fef7', 1, '186.224.108.24', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 04:38:44', '2025-08-21 18:25:40'),
(53, 141, 'anon_191', '86f0c0aa2a199bbd1554721815275a38f0e61dcfd59f7ac7fed50aec449ed650', 1, '186.224.108.24', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 04:38:50', '2025-08-21 18:25:40'),
(54, 141, 'anon_220', 'eafbf20b822cf71a600d6493e17a2d0005ffa976d5e215f87bde4c0093613712', 1, '146.70.199.147', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0', NULL, NULL, NULL, 'ru', 'desktop', 'Firefox', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 07:02:25', '2025-08-21 18:25:40'),
(55, 141, 'anon_222', 'dd8d14bf1ca353378568520743b0c321eae8dd92c11c4b12f47101be68af03b2', 1, '35.226.114.14', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/media/system/js/core.js', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 07:28:36', '2025-08-21 18:25:40'),
(56, 141, 'anon_226', 'b184d5f4fef8dc2eda9c33f79cae70e9fbc926ff215e1b0f6afcc0ec29e8c9ba', 1, '128.90.141.9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/115.0.0.0', NULL, NULL, NULL, 'ru', 'desktop', 'Edge', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 08:38:13', '2025-08-21 18:25:40'),
(57, 141, 'anon_228', 'efd5e0e12eeb5180d2a6931279b98ff02b3f938ea4f0e50842fdcda86d47bd81', 1, '128.90.141.9', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wp-admin/install.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 08:38:15', '2025-08-21 18:25:40'),
(58, 141, 'anon_230', '6b2bda519b4f72951ac2492fb723c92c0120ef2579e6c68c184d527a0fbcb8a4', 1, '128.90.141.9', 'Mozilla/5.0 (iPad; CPU OS 16_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'tablet', 'Safari', 'Unknown', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wordpress/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 08:38:17', '2025-08-21 18:25:40'),
(59, 141, 'anon_232', '49a5ad62eebfd2bf857060add5736bb602f603e980e0176fe588da6a24717aa3', 1, '128.90.141.9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0', NULL, NULL, NULL, 'ru', 'desktop', 'Firefox', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wp/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 08:38:22', '2025-08-21 18:25:40'),
(60, 141, 'anon_234', '28bf303906870de7b1c71a89a7c738a31b3b83fd2de8cd2bf2712ced054f4474', 1, '128.90.141.9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/new/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 08:38:26', '2025-08-21 18:25:40'),
(61, 141, 'anon_238', '530506e6f37d8e9691d0d9bb5e12310c4579af0a51ce66fd2c63088343c19dff', 1, '128.90.141.9', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/old/wp-admin/install.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 08:38:33', '2025-08-21 18:25:40'),
(62, 141, 'anon_244', '668de374f5cca49a4f29c48d5c0766171c7dfd15aac5854a2b08d5fdf69357f9', 1, '128.90.141.9', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15', NULL, NULL, NULL, 'ru', 'desktop', 'Safari', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/test/wp-admin/install.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 08:38:43', '2025-08-21 18:25:40'),
(63, 141, 'anon_248', '057d03eac29656d0b2176427130f167e7da610b44bddee8e88145f712b14a117', 1, '43.157.148.38', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 10:55:31', '2025-08-21 18:25:40'),
(64, 141, 'anon_250', '4a5eb025bec6f54b37a10e67b6d9e1abaed049e5243f4b9a8d7de8b4cb24f3ad', 1, '94.154.35.236', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 11:13:07', '2025-08-21 18:25:40'),
(65, 141, 'anon_252', 'a032818f2be6133b19261f5e80886b006e46ed94adf0bde02fd3453f747ec75b', 1, '5.255.253.39', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 9, 7, 0, '2025-08-19 11:55:38', '2025-08-21 18:25:40'),
(66, 141, 'anon_263', 'a6f54248c2d6c437b2ce1e2e30e0ea4f96fd63e2db2fcd9b2b7135f783382538', 1, '141.8.142.37', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 8, 12, 0, '2025-08-19 13:03:15', '2025-08-21 18:25:40'),
(67, 141, 'anon_265', 'ac3bd8070a4702a6c9f664881ba6a09d2f8507545dc0a2c20718a8cf4669e21a', 1, '167.71.211.183', 'Mozilla/5.0 (X11; Linux x86_64; rv:83.0) Gecko/20100101 Firefox/83.0', NULL, NULL, NULL, 'ru', 'desktop', 'Firefox', 'Linux', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 13:56:15', '2025-08-21 18:25:40'),
(68, 141, 'anon_269', '821840b4e814c42cd0ecaa26df9575f30d2917c68018609339b0a992a7faa3f0', 1, '5.255.253.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 7, 20, 0, '2025-08-19 17:04:44', '2025-08-21 18:25:40'),
(69, 141, 'anon_271', 'c96c3129f4c8c5308ee5cee5a260a22b9076f52c367a52b8833eccb31f216c57', 1, '77.35.218.106', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 17:31:15', '2025-08-21 18:25:40'),
(70, 141, 'anon_273', '3f88554f24e7bd8117e317d13d0ea0bf5e25f22dbeeba1b21db8b6cd1eb4da22', 1, '194.164.107.5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 17:35:28', '2025-08-21 18:25:40'),
(71, 141, 'anon_275', '01b06028c55a630b3bcf57c4cd5cc227511136c6eaa39207b7969499647b1031', 1, '43.159.141.150', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 17:53:33', '2025-08-21 18:25:40'),
(72, 141, 'anon_299', '8ad578ebdb482dbd43bc242140f58ce9ac9fa93c362aa7f4d1bc5f041fdbae78', 1, '141.8.142.40', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 9, 11, 0, '2025-08-19 21:06:28', '2025-08-21 18:25:40'),
(73, 141, 'anon_301', '5848b460decdd7674892ad1414cafef9e51b7711da3e434044eaa59e17048f14', 1, '94.154.35.236', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-19 22:08:58', '2025-08-21 18:25:40'),
(74, 141, 'anon_306', 'f1197aa6928ec48171601d4666d62fae6aad2ecc6e1a345ba7448c1924f57469', 1, '71.6.134.233', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://www.relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 01:38:23', '2025-08-21 18:25:40'),
(75, 141, 'anon_309', '9623d37cb288c386608d7b784992bff28ecc28a00cd51da54eb50b44cff3efad', 1, '170.106.72.93', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 03:31:04', '2025-08-21 18:25:40'),
(76, 141, 'anon_318', '28d13b27601f5a6001c7fb1943fe9d4e00f6627b0578d31a673d8530e6e6485d', 1, '34.83.40.15', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/media/system/js/core.js', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 06:46:40', '2025-08-21 18:25:40'),
(77, 141, '1180b18b6a3da1c5915819a559727b1f653dd73a8e93a8fd220b91c751885712', '007b5677919a07e130c6b85cda2effae801e9029ac24753ef89865f05d9729cd', 0, '185.15.63.121', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/381.1.792835455 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 07:31:43', '2025-08-21 18:25:40'),
(78, 141, 'anon_321', '5a1d8d73d82641ddf9f4c4b409ba4e3baba9dfd847065a34bda906b4f04c0e39', 1, '185.15.63.121', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/22G86 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 2, 5, 0, '2025-08-20 07:35:21', '2025-08-21 18:25:40'),
(79, 141, 'anon_325', 'f53a277d0899ae14e0b2ad2488ae3597e6fe8daf9640c54d5e1a5084da218d8b', 1, '82.148.16.158', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 07:47:34', '2025-08-21 18:25:40'),
(80, 141, 'anon_327', '7be57431ebf43a25ab39020e05728f2677b2ecbfcb0b416dd88bb96dc337c9b1', 1, '91.201.115.174', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 08:42:27', '2025-08-21 18:25:40'),
(81, 141, 'anon_328', '6e9747e488ac8c8835092a142d6395193f8e38ac10f63b7c95988b19f0eba714', 1, '41.211.122.100', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 08:42:30', '2025-08-21 18:25:40'),
(82, 141, 'anon_329', '4f833c13c43edef01caacccac22b0864c25abe171edbb559a5e372b0fdf6f142', 1, '41.211.122.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 08:42:33', '2025-08-21 18:25:40'),
(83, 141, 'anon_331', '79c62ae2e747f949b8700a330d89ed76fb2f8ff1f7ed4361966d3fcaaf271f38', 1, '45.89.70.31', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 CCleaner/130.0.0.0', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 09:03:35', '2025-08-21 18:25:40'),
(84, 141, 'anon_333', '9302668d4c0e1d8795f260ce41d42d176bd2fd39cdf4cc110f7f4e49da0ae0ae', 1, '217.142.191.67', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/media/system/js/core.js', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 09:24:02', '2025-08-21 18:25:40'),
(85, 141, 'anon_335', 'c123313bf539bd07276be1626eaedab122cac702895721321fe992edc63f3a2b', 1, '43.157.153.236', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 10:03:52', '2025-08-21 18:25:40'),
(86, 141, 'anon_338', '40c99d947d48904aae0ed03dfcfcfb2dd4a166a0bc18eb1c529c9db794c379f6', 1, '141.8.142.44', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 11:10:22', '2025-08-21 18:25:40'),
(87, 141, 'anon_340', '081b02fcd805f08187be25d511844a9ef8547f7785676667397d9d4892060da3', 1, '34.53.13.211', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/wordpress', '/wordpress', NULL, 0, 1, 0, 1, '2025-08-20 15:51:21', '2025-08-21 18:25:40'),
(88, 141, 'anon_342', 'e3a29929712b2056d4265de73ad8a4ebf6887310878c59f08800796cf21688a0', 1, '43.157.150.69', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 16:12:28', '2025-08-21 18:25:40'),
(89, 141, 'anon_346', '09958ac1c710f0fea3d24b64ede63d28fae225b5f906202addbdd287f8d2c4cf', 1, '89.110.103.94', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 17:40:12', '2025-08-21 18:25:40'),
(90, 141, 'anon_347', 'feac002fc65c1067b5e0c1c2a4ab3450ff4cbb14a45356f1d60c41c064d968ff', 1, '27.131.14.77', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 17:40:16', '2025-08-21 18:25:40'),
(91, 141, 'anon_348', 'e1571570d388d17b7342a01a1e501ed035693f2dc06596da00802740c4ffe2e3', 1, '27.131.14.77', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 17:40:19', '2025-08-21 18:25:40'),
(92, 141, 'anon_354', '9bc14d2b679df2ce8192994f1cf284b658d2f1126f005634e893458070c19958', 1, '185.209.198.122', 'Mozilla/5.0', NULL, NULL, NULL, 'ru', 'desktop', 'Unknown', 'Unknown', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 18:02:39', '2025-08-21 18:25:40'),
(93, 141, 'anon_356', '0fa99a7bcbcc4e7b54ced08324511d1bca2c0a99f73e39a1c9acf3b6d4fff628', 1, '198.98.50.82', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 18:11:57', '2025-08-21 18:25:40'),
(94, 141, 'anon_358', '2c03bac60bebb4183d6181e94870cdf1b7534ea5664aec5b95b1946290effcde', 1, '198.98.50.82', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'google', NULL, NULL, NULL, NULL, NULL, 'http://www.google.com.hk', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 18:13:30', '2025-08-21 18:25:40'),
(95, 141, 'anon_362', '369e06771c4f1651c81075c0b7220129b8506de2dd01bfb2097e36571a2e7474', 1, '5.255.253.35', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 21:10:57', '2025-08-21 18:25:40'),
(96, 141, 'anon_364', '50e9ae42049c741327206ae2285a53a7688bf983b32aa8bf3126fffedb620a99', 1, '147.45.186.110', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 23:36:53', '2025-08-21 18:25:40'),
(97, 141, 'anon_366', '7d07f1ceaab926e64e8aa8893a6b58cba2599496d6a69ebe567c092b407f652f', 1, '80.85.245.37', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 23:43:32', '2025-08-21 18:25:40'),
(98, 141, 'anon_367', 'fc5e831fa3c748fb5fd36366e85fb643e50a62adc3a32f1d5e4969a4cd7aaf6a', 1, '202.79.43.13', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 23:43:34', '2025-08-21 18:25:40'),
(99, 141, 'anon_368', '7e37a1a929799c78a5ed0eace09cba77f0773d8d904f8b1e2bfa8a28a5ff4b9f', 1, '202.79.43.13', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 23:43:36', '2025-08-21 18:25:40'),
(100, 141, 'anon_370', '6caa5429787fffdb649f64d50e751cf96ca617f49f143a5874793f7246108d01', 1, '94.154.35.236', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-20 23:50:41', '2025-08-21 18:25:40'),
(101, 141, 'anon_372', 'b3371203fc279001549066d34efb6973c57f89125ce9d7680dd87264791e8d72', 1, '18.191.184.231', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 00:00:21', '2025-08-21 18:25:40'),
(102, 141, 'anon_378', '5f2394678bf5e317c7779d24d777283315931ef40843f1135fab7bb1fcafeda6', 1, '51.158.242.119', 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 02:26:46', '2025-08-21 18:25:40');
INSERT INTO `user_sessions` (`id`, `organization_id`, `session_id`, `visitor_id`, `is_anonymous`, `ip_address`, `user_agent`, `country`, `region`, `city`, `language`, `device_type`, `browser`, `os`, `screen_resolution`, `source`, `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, `utm_term`, `referrer`, `landing_page`, `exit_page`, `segment_id`, `is_returning`, `page_views`, `session_duration`, `bounce`, `created_at`, `last_activity`) VALUES
(103, 141, 'anon_380', 'f54bbb33c9db0f9609da6a0f51507bd88cd31550765a7b4c5b72ae8c6537794b', 1, '35.193.134.173', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/media/system/js/core.js', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 02:46:28', '2025-08-21 18:25:40'),
(104, 141, 'anon_382', '62b17c68b4d756c22dfad14d3b52c7bec47e90263a4463bed5a35ad6bbf77400', 1, '194.127.167.124', 'Mozilla/5.0', NULL, NULL, NULL, 'ru', 'desktop', 'Unknown', 'Unknown', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 04:08:48', '2025-08-21 18:25:40'),
(105, 141, 'anon_384', 'cda5794557729db7be0c63ad902368ff397379e1ca4cbd1cbc3654b9545802c0', 1, '94.103.87.196', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 04:27:15', '2025-08-21 18:25:40'),
(106, 141, 'anon_385', '3fcbeb1b8c3704424903e847dc67a9a68956e6007f602b477fd2dcad38b4a388', 1, '37.205.119.48', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 04:27:23', '2025-08-21 18:25:40'),
(107, 141, 'anon_386', '4ffb2c2a22a258959a758045c78a828d43b7f691427612cb3b1a5d2d67d1a4c3', 1, '37.205.119.48', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 04:27:26', '2025-08-21 18:25:40'),
(108, 141, 'anon_390', '66f6ef1e1ee18b6320b53cfb5a89a7370abbfd267c542ac221d1893da47a3942', 1, '212.34.135.52', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:11:34', '2025-08-21 18:25:40'),
(109, 141, 'anon_391', '6d631e22cf47bd5435817010fade6c67f91591631d385b983b8a67db6634fc7b', 1, '117.4.89.222', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:11:36', '2025-08-21 18:25:40'),
(110, 141, 'anon_392', 'f69284c745e6ac0547583c8ee530ff9beea524a8000426cd61b786895957d6a2', 1, '117.4.89.222', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:11:39', '2025-08-21 18:25:40'),
(111, 141, 'anon_394', '17803a5328b80c1dc3d2f2b870abb627b2adae8dbc41bec727494f48f4e045f4', 1, '94.102.51.15', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, 'relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:26:47', '2025-08-21 18:25:40'),
(112, 141, 'anon_396', '1b06cfb32e5d1a6cf8aa6a60a424075bb563a96cd11f555c8220a4ee49b8f1bc', 1, '185.220.101.129', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru?name=%F0%9F%93%80+%E2%9A%A0%EF%B8%8F+Important+-+2.2+BTC+sent+to+your+address.+Confirm+funds+%E2%86%92+https%3A%2F%2Fgraph.org%2FSECURE-YOUR-BITCOIN-07-23%3Fhs%3Df7ad712dd30606816f569d165fe8ed0a%26+%F0%9F%93%80&email=roofa2000%40automisly.org&phone=825445336785&telegram=825445336785', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:26:59', '2025-08-21 18:25:40'),
(113, 141, 'anon_398', 'ed71f88f0a9cf99b51a2d9d4ed5a3a40952c54f737b5ebb828e273d7f755ddb7', 1, '49.51.183.220', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:27:09', '2025-08-21 18:25:40'),
(114, 141, 'anon_399', 'ab738bfe768c993391faa32ec5072bdb1004d99981175fc2ece2cc7c3be1dbc8', 1, '45.84.107.222', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, '.\\', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/.\\/ai-website-nedvizhimosti', '/.\\/ai-website-nedvizhimosti', '/.\\/ai-website-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:27:54', '2025-08-21 18:25:40'),
(115, 141, 'anon_400', 'a179fea61a2649746dabcdafa4890a71660058b1d75fa6bce4fc4c590d547f3e', 1, '45.84.107.174', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, '.\\', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/.\\/kak-rabotaet-vnedrenie-ai-systemy', '/.\\/kak-rabotaet-vnedrenie-ai-systemy', '/.\\/kak-rabotaet-vnedrenie-ai-systemy', NULL, 0, 1, 0, 1, '2025-08-21 05:28:06', '2025-08-21 18:25:40'),
(116, 141, 'anon_401', 'c192adfe06ae26441349af5cecff97c722550b3947a6a78880cd41d50fefb05a', 1, '45.84.107.55', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:28:46', '2025-08-21 18:25:40'),
(117, 141, 'anon_402', '367ec8d1f8dfb5d394978b970dd6f3da8598485ba0714b6987506d563334e37b', 1, '185.220.101.136', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-lending-nedvizhimosti', '/ai-lending-nedvizhimosti', '/ai-lending-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:29:17', '2025-08-21 18:25:40'),
(118, 141, 'anon_403', 'a204c8bccd56f72302ceda535193b57859060c16a5dde97416cad8caf55f7b3b', 1, '185.220.101.48', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/it-problemy-agentstva-nedvizhimosti', '/it-problemy-agentstva-nedvizhimosti', '/it-problemy-agentstva-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:30:40', '2025-08-21 18:25:40'),
(119, 141, 'anon_405', 'c137e763d3220062411c44dc95b33d077a7d9c2bfe843c104adc99773373c457', 1, '124.198.131.253', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru?name=%F0%9F%93%90+%E2%9A%A0%EF%B8%8F+Important%3A+2.2+BTC+sent+to+your+wallet.+Confirm+funds+%3E%3E+https%3A%2F%2Fgraph.org%2FSECURE-YOUR-BITCOIN-07-23%3Fhs%3D20c6e4074d38ea680e5fadfd946ac2af%26+%F0%9F%93%90&email=roofa2000%40automisly.org&phone=026295945117&telegram=026295945117', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:31:02', '2025-08-21 18:25:40'),
(120, 141, 'anon_407', '0a6a58baa57cd78f6b3215e707c94b5aab6fb607f0ba57667da1cc6266933e1b', 1, '195.47.238.87', 'Mozilla/5.0 (Linux; Android 9; HRY-LX1 Build/HONORHRY-L21) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36 YaApp_Android/10.20 YaSearchBrowser/10.20', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru?name=%E2%9A%96+%E2%9A%A0%EF%B8%8F+Important%3A+2.2+BTC+sent+to+your+address.+Confirm+payment+%3E%3E+https%3A%2F%2Fgraph.org%2FSECURE-YOUR-BITCOIN-07-23%3Fhs%3Dd5c2769009428c6c34492f113a3f4160%26+%E2%9A%96&email=roofa2000%40automisly.org&phone=485442822782&telegram=485442822782', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 05:31:43', '2025-08-21 18:25:40'),
(121, 141, 'anon_409', '91adfe345ea5afd07b750d45fa96902902b962c38c9c1564d32503a300423216', 1, '149.56.150.22', 'Mozilla/5.0 (compatible; Dataprovider.com)', NULL, NULL, NULL, 'ru', 'desktop', 'Unknown', 'Unknown', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 06:09:35', '2025-08-21 18:25:40'),
(122, 141, 'anon_410', '3352c8b51f32d770facb8c796a07bdffcb55bc7278a606021a6a73946ca80091', 1, '149.56.150.22', 'Mozilla/5.0 (Linux; Android 10; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36', NULL, NULL, NULL, 'ru', 'mobile', 'Chrome', 'Linux', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 06:10:04', '2025-08-21 18:25:40'),
(123, 141, 'anon_416', 'eee2feac537ced4392b170c7a6b550c507b685245459143de3df6f289a573ec2', 1, '149.56.150.81', 'Mozilla/5.0 (compatible; Dataprovider.com)', NULL, NULL, NULL, 'ru', 'desktop', 'Unknown', 'Unknown', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 07:37:34', '2025-08-21 18:25:40'),
(124, 141, 'anon_419', '6def4a1d09cb4dfff5bb20a8f5756bd7d1378538027237d5c513be6cc9f8443c', 1, '94.181.165.225', 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 08:00:40', '2025-08-21 18:25:40'),
(125, 141, 'anon_422', '06a29b2f66193bc002ba3db298d080649855b1c7f71575d1543d1e958e8fb09d', 1, '195.26.225.123', 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.66 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 09:47:52', '2025-08-21 18:25:40'),
(126, 141, 'anon_424', '63475e1c742f4807ed244c259139805476943bd76e37879526b7c7e524b62e1a', 1, '87.71.139.87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 10:34:05', '2025-08-21 18:25:40'),
(127, 141, 'anon_432', '37b3bcdfd2581afc84c56a1463521ac9a903495629cafe8d57f11ee8c69b17ae', 1, '141.8.142.33', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 12:08:49', '2025-08-21 18:25:40'),
(128, 141, 'anon_434', '97cc17da6f19822a44a747422ecc02fbbf7564806682aa065b21a4294664705d', 1, '43.159.141.150', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', NULL, NULL, NULL, 'ru', 'mobile', 'Safari', 'iOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 12:25:34', '2025-08-21 18:25:40'),
(129, 141, 'anon_436', '8d93b3646e31973f10fc1e3f314d46be040ac7ed2eee1dd00e30810e2be5994b', 1, '141.8.142.37', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 12:31:12', '2025-08-21 18:25:40'),
(130, 141, 'anon_444', '9b2940a6295a524508d4573071f0f64772e0205165ab42dc664c4f0ccd69507f', 1, '212.34.140.200', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 13:31:38', '2025-08-21 18:25:40'),
(131, 141, 'anon_445', 'f3af64dfad75762ec559a80d713be00c8f4aa9c3b9466f29508fce8feb36e1c4', 1, '182.53.207.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 13:31:41', '2025-08-21 18:25:40'),
(132, 141, 'anon_446', '7c1d6993e0808001a5f4cb804a5c79156ed8a5eec256e52d8dd03ba1486c0edd', 1, '182.53.207.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/komanda-briemchain-ai-pravo-tehnologii', '/komanda-briemchain-ai-pravo-tehnologii', NULL, 0, 1, 0, 1, '2025-08-21 13:32:01', '2025-08-21 18:25:40'),
(133, 141, 'anon_448', 'ca7869f6a50e9cc21b0bf34426bd40a3a0de23cab5302db615f7d423f2d59c5d', 1, '45.138.16.42', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, 'relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 14:13:49', '2025-08-21 18:25:40'),
(134, 141, 'anon_452', '181e16d1393cecc5ccf335a34c2733231a5553cd536b6382ad45d5c502cc1470', 1, '94.181.165.225', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 0, 1, '2025-08-21 14:33:54', '2025-08-21 18:25:40'),
(135, 141, '394607b3fb9d885cfdca5147846fbe097100f613dcaf4fd491008d49d5116698', 'b0feef8cbeb2ddeacb437738c1e75c4dbdcbab1de69e15315030460390ca7c65', 0, '34.168.204.118', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/wordpress', '/wordpress', NULL, 1, 1, 0, 1, '2025-08-21 15:16:44', '2025-08-21 18:25:40'),
(136, 141, 'a03780beff4c45699e30dc93d972b2df40b0da79502396b43a3e594a28be50c2', '6e3d5eb62a337e103b3e79cc339e747d667e2714de28418fc8bb4c88f32d1b7f', 0, '185.54.49.166', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Linux', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 1, 1, 0, 1, '2025-08-21 15:28:15', '2025-08-21 18:25:40'),
(137, 141, '72e3e27e22ce13954b23bcb12543a6341fe41c9a308c86915b63e5ddb4a3dfea', '191c057b35b279d274f86b634050ea1bf9283f846f9afdbc81773f54d432ca96', 0, '91.84.111.136', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'referral', NULL, NULL, NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 1, 1, 0, 1, '2025-08-21 15:43:42', '2025-08-21 18:25:40'),
(138, 141, 'b622d7c0c919b80a681ffc428138fb619b7f834c1127a2dd62b93e0850cb0811', '0a6aacfcd1697acbe4fce07ba575242bf97023163ce975bed49359ed9e1b4058', 0, '113.181.1.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'macOS', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 1, 1, 0, 1, '2025-08-21 15:43:44', '2025-08-21 18:25:40'),
(139, 141, '7a8d3be977e7f3546dd9f9c86eb0d21cadd092a11bc473fdad0bb3abab2cc15b', '0574b021e6a9eb207b85ada4ba51ae39a959e42ceea04d87d490e42ae070ae00', 0, '113.181.1.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 1, 1, 0, 1, '2025-08-21 15:43:46', '2025-08-21 18:25:40'),
(140, 141, 'bdbab9bfef91be57ae6e26b24398a0ce19184f461bb37266766cf51c09243997', '3b796a687cd1bf6200a8880769792ac952015a76c0cd7c56ef795b759606fc79', 0, '94.154.35.236', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36', NULL, NULL, NULL, 'ru', 'desktop', 'Chrome', 'Windows', NULL, 'direct', NULL, NULL, NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', NULL, 1, 1, 0, 1, '2025-08-21 18:09:48', '2025-08-21 18:25:40');

-- --------------------------------------------------------

--
-- Структура таблицы `website_analytics`
--

CREATE TABLE IF NOT EXISTS `website_analytics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `domain` varchar(255) NOT NULL,
  `session_id` varchar(64) NOT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `is_new_visitor` tinyint(1) DEFAULT '0',
  `is_returning` tinyint(1) DEFAULT '0',
  `device_type` varchar(20) DEFAULT NULL,
  `browser` varchar(50) DEFAULT NULL,
  `os` varchar(50) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `utm_source` varchar(100) DEFAULT NULL,
  `utm_medium` varchar(100) DEFAULT NULL,
  `utm_campaign` varchar(100) DEFAULT NULL,
  `referrer` text,
  `landing_page` varchar(500) DEFAULT NULL,
  `exit_page` varchar(500) DEFAULT NULL,
  `session_duration` int DEFAULT '0',
  `page_views` int DEFAULT '1',
  `bounce` tinyint(1) DEFAULT '1',
  `has_conversion` tinyint(1) DEFAULT '0',
  `conversion_entity_type` enum('lead','ticket','task') DEFAULT NULL,
  `conversion_entity_id` int DEFAULT NULL,
  `form_type` varchar(50) DEFAULT NULL,
  `session_date` date NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `last_processed_time` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_processed_id` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_org_domain` (`organization_id`,`domain`),
  KEY `idx_session_date` (`session_date`),
  KEY `idx_session_id` (`session_id`),
  KEY `visitor_id` (`visitor_id`),
  KEY `conversion_tracking` (`has_conversion`,`conversion_entity_type`),
  KEY `source_analysis` (`source`,`utm_source`),
  KEY `bounce_analysis` (`bounce`,`device_type`)
) ENGINE=InnoDB AUTO_INCREMENT=322 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `website_analytics`
--

INSERT INTO `website_analytics` (`id`, `organization_id`, `domain`, `session_id`, `visitor_id`, `is_new_visitor`, `is_returning`, `device_type`, `browser`, `os`, `language`, `source`, `utm_source`, `utm_medium`, `utm_campaign`, `referrer`, `landing_page`, `exit_page`, `session_duration`, `page_views`, `bounce`, `has_conversion`, `conversion_entity_type`, `conversion_entity_id`, `form_type`, `session_date`, `ip_address`, `last_processed_time`, `created_at`, `last_processed_id`) VALUES
(1, 141, 'relanding.ru', 'anon_1755119615', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 246509, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755119615),
(2, 141, 'relanding.ru', 'anon_1755122057', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 244067, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755122057),
(3, 141, 'relanding.ru', 'anon_1755122291', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 243833, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755122291),
(4, 141, 'relanding.ru', 'anon_1755124551', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 241573, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755124551),
(5, 141, 'relanding.ru', 'anon_1755124553', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 241571, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755124553),
(6, 141, 'relanding.ru', 'anon_1755130383', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 235741, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755130383),
(7, 141, 'relanding.ru', 'anon_1755130386', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 235738, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755130386),
(8, 141, 'relanding.ru', 'anon_1755130392', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 235732, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755130392),
(9, 141, 'relanding.ru', 'anon_1755133438', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 232686, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755133438),
(10, 141, 'relanding.ru', 'anon_1755144417', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 221707, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755144417),
(11, 141, 'relanding.ru', 'anon_1755150953', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 215171, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755150953),
(12, 141, 'relanding.ru', 'anon_1755155796', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 210328, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755155796),
(13, 141, 'relanding.ru', 'anon_1755169852', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 196272, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755169852),
(14, 141, 'relanding.ru', 'anon_1755181440', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 184684, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755181440),
(15, 141, 'relanding.ru', 'anon_1755184561', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 181563, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755184561),
(16, 141, 'relanding.ru', 'anon_1755187399', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 178725, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755187399),
(17, 141, 'relanding.ru', 'anon_1755187402', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 178722, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755187402),
(18, 141, 'relanding.ru', 'anon_1755188037', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 178087, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755188037),
(19, 141, 'relanding.ru', 'anon_1755188560', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 177564, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755188560),
(20, 141, 'relanding.ru', 'anon_1755192987', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 173137, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755192987),
(21, 141, 'relanding.ru', 'anon_1755194019', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 172105, 1, 1, 0, NULL, NULL, NULL, '2025-08-14', NULL, NULL, '2025-08-16 19:36:02', 1755194019),
(22, 141, 'relanding.ru', 'anon_1755218758', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 147366, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755218758),
(23, 141, 'relanding.ru', 'anon_1755221993', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 144131, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755221993),
(24, 141, 'relanding.ru', 'anon_1755221996', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 144128, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755221996),
(25, 141, 'relanding.ru', 'anon_1755223963', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 142161, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755223963),
(26, 141, 'relanding.ru', 'anon_1755226150', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 139974, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755226150),
(27, 141, 'relanding.ru', 'anon_1755227673', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 138451, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755227673),
(28, 141, 'relanding.ru', 'anon_1755234774', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 131350, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755234774),
(29, 141, 'relanding.ru', 'anon_1755245201', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 120923, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755245201),
(30, 141, 'relanding.ru', 'anon_1755245857', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 120267, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755245857),
(31, 141, 'relanding.ru', 'anon_1755245907', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 120217, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755245907),
(32, 141, 'relanding.ru', 'anon_1755248825', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 117299, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755248825),
(33, 141, 'relanding.ru', 'anon_1755249204', '', 0, 1, 'desktop', NULL, NULL, '_ignition', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 116920, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755249204),
(34, 141, 'relanding.ru', 'anon_1755249581', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 116543, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755249581),
(35, 141, 'relanding.ru', 'anon_1755252414', '', 0, 1, 'desktop', NULL, NULL, '_ignition', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 113710, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755252414),
(36, 141, 'relanding.ru', 'anon_1755257174', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 108950, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755257174),
(37, 141, 'relanding.ru', 'anon_1755259355', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 106769, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755259355),
(38, 141, 'relanding.ru', 'anon_1755268050', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 98074, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755268050),
(39, 141, 'relanding.ru', 'anon_1755268219', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 97905, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755268219),
(40, 141, 'relanding.ru', 'anon_1755271069', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 95055, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755271069),
(41, 141, 'relanding.ru', 'anon_1755271426', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 94698, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755271426),
(42, 141, 'relanding.ru', 'anon_1755272142', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 93982, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755272142),
(43, 141, 'relanding.ru', 'anon_1755272398', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 93726, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755272398),
(44, 141, 'relanding.ru', 'anon_1755272627', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 93497, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755272627),
(45, 141, 'relanding.ru', 'anon_1755275982', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 90142, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755275982),
(46, 141, 'relanding.ru', 'anon_1755275984', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 90140, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755275984),
(47, 141, 'relanding.ru', 'anon_1755280249', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 85875, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755280249),
(48, 141, 'relanding.ru', 'anon_1755281924', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 84200, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755281924),
(49, 141, 'relanding.ru', 'anon_1755282625', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 83499, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755282625),
(50, 141, 'relanding.ru', 'anon_1755283883', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 82241, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755283883),
(51, 141, 'relanding.ru', 'anon_1755284631', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 81493, 1, 1, 0, NULL, NULL, NULL, '2025-08-15', NULL, NULL, '2025-08-16 19:36:02', 1755284631),
(52, 141, 'relanding.ru', 'anon_1755292606', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 73518, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755292606),
(53, 141, 'relanding.ru', 'anon_1755295057', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 71067, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755295057),
(54, 141, 'relanding.ru', 'anon_1755297493', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 68631, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755297493),
(55, 141, 'relanding.ru', 'anon_1755297495', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 68629, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755297495),
(56, 141, 'relanding.ru', 'anon_1755299959', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 66165, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755299959),
(57, 141, 'relanding.ru', 'anon_1755302209', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 63915, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755302209),
(58, 141, 'relanding.ru', 'anon_1755302580', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 63544, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755302580),
(59, 141, 'relanding.ru', 'anon_1755304222', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 61902, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755304222),
(60, 141, 'relanding.ru', 'anon_1755329393', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 36731, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755329393),
(61, 141, 'relanding.ru', 'anon_1755334229', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 31895, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755334229),
(62, 141, 'relanding.ru', 'anon_1755335217', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 30907, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755335217),
(63, 141, 'relanding.ru', 'anon_1755340667', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25457, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340667),
(64, 141, 'relanding.ru', 'anon_1755340668', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25456, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340668),
(65, 141, 'relanding.ru', 'anon_1755340670', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25454, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340670),
(66, 141, 'relanding.ru', 'anon_1755340671', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25453, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340671),
(67, 141, 'relanding.ru', 'anon_1755340683', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25441, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340683),
(68, 141, 'relanding.ru', 'anon_1755340684', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25440, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340684),
(69, 141, 'relanding.ru', 'anon_1755340687', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25437, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340687),
(70, 141, 'relanding.ru', 'anon_1755340688', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 25436, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755340688),
(71, 141, 'relanding.ru', 'anon_1755349874', '', 0, 1, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 16250, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755349874),
(72, 141, 'relanding.ru', '6f39adfbaac3afad738b9620286163521757a625c4741f6cc5c16bdc8373a702', '', 0, 1, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 9938, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755356186),
(73, 141, 'relanding.ru', 'anon_1755362801', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 3323, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755362801),
(74, 141, 'relanding.ru', 'anon_1755364360', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 1764, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755364360),
(75, 141, 'relanding.ru', 'anon_1755364996', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 1128, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755364996),
(76, 141, 'relanding.ru', 'anon_1755368308', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 1755368308),
(77, 141, 'relanding.ru', 'offset_marker', '', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-16 19:36:02', 76),
(78, 141, 'relanding.ru', 'anon_1755403256', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 37, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 05:22:03', 1755403256),
(79, 141, 'relanding.ru', 'anon_1755403260', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 33, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 05:22:03', 1755403260),
(80, 141, 'relanding.ru', 'anon_1755404433', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 05:22:03', 1755404433),
(81, 141, 'relanding.ru', 'offset_marker', '', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 05:22:03', 80),
(82, 141, 'relanding.ru', 'anon_1755376332', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-16', NULL, NULL, '2025-08-17 16:18:05', 1755376332),
(83, 141, 'relanding.ru', 'anon_1755382570', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:05', 1755382570),
(84, 141, 'relanding.ru', 'anon_1755383588', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:05', 1755383588),
(85, 141, 'relanding.ru', 'anon_1755384271', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:05', 1755384271),
(86, 141, 'relanding.ru', 'anon_1755386059', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:05', 1755386059),
(87, 141, 'relanding.ru', 'anon_1755387462', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:05', 1755387462),
(88, 141, 'relanding.ru', 'anon_1755387940', '', 1, 0, 'mobile', NULL, NULL, '.%5C', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755387940),
(89, 141, 'relanding.ru', 'anon_1755392826', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755392826),
(90, 141, 'relanding.ru', 'anon_1755393528', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755393528),
(91, 141, 'relanding.ru', 'anon_1755393530', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755393530),
(92, 141, 'relanding.ru', 'anon_1755393533', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755393533),
(93, 141, 'relanding.ru', 'anon_1755397701', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755397701),
(94, 141, 'relanding.ru', 'anon_1755397972', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755397972),
(95, 141, 'relanding.ru', 'anon_1755398064', '', 1, 0, 'mobile', NULL, NULL, '.\\', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398064),
(96, 141, 'relanding.ru', 'anon_1755398096', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398096),
(97, 141, 'relanding.ru', 'anon_1755398111', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398111),
(98, 141, 'relanding.ru', 'anon_1755398126', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398126),
(99, 141, 'relanding.ru', 'anon_1755398176', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398176),
(100, 141, 'relanding.ru', 'anon_1755398239', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398239),
(101, 141, 'relanding.ru', 'anon_1755398278', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398278),
(102, 141, 'relanding.ru', 'anon_1755398303', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398303),
(103, 141, 'relanding.ru', 'anon_1755398314', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755398314),
(104, 141, 'relanding.ru', 'anon_1755409051', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755409051),
(105, 141, 'relanding.ru', 'anon_1755409101', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755409101),
(106, 141, 'relanding.ru', 'anon_1755411573', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755411573),
(107, 141, 'relanding.ru', 'anon_1755412797', '', 1, 0, 'mobile', NULL, NULL, '.%5C', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755412797),
(108, 141, 'relanding.ru', 'anon_1755413079', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755413079),
(109, 141, 'relanding.ru', 'anon_1755414689', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755414689),
(110, 141, 'relanding.ru', 'anon_1755415203', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755415203),
(111, 141, 'relanding.ru', 'anon_1755415648', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755415648),
(112, 141, 'relanding.ru', 'anon_1755416436', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755416436),
(113, 141, 'relanding.ru', 'anon_1755417170', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755417170),
(114, 141, 'relanding.ru', 'anon_1755417192', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755417192),
(115, 141, 'relanding.ru', 'anon_1755421312', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755421312),
(116, 141, 'relanding.ru', 'anon_1755425725', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755425725),
(117, 141, 'relanding.ru', 'anon_1755425734', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755425734),
(118, 141, 'relanding.ru', 'anon_1755431247', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755431247),
(119, 141, 'relanding.ru', 'anon_1755431310', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755431310),
(120, 141, 'relanding.ru', 'anon_1755431396', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755431396),
(121, 141, 'relanding.ru', 'anon_1755434514', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755434514),
(122, 141, 'relanding.ru', 'anon_1755445168', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 1755445168),
(123, 141, 'relanding.ru', 'offset_marker', '', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 16:18:06', 122),
(124, 141, 'unknown', 'external_1755447803', 'external_d5b12d53a09cf4ae6516c995bff5f09300c26828c3189bca9315f79', 1, 0, 'unknown', NULL, NULL, 'ru', 'external', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 'lead', 125, NULL, '2025-08-17', 'unknown', NULL, '2025-08-17 16:23:23', 0),
(125, 141, 'relanding.ru', 'anon_1755447688', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755447688),
(126, 141, 'relanding.ru', 'anon_1755450888', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755450888),
(127, 141, 'relanding.ru', 'anon_1755451010', '', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755451010),
(128, 141, 'relanding.ru', 'anon_1755452166', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755452166),
(129, 141, 'relanding.ru', 'anon_1755452171', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755452171),
(130, 141, 'relanding.ru', 'anon_1755452178', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755452178),
(131, 141, 'relanding.ru', 'anon_1755453670', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755453670),
(132, 141, 'relanding.ru', 'anon_1755454429', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755454429),
(133, 141, 'relanding.ru', 'anon_1755454432', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755454432),
(134, 141, 'relanding.ru', 'anon_1755454433', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755454433),
(135, 141, 'relanding.ru', 'anon_1755454434', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755454434),
(136, 141, 'relanding.ru', 'anon_1755454435', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755454435),
(137, 141, 'relanding.ru', 'anon_1755454437', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755454437),
(138, 141, 'relanding.ru', 'anon_1755455399', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755455399),
(139, 141, 'relanding.ru', 'anon_1755455916', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'other', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755455916),
(140, 141, 'relanding.ru', 'anon_1755457481', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 1755457481),
(141, 141, 'relanding.ru', 'offset_marker', '', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-17 19:14:04', 139),
(142, 141, 'unknown', 'external_1755526482', 'external_d5b12d53a09cf4ae6516c995bff5f09300c26828c3189bca9315f79', 1, 0, 'unknown', NULL, NULL, 'ru', 'external', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 'lead', 125, NULL, '2025-08-18', 'unknown', NULL, '2025-08-18 14:14:42', 0),
(143, 141, 'unknown', 'external_1755531002', 'external_d5b12d53a09cf4ae6516c995bff5f09300c26828c3189bca9315f79', 1, 0, 'unknown', NULL, NULL, 'ru', 'external', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 'lead', 125, NULL, '2025-08-18', 'unknown', NULL, '2025-08-18 15:30:02', 0),
(144, 141, 'relanding.ru', '5ac85675942e87dec4080760c7568c20f611b2ccd6b77390e604e00b4d875afa', 'c0e2aa9d333bbc1a3db64685c5bbb4960e902a5db86cc5485fb14f4ff7e172b3', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ekskluziv-12-mest-ai-systema', '/modules/public/logEvent.php', 39580, 34, 0, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-19 14:16:02', 0),
(145, 141, 'relanding.ru', 'anon_3', 'eb4ea6123d4546f4b34b7867c9a0e11e0837c5478301fb023574a488e93826cd', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-19 14:16:02', 0),
(146, 141, 'relanding.ru', 'anon_4', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-17', NULL, NULL, '2025-08-19 14:16:02', 0),
(147, 141, 'relanding.ru', 'anon_6', 'dbc71d15b789c87cca01748e96ebd4cc6a78aa40075102ad03134df6230cfd1d', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(148, 141, 'relanding.ru', 'anon_8', '96916b1822770399f4f395fcf5c9a44566079a06107421f27c905980b027ab70', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(149, 141, 'relanding.ru', 'anon_9', 'ca92dc63222162c51fd57cb30fdf753dbc01b3267ba96125bd52669c47188acc', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/sravnenie-ai-systema-vs-konkurenty', '/sravnenie-ai-systema-vs-konkurenty', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(150, 141, 'relanding.ru', 'anon_10', '6dcb67315c871a24dceaad28bf2f71df09961efc0478f7f867ad9ffcf6625a8d', 1, 0, 'mobile', NULL, NULL, '.%5C', 'direct', NULL, NULL, NULL, '', '/.%5C/ai-website-nedvizhimosti', '/.%5C/ai-website-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(151, 141, 'relanding.ru', 'anon_11', 'd343badbfba122b9ef39334a43af47a3a6dc4bd5db514203c16e6afbcd03edae', 1, 0, 'mobile', NULL, NULL, '.%5C', 'direct', NULL, NULL, NULL, '', '/.%5C/kak-rabotaet-vnedrenie-ai-systemy', '/.%5C/kak-rabotaet-vnedrenie-ai-systemy', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(152, 141, 'relanding.ru', 'anon_12', '813e98cc2ea150c18e8a55a5957f7d401bcbaf386d508a02d7c2ce6b54779f6f', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-promotion-nedvizhimosti', '/ai-promotion-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(153, 141, 'relanding.ru', 'anon_14', '032044d494829769310500ec5216bfc2d8490a7c6115c19f2e055e6c2b6912f0', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, 'RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(154, 141, 'relanding.ru', 'anon_15', '2993938e945cda5eae48f7f7a905cd3d02462b8918873686323630d3fcca90dd', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/poluchit-ai-ekosistemu-nedvizhimosti', '/poluchit-ai-ekosistemu-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(155, 141, 'relanding.ru', 'anon_16', '253dac981d496f939bcfc937b9dcc911ced83104a733e9aad42a1626a4429063', 1, 0, 'desktop', NULL, NULL, '_profiler', 'direct', NULL, NULL, NULL, '', '/_profiler/open?file=app/config/parameters.yml', '/_profiler/open?file=app/config/parameters.yml', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(156, 141, 'relanding.ru', 'anon_34', 'ee3e098023349e8a3be6aae51b0557a564b68c86fdce9cf97b72b0863f4f7e6f', 1, 0, 'desktop', NULL, NULL, 'profiler', 'direct', NULL, NULL, NULL, '', '/profiler/open?file=app/config/parameters.yml', '/profiler/open?file=app/config/parameters.yml', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(157, 141, 'relanding.ru', 'anon_35', '67c7d9ba0836e08c63d7ad6da14aa289e52592257ebfacd340b4c0bc6e645e66', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/poluchit-ai-ekosistemu-nedvizhimosti', '/poluchit-ai-ekosistemu-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(158, 141, 'relanding.ru', 'anon_37', '9cbf620c539abb0f97d79a12983271576e0c7f0ac6d957a399526088b47570cc', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(159, 141, 'relanding.ru', 'anon_38', '5eb28c73babf62ec9691e777d76110e8ccf8a18e0a0f09ad6a525d11a3a4d23d', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(160, 141, 'relanding.ru', 'anon_39', '53da64b99fe2978f5dcdb9a84ee04758efd6ea045483415d19728a128f74a6ad', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(161, 141, 'relanding.ru', 'anon_40', '5de9ad19aa0037214b7c81e73e4a2840ffcfdf0141d89f1e4ef43b440933a4c6', 1, 0, 'mobile', NULL, NULL, '.%5C', 'direct', NULL, NULL, NULL, '', '/.%5C/it-problemy-agentstva-nedvizhimosti', '/.%5C/it-problemy-agentstva-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(162, 141, 'relanding.ru', 'anon_62', '059bd9fdcb7de8f8f2c7be373b3f579a6341b0edd6fe655a716bd76ec5c75854', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-lending-nedvizhimosti', '/ai-lending-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(163, 141, 'relanding.ru', 'anon_63', 'e1c1feb9d4249ca92a0aae7aaea00af52304838b7b1c1432c395292f73a28a68', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/kak-rabotaet-vnedrenie-ai-systemy', '/kak-rabotaet-vnedrenie-ai-systemy', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(164, 141, 'relanding.ru', 'anon_64', '743fb00c1ecb576d324ee24293137d7d51b543aae4a35aa2e246263d8ba68a0c', 1, 0, 'mobile', NULL, NULL, '.%5C', 'direct', NULL, NULL, NULL, '', '/.%5C/ai-core-avtomatizaciya', '/.%5C/ai-core-avtomatizaciya', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(165, 141, 'relanding.ru', 'anon_65', 'bc6201fdea1dde8eb1f802c4882df469ca911300d0773b1ab87eb9ab2f13579e', 1, 0, 'mobile', NULL, NULL, '.%5C', 'direct', NULL, NULL, NULL, '', '/.%5C/ai-promotion-nedvizhimosti', '/.%5C/ai-promotion-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(166, 141, 'relanding.ru', 'anon_67', '7b5bcffb45a64ed693d1d3233f41f2e80bc2dad19098c068f49eb46f284263b3', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(167, 141, 'relanding.ru', 'anon_69', 'ec55dc8b96c4910c141723ed586585ec445c1349d7d42aa4f1a249ee68bbf4bd', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(168, 141, 'relanding.ru', 'anon_71', 'ac6032580bcceabe552a44aeaf0268a6a160e9481494a5286033060ee6445b4f', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ekskluziv-12-mest-ai-systema', '/ekskluziv-12-mest-ai-systema', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(169, 141, 'relanding.ru', 'anon_73', '37be5aa4cd4c0fe88888b356506e8395eaed70fc36be205ac8007b2be3638dc9', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(170, 141, 'relanding.ru', 'anon_75', 'b6e449204a3e14bbb7973cad90cf0e4fde02228eda23e721f95440a035127745', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(171, 141, 'relanding.ru', 'anon_77', '95a09c57e914af3b5a605db7ee1df1edccb67683c3a79a7167b633186755015c', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(172, 141, 'relanding.ru', 'anon_79', '53817b56a70c64cf8a9c21203a8a47de97bbaa660857a14fe194e5aa522a4e94', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(173, 141, 'relanding.ru', 'anon_82', '8ff4a2d20f2566475d5f24f09dfd8364263d0bf53b9d79f19fbd2c832b91cc94', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(174, 141, 'relanding.ru', 'anon_84', 'fb9806e80296455cc061807c23003327523bb9f9e8f2f5bb9e44e0f02c41e5a7', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(175, 141, 'relanding.ru', 'anon_86', '5125db7b46c0c469dcae63f4d3b8f23e5a3b0ed79768fa68e24d01d9a361a9b7', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(176, 141, 'relanding.ru', 'anon_88', 'ec1cac4cff133fe8b99152e0b7f4bae2dac27aa199bfdcd2706429128e98ead6', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(177, 141, 'relanding.ru', 'anon_90', '6ace70066a8b2b2a10712605aba69eab9f3c4f0b25b3f32471224719d4dcbf28', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(178, 141, 'relanding.ru', 'anon_94', '7a4c347b200c371f02b302d30a866c2a6d7d57d1bc9861ebf72665578638ffb7', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(179, 141, 'relanding.ru', 'anon_96', '7b62a190171f0161a69f66d89344c40111430d16c8ea4f2f85dc1c3529f9e86e', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(180, 141, 'relanding.ru', 'anon_97', 'ae4f8f84bae5b288fa03d43b39a1510cad1bc66c22767521cb85f9646bdbd002', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 2, 0, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(181, 141, 'relanding.ru', 'anon_98', '1470dd9be74b8fb72cafebfba864da8cae13c96b68f3a0e2fefddba55aa467fc', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 2, 0, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(182, 141, 'relanding.ru', 'anon_99', '6c4e91ab7a5f0d5e3d759a6612dcfec5dc8726198cf27bd426da64ca0e40de57', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(183, 141, 'relanding.ru', 'anon_101', '55922bd3c11dbf3e5e073fc536949979f84de01435eb1f808c1168257a8c2f17', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(184, 141, 'relanding.ru', 'anon_103', 'd71645ba0da53d0a4bef986c4168768cc4e9ce2012765953927c347630a7e0c1', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(185, 141, 'relanding.ru', 'anon_105', 'f73109e65e3a9abba1c0b754f2eeb6aad510dcca6373d553b3106bea162bee02', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(186, 141, 'relanding.ru', 'anon_107', 'd0ed0e8e4f94033aad0e81cfaf936c27b907ed574825ca358ee68157fc3618e9', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(187, 141, 'relanding.ru', 'anon_109', 'facbd3febb0e94b11c59000f5f12d7c02c6d7c2a34fd6fc18c4a60a179c5e243', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://www.relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(188, 141, 'relanding.ru', 'anon_111', 'ee9ce49aee290efb73987a036786c923e592a935f896b3879ee675b26d6158be', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(189, 141, 'relanding.ru', 'anon_114', 'bc289c3fba27cf0e1145a109fdb391d702d4dee024a677d628230b3c89a5f4bf', 1, 0, 'mobile', NULL, NULL, 'ru', 'google', NULL, NULL, NULL, 'https://www.google.com/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 55001, 4, 0, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(190, 141, 'relanding.ru', 'anon_115', 'b67e42b7160627cb066a90623f26f83fe715c23cee7ab57cbe75ba5b7440ef12', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-website-nedvizhimosti', '/ai-website-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(191, 141, 'relanding.ru', 'anon_116', '39f787f0224e7bd2125a3f2876fc0ca7fc69ef00e8c22e1b604ddd70a9b9d05b', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/wordpress', '/wordpress', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(192, 141, 'relanding.ru', 'anon_118', '7d5bf13373b398de332b6181e846622dffd779817fab175fa8ae5d7e463a54bd', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(193, 141, 'relanding.ru', 'anon_119', '1d8ce721e142fccb918e6d58f8c79a7e85a41b21d709d44c1449bb55a6c2bf3d', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(194, 141, 'relanding.ru', 'anon_120', '39bc9f7f69d6a851aaecb7efb370ca376e18007bf41bd9ac944617c3ae81a4bb', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(195, 141, 'relanding.ru', 'anon_123', 'c38be96e6104a833a6d6599f3946cb28d92841eecd7635078f06c2dd6cf05d46', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 8, 6, 0, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(196, 141, 'relanding.ru', 'anon_125', 'a4e9f8f95faac89bdb2452d3b435794e721059c22db0e171dace3010b6e0e0d6', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(197, 141, 'relanding.ru', 'anon_127', 'ef75a1408d9cb132d32fad56503a49332af290b06cf4fb141aa69824238d11f1', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0);
INSERT INTO `website_analytics` (`id`, `organization_id`, `domain`, `session_id`, `visitor_id`, `is_new_visitor`, `is_returning`, `device_type`, `browser`, `os`, `language`, `source`, `utm_source`, `utm_medium`, `utm_campaign`, `referrer`, `landing_page`, `exit_page`, `session_duration`, `page_views`, `bounce`, `has_conversion`, `conversion_entity_type`, `conversion_entity_id`, `form_type`, `session_date`, `ip_address`, `last_processed_time`, `created_at`, `last_processed_id`) VALUES
(198, 141, 'relanding.ru', 'anon_129', '16cd990a475c7001b4dc7069cc425e7e183c350d4ee923ca1ac33558f8bfaa12', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(199, 141, 'relanding.ru', 'anon_131', '9a4d39d0db0d3def3995ab682a136859f330795a461d29f991fecaa7fcc3c6a1', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(200, 141, 'relanding.ru', 'anon_134', '47f44517003f9348d9b3fc8129e58de18d16bda24042917fbd7568004991e864', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/feed/', '/feed/', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(201, 141, 'relanding.ru', 'anon_136', '17383029c16c5504512cf34051f7891b3783866fddc557dbef488f8a44a53905', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(202, 141, 'relanding.ru', 'anon_143', 'b73693961295b0c1cf5b0effd9a77a23e4433534cb5c8f5ce08cfe27c1c2c584', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(203, 141, 'relanding.ru', 'anon_144', '655b2ba0a7e29469e18ea71c2b93a842f93cc17b2c29e164b817dfaecc366ffa', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(204, 141, 'relanding.ru', 'anon_145', '97011eb1030ac650fedc594f101ba9925df2d879ae476ad2bb09d8c533c89a38', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-18', NULL, NULL, '2025-08-19 14:16:02', 0),
(205, 141, 'relanding.ru', 'anon_148', 'a686fcaf762dccf8f4ff1840b116f58105209ed27ba3ae24385511b818d3f7a1', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(206, 141, 'relanding.ru', 'anon_150', '65dec30215d356f445bb5b8f4a4c2e9156df242b893767bd3d8c4073aefbbed6', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(207, 141, 'relanding.ru', 'anon_152', '3c9ff8426d223da9416f57cdaad0910ec659817fb9eb67a47a809950b05caf63', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(208, 141, 'relanding.ru', 'anon_154', 'ace69ee6d6646a757be17b322f64aad30d478d053785ec391c41fab7e204f54b', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(209, 141, 'relanding.ru', 'anon_156', '0a1447ae0aae82243fc43fafdad48bc87fad4433f87dde0be0377a0f45086ce9', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(210, 141, 'relanding.ru', 'anon_158', '67b3705e358e7000cb32a170f05ec465ff0560016e4f91fc7b9a1c12fb16d48f', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(211, 141, 'relanding.ru', 'anon_160', '9c808ff07bc251def80f6db14e3f5cc9184f6aafd7ae9051c330f6be7138f392', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(212, 141, 'relanding.ru', 'anon_161', '106a1a846aa8b1de38136128c8b6bf2397c1664b961b957346b2f1e84cef5aa7', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/wordpress', '/wordpress', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(213, 141, 'relanding.ru', 'anon_163', '9a15cc2ef207b0d2ba386fe712154bd6d2fe80eb319cf09e0caed6de30b53562', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(214, 141, 'relanding.ru', 'anon_164', 'c0196f596de521e9d6e5c5cdd90214c352eae6ffef506f9d283ca84b8e08fe03', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(215, 141, 'relanding.ru', 'anon_165', '2d53f55c9886319f86ad0e4e1a7c6f89e4c96a1cd12c9b23a96127dab682ea0b', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(216, 141, 'relanding.ru', 'anon_187', '214c3a220a774bb776ed8c551c002602d3111084e900b26efaf6aae96a4cebb5', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(217, 141, 'relanding.ru', 'anon_189', '07be58c318e7a006ce729b147baca757ab9669b421106e7dae3c72ee411c9114', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(218, 141, 'relanding.ru', 'anon_190', '55e82254d2f0c7acf3fe01707ed8430896ceb197d86a9913820576d897d4fef7', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(219, 141, 'relanding.ru', 'anon_191', '86f0c0aa2a199bbd1554721815275a38f0e61dcfd59f7ac7fed50aec449ed650', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(220, 141, 'relanding.ru', 'anon_218', '4f39e3e1753c332be58a7b06a776116be7d7c38e737166bc840ea7f780528380', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, 'RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(221, 141, 'relanding.ru', 'anon_220', 'eafbf20b822cf71a600d6493e17a2d0005ffa976d5e215f87bde4c0093613712', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(222, 141, 'relanding.ru', 'anon_222', 'dd8d14bf1ca353378568520743b0c321eae8dd92c11c4b12f47101be68af03b2', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/media/system/js/core.js', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(223, 141, 'relanding.ru', 'anon_224', '7eb2e9cefe85d65a3366d09bd4c6df1d29e3462374dde5459979c7fb95bd1c26', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(224, 141, 'relanding.ru', 'anon_226', 'b184d5f4fef8dc2eda9c33f79cae70e9fbc926ff215e1b0f6afcc0ec29e8c9ba', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(225, 141, 'relanding.ru', 'anon_228', 'efd5e0e12eeb5180d2a6931279b98ff02b3f938ea4f0e50842fdcda86d47bd81', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wp-admin/install.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(226, 141, 'relanding.ru', 'anon_230', '6b2bda519b4f72951ac2492fb723c92c0120ef2579e6c68c184d527a0fbcb8a4', 1, 0, 'tablet', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wordpress/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(227, 141, 'relanding.ru', 'anon_232', '49a5ad62eebfd2bf857060add5736bb602f603e980e0176fe588da6a24717aa3', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/wp/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(228, 141, 'relanding.ru', 'anon_234', '28bf303906870de7b1c71a89a7c738a31b3b83fd2de8cd2bf2712ced054f4474', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/new/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(229, 141, 'relanding.ru', 'anon_236', '8516abe168847eee210bf309b58bf71f88bbf01dec7ea09ef80ada3848581ce0', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/new/wp-admin/install.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(230, 141, 'relanding.ru', 'anon_238', '530506e6f37d8e9691d0d9bb5e12310c4579af0a51ce66fd2c63088343c19dff', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/old/wp-admin/install.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(231, 141, 'relanding.ru', 'anon_240', '4bc832034e1a938f3299fd2dea422fbe59cda88f2a9a602017fea5efafce8453', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/blog/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(232, 141, 'relanding.ru', 'anon_242', '65c9949816d166242b8edcdabb353a9c8b44cf0cd64a3b88b77df6f66dc1731e', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/test/wp-admin/setup-config.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(233, 141, 'relanding.ru', 'anon_244', '668de374f5cca49a4f29c48d5c0766171c7dfd15aac5854a2b08d5fdf69357f9', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti/test/wp-admin/install.php?step=1&language=en_GB', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(234, 141, 'relanding.ru', 'anon_246', '3d02cb5dbba94c21f3615d82fccd6a7ba3c50a6186f7c98ce783874e49310fd9', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(235, 141, 'relanding.ru', 'anon_248', '057d03eac29656d0b2176427130f167e7da610b44bddee8e88145f712b14a117', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(236, 141, 'relanding.ru', 'anon_250', '4a5eb025bec6f54b37a10e67b6d9e1abaed049e5243f4b9a8d7de8b4cb24f3ad', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(237, 141, 'relanding.ru', 'anon_252', 'a032818f2be6133b19261f5e80886b006e46ed94adf0bde02fd3453f747ec75b', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 7, 9, 0, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(238, 141, 'relanding.ru', 'anon_254', '11e2a87eaf258192269dbb0f36e38baf0df70f44a5090b5f48d2c157b8dc646a', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(239, 141, 'relanding.ru', 'anon_256', '8a817bcb082960b2d0ed2a1ed068ea6d7a8c9a491a91a7fc6ce3cbea8fac9ea4', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(240, 141, 'relanding.ru', 'anon_258', '8e34e8ba401c5f9908407377295f6760bdaf539d313ea110be7a53026c059788', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(241, 141, 'relanding.ru', 'anon_263', 'a6f54248c2d6c437b2ce1e2e30e0ea4f96fd63e2db2fcd9b2b7135f783382538', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 12, 8, 0, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(242, 141, 'relanding.ru', 'anon_265', 'ac3bd8070a4702a6c9f664881ba6a09d2f8507545dc0a2c20718a8cf4669e21a', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-19 14:16:02', 0),
(243, 141, 'relanding.ru', 'anon_267', 'f9ce765ecf1636069ee87d5c07262b201b9d17a7c6b1258d92877cd89a13f1e1', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-20 12:33:03', 0),
(244, 141, 'relanding.ru', 'anon_269', '821840b4e814c42cd0ecaa26df9575f30d2917c68018609339b0a992a7faa3f0', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 20, 7, 0, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-20 12:33:03', 0),
(245, 141, 'relanding.ru', 'anon_271', 'c96c3129f4c8c5308ee5cee5a260a22b9076f52c367a52b8833eccb31f216c57', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-20 12:33:03', 0),
(246, 141, 'relanding.ru', 'anon_273', '3f88554f24e7bd8117e317d13d0ea0bf5e25f22dbeeba1b21db8b6cd1eb4da22', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-20 12:33:03', 0),
(247, 141, 'relanding.ru', 'anon_275', '01b06028c55a630b3bcf57c4cd5cc227511136c6eaa39207b7969499647b1031', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-20 12:33:03', 0),
(248, 141, 'relanding.ru', 'anon_276', '', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-19', NULL, NULL, '2025-08-20 12:33:03', 0),
(249, 141, 'relanding.ru', 'anon_299', '8ad578ebdb482dbd43bc242140f58ce9ac9fa93c362aa7f4d1bc5f041fdbae78', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 11, 9, 0, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(250, 141, 'relanding.ru', 'anon_301', '5848b460decdd7674892ad1414cafef9e51b7711da3e434044eaa59e17048f14', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(251, 141, 'relanding.ru', 'anon_302', '9291f57dd4dc7dbe4861d3a50d176e05f19f1a54aee9964dd885bfc9b4905409', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/komanda-briemchain-ai-pravo-tehnologii', '/komanda-briemchain-ai-pravo-tehnologii', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(252, 141, 'relanding.ru', 'anon_304', 'fc954f07ac370bd9ea3fbadbeb78e6dc9c86d02cd881f78ca1ee4aee2256c780', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(253, 141, 'relanding.ru', 'anon_306', 'f1197aa6928ec48171601d4666d62fae6aad2ecc6e1a345ba7448c1924f57469', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://www.relanding.ru/', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(254, 141, 'relanding.ru', 'anon_307', 'a4f30c2e616f2ad75ca926775001b971149b5b6fdad4c516d003430addb3f6ed', 1, 0, 'desktop', NULL, NULL, 'bitrix', 'direct', NULL, NULL, NULL, '', '/bitrix/admin', '/bitrix/admin', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(255, 141, 'relanding.ru', 'anon_309', '9623d37cb288c386608d7b784992bff28ecc28a00cd51da54eb50b44cff3efad', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(256, 141, 'relanding.ru', 'anon_311', 'd56554c71e7836326b24afe1ea508efb4af3aa10e0b2475ee99fd4160a2bc3a1', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(257, 141, 'relanding.ru', 'anon_314', '4495c0c30a0047184904c8929ff2cf048d39d1650296ed75f9d431380c13a6f9', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(258, 141, 'relanding.ru', 'anon_316', '8fa75f228212a46b47f2b184dab446c4af66c5cdf23de23f79aa178634ed8462', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(259, 141, 'relanding.ru', 'anon_318', '28d13b27601f5a6001c7fb1943fe9d4e00f6627b0578d31a673d8530e6e6485d', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/media/system/js/core.js', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(260, 141, 'relanding.ru', '1180b18b6a3da1c5915819a559727b1f653dd73a8e93a8fd220b91c751885712', '007b5677919a07e130c6b85cda2effae801e9029ac24753ef89865f05d9729cd', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(261, 141, 'relanding.ru', 'anon_321', '5a1d8d73d82641ddf9f4c4b409ba4e3baba9dfd847065a34bda906b4f04c0e39', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 5, 2, 0, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(262, 141, 'relanding.ru', 'anon_323', '9f90d5a1e6b866b06c0d24e9d208024aafa5774cf7c6bbd3d96df139253ae18a', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(263, 141, 'relanding.ru', 'anon_325', 'f53a277d0899ae14e0b2ad2488ae3597e6fe8daf9640c54d5e1a5084da218d8b', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(264, 141, 'relanding.ru', 'anon_327', '7be57431ebf43a25ab39020e05728f2677b2ecbfcb0b416dd88bb96dc337c9b1', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(265, 141, 'relanding.ru', 'anon_328', '6e9747e488ac8c8835092a142d6395193f8e38ac10f63b7c95988b19f0eba714', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(266, 141, 'relanding.ru', 'anon_329', '4f833c13c43edef01caacccac22b0864c25abe171edbb559a5e372b0fdf6f142', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(267, 141, 'relanding.ru', 'anon_331', '79c62ae2e747f949b8700a330d89ed76fb2f8ff1f7ed4361966d3fcaaf271f38', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(268, 141, 'relanding.ru', 'anon_333', '9302668d4c0e1d8795f260ce41d42d176bd2fd39cdf4cc110f7f4e49da0ae0ae', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru/media/system/js/core.js', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(269, 141, 'relanding.ru', 'anon_335', 'c123313bf539bd07276be1626eaedab122cac702895721321fe992edc63f3a2b', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(270, 141, 'relanding.ru', 'anon_336', 'eb8e28bf537973d733bffdf8b3a9c225580076946ad37f22f7eb8d8baaaebadc', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(271, 141, 'relanding.ru', 'anon_338', '40c99d947d48904aae0ed03dfcfcfb2dd4a166a0bc18eb1c529c9db794c379f6', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 12:33:03', 0),
(272, 141, 'relanding.ru', 'anon_340', '081b02fcd805f08187be25d511844a9ef8547f7785676667397d9d4892060da3', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/wordpress', '/wordpress', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 16:52:03', 0),
(273, 141, 'relanding.ru', 'anon_342', 'e3a29929712b2056d4265de73ad8a4ebf6887310878c59f08800796cf21688a0', 1, 0, 'mobile', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'http://relanding.ru', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 16:52:03', 0),
(274, 141, 'relanding.ru', 'anon_344', '28621037c89fc53276a51d1a21394b3f0f3721c09937d4fbef8d60f5a106bbda', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, 'RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 16:52:03', 0),
(275, 141, 'relanding.ru', 'anon_346', '09958ac1c710f0fea3d24b64ede63d28fae225b5f906202addbdd287f8d2c4cf', 1, 0, 'desktop', NULL, NULL, 'ru', 'referral', NULL, NULL, NULL, 'https://RELANDING.RU', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 17:41:01', 0),
(276, 141, 'relanding.ru', 'anon_347', 'feac002fc65c1067b5e0c1c2a4ab3450ff4cbb14a45356f1d60c41c064d968ff', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 17:41:01', 0),
(277, 141, 'relanding.ru', 'anon_348', 'e1571570d388d17b7342a01a1e501ed035693f2dc06596da00802740c4ffe2e3', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 17:41:01', 0),
(278, 141, 'relanding.ru', 'anon_350', 'b9e0abf6e28cf303cc95c13ae203b6bf6f47d47c8d4d25df2a6f1417f2ecf22a', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 17:47:01', 0),
(279, 141, 'relanding.ru', 'anon_352', '10378dae91f8c3a800cd658e257aab67f78b4b15d0e396a43d6ce4a2087cd7da', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 18:20:01', 0),
(280, 141, 'relanding.ru', 'anon_354', '9bc14d2b679df2ce8192994f1cf284b658d2f1126f005634e893458070c19958', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 18:20:01', 0),
(281, 141, 'relanding.ru', 'anon_356', '0fa99a7bcbcc4e7b54ced08324511d1bca2c0a99f73e39a1c9acf3b6d4fff628', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, '', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 18:20:01', 0),
(282, 141, 'relanding.ru', 'anon_358', '2c03bac60bebb4183d6181e94870cdf1b7534ea5664aec5b95b1946290effcde', 1, 0, 'desktop', NULL, NULL, 'ru', 'google', NULL, NULL, NULL, 'http://www.google.com.hk', '/ai-ekosistema-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-20', NULL, NULL, '2025-08-20 18:20:01', 0),
(283, 141, 'relanding.ru', 'test_2025-08-21_0_68a860022a64f', 'visitor_2025-08-21_0_68a860022a651', 0, 1, 'desktop', 'Safari', 'macOS', 'ru', 'yandex', NULL, NULL, NULL, NULL, '/', NULL, 1520, 5, 1, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 11:50:30', 0),
(284, 141, 'relanding.ru', 'test_2025-08-21_1_68a860022a657', 'visitor_2025-08-21_1_68a860022a658', 1, 1, 'mobile', 'Chrome', 'iOS', 'ru', 'social', NULL, NULL, NULL, NULL, '/', NULL, 1264, 7, 1, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 16:18:14', 0),
(285, 141, 'relanding.ru', 'test_2025-08-21_2_68a860022a65b', 'visitor_2025-08-21_2_68a860022a65c', 0, 0, 'desktop', 'Chrome', 'Windows', 'ru', 'yandex', NULL, NULL, NULL, NULL, '/', NULL, 611, 2, 1, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 09:16:47', 0),
(286, 141, 'relanding.ru', 'test_2025-08-21_3_68a860022a65d', 'visitor_2025-08-21_3_68a860022a65e', 0, 0, 'desktop', 'Chrome', 'iOS', 'ru', 'yandex', NULL, NULL, NULL, NULL, '/', NULL, 562, 2, 1, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 10:29:12', 0),
(287, 141, 'relanding.ru', 'test_2025-08-21_4_68a860022a65f', 'visitor_2025-08-21_4_68a860022a660', 0, 0, 'mobile', 'Chrome', 'iOS', 'ru', 'direct', NULL, NULL, NULL, NULL, '/', NULL, 1789, 7, 1, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 09:47:20', 0),
(288, 141, 'relanding.ru', 'test_2025-08-21_5_68a860022a662', 'visitor_2025-08-21_5_68a860022a663', 0, 0, 'mobile', 'Safari', 'iOS', 'ru', 'yandex', NULL, NULL, NULL, NULL, '/', NULL, 1199, 5, 0, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 12:11:39', 0),
(289, 141, 'relanding.ru', 'test_2025-08-21_6_68a860022a664', 'visitor_2025-08-21_6_68a860022a665', 1, 0, 'desktop', 'Edge', 'macOS', 'ru', 'yandex', NULL, NULL, NULL, NULL, '/', NULL, 1023, 1, 0, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 10:45:29', 0),
(290, 141, 'relanding.ru', 'test_2025-08-21_7_68a860022a666', 'visitor_2025-08-21_7_68a860022a667', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'google', NULL, NULL, NULL, NULL, '/', NULL, 1708, 4, 1, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 06:15:56', 0),
(291, 141, 'relanding.ru', 'test_2025-08-21_8_68a860022a669', 'visitor_2025-08-21_8_68a860022a66a', 1, 0, 'mobile', 'Chrome', 'iOS', 'ru', 'yandex', NULL, NULL, NULL, NULL, '/', NULL, 1772, 4, 0, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 06:06:22', 0),
(292, 141, 'relanding.ru', 'test_2025-08-21_9_68a860022a66c', 'visitor_2025-08-21_9_68a860022a66d', 1, 1, 'mobile', 'Edge', 'Windows', 'ru', 'google', NULL, NULL, NULL, NULL, '/', NULL, 1103, 5, 1, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 08:33:05', 0),
(293, 141, 'relanding.ru', 'test_2025-08-21_10_68a860022a66e', 'visitor_2025-08-21_10_68a860022a66f', 1, 1, 'mobile', 'Edge', 'Android', 'ru', 'social', NULL, NULL, NULL, NULL, '/', NULL, 960, 5, 0, 0, NULL, NULL, NULL, '2025-08-21', NULL, NULL, '2025-08-21 07:36:47', 0),
(294, 141, 'relanding.ru', 'generated_68a867024760b_1755866882', 'generated_f663b2d1af2bcf172754dfc7b9829721', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-22', '104.196.61.5', NULL, '2025-08-22 03:59:40', 0),
(295, 141, 'relanding.ru', 'sess_68a7fdc2dcb3b_1755839938', 'visitor_68a7fdc2dcb59_1755839938', 1, 0, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-website-nedvizhimosti', '/ai-ekosistema-nedvizhimosti', 7219, 12, 0, 0, NULL, NULL, NULL, '2025-08-22', '2a02:2454:c2eb:8d00:2998:975d:8658:6450', NULL, '2025-08-22 05:18:58', 0),
(296, 141, 'relanding.ru', 'sess_68a82f128fdda_1755852562', 'visitor_68a7fdc2dcb59_1755839938', 1, 0, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', '/ai-lending-nedvizhimosti', 29, 5, 0, 0, NULL, NULL, NULL, '2025-08-22', '2a02:2454:c2eb:8d00:2998:975d:8658:6450', NULL, '2025-08-22 08:49:22', 0),
(297, 141, 'relanding.ru', 'sess_68a86bdf01e3c_1755868127', 'visitor_68a7fdc2dcb59_1755839938', 1, 0, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-lending-nedvizhimosti', NULL, 0, 2, 0, 0, NULL, NULL, NULL, '2025-08-22', '2a02:2454:c2eb:8d00:2998:975d:8658:6450', NULL, '2025-08-22 13:08:47', 0),
(298, 141, 'relanding.ru', 'sess_68a8b5806f9fc_1755886976', 'visitor_68a8b5806fa20_1755886976', 1, 0, 'desktop', 'Chrome', 'Windows', 'ru', 'yandex', NULL, NULL, NULL, 'https://yandex.ru/', '/ai-website-nedvizhimosti', NULL, 0, 14, 0, 0, NULL, NULL, NULL, '2025-08-22', '2a02:2454:c2eb:8d00:e42e:5ebd:9622:8bb5', NULL, '2025-08-22 18:22:56', 0),
(299, 141, 'relanding.ru', 'sess_68a8b6df4e965_1755887327', 'visitor_68a8b6df4e981_1755887327', 1, 0, 'desktop', 'Chrome', 'Windows', 'ru', 'google', NULL, NULL, NULL, 'https://www.google.com/', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-22', '2a02:2454:c2eb:8d00:e42e:5ebd:9622:8bb5', NULL, '2025-08-22 18:28:47', 0),
(300, 141, 'relanding.ru', 'sess_68a8c1922c78f_1755890066', 'visitor_68a8b5806fa20_1755886976', 1, 0, 'desktop', 'Chrome', 'Windows', 'ru', 'yandex', NULL, NULL, NULL, 'https://yandex.ru/', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-22', '2a02:2454:c2eb:8d00:e42e:5ebd:9622:8bb5', NULL, '2025-08-22 19:14:26', 0),
(301, 141, 'relanding.ru', 'generated_68a94045a6577_1755922501', 'generated_27b80ff17bb1b9916f01f5caba07ec85', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-23', '35.223.222.20', NULL, '2025-08-22 22:31:07', 0),
(302, 141, 'relanding.ru', 'sess_68a95b9029616_1755929488', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-23', '2a02:2454:c2eb:8d00:e42e:5ebd:9622:8bb5', NULL, '2025-08-23 06:11:28', 0),
(303, 141, 'relanding.ru', 'sess_68a981b70a6f5_1755939255', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-23', '2a02:2454:c2eb:8d00:e42e:5ebd:9622:8bb5', NULL, '2025-08-23 08:54:15', 0),
(304, 141, 'relanding.ru', 'sess_68aab961d7e9c_1756019041', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-24', '2a02:2454:c2eb:8d00:4cb1:73b8:2630:847b', NULL, '2025-08-24 07:04:01', 0),
(305, 141, 'relanding.ru', 'sess_68ab0525d33a6_1756038437', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-24', '2a02:2454:c2eb:8d00:4cb1:73b8:2630:847b', NULL, '2025-08-24 12:27:17', 0),
(306, 141, 'relanding.ru', 'generated_68ac27b75b5c5_1756112823', 'generated_c0968d524e0471a3692e11b77fdac932', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-24', '69.167.12.35', NULL, '2025-08-24 13:22:16', 0),
(307, 141, 'relanding.ru', 'generated_68ac27b75b5ce_1756112823', 'generated_f9e4050269b2f91d5a2a89274db5f8e0', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-24', '69.167.12.35', NULL, '2025-08-24 13:22:24', 0),
(308, 141, 'relanding.ru', 'sess_68ab63e970d80_1756062697', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-24', '2a02:2454:c2eb:8d00:7008:e45a:62c5:4dda', NULL, '2025-08-24 19:11:37', 0),
(309, 141, 'relanding.ru', 'sess_68ab711a7aaa0_1756066074', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-24', '2a02:2454:c2eb:8d00:7008:e45a:62c5:4dda', NULL, '2025-08-24 20:07:54', 0),
(310, 141, 'relanding.ru', 'sess_68abe8c25ed07_1756096706', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ekskluziv-12-mest-ai-systema', NULL, 0, 2, 0, 0, NULL, NULL, NULL, '2025-08-25', '2a02:2454:c2eb:8d00:7008:e45a:62c5:4dda', NULL, '2025-08-25 04:38:26', 0),
(311, 141, 'relanding.ru', 'sess_68acbdd8e81e0_1756151256', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-25', '2a02:2454:c2eb:8d00:35ff:871d:36e6:ed25', NULL, '2025-08-25 19:47:36', 0),
(312, 141, 'relanding.ru', 'generated_68ad7936a9b63_1756199222', 'generated_4f7fe354c7491de69e1a798a2c120cde', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-26', '138.199.19.158', NULL, '2025-08-26 05:43:47', 0),
(313, 141, 'relanding.ru', 'generated_68aecab7263f2_1756285623', 'generated_4db4e13a449fbb5d5f260efcf3b79bcb', 1, 0, 'mobile', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-26', '128.90.141.4', NULL, '2025-08-26 12:06:45', 0),
(314, 141, 'relanding.ru', 'sess_68aeb8216f464_1756280865', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/it-problemy-agentstva-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-27', '2a02:2455:a0b1:300:2419:339a:9c88:d462', NULL, '2025-08-27 07:47:45', 0),
(315, 141, 'relanding.ru', 'sess_68aed76f66e51_1756288879', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'mobile', 'Chrome', 'Linux', 'ru', 'direct', NULL, NULL, NULL, NULL, '/it-problemy-agentstva-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-27', '2a02:2455:a0b1:300:2419:339a:9c88:d462', NULL, '2025-08-27 10:01:19', 0),
(316, 141, 'relanding.ru', 'generated_68b01c363a6d6_1756372022', 'generated_49cc339a0a9dd3834a608db72f6af7e0', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-27', '54.151.172.206', NULL, '2025-08-27 11:35:48', 0),
(317, 141, 'relanding.ru', 'sess_68af4e56f1628_1756319318', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/it-problemy-agentstva-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-27', '2a02:2455:a0b1:300:ec07:5a77:8b1c:bce9', NULL, '2025-08-27 18:28:38', 0),
(318, 141, 'relanding.ru', 'sess_68af626e057df_1756324462', 'visitor_68a8b6df4e981_1755887327', 0, 1, 'desktop', 'Chrome', 'Windows', 'ru', 'direct', NULL, NULL, NULL, NULL, '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-27', '2a02:2455:a0b1:300:ec07:5a77:8b1c:bce9', NULL, '2025-08-27 19:54:22', 0),
(319, 141, 'relanding.ru', 'sess_68b03ca68e6df_1756380326', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'referral', NULL, NULL, NULL, 'https://relanding.ru/legal/cookies/', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-28', '2a02:2455:a0b1:300:84a4:dcc0:48a2:f7cf', NULL, '2025-08-28 11:25:26', 0),
(320, 141, 'relanding.ru', 'sess_68b057add822f_1756387245', 'visitor_68a7fdc2dcb59_1755839938', 0, 1, 'desktop', 'Firefox', 'Windows', 'ru', 'referral', NULL, NULL, NULL, 'https://relanding.ru/legal/cookies/', '/ai-ekosistema-nedvizhimosti', NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-28', '2a02:2455:a0b1:300:84a4:dcc0:48a2:f7cf', NULL, '2025-08-28 13:20:45', 0),
(321, 141, 'relanding.ru', 'generated_68b2bf35eb8f3_1756544821', 'generated_d42dca041d1cf8da37606c68e5c743db', 1, 0, 'desktop', NULL, NULL, 'ru', 'direct', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 0, NULL, NULL, NULL, '2025-08-30', '102.165.48.81', NULL, '2025-08-30 07:33:12', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `website_daily_stats`
--

CREATE TABLE IF NOT EXISTS `website_daily_stats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `domain` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `unique_visitors` int DEFAULT '0',
  `total_sessions` int DEFAULT '0',
  `new_visitors` int DEFAULT '0',
  `returning_visitors` int DEFAULT '0',
  `avg_session_duration` decimal(10,2) DEFAULT '0.00',
  `total_time` int DEFAULT '0',
  `bounce_rate` decimal(5,2) DEFAULT '0.00',
  `pages_per_session` decimal(5,2) DEFAULT '0.00',
  `source_direct` int DEFAULT '0',
  `source_google` int DEFAULT '0',
  `source_yandex` int DEFAULT '0',
  `source_social` int DEFAULT '0',
  `source_email` int DEFAULT '0',
  `source_referral` int DEFAULT '0',
  `source_paid` int DEFAULT '0',
  `source_other` int DEFAULT '0',
  `desktop_visitors` int DEFAULT '0',
  `mobile_visitors` int DEFAULT '0',
  `tablet_visitors` int DEFAULT '0',
  `top_country_1` varchar(2) DEFAULT NULL,
  `top_country_1_count` int DEFAULT '0',
  `top_country_2` varchar(2) DEFAULT NULL,
  `top_country_2_count` int DEFAULT '0',
  `top_country_3` varchar(2) DEFAULT NULL,
  `top_country_3_count` int DEFAULT '0',
  `top_page_1` varchar(255) DEFAULT NULL,
  `top_page_1_views` int DEFAULT '0',
  `top_page_2` varchar(255) DEFAULT NULL,
  `top_page_2_views` int DEFAULT '0',
  `top_page_3` varchar(255) DEFAULT NULL,
  `top_page_3_views` int DEFAULT '0',
  `total_conversions` int DEFAULT '0',
  `conversion_rate` decimal(5,2) DEFAULT '0.00',
  `conversions_leads` int DEFAULT '0',
  `conversions_tickets` int DEFAULT '0',
  `conversions_tasks` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_org_domain_date` (`organization_id`,`domain`,`date`),
  KEY `idx_organization_id` (`organization_id`),
  KEY `idx_domain` (`domain`),
  KEY `idx_date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `website_daily_stats`
--

INSERT INTO `website_daily_stats` (`id`, `organization_id`, `domain`, `date`, `unique_visitors`, `total_sessions`, `new_visitors`, `returning_visitors`, `avg_session_duration`, `total_time`, `bounce_rate`, `pages_per_session`, `source_direct`, `source_google`, `source_yandex`, `source_social`, `source_email`, `source_referral`, `source_paid`, `source_other`, `desktop_visitors`, `mobile_visitors`, `tablet_visitors`, `top_country_1`, `top_country_1_count`, `top_country_2`, `top_country_2_count`, `top_country_3`, `top_country_3_count`, `top_page_1`, `top_page_1_views`, `top_page_2`, `top_page_2_views`, `top_page_3`, `top_page_3_views`, `total_conversions`, `conversion_rate`, `conversions_leads`, `conversions_tickets`, `conversions_tasks`, `created_at`, `updated_at`) VALUES
(1, 141, 'unknown', '2025-08-18', 1, 2, 2, 0, 0.00, 0, 100.00, 1.00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, 2, 200.00, 0, 0, 0, '2025-08-19 14:16:02', '2025-08-19 14:25:02'),
(2, 141, 'relanding.ru', '2025-08-18', 58, 58, 58, 0, 948.43, 55009, 93.10, 1.17, 0, 0, 0, 0, 0, 0, 0, 0, 36, 22, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, 0, 0.00, 0, 0, 0, '2025-08-19 14:16:02', '2025-08-19 14:25:02'),
(5, 141, 'relanding.ru', '2025-08-19', 44, 44, 44, 0, 0.89, 39, 93.18, 1.48, 0, 0, 0, 0, 0, 0, 0, 0, 37, 6, 1, NULL, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, 0, 0.00, 0, 0, 0, '2025-08-20 12:33:03', '2025-08-20 18:21:02'),
(11, 141, 'relanding.ru', '2025-08-21', 11, 11, 5, 5, 1228.27, 0, 63.64, 4.27, 0, 0, 0, 0, 0, 0, 0, 0, 5, 6, 0, NULL, 0, NULL, 0, NULL, 0, '/', 11, NULL, 0, NULL, 0, 0, 0.00, 0, 0, 0, '2025-08-22 12:28:03', '2025-08-22 12:28:03'),
(13, 141, 'relanding.ru', '2025-08-22', 1, 2, 2, 0, 3624.00, 0, 0.00, 8.50, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, NULL, 0, NULL, 0, NULL, 0, '/ai-ekosistema-nedvizhimosti', 1, '/ai-website-nedvizhimosti', 1, NULL, 0, 0, 0.00, 0, 0, 0, '2025-08-23 04:15:01', '2025-08-23 04:15:01');

-- --------------------------------------------------------

--
-- Структура таблицы `website_hourly_stats`
--

CREATE TABLE IF NOT EXISTS `website_hourly_stats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organization_id` int NOT NULL,
  `domain` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `hour` tinyint NOT NULL,
  `unique_visitors` int DEFAULT '0',
  `total_sessions` int DEFAULT '0',
  `page_views` int DEFAULT '0',
  `avg_session_duration` decimal(10,2) DEFAULT '0.00',
  `conversions` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_org_domain_date_hour` (`organization_id`,`domain`,`date`,`hour`),
  KEY `idx_organization_id` (`organization_id`),
  KEY `idx_domain` (`domain`),
  KEY `idx_date_hour` (`date`,`hour`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `business_facts`
--
ALTER TABLE `business_facts`
  ADD CONSTRAINT `business_facts_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  ADD CONSTRAINT `business_facts_ibfk_2` FOREIGN KEY (`source_id`) REFERENCES `organization_sources` (`id`);

--
-- Ограничения внешнего ключа таблицы `business_profiles`
--
ALTER TABLE `business_profiles`
  ADD CONSTRAINT `business_profiles_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `client_organization`
--
ALTER TABLE `client_organization`
  ADD CONSTRAINT `client_organization_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `client_organization_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_comments_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `conversation_feedback`
--
ALTER TABLE `conversation_feedback`
  ADD CONSTRAINT `conversation_feedback_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`);

--
-- Ограничения внешнего ключа таблицы `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `events_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `event_ai_analysis`
--
ALTER TABLE `event_ai_analysis`
  ADD CONSTRAINT `event_ai_analysis_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `event_logs`
--
ALTER TABLE `event_logs`
  ADD CONSTRAINT `event_logs_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `faq_entries`
--
ALTER TABLE `faq_entries`
  ADD CONSTRAINT `faq_entries_ibfk_1` FOREIGN KEY (`merged_to`) REFERENCES `faq_entries` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_faq_source` FOREIGN KEY (`source_id`) REFERENCES `organization_sources` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `form_fields`
--
ALTER TABLE `form_fields`
  ADD CONSTRAINT `form_fields_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `invite`
--
ALTER TABLE `invite`
  ADD CONSTRAINT `invite_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `leads`
--
ALTER TABLE `leads`
  ADD CONSTRAINT `fk_leads_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_leads_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `leads_ibfk_1` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `leads_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `organization_sources`
--
ALTER TABLE `organization_sources`
  ADD CONSTRAINT `organization_sources_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `org_comments`
--
ALTER TABLE `org_comments`
  ADD CONSTRAINT `org_comments_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `org_comments_ibfk_2` FOREIGN KEY (`source_id`) REFERENCES `organization_sources` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `outbox`
--
ALTER TABLE `outbox`
  ADD CONSTRAINT `fk_outbox_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_outbox_organization` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `outbox_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `prompt_profiles`
--
ALTER TABLE `prompt_profiles`
  ADD CONSTRAINT `prompt_profiles_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  ADD CONSTRAINT `prompt_profiles_ibfk_2` FOREIGN KEY (`source_id`) REFERENCES `organization_sources` (`id`);

--
-- Ограничения внешнего ключа таблицы `prompt_templates`
--
ALTER TABLE `prompt_templates`
  ADD CONSTRAINT `prompt_templates_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  ADD CONSTRAINT `prompt_templates_ibfk_2` FOREIGN KEY (`source_id`) REFERENCES `organization_sources` (`id`),
  ADD CONSTRAINT `prompt_templates_ibfk_3` FOREIGN KEY (`intent_id`) REFERENCES `chat_intents` (`id`);

--
-- Ограничения внешнего ключа таблицы `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `fk_tasks_event_id` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `user_organization_roles`
--
ALTER TABLE `user_organization_roles`
  ADD CONSTRAINT `user_organization_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_organization_roles_ibfk_2` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_org_id`) REFERENCES `user_organization_roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `website_analytics`
--
ALTER TABLE `website_analytics`
  ADD CONSTRAINT `website_analytics_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
