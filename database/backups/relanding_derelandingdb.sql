-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Хост: relanding.de.mysql.service.one.com:3306
-- Время создания: Авг 30 2025 г., 13:57
-- Версия сервера: 10.6.23-MariaDB-ubu2204
-- Версия PHP: 8.1.2-1ubuntu2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `relanding_derelandingdb`
--

-- --------------------------------------------------------

--
-- Структура таблицы `analytics_daily_reports`
--

CREATE TABLE `analytics_daily_reports` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `report_date` date NOT NULL,
  `sent_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `analytics_events`
--

CREATE TABLE `analytics_events` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `session_id` varchar(64) DEFAULT NULL,
  `event_type` enum('click','scroll','form_submit','download','video_play','conversion','custom') NOT NULL,
  `event_category` varchar(100) DEFAULT NULL,
  `event_action` varchar(100) DEFAULT NULL,
  `event_label` varchar(255) DEFAULT NULL,
  `event_value` decimal(10,2) DEFAULT NULL,
  `event_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`event_data`)),
  `page_slug` varchar(255) DEFAULT NULL,
  `element_id` varchar(100) DEFAULT NULL,
  `element_class` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `analytics_processing_log`
--

CREATE TABLE `analytics_processing_log` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_processed_time` int(11) NOT NULL,
  `records_processed` int(11) DEFAULT 0,
  `processed_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `anonymous_analytics`
--

CREATE TABLE `anonymous_analytics` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `domain` varchar(255) NOT NULL,
  `event_type` varchar(50) NOT NULL DEFAULT 'section_view',
  `event_date` date NOT NULL,
  `device_type` varchar(50) DEFAULT 'unknown',
  `language` varchar(10) DEFAULT 'ru',
  `page_url` varchar(500) DEFAULT NULL,
  `events_count` int(11) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `attachments`
--

CREATE TABLE `attachments` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `organization_id` int(11) NOT NULL,
  `related_type` varchar(50) DEFAULT NULL,
  `related_id` int(11) DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `file_url` text NOT NULL,
  `content_type` varchar(100) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `uploaded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `business_facts`
--

CREATE TABLE `business_facts` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `page_slug` varchar(128) DEFAULT NULL,

  `fact_key` varchar(64) DEFAULT NULL,
  `fact_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`fact_value`)),
  `valid_from` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,

  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
-- --------------------------------------------------------

--
-- Структура таблицы `business_profiles`
--

CREATE TABLE `business_profiles` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `services` text NOT NULL,
  `contact_info` text NOT NULL,
  `faq` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `business_profiles`
--

INSERT INTO `business_profiles` (`id`, `organization_id`, `description`, `services`, `contact_info`, `faq`, `created_at`) VALUES
(1, 1, '? *Willkommen bei BriemChainAI!* ?\\\\n\\\\nBriemChainAI ist ein revolutionäres *modulares System* zur Verwaltung von Organisationen. ?\\\\n\\\\n? Erstellen Sie *intelligente Organisationen* und automatisieren Sie Geschäftsprozesse.\\\\n? Verwalten Sie Ihr Team, fügen Sie Mitarbeiter hinzu und delegieren Sie Aufgaben mit einer Berührung. \\\\n✅ Erstellen Sie Ihre eigene Organisation `/createOrg', '', '', NULL, '2025-04-09 16:40:54');

-- --------------------------------------------------------

--
-- Структура таблицы `chat_intents`
--

CREATE TABLE `chat_intents` (
  `id` int(11) NOT NULL,
  `code` varchar(64) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `trigger_patterns` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`trigger_patterns`)),
  `required_terms` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`required_terms`)),
  `forbidden_terms` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`forbidden_terms`)),
  `priority` tinyint(4) DEFAULT 0,
  `fallback_action` varchar(32) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `clients`
--

CREATE TABLE `clients` (
  `id` int(11) NOT NULL,
  `telegram_id` bigint(20) DEFAULT NULL,
  `telegram_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client_config`
--

CREATE TABLE `client_config` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client_organization`
--

CREATE TABLE `client_organization` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `role` enum('customer','partner','supplier') NOT NULL DEFAULT 'customer',
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `target_type` enum('lead','ticket','task') NOT NULL,
  `target_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `client_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `conversation_feedback`
--

CREATE TABLE `conversation_feedback` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `session_id` varchar(64) DEFAULT NULL,
  `question` text DEFAULT NULL,
  `intent_detected` varchar(64) DEFAULT NULL,
  `template_used` int(11) DEFAULT NULL,
  `ai_response` text DEFAULT NULL,
  `user_rating` tinyint(4) DEFAULT NULL,
  `user_comment` text DEFAULT NULL,
  `converted` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `source_type` enum('email','phone','socialMedia','websiteComments','websiteForm','websiteChat','websiteReviews','chat','other') NOT NULL,
  `source_value` varchar(255) NOT NULL,
  `from_name` varchar(255) DEFAULT NULL,
  `from_contact` varchar(128) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `subject` text DEFAULT NULL,
  `message` mediumtext DEFAULT NULL,
  `received_at` timestamp NULL DEFAULT current_timestamp(),
  `is_first_contact` tinyint(1) DEFAULT 1,
  `preferred_channel` enum('email','telegram','sms','chat','webhook','phone') DEFAULT NULL,
  `related_type` varchar(20) DEFAULT NULL,
  `related_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `event_ai_analysis`
--

CREATE TABLE `event_ai_analysis` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `ai_type` enum('new','reply','continued','forwarded','attachment','other') DEFAULT 'new',
  `ai_intent` enum('order','question','complaint','feedback','cancel','error','spam','check','followup') DEFAULT NULL,
  `ai_tone` enum('positive','neutral','negative') DEFAULT NULL,
  `ai_urgency` enum('low','medium','high','critical') DEFAULT NULL,
  `ai_confidence` float DEFAULT NULL,
  `ai_recommended_action` enum('create_lead','create_ticket','create_task','add_comment','archive','manual_review') DEFAULT 'manual_review',
  `ai_summary` text DEFAULT NULL,
  `processed_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `event_logs`
--

CREATE TABLE `event_logs` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `actor` varchar(100) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `faq_candidates`
--

CREATE TABLE `faq_candidates` (
  `id` int(11) NOT NULL,
  `page_slug` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `question` text NOT NULL,
  `answer_suggestion` text DEFAULT NULL,
  `lang` varchar(10) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `status` enum('pending','approved','merged','rejected') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `faq_entries`
--

CREATE TABLE `faq_entries` (
  `id` int(11) NOT NULL,
  `page_slug` varchar(255) NOT NULL,
  `question` text NOT NULL,
  `answer` text NOT NULL,
  `lang` varchar(10) NOT NULL,
  `merged_to` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1,
  `organization_id` int(11) NOT NULL,
  `source_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `faq_entries`
--

INSERT INTO `faq_entries` (`id`, `page_slug`, `question`, `answer`, `lang`, `merged_to`, `created_at`, `updated_at`, `is_active`, `organization_id`, `source_id`) VALUES
(2, 'ki-oecosystem-mittelstand', 'Was macht die AI-Экосистема so besonders für den Mittelstand?', 'Unsere AI-Экосистема vereint vier speziell für den Mittelstand entwickelte Lösungen in einer Plattform: CRM, Website, Landing Pages und Chat-Bot. Alles wird bequem über Telegram verwaltet - Ihr gesamtes digitales Geschäft in einem Handy. Sie sparen 10-15 Stunden pro Woche, steigern Ihre Leads um 40-60% und sind dabei vollständig GDPR/AI Act konform.', 'de', NULL, '2025-08-30 10:00:00', '2025-08-30 10:00:00', 1, 1, 1),
(3, 'ki-oecosystem-mittelstand', 'Wie schnell kann ich mit der Экосистема starten?', 'In nur 2-4 Wochen ist Ihre komplette digitale Präsenz einsatzbereit. Sie erhalten einen kostenlosen 30-Tage-Piloten, um alle Funktionen zu testen. Die Setup-Kosten liegen bei €3.000-7.000 mit flexibler Ratenzahlung möglich. Danach nur €300-600/Monat - weniger als ein Vollzeit-Mitarbeiter kostet.', 'de', NULL, '2025-08-30 10:01:00', '2025-08-30 10:01:00', 1, 1, 1),
(4, 'ki-oecosystem-mittelstand', 'Ist die Lösung GDPR und AI Act konform?', 'Ja, absolute Rechtssicherheit ist unser Priorität. Automatisches Consent-Management, Datenminimierung, Right-to-be-forgotten Funktion, EU-Hosting und vollständige Transparenz-Logs für alle AI-Entscheidungen. Wir stellen DPIA-Templates bereit und dokumentieren alles gemäß AI Act für Low-Risk-Anwendungen.', 'de', NULL, '2025-08-30 10:02:00', '2025-08-30 10:02:00', 1, 1, 1),
(5, 'ki-oecosystem-mittelstand', 'Wie hilft das AI-CRM bei der Leadverteilung?', 'Unser AI-CRM klassifiziert eingehende Anfragen automatisch (Lead/Ticket/Aufgabe) und verteilt sie intelligent nach Spezialisierung und Arbeitsbelastung Ihrer Mitarbeiter. Follow-up-Erinnerungen nach 24 Stunden verhindern, dass Leads verloren gehen. Sie reduzieren Antwortzeiten von über 24 Stunden auf unter 4 Stunden.', 'de', NULL, '2025-08-30 10:03:00', '2025-08-30 10:03:00', 1, 1, 1),
(6, 'ki-oecosystem-mittelstand', 'Funktioniert die CRM-Integration mit DATEV?', 'Selbstverständlich. Nahtlose Integration mit DATEV, SAP und Excel. Import Ihrer bestehenden Kundendaten, Export für Buchhaltung und Reporting. Der Übergang erfolgt ohne Datenverlust - wir kümmern uns um die komplette Migration Ihrer vorhandenen Systeme.', 'de', NULL, '2025-08-30 10:04:00', '2025-08-30 10:04:00', 1, 1, 1),
(7, 'ki-oecosystem-mittelstand', 'Wie verwalte ich das CRM unterwegs?', 'Komplette Verwaltung über Telegram auf Deutsch. Einfache Befehle wie \"Zeige alle Anfragen\" oder \"Weise Anfrage ID123 an Müller zu\". Bestätigungen für wichtige Aktionen, tägliche Reports direkt ins Handy. Perfekt für mobile Geschäftsführung - alles was Sie brauchen, ist Telegram.', 'de', NULL, '2025-08-30 10:05:00', '2025-08-30 10:05:00', 1, 1, 1),
(8, 'ki-oecosystem-mittelstand', 'Warum lädt die AI-Website so schnell?', 'Unsere Websites sind ohne externe Bibliotheken entwickelt und laden in unter 0,5 Sekunden. Optimiert für mobile Endgeräte, da 70% Ihrer Kunden über Smartphone suchen. Bessere Performance bedeutet bessere Google-Rankings und zufriedenere Besucher - das steigert Ihre Konversionsrate um 2-4x.', 'de', NULL, '2025-08-30 10:06:00', '2025-08-30 10:06:00', 1, 1, 1),
(9, 'ki-oecosystem-mittelstand', 'Wie erstelle ich neue Inhalte für die Website?', 'Über Telegram-Bot in 10 Minuten: \"Erstelle Inhalt für domain.com zum Thema X\". Die AI generiert SEO-optimierten Content, Sie bestätigen mit einem Klick. 20-40 segmentierte Bereiche (Dienstleistungen, Produkte, Aktionen) für 3-5x bessere SEO-Abdeckung. Kein technisches Know-how erforderlich.', 'de', NULL, '2025-08-30 10:07:00', '2025-08-30 10:07:00', 1, 1, 1),
(10, 'ki-oecosystem-mittelstand', 'Kann ich meine alte Website migrieren?', 'Ja, problemloser Import von Ihrer bestehenden Website oder DATEV. Wir übertragen alle wichtigen Inhalte und optimieren sie für bessere Performance. Keine Ausfallzeiten, keine verlorenen Google-Rankings. Der Migrationsprozess dauert unter 30 Tage und wird vollständig von uns begleitet.', 'de', NULL, '2025-08-30 10:08:00', '2025-08-30 10:08:00', 1, 1, 1),
(11, 'ki-oecosystem-mittelstand', 'Wofür brauche ich Landing Pages zusätzlich zur Website?', 'Landing Pages sind perfekt für zeitkritische Aktionen und Kampagnen. Während Ihre Website Ihr Unternehmen präsentiert, fokussiert eine Landing Page auf EIN Ziel: mehr Anfragen für spezielle Angebote. Urgency-Elemente wie Timer steigern die Konversion um 4-8x. Ideal für Handwerk-Promotions oder Saisonangebote.', 'de', NULL, '2025-08-30 10:09:00', '2025-08-30 10:09:00', 1, 1, 1),
(12, 'ki-oecosystem-mittelstand', 'Wie schnell kann ich eine Landing Page für eine Aktion erstellen?', 'In nur 3-5 Tagen ist Ihre Landing Page live. Über Telegram-Bot: \"Erstelle Aktion für domain.com\" - die AI generiert Hero-Sektion, Angebote, CTA-Buttons und Formulare. Sie passen Details an und bestätigen. Perfekt für spontane Aktionen oder saisonale Angebote im Handwerk.', 'de', NULL, '2025-08-30 10:10:00', '2025-08-30 10:10:00', 1, 1, 1),
(13, 'ki-oecosystem-mittelstand', 'Werden meine Landing Pages bei Google gefunden?', 'Absolut. AI-optimierte SEO für Nischensuchanfragen sorgt für 3-5x bessere Sichtbarkeit. Segmentierte Blöcke funktionieren wie \"virtuelle Seiten\" und ranken für spezifische Suchbegriffe. Ergebnis: Top-Positionen innerhalb einer Woche und 40-60% mehr qualifizierte Leads.', 'de', NULL, '2025-08-30 10:11:00', '2025-08-30 10:11:00', 1, 1, 1),
(14, 'ki-oecosystem-mittelstand', 'Kann der Chat-Bot wirklich 90% der Kundenanfragen beantworten?', 'Ja, durch eine speziell auf Ihr Unternehmen angepasste Wissensbasis mit 50 Q&A. Häufigste Fragen zu Preisen, Öffnungszeiten, Dienstleistungen werden sofort beantwortet. Komplexere Anfragen werden an Sie weitergeleitet. Das entlastet Sie erheblich und bietet Kunden 24/7 Service.', 'de', NULL, '2025-08-30 10:12:00', '2025-08-30 10:12:00', 1, 1, 1),
(15, 'ki-oecosystem-mittelstand', 'Wie integriere ich den Chat-Bot in meine bestehende Website?', 'Plug-and-Play Integration durch einfachen JavaScript-Code. Funktioniert mit jeder Website - egal ob WordPress, Jimdo oder custom entwickelt. Setup in 1-2 Tagen, danach sammelt der Bot automatisch Leads mit GDPR-konformen Formularen und leitet sie direkt an Ihr CRM weiter.', 'de', NULL, '2025-08-30 10:13:00', '2025-08-30 10:13:00', 1, 1, 1),
(16, 'ki-oecosystem-mittelstand', 'Was passiert wenn der Chat-Bot eine Anfrage nicht beantworten kann?', 'Intelligente Eskalation: Der Bot erkennt komplexe Anfragen und leitet sie sofort an Sie per Telegram weiter. Sie können die Anfrage annehmen oder ablehnen. Der Kunde erhält eine persönliche Antwort von Ihnen. So verpassen Sie keine wichtigen Leads, sparen aber Zeit bei Routinefragen.', 'de', NULL, '2025-08-30 10:14:00', '2025-08-30 10:14:00', 1, 1, 1),
(17, 'ki-oecosystem-mittelstand', 'Wie sicher sind meine Daten in der AI-Экосистема?', 'Höchste Sicherheitsstandards: EU-Hosting (GAIA-X), Ende-zu-Ende Verschlüsselung, automatische Backups. Datenminimierung - wir speichern nur was nötig ist. Right-to-be-forgotten per Telegram-Befehl. Vollständige Transparenz über alle AI-Entscheidungen. Ihre Daten bleiben in Europa und unter deutscher Rechtsprechung.', 'de', NULL, '2025-08-30 10:15:00', '2025-08-30 10:15:00', 1, 1, 1),
(18, 'ki-oecosystem-mittelstand', 'Brauche ich technische Kenntnisse um die Экосистема zu nutzen?', 'Nein, absolut nicht. Die komplette Verwaltung erfolgt über Telegram wie WhatsApp. Einfache deutsche Befehle, Bestätigungen bei wichtigen Aktionen, nur 10-15 Basis-Kommandos. Wenn Sie WhatsApp nutzen können, können Sie auch unsere Экосистема verwalten. Bei Fragen ist unser Support da.', 'de', NULL, '2025-08-30 10:16:00', '2025-08-30 10:16:00', 1, 1, 1),
(19, 'ki-oecosystem-mittelstand', 'Kann ich meine bestehenden Tools weiter nutzen?', 'Ja, nahtlose Integration mit Ihren bewährten Systemen: DATEV für Buchhaltung, Excel für Reports, bestehende E-Mail-Konten, Stripe/PayPal für Zahlungen. Ihre Workflows bleiben erhalten, werden aber durch AI automatisiert und optimiert. Kein Systembruch, nur Verbesserung.', 'de', NULL, '2025-08-30 10:17:00', '2025-08-30 10:17:00', 1, 1, 1),
(20, 'ki-oecosystem-mittelstand', 'Welchen ROI kann ich von der AI-Экосистема erwarten?', 'Unsere Kunden berichten: 40-60% mehr Leads, 10-15 Stunden Zeitersparnis pro Woche, 4-8x höhere Konversionsraten. Bei monatlichen Kosten von €300-600 amortisiert sich die Investition meist binnen 2-3 Monaten durch gesteigerte Auftragslage und gesparte Arbeitszeit.', 'de', NULL, '2025-08-30 10:18:00', '2025-08-30 10:18:00', 1, 1, 1),
(21, 'ki-oecosystem-mittelstand', 'Wie messe ich den Erfolg der AI-Экосистема?', 'Tägliche Reports direkt in Telegram: Konversionsraten nach Kanälen, Lead-Qualität, Mitarbeiter-Effizienz, Website-Performance. Excel-Export für detaillierte Analysen. Sie sehen schwarz auf weiß: mehr Anfragen, schnellere Bearbeitung, zufriedenere Kunden. Messbare Ergebnisse statt Bauchgefühl.', 'de', NULL, '2025-08-30 10:19:00', '2025-08-30 10:19:00', 1, 1, 1),
(22, 'ki-oecosystem-mittelstand', 'Welchen Support erhalte ich nach der Einrichtung?', 'Vollumfänglicher deutscher Support: Telegram-Chat für schnelle Fragen, Telefon-Support bei komplexeren Themen, regelmäßige Updates und neue Features automatisch. Unser Team kennt die Besonderheiten des deutschen Mittelstands und unterstützt Sie langfristig beim digitalen Wachstum.', 'de', NULL, '2025-08-30 10:20:00', '2025-08-30 10:20:00', 1, 1, 1),
(23, 'ki-oecosystem-mittelstand', 'Was ist wenn mir die Lösung nicht gefällt?', 'Kostenloser 30-Tage-Pilot ohne Verpflichtungen. Testen Sie alle Funktionen ausgiebig. Sollten Sie nicht zufrieden sein, können Sie jederzeit kündigen. Ihre Daten erhalten Sie vollständig zurück. Wir sind überzeugt von unserem Produkt und möchten nur zufriedene Langzeit-Kunden.', 'de', NULL, '2025-08-30 10:21:00', '2025-08-30 10:21:00', 1, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `form_fields`
--

CREATE TABLE `form_fields` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `field_name` varchar(255) NOT NULL,
  `field_value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `invite`
--

CREATE TABLE `invite` (
  `id` int(11) NOT NULL,
  `invitee_nick` varchar(255) NOT NULL,
  `invitee_name` varchar(255) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `organization_name` varchar(255) NOT NULL,
  `inviter_id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `leads`
--

CREATE TABLE `leads` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `status` enum('new','in_progress','waiting','closed') DEFAULT 'new',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `notification_log`
--

CREATE TABLE `notification_log` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `telegram_id` bigint(20) NOT NULL,
  `entity_type` enum('lead','ticket','task') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` int(11) NOT NULL,
  `notification_type` enum('new_entity','comment','update') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'new_entity',
  `summary_confidence` decimal(3,2) DEFAULT 0.00,
  `summary_tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `response_time` int(11) DEFAULT NULL,
  `clicked_action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT current_timestamp(),
  `responded_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `organizations`
--

CREATE TABLE `organizations` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `chat_id` bigint(20) DEFAULT NULL,
  `terms_url` varchar(255) DEFAULT NULL,
  `privacy_url` varchar(255) DEFAULT NULL,
  `token` varchar(32) DEFAULT NULL,
  `bot_token` varchar(255) DEFAULT NULL,
  `model_id` varchar(100) DEFAULT NULL,
  `auto_reply_mode` enum('auto','manual') NOT NULL DEFAULT 'manual',
  `assignment_mode` enum('auto','manual') NOT NULL DEFAULT 'manual',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `level` enum('basic','pro') NOT NULL DEFAULT 'basic',
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `organizations`
--

INSERT INTO `organizations` (`id`, `name`, `chat_id`, `terms_url`, `privacy_url`, `token`, `bot_token`, `model_id`, `auto_reply_mode`, `assignment_mode`, `created_at`, `level`, `is_active`) VALUES
(1, 'BriemChainAI', NULL, NULL, NULL, '40ca43cee89000063b14faecd67429fa', '7906343235:AAEHbVU_RQyRx2QUKS1BYIPGLGZzy1y0DfU', NULL, 'manual', 'manual', '2025-04-09 15:52:29', 'pro', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `organization_sources`
--

CREATE TABLE `organization_sources` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `source_type` enum('email','phone','social','website','chat','telegram','other') NOT NULL,
  `source_value` varchar(500) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `is_confirmed` tinyint(1) DEFAULT 0,
  `confirm_token` varchar(255) DEFAULT NULL,
  `source_name` varchar(255) DEFAULT NULL,
  `source_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `has_api` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `organization_sources`
--

INSERT INTO `organization_sources` (`id`, `organization_id`, `source_type`, `source_value`, `role`, `config`, `is_confirmed`, `confirm_token`, `source_name`, `source_url`, `is_active`, `has_api`) VALUES
(1, 1, 'website', 'relanding.de', NULL, NULL, 0, NULL, 'Website relanding.de', 'relanding.de', 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `org_comments`
--

CREATE TABLE `org_comments` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `source_id` int(11) NOT NULL,
  `author_name` varchar(255) DEFAULT 'Гость',
  `author_email` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `rating` tinyint(1) DEFAULT NULL,
  `user_ip` varchar(45) DEFAULT NULL,
  `sentiment` enum('positive','neutral','negative','spam') DEFAULT 'neutral',
  `status` enum('pending','approved','rejected','spam') DEFAULT 'pending',
  `is_published` tinyint(1) DEFAULT 0,
  `telegram_message_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `outbox`
--

CREATE TABLE `outbox` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `recipient_type` enum('email','telegram','sms','chat','webhook') DEFAULT NULL,
  `recipient` varchar(255) NOT NULL,
  `sender` varchar(255) DEFAULT NULL,
  `sender_type` enum('email','telegram','sms','webhook') DEFAULT NULL,
  `subject` text DEFAULT NULL,
  `body` text DEFAULT NULL,
  `generated_by` enum('ai','human') DEFAULT 'ai',
  `status` enum('sent','queued','failed') DEFAULT 'queued',
  `created_at` datetime DEFAULT current_timestamp(),
  `client_id` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `page_views`
--

CREATE TABLE `page_views` (
  `id` int(11) NOT NULL,
  `session_id` varchar(64) NOT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `page_slug` varchar(255) NOT NULL,
  `page_title` varchar(255) DEFAULT NULL,
  `page_url` text NOT NULL,
  `time_on_page` int(11) DEFAULT 0,
  `scroll_depth` int(11) DEFAULT 0,
  `exit_intent` tinyint(1) DEFAULT 0,
  `viewed_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `prompt_profiles`
--

CREATE TABLE `prompt_profiles` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `page_slug` varchar(128) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `lang` enum('ru','de','en') DEFAULT 'ru',
  `tone` varchar(64) DEFAULT 'профессиональный',
  `brand_voice` text DEFAULT NULL,
  `static_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`static_data`)),
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `prompt_profiles`
--

INSERT INTO `prompt_profiles` (`id`, `organization_id`, `source_id`, `page_slug`, `title`, `lang`, `tone`, `brand_voice`, `static_data`, `is_active`, `created_at`) VALUES
(1, 1, 1, 'ki-oecosystem-mittelstand', 'AI-Ökosystem für Mittelstand', 'de', 'professional_accessible', 'Professionell aber zugänglich - technische Kompetenz ohne Komplexität. Fokus auf praktische Lösungen für KMU mit 15-100 Mitarbeitern. Betonung von Compliance, ROI und einfacher Bedienung.', '{\"target_audience\": \"Mittelstand KMU 15-100 Mitarbeiter\", \"key_regions\": \"NRW, Baden-Württemberg, Bayern\", \"industries\": [\"Immobilien\", \"Produktion\", \"Handwerk\", \"Steuerberatung\", \"Medizin\"], \"decision_makers\": \"Geschäftsführer, IT-Leiter, Inhaber 35-50 Jahre\", \"budget_range\": \"8000-25000 EUR setup, 300-800 EUR/Monat\"}', 1, '2025-08-30 13:51:45');

-- --------------------------------------------------------

--
-- Структура таблицы `prompt_templates`
--

CREATE TABLE `prompt_templates` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `page_slug` varchar(128) DEFAULT NULL,
  `intent_id` int(11) NOT NULL,
  `version` varchar(16) DEFAULT 'v1',
  `system_prompt` mediumtext DEFAULT NULL,
  `few_shots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`few_shots`)),
  `output_format` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`output_format`)),
  `guardrails` text DEFAULT NULL,
  `default_action` varchar(32) DEFAULT NULL,
  `priority` tinyint(4) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `conversion_rate` decimal(5,2) DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `queue_tasks`
--

CREATE TABLE `queue_tasks` (
  `id` int(11) NOT NULL,
  `script_name` varchar(50) NOT NULL,
  `request_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `status` enum('waiting','processing','completed','failed') DEFAULT 'waiting',
  `priority` enum('high','medium','low') DEFAULT 'medium',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `render_cache`
--

CREATE TABLE `render_cache` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `domain` varchar(255) NOT NULL,
  `page_slug` varchar(100) DEFAULT NULL,
  `language` varchar(10) NOT NULL DEFAULT 'ru',
  `device_type` enum('mobile','desktop') NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `render_cache`
--

INSERT INTO `render_cache` (`id`, `domain`, `page_slug`, `language`, `device_type`, `data`, `created_at`, `updated_at`) VALUES
(1, 'relanding.de', 'ki-oecosystem-mittelstand', 'de', 'desktop', '{\r\n  \"domain\": \"relanding.de\",\r\n  \"page_slug\":\"ki-oecosystem-mittelstand\",\r\n  \"type\":\"landing\",\r\n  \"deviceType\":\"desktop\",\r\n  \"brand\":\"ReLanding<span> | Mobile Geschäftsführung</span>\",\r\n  \"slogan\":\"Ihr Business in einem Telefon\",\r\n  \"f_brand\":\"BriemChainAI\",\r\n  \"developerName\":\"\",\r\n  \"developerLink\":\"\",\r\n  \"phone1\":\"\",\r\n  \"activeLevel\":0,\r\n  \"levels\": [\r\n    {\r\n      \"title\": \"KI-Ökosystem für Mittelstand\",\r\n      \"nav_title\": \"KI-Ökosystem\",\r\n      \"slug\": \"\",\r\n      \"meta_title\": \"\",\r\n      \"meta\": \"\",\r\n      \"scrFull\": \"full\",\r\n      \"activeScreen\":0,\r\n      \"screens\": [\r\n        {\r\n          \"slug\": \"ki-oekosystem-mittelstand\",\r\n          \"rating\": \"\",\r\n          \"img_pos\": \"center\",\r\n          \"text_pos\": \"center\",\r\n          \"dataIds\": [\"1\"],\r\n          \"textId\": \"101\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"0\"\r\n        }\r\n      ]\r\n    },\r\n    {\r\n      \"title\": \"IT-Herausforderungen\",\r\n      \"nav_title\": \"IT-Herausforderungen\",\r\n      \"slug\": \"it-probleme-mittelstand\",\r\n      \"meta_title\": \"Erfahren Sie die 6 zentralen IT-Herausforderungen von KMU: Cybersicherheit, Fachkräftemangel, veraltete Systeme, fehlende Digitalstrategie, Compliance-Unsicherheit und hohe IT-Kosten. Unsere AI-gestützte Ekosystem-Lösung automatisiert CRM, Websites, Landings und Chats – einfach und GDPR-konform.\",\r\n      \"scrFull\":\"\",\r\n      \"activeScreen\":0,\r\n      \"screens\": [\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"IT-Sicherheit & Cyberbedrohungen\",\r\n          \"img_pos\": \"\",\r\n          \"text_pos\": \"\",\r\n          \"dataIds\": [\"21\"],\r\n          \"textId\": \"201\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"0\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Fachkräftemangel & IT-Expertise\",\r\n          \"img_pos\": \"\",\r\n          \"text_pos\": \"\",\r\n          \"dataIds\": [\"26\"],\r\n          \"textId\": \"202\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"1\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Veraltete IT-Infrastrukturen\",\r\n          \"img_pos\": \"\",\r\n          \"text_pos\": \"\",\r\n          \"dataIds\": [\"31\"],\r\n          \"textId\": \"203\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"2\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Digitalisierung ohne Strategie\",\r\n          \"img_pos\": \"\",\r\n          \"text_pos\": \"\",\r\n          \"dataIds\": [\"36\"],\r\n          \"textId\": \"204\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"3\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Compliance & Rechtsunsicherheit\",\r\n          \"img_pos\": \"\",\r\n          \"text_pos\": \"\",\r\n          \"dataIds\": [\"41\"],\r\n          \"textId\": \"205\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"4\"\r\n        }\r\n      ]\r\n    },\r\n    {\r\n      \"title\": \"4 KI-Produkte für Mittelstand\",\r\n      \"nav_title\": \"Produkt\",\r\n      \"slug\": \"\",\r\n      \"meta_title\": \"\",\r\n      \"meta\": \"\",\r\n      \"scrFull\": \"full\",\r\n      \"activeScreen\":0,\r\n      \"screens\": [\r\n        {\r\n          \"slug\": \"ki-crm-mittelstand\",\r\n          \"nav_title\": \"AI-CRM Profi\",\r\n          \"dataIds\": [\"10003\"],\r\n          \"textId\": \"301\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"0\"\r\n        },\r\n        {\r\n          \"slug\": \"ki-website-mittelstand\",\r\n          \"nav_title\": \"Intelligente Website-Lösung\",\r\n          \"dataIds\": [\"10006\"],\r\n          \"textId\": \"302\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"1\"\r\n        },\r\n        {\r\n          \"slug\": \"ki-landing-mittelstand\",\r\n          \"nav_title\": \"Hochkonvertierende Landing-Pages\",\r\n          \"dataIds\": [\"10011\"],\r\n          \"textId\": \"303\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"2\"\r\n        },\r\n        {\r\n          \"slug\": \"ki-chatbot-mittelstand\",\r\n          \"nav_title\": \"Automatisierter Kundenservice\",\r\n          \"dataIds\": [\"10061\"],\r\n          \"textId\": \"304\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"3\"\r\n        }\r\n      ]\r\n    },\r\n    {\r\n      \"title\": \"Stufenweise Integration\",\r\n      \"nav_title\": \"Integration\",\r\n      \"slug\": \"stufenweise-integration-ai-oekosystem\",\r\n      \"meta_title\": \"Entdecken Sie die modulare Integration unserer AI-Ökosystem (CRM, Website, Landing Page, Chatbot) für KMU. Stufenweise Implementierung mit DATEV-Anbindung, GDPR-Compliance und Telegram-Management – einfach, rechtssicher und ROI-stark.\",\r\n      \"meta\": \"\",\r\n      \"scrFull\": \"\",\r\n      \"activeScreen\":0,\r\n      \"screens\": [\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Analyse und Vorbereitung\",\r\n          \"dataIds\": [\"61\"],\r\n          \"textId\": \"401\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"0\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Anschluss der Module\",\r\n          \"dataIds\": [\"66\"],\r\n          \"textId\": \"402\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"1\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Integration und Automatisierung\",\r\n          \"dataIds\": [\"71\"],\r\n          \"textId\": \"403\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"2\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Testen und Pilot\",\r\n          \"dataIds\": [\"76\"],\r\n          \"textId\": \"404\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"3\"\r\n        },\r\n        {\r\n          \"slug\": \"\",\r\n          \"nav_title\": \"Skalierung\",\r\n          \"dataIds\": [\"91\"],\r\n          \"textId\": \"407\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"5\"\r\n        }\r\n      ]\r\n    },\r\n    {\r\n      \"title\": \"Intelligent upgraden\",\r\n      \"nav_title\": \"Trade-In Angebot\",\r\n      \"slug\": \"\",\r\n      \"meta_title\": \"\",\r\n      \"meta\": \"\",\r\n      \"scrFull\": \"full\",\r\n      \"activeScreen\":0,\r\n      \"screens\": [\r\n        {\r\n          \"slug\": \"trade-in-ai-system-upgrade\",\r\n          \"rating\": \"\",\r\n          \"img_pos\": \"center\",\r\n          \"text_pos\": \"center\",\r\n          \"dataIds\": [\"1056\"],\r\n          \"textId\": \"601\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"0\"\r\n        }\r\n      ]\r\n    },\r\n    {\r\n      \"title\": \"ReLanding | Team\",\r\n      \"nav_title\": \"Team\",\r\n      \"slug\": \"\",\r\n      \"meta_title\": \"\",\r\n      \"meta\": \"\",\r\n      \"scrFull\": \"full\",\r\n      \"activeScreen\":0,\r\n      \"screens\": [\r\n        {\r\n          \"slug\": \"ueber-relanding-team\",\r\n          \"rating\": \"\",\r\n          \"dataIds\": [\"1057\"],\r\n          \"textId\": \"701\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"0\"\r\n        }\r\n      ]\r\n    },\r\n    {\r\n      \"title\": \"Erfolg bestimmen\",\r\n      \"nav_title\": \"Jetzt starten\",\r\n      \"slug\": \"\",\r\n      \"meta_title\": \"\",\r\n      \"meta\": \"\",\r\n      \"scrFull\": \"full\",\r\n      \"activeScreen\":0,\r\n      \"screens\": [\r\n        {\r\n          \"slug\": \"entscheidung-ai-oekosystem-starten\",\r\n          \"rating\": \"\",\r\n          \"img_pos\": \"center\",\r\n          \"text_pos\": \"center\",\r\n          \"dataIds\": [\"1058\"],\r\n          \"textId\": \"801\",\r\n          \"style_id\": \"\",\r\n          \"display_order\":\"0\"\r\n        }\r\n      ]\r\n    }\r\n  ],\r\n  \r\n  \"1\": {\"type\": \"image\", \r\n    \"path\": \"ki-oekosystem-mittelstand-dashboard.webp\", \r\n    \"m_path\": \"ki-oekosystem-mittelstand-dashboard-mobile.webp\", \r\n    \"name\": \"Dashboard der KI-Ökosystem Plattform mit CRM, Website, Landing und ChatBot Modulen.\"},\r\n\r\n  \"101\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"KI-Ökosystem für KMU - CRM + Website + ChatBot | MVP Ecosystem\",\r\n    \"meta_title\": \"Komplette KI-Digitalisierung für deutsche KMU: 4 Systeme in 1 Plattform. 40% mehr Leads, GDPR-konform, Telegram-Steuerung. 30 Tage kostenlos testen.\",\r\n    \"meta\": [],\r\n    \"figcaption\": [\"\"],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Unser KI-Ökosystem automatisiert Ihr KMU: CRM, Website, Chatbot – einfach, rechtssicher, mobil\",\r\n    \"title\": \"Mehr Leads, weniger Aufwand\",\r\n    \"benefits\": \"<li>40-60% mehr Leads</li><li>10-15 Std. Zeitersparnis</li><li>GDPR/AI Act konform</li><li>Mobile Steuerung via Telegram</li>\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<section><h4 class=\'panel-highline\'>Automatisierung, Effizienz, ROI - Warum deutsche KMU digitale Lösungen benötigen</h4><div class=\'panel-wrap act\'><p>74% der deutschen KMU haben digitalen Nachholbedarf. Unser AI-Ökosystem automatisiert 90% der Kundeninteraktionen und steigert die Lead-Generierung um durchschnittlich 40-60% im ersten Jahr.</p><ul class=\'panel-grid\'><li><strong>Zeit sparen:</strong> 10-15 Stunden wöchentlich weniger Routinearbeit</li><li><strong>Leads sichern:</strong> Keine verlorenen Anfragen mehr durch automatische Erfassung</li><li><strong>Wachstum messbar:</strong> ROI von 300-500% bereits nach 12-15 Monaten</li><li><strong>Compliance sicher:</strong> Automatische GDPR-Einhaltung reduziert Bußgeldrisiko</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./it-probleme-mittelstand\' data-level=\'1\' data-screen=\'0\'>IT-Probleme →</a></p></div></section><section><h4 class=\'panel-highline\'>Messbare Leistung und schnelle Implementierung</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Konkrete Zahlen unserer Kunden</h5><ul class=\'panel-grid\'><li><strong>Antwortzeit:</strong> Unter 4 Stunden statt 24+ Stunden</li><li><strong>Website-Speed:</strong> Unter 0,5 Sekunden Ladezeit</li><li><strong>Lead-Steigerung:</strong> Durchschnittlich 67% mehr qualifizierte Anfragen</li><li><strong>System-Verfügbarkeit:</strong> 99,9% Uptime garantiert</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Implementierungszeiten</h5><ul class=\'panel-grid\'><li><strong>Setup:</strong> 2-4 Wochen bis zur vollständigen Integration</li><li><strong>First Value:</strong> Erste Ergebnisse nach 30 Tagen messbar</li><li><strong>Team-Training:</strong> 2 Tage bis 80% Nutzungsrate erreicht</li><li><strong>ROI-Nachweis:</strong> Positive Kapitalrendite ab dem 3. Quartal</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./stufenweise-integration-ai-oekosystem\' data-level=\'3\' data-screen=\'0\'>Stufenweise Integration →</a></p></div></section><section><h4 class=\'panel-highline\'>Technische Integration und intelligente Automatisierung</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>API-Integration und Systemverbindungen</h5><ul class=\'panel-grid\'><li><strong>DATEV-Schnittstelle:</strong> Nahtloser Import/Export von Kundendaten</li><li><strong>Excel-Kompatibilität:</strong> Bestehende Datenstrukturen bleiben erhalten</li><li><strong>Stripe-Integration:</strong> Automatische Zahlungsabwicklung</li><li><strong>Telegram-API:</strong> Zentrale Steuerung über Messenger-Interface</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>KI-Algorithmen für intelligente Klassifikation</h5><ul class=\'panel-grid\'><li><strong>Lead-Klassifizierung:</strong> Automatische Unterscheidung zwischen Anfragen, Tickets und Aufgaben</li><li><strong>Content-Generation:</strong> SEO-optimierte Inhalte in 12 Minuten erstellt</li><li><strong>Auto-Follow-up:</strong> Intelligente Nachfassautomatisierung nach 24 Stunden</li><li><strong>Performance-Analyse:</strong> Tägliche Berichte über Conversion und Lead-Qualität</li></ul></div></section><section><h4 class=\'panel-highline\'>Sicherheit und rechtliche Compliance</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>GDPR und AI Act Konformität</h5><ul class=\'panel-grid\'><li><strong>Datenschutz:</strong> Automatische Einverständniserklärungen und Datenminimierung</li><li><strong>EU-Hosting:</strong> Alle Server in Deutschland, keine Drittland-Übertragung</li><li><strong>AI Act Ready:</strong> Vollständige Dokumentation für Low-Risk KI-Anwendungen</li><li><strong>Transparenz:</strong> Nachvollziehbare Logs aller KI-Entscheidungen</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Technische Zuverlässigkeit</h5><ul class=\'panel-grid\'><li><strong>Backup-Strategie:</strong> Tägliche automatische Datensicherung</li><li><strong>Monitoring:</strong> 24/7 Systemüberwachung mit proaktiver Fehlerbehebung</li><li><strong>Verschlüsselung:</strong> End-to-End Verschlüsselung aller Datenübertragungen</li><li><strong>Support:</strong> Deutschsprachiger Expertenservice während Geschäftszeiten</li></ul></div></section><section><div class=\'panel-wrap act offer\'><h4 class=\'panel-highline offer\'>Trade-In Aktion - Systemwechsel mit 30% Ersparnis</h4><h5>Bestehende Systeme werden angerechnet</h5><p>Bei vorhandenen digitalen Lösungen gewähren wir einmalig 30% Rabatt auf die Setup-Gebühr. Diese Ersparnis gilt unabhängig davon, ob Sie bereits eine Website, ein CRM oder einen ChatBot nutzen.</p><ul class=\'panel-grid\'><li><strong>Website vorhanden:</strong> Inhalte und Design werden in unser AI-System übernommen</li><li><strong>CRM im Einsatz:</strong> Kundendaten werden verlustfrei migriert</li><li><strong>ChatBot aktiv:</strong> Bestehende Q&A-Datenbank wird integriert</li><li><strong>Mehrere Systeme:</strong> Maximale Ersparnis von 30% auf einmalige Kosten</li></ul><h5>Nahtlose Migration ohne Betriebsunterbrechung</h5><p>Unser Migrationsteam sorgt für einen reibungslosen Übergang. Ihre bestehenden Systeme bleiben während der Implementierung aktiv. Nach erfolgreicher Integration schalten wir gemeinsam auf das neue AI-Ökosystem um.</p><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'chat\'>Jetzt KI-Beratung starten →</button></div></div></section><section><h4 class=\'panel-highline\'>KI-Ökosystem — einheitliche Automatisierung für messbare Ergebnisse!</h4><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'faq\'>Häufige Fragen →</button></div></section>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"secBtnService\": \"\",\r\n    \"pageActBtn\": \"Jetzt KI-Beratung starten\",\r\n    \"btnService\": \"chat\"\r\n  },\r\n\r\n  \"21\": {\"type\": \"image\", \r\n    \"path\": \"phishing-alarm-im-büro.webp\", \r\n    \"m_path\": \"phishing-alarm-im-büro.webp\",\r\n    \"name\": \"Zwei Mitarbeiter in einem deutschen KMU diskutieren humorvoll über eine geöffnete Phishing-Mail und die Backup-Strategie, um die Dringlichkeit von IT-Sicherheit und Datenschutz im Mittelstand zu betonen.\"},\r\n  \r\n  \"26\": {\"type\": \"image\", \r\n    \"path\": \"it-expertise-dialog.webp\", \r\n    \"m_path\": \"it-expertise-dialog.webp\",\r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU scherzen über den Mangel an IT-Expertise und die Angst vor Systemausfällen, um die Herausforderungen des IT-Fachkräftemangels und der Digitalisierung im Mittelstand zu verdeutlichen.\"},\r\n  \r\n  \"31\": {\"type\": \"image\", \r\n    \"path\": \"digitalisierungs-debatte.webp\", \r\n    \"m_path\": \"digitalisierungs-debatte.webp\",\r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU diskutieren über die Kosten der IT-Modernisierung und den Verlust von Kunden durch veraltete Systeme, um die Notwendigkeit der Digitalisierung im Mittelstand hervorzuheben.\"},\r\n  \r\n  \"36\": {\"type\": \"image\", \r\n    \"path\": \"roadmap-humor.webp\", \r\n    \"m_path\": \"roadmap-humor.webp\",\r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU scherzen über die Notwendigkeit einer IT-Roadmap, wobei eine skizzierte Planung auf einem Bierdeckel die pragmatische Herangehensweise an Digitalisierung und Modernisierung im Mittelstand verdeutlicht.\"},\r\n  \r\n  \"41\": {\"type\": \"image\", \r\n    \"path\": \"gdpr-lachen.webp\", \r\n    \"m_path\": \"gdpr-lachen.webp\", \r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU lachen über die Herausforderungen mit GDPR-Strafen und scherzen über die Zahlung mit Likes und Followern, um die Unsicherheiten rund um Datenschutz und Compliance im Mittelstand humorvoll darzustellen.\"},\r\n  \r\n  \"201\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"IT-Sicherheit & Cyberbedrohungen\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>55 % der KMU in Deutschland erlitten 2024 Cybersicherheitsvorfälle, was zu Datenverlusten und Strafen führt.</p><ul><li>Ransomware und Phishing gefährden CRM-Daten und Chat-Kommunikation.</li><li>GDPR-Verstöße durch ungesicherte Websites und Landings kosten teuer.</li><li>Ohne integrierte AI-Lösungen wie Chat-Bots steigt das Risiko für kleine Unternehmen.</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"serviceName\": \"\"\r\n  },\r\n  \"202\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Fachkräftemangel & IT-Expertise\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>109.000 fehlende IT-Experten zwingen KMU, ohne interne Hilfe auszukommen, was Digitalisierung blockiert.</p><ul><li>Keine Expertise für CRM-Integration oder Website-Updates verursacht Stillstand.</li><li>Outsourcing für Landing-Pages und AI-Chats wird teuer und zeitaufwendig.</li><li>Eine einheitliche Ekosystem-Lösung reduziert den Bedarf an Spezialisten.</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"serviceName\": \"\"\r\n  },\r\n  \"203\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Veraltete IT-Infrastrukturen\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>66 % der KMU kämpfen mit alten Systemen, die inkompatibel und teuer zu warten sind.</p><ul><li>Legacy-CRM und Websites laden langsam, was Kunden abschreckt.</li><li>Probleme bei der Integration von Landings und Chat-Bots behindern den Workflow.</li><li>Moderne AI-gestützte Ekosysteme modernisieren ohne hohe Kosten.</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"serviceName\": \"\"\r\n  },\r\n  \"204\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Digitalisierung ohne Strategie\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>42 % der KMU fehlt eine klare Strategie, was zu chaotischen Investitionen in IT führt.</p><ul><li>Unkoordinierte CRM, Websites und Landings verursachen Datenverluste.</li><li>AI-Chats ohne Automatisierung scheitern an manuellen Prozessen.</li><li>Eine integrierte Ekosystem-Plattform bietet eine Roadmap für Erfolg.</li></ul>\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"serviceName\": \"\"\r\n  },\r\n  \"205\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Compliance & Rechtsunsicherheit\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>58 % der KMU sind unsicher bei AI Act und GDPR, was rechtliche Risiken birgt.</p><ul><li>Datenschutzprobleme in CRM und Chat-Bots führen zu Strafen.</li><li>Websites und Landings ohne Compliance-Features gefährden den Betrieb.</li><li>Eine GDPR-konforme Ekosystem-Lösung sichert Transparenz und Schutz.</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"serviceName\": \"\"\r\n  },\r\n\r\n  \"10003\": {\"type\": \"image\", \r\n    \"path\": \"ki-crm-mittelstand-telegram-dashboard.webp\", \r\n    \"m_path\": \"ki-crm-mittelstand-telegram-dashboard-mobile.webp\",\r\n    \"name\": \"Telegram-Dashboard für KI-CRM mit Leadverteilung und automatischen Follow-ups\"},\r\n  \r\n  \"301\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"KI-CRM Mittelstand: Mobile Geschäftsführung per Telegram\",\r\n    \"meta_title\": \"KI-CRM für KMU mit Telegram-Steuerung. 3x mehr Leads, GDPR-konform, DATEV-Integration. Mobile Geschäftsführung in der Hosentasche.\",\r\n    \"meta\": [],\r\n    \"figcaptions\":[\"\"],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Omnichannel KI-CRM mit Telegram-Steuerung automatisiert 90% der Kundeninteraktionen und erhöht Leads um 40-60%\",\r\n    \"title\": \"Effiziente Mobile Geschäftsführung\",\r\n    \"benefits\": \"<li>+40% Leads</li><li>10-15 Std. Zeitersparnis</li><li>GDPR/AI Act konform</li><li>Telegram-Steuerung</li>\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<section><h4 class=\'panel-highline\'>Automatisierung, Effizienz, ROI - Warum KMU intelligente CRM-Systeme benötigen</h4><div class=\'panel-wrap act\'><p>Deutsche KMU verlieren durchschnittlich 30-40% ihrer Kundenanfragen durch chaotische Kommunikation. Unser AI-CRM automatisiert die Kundenerfassung und reduziert manuelle Bearbeitung um 10-15 Stunden pro Woche.</p><ul class=\'panel-grid\'><li><strong>Leads sichern:</strong> Automatische Erfassung aus Email, Website und Telegram</li><li><strong>Zeit sparen:</strong> KI-Klassifikation reduziert manuelle Sortierung um 80%</li><li><strong>Antworten beschleunigen:</strong> Follow-up-Automatisierung unter 4 Stunden</li><li><strong>Geschäft mobil:</strong> Komplette CRM-Steuerung über Telegram-Bot</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./it-probleme-mittelstand\' data-level=\'1\' data-screen=\'0\'>IT-Probleme →</a></p></div></section><section><h4 class=\'panel-highline\'>Messbare CRM-Performance und Implementierungsgeschwindigkeit</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Leistungskennzahlen unserer Kunden</h5><ul class=\'panel-grid\'><li><strong>Lead-Erfassung:</strong> 100% aller Anfragen automatisch dokumentiert</li><li><strong>Klassifikationsgenauigkeit:</strong> 95% korrekte KI-Kategorisierung</li><li><strong>Reaktionszeit:</strong> Durchschnittlich unter 3 Stunden statt 24+ Stunden</li><li><strong>Datenverlust:</strong> 0% durch automatische Backup-Systeme</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Setup und Betrieb</h5><ul class=\'panel-grid\'><li><strong>Installation:</strong> 2-4 Wochen inklusive DATEV-Migration</li><li><strong>Team-Onboarding:</strong> 5-7 Tage bis zur vollständigen Nutzung</li><li><strong>ROI-Zeitraum:</strong> Erste Effizienzgewinne nach 30 Tagen messbar</li><li><strong>System-Verfügbarkeit:</strong> 99,9% Uptime mit EU-Hosting</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./stufenweise-integration-ai-oekosystem\' data-level=\'3\' data-screen=\'0\'>Stufenweise Integration →</a></p></div></section><section><h4 class=\'panel-highline\'>API-Integration und intelligente Klassifikationsalgorithmen</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Nahtlose Systemintegrationen</h5><ul class=\'panel-grid\'><li><strong>DATEV-Anbindung:</strong> Bidirektionaler Import/Export von Kundenstammdaten</li><li><strong>Excel-Kompatibilität:</strong> Bestehende Tabellen werden verlustfrei übernommen</li><li><strong>Email-Integration:</strong> IMAP/POP3 für alle gängigen Provider</li><li><strong>Website-Connector:</strong> Automatische Formular-Integration über API</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>KI-Algorithmen für automatische Klassifikation</h5><ul class=\'panel-grid\'><li><strong>Lead-Erkennung:</strong> Kaufinteresse wird durch Schlüsselwörter identifiziert</li><li><strong>Ticket-Klassifizierung:</strong> Support-Anfragen automatisch kategorisiert</li><li><strong>Aufgaben-Zuordnung:</strong> Interne Requests an richtige Abteilung geleitet</li><li><strong>Telegram-Befehle:</strong> Deutsche Sprachverarbeitung für mobile Steuerung</li></ul></div></section><section><h4 class=\'panel-highline\'>Datenschutz und Enterprise-Sicherheit</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>GDPR und AI Act Compliance</h5><ul class=\'panel-grid\'><li><strong>Datenminimierung:</strong> Nur Name, Email und Anfrage werden gespeichert</li><li><strong>Einverständnis-Management:</strong> Automatische Consent-Anfragen bei Erstellung</li><li><strong>Recht auf Löschung:</strong> Telegram-Befehl \\\"Lösche Kunde ID123\\\" verfügbar</li><li><strong>KI-Transparenz:</strong> Vollständiges Logging aller automatischen Entscheidungen</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Technische Sicherheitsmaßnahmen</h5><ul class=\'panel-grid\'><li><strong>Verschlüsselung:</strong> AES-256 für alle gespeicherten Kundendaten</li><li><strong>Zugriffskontrole:</strong> Rollenbasierte Berechtigungen für 35 Mitarbeitertypen</li><li><strong>Backup-Strategie:</strong> Automatische tägliche Sicherung mit 30-Tage-Aufbewahrung</li><li><strong>Hosting-Standort:</strong> Ausschließlich deutsche Rechenzentren</li></ul></div></section><section><div class=\'panel-wrap act offer\'><h4 class=\'panel-highline offer\'>Trade-In Aktion - Bestehende CRM-Systeme werden angerechnet</h4><h5>Migration mit finanzieller Entlastung</h5><p>Bei Wechsel von einem bestehenden CRM-System gewähren wir einmalig 30% Rabatt auf die Setup-Gebühr. Diese Ersparnis gilt unabhängig vom Umfang Ihres aktuellen Systems.</p><ul class=\'panel-grid\'><li><strong>Excel-Listen:</strong> Vollständige Datenübernahme in strukturierte CRM-Felder</li><li><strong>Bestehende CRM:</strong> API-basierte Migration ohne Datenverlust</li><li><strong>DATEV-Integration:</strong> Nahtlose Übernahme aller Kundenhistorien</li><li><strong>Email-Archive:</strong> Vollständiger Import vergangener Korrespondenz</li></ul><h5>Risikofreie Umstellung</h5><p>Unser Migrationsteam führt eine Parallel-Installation durch. Ihr bestehendes System läuft weiter, bis alle Daten vollständig übertragen sind. Erst nach erfolgreicher Validierung schalten wir auf das neue AI-CRM um.</p><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'chat\'>Jetzt KI-Beratung starten →</button></div></div></section><section><h4 class=\'panel-highline\'>KI-CRM — mobile Geschäftsführung für maximale Effizienz!</h4><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'faq\'>Häufige Fragen →</button></div></section>\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"secBtnService\": \"\",\r\n    \"pageActBtn\": \"Jetzt KI-Beratung starten\",\r\n    \"btnService\": \"chat\"\r\n  },\r\n\r\n  \"10006\": {\"type\": \"image\", \r\n    \"path\": \"ki-website-mittelstand-content-management.webp\", \r\n    \"m_path\": \"ki-website-mittelstand-content-management-mobile.webp\", \r\n    \"name\": \"Telegram-gesteuerte KI-Website mit Content-Management Dashboard für KMU\"},\r\n  \r\n  \"302\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"KI-Website für KMU - 3-5x SEO-Reichweite unter 0,5s | Site\",\r\n    \"meta_title\": \"Intelligente Website für KMU: 20-40 SEO-Seiten, unter 0,5s Ladezeit, Telegram-Steuerung. KI-Content in 12 Minuten. GDPR-konform. Jetzt testen.\",\r\n    \"meta\": [],\r\n    \"figcaptions\":[\"\"],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Unsere KI-Website steigert Ihre Sichtbarkeit mit <0,5s Ladezeit und automatisiertem Content – mobil, rechtssicher, effizient\",\r\n    \"title\": \"Blitzschnell und SEO-stark\",\r\n    \"benefits\": \"<li>5x SEO-Reichweite</li><li><0,5s Ladezeit</li><li>GDPR/AI Act konform</li><li>Telegram-Management</li>\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<section><h4 class=\'panel-highline\'>Automatisierung, Effizienz, ROI - Warum KMU moderne Website-Technologie brauchen</h4><div class=\'panel-wrap act\'><p>Deutsche KMU verlieren potenzielle Kunden durch veraltete Websites mit schlechter Performance. Unsere KI-Website steigert die Sichtbarkeit um das 3-5-fache und reduziert den Content-Management-Aufwand um 90%.</p><ul class=\'panel-grid\'><li><strong>SEO-Dominanz:</strong> 20-40 spezialisierte Seiten decken Ihre gesamte Angebotspalette ab</li><li><strong>Speed-Vorteil:</strong> Unter 0,5 Sekunden Ladezeit übertrifft 95% der Konkurrenz</li><li><strong>Content-Effizienz:</strong> KI generiert professionelle Texte in 12 Minuten</li><li><strong>Mobile Steuerung:</strong> Komplettes Website-Management über Telegram-Bot</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./it-probleme-mittelstand\' data-level=\'1\' data-screen=\'0\'>IT-Probleme →</a></p></div></section><section><h4 class=\'panel-highline\'>Messbare Website-Performance und technische Spezifikationen</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Leistungskennzahlen unserer Implementierungen</h5><ul class=\'panel-grid\'><li><strong>Ladegeschwindigkeit:</strong> Durchschnittlich 0,3 Sekunden auf allen Geräten</li><li><strong>SEO-Steigerung:</strong> 200-400% mehr organische Sichtbarkeit in 6 Monaten</li><li><strong>Core Web Vitals:</strong> 100% Google-konforme Performance-Werte</li><li><strong>Mobile-Optimierung:</strong> Perfekte Darstellung auf allen Smartphone-Modellen</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Setup und Content-Management</h5><ul class=\'panel-grid\'><li><strong>Entwicklungszeit:</strong> 2-3 Wochen von Konzept bis Live-Schaltung</li><li><strong>Content-Erstellung:</strong> KI generiert Seiteninhalte in durchschnittlich 12 Minuten</li><li><strong>Wartungsaufwand:</strong> Unter 1 Stunde monatlich durch Telegram-Automatisierung</li><li><strong>Update-Geschwindigkeit:</strong> Änderungen live in unter 30 Sekunden</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./stufenweise-integration-ai-oekosystem\' data-level=\'3\' data-screen=\'0\'>Stufenweise Integration →</a></p></div></section><section><h4 class=\'panel-highline\'>KI-Content-Generation und intelligente Website-Architektur</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Automatisierte Content-Erstellung</h5><ul class=\'panel-grid\'><li><strong>Telegram-Befehle:</strong> \\\"/createContent Maschinenbau\\\" erstellt komplette Servicepage</li><li><strong>SEO-Optimierung:</strong> Automatische Meta-Tags, Strukturierte Daten, Alt-Texte</li><li><strong>Branchenspezifisch:</strong> KI kennt Terminologie für Handwerk, Beratung, Produktion</li><li><strong>Mehrsprachigkeit:</strong> Inhalte auf Deutsch mit korrekter Grammatik und Stil</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Technische Website-Architektur</h5><ul class=\'panel-grid\'><li><strong>Headless CMS:</strong> Moderne Architektur ohne WordPress-Ballast</li><li><strong>20-40 Einzelseiten:</strong> Jede Dienstleistung erhält dedizierte Landing-Page</li><li><strong>API-Integration:</strong> Nahtlose Verbindung zu CRM für Lead-Erfassung</li><li><strong>Progressive Web App:</strong> App-ähnliche Performance im Browser</li></ul></div></section><section><h4 class=\'panel-highline\'>GDPR-Compliance und technische Sicherheit</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Rechtssichere Website-Features</h5><ul class=\'panel-grid\'><li><strong>Auto-Consent:</strong> Intelligente Cookie-Banner mit GDPR-konformen Einstellungen</li><li><strong>Datenschutzerklärung:</strong> Automatisch generiert und rechtlich geprüft</li><li><strong>Impressum-Generator:</strong> Vollständige Anbieterkennzeichnung nach TMG</li><li><strong>KI-Transparenz:</strong> Kennzeichnung aller KI-generierten Inhalte</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Server-Sicherheit und Hosting</h5><ul class=\'panel-grid\'><li><strong>EU-Hosting:</strong> Ausschließlich deutsche Rechenzentren</li><li><strong>SSL-Verschlüsselung:</strong> Automatische HTTPS-Zertifikate</li><li><strong>DDoS-Schutz:</strong> Enterprise-Level Sicherheit gegen Angriffe</li><li><strong>Backup-System:</strong> Täglich automatische Sicherung aller Inhalte</li></ul></div></section><section><div class=\'panel-wrap act offer\'><h4 class=\'panel-highline offer\'>Trade-In Aktion - Bestehende Website wird angerechnet</h4><h5>Kostenersparnis durch Website-Migration</h5><p>Nutzen Sie bereits eine Website? Wir rechnen deren Wert mit 30% auf die Setup-Kosten unserer KI-Website an. Ihre bestehenden Inhalte und das Design-Investment gehen nicht verloren.</p><ul class=\'panel-grid\'><li><strong>Content-Übernahme:</strong> Bestehende Texte werden KI-optimiert und integriert</li><li><strong>Design-Migration:</strong> Corporate Design wird in moderne Performance-Architektur übertragen</li><li><strong>SEO-Bewahrung:</strong> Bestehende Rankings bleiben durch 301-Weiterleitungen erhalten</li><li><strong>Domain-Transfer:</strong> Ihre etablierte Web-Adresse bleibt unverändert</li></ul><h5>Unterbrechungsfreie Migration</h5><p>Die neue AI-Website wird parallel entwickelt. Ihre aktuelle Seite bleibt während der Entwicklung online. Der Wechsel erfolgt erst nach vollständiger Qualitätsprüfung und Ihrer Freigabe.</p><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'chat\'>Jetzt KI-Beratung starten →</button></div></div></section><section><h4 class=\'panel-highline\'>KI-Website — professionelle Web-Präsenz für maximalen Geschäftserfolg!</h4><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'faq\'>Häufige Fragen →</button></div></section>\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"secBtnService\": \"\",\r\n    \"pageActBtn\": \"Jetzt KI-Beratung starten\",\r\n    \"btnService\": \"chat\"\r\n  },\r\n\r\n  \"10011\": {\"type\": \"image\", \r\n    \"path\": \"ki-landing-mittelstand-conversion-optimizer.webp\", \r\n    \"m_path\": \"ki-landing-mittelstand-conversion-optimizer-mobile.webp\", \r\n    \"name\": \"KI-Landing Conversion Dashboard mit Telegram-Steuerung und Aktionsblöcken für KMU\"},\r\n  \r\n  \"303\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"KI-Landing für KMU - 4-8x höhere Conversion in 5 Tagen | Landing\",\r\n    \"meta_title\": \"Hochkonvertierende Landing-Page für KMU: 4-8 Aktionsblöcke, unter 0,5s Ladezeit, Telegram-Erstellung. 4-8x Conversion-Rate. Jetzt starten.\",\r\n    \"meta\": [],\r\n    \"figcaptions\":[\"\"],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Unsere KI-Landingpage steigert Leads um 40-60% mit <0,5s Ladezeit und AI-Content – mobil, rechtssicher, konversionsstark\",\r\n    \"title\": \"Höchste Conversion, einfach erstellt\",\r\n    \"benefits\": \"<li>4-8x Conversion</li><li><0,5s Ladezeit</li><li>GDPR/AI Act konform</li><li>Telegram-Steuerung</li>\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<section><h4 class=\'panel-highline\'>Automatisierung, Effizienz, ROI - Warum KMU spezialisierte Landing-Pages brauchen</h4><div class=\'panel-wrap act\'><p>Deutsche KMU verlieren bei Aktionen und Promotions bis zu 60% ihrer Interessenten durch schwache Landing-Pages. Unser KI-Landing steigert die Conversion um das 4-8-fache und erstellt professionelle Aktionsseiten in nur 12 Minuten.</p><ul class=\'panel-grid\'><li><strong>Conversion maximieren:</strong> Spezialisierte Aktionsblöcke für Handwerk, Beratung und Handel</li><li><strong>Urgency erzeugen:</strong> Countdown-Timer und limitierte Angebote steigern Abschlussrate</li><li><strong>Leads sichern:</strong> Jede Anfrage wird automatisch ins CRM übertragen</li><li><strong>Zeit sparen:</strong> Komplette Landing-Page per Telegram-Befehl in 10 Minuten erstellt</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./it-probleme-mittelstand\' data-level=\'1\' data-screen=\'0\'>IT-Probleme →</a></p></div></section><section><h4 class=\'panel-highline\'>Messbare Conversion-Performance und Erstellungsgeschwindigkeit</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Conversion-Metriken unserer Kunden</h5><ul class=\'panel-grid\'><li><strong>Durchschnittliche Conversion:</strong> 12-18% bei B2B-Aktionen (branchenüblich: 2-3%)</li><li><strong>Lead-Qualität:</strong> 85% der Anfragen werden zu qualifizierten Gesprächen</li><li><strong>Absprungrate:</strong> Unter 25% durch optimierte User Experience</li><li><strong>Mobile Conversion:</strong> 94% aller Leads kommen über Smartphone</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Erstellung und Deployment</h5><ul class=\'panel-grid\'><li><strong>Setup-Zeit:</strong> Vollständige Landing-Page in durchschnittlich 12 Minuten live</li><li><strong>A/B-Test Setup:</strong> Verschiedene Aktionsvarianten in 2 Minuten erstellt</li><li><strong>Anpassungszeit:</strong> Preise, Texte, Bilder in unter 30 Sekunden geändert</li><li><strong>Go-Live:</strong> Von Telegram-Befehl bis funktionierender Landing-Page unter 5 Minuten</li></ul></div></section><section><h4 class=\'panel-highline\'>KI-Conversion-Optimierung und intelligente Aktionsblöcke</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Automatisierte Landing-Page-Erstellung</h5><ul class=\'panel-grid\'><li><strong>Telegram-Befehle:</strong> \\\"/createAction Sanitär Winteraktion\\\" generiert komplette Landing-Page</li><li><strong>Branchenspezifisch:</strong> Optimierte Vorlagen für Handwerk, Immobilien, Beratung, Produktion</li><li><strong>Urgency-Automatik:</strong> Countdown-Timer, Lagerbestände und limitierte Angebote</li><li><strong>CTA-Optimierung:</strong> KI wählt die besten Call-to-Action-Texte für Ihre Zielgruppe</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Intelligente Conversion-Blöcke</h5><ul class=\'panel-grid\'><li><strong>Hero-Section:</strong> Emotionale Ansprache mit klarer Wertversprechen</li><li><strong>Vertrauen schaffen:</strong> Referenzen, Zertifikate, Kundenbewertungen automatisch eingebunden</li><li><strong>Preis-Anker:</strong> Psychologisch optimierte Preisdarstellung mit Rabatt-Mechanismen</li><li><strong>Formulare:</strong> GDPR-konforme Kontakterfassung mit minimalen Eingabefeldern</li></ul></div></section><section><h4 class=\'panel-highline\'>GDPR-konforme Lead-Erfassung und Datenschutz</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Rechtssichere Aktions-Landing-Pages</h5><ul class=\'panel-grid\'><li><strong>Auto-Consent:</strong> Intelligente Einverständniserklärungen für alle Formulare</li><li><strong>Datenminimierung:</strong> Nur Name, Telefon und Interesse werden erfasst</li><li><strong>Widerrufsrecht:</strong> Automatische Opt-out-Möglichkeiten in jeder Kommunikation</li><li><strong>KI-Kennzeichnung:</strong> Transparente Markierung aller KI-generierten Inhalte</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Performance und Sicherheit</h5><ul class=\'panel-grid\'><li><strong>Ladegeschwindigkeit:</strong> Unter 0,4 Sekunden auf allen Geräten</li><li><strong>Mobile-First:</strong> Optimiert für Smartphone-Nutzung (94% der Zugriffe)</li><li><strong>SSL-Verschlüsselung:</strong> Sichere Datenübertragung aller Formulareingaben</li><li><strong>EU-Hosting:</strong> Server ausschließlich in deutschen Rechenzentren</li></ul></div></section><section><div class=\'panel-wrap act offer\'><h4 class=\'panel-highline offer\'>Trade-In Aktion - Bestehende Marketing-Materialien werden angerechnet</h4><h5>Vorhandene Aktionsmaterialien optimal nutzen</h5><p>Haben Sie bereits Flyer, Prospekte oder Online-Werbung? Wir rechnen deren Erstellungskosten mit 30% auf unsere Landing-Page-Entwicklung an. Ihre Investitionen in Grafikdesign und Texte gehen nicht verloren.</p><ul class=\'panel-grid\'><li><strong>Design-Integration:</strong> Bestehende Corporate Identity wird perfekt übernommen</li><li><strong>Content-Recycling:</strong> Flyer-Texte werden für Online-Conversion optimiert</li><li><strong>Bild-Integration:</strong> Professionelle Produktfotos werden hochauflösend eingebunden</li><li><strong>Kampagnen-Synchronisation:</strong> Print- und Online-Aktionen perfekt abgestimmt</li></ul><h5>Schnelle Umsetzung ohne Verzögerung</h5><p>Während wir Ihre neue KI-Landing entwickeln, können Sie Ihre bisherigen Aktionen normal weiterführen. Der Wechsel erfolgt nahtlos - bestehende Links und QR-Codes funktionieren weiter.</p><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'chat\'>Jetzt KI-Beratung starten →</button></div></div></section><section><h4 class=\'panel-highline\'>KI-Landing — maximale Conversion für erfolgreiche Aktionen!</h4><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'faq\'>Häufige Fragen →</button></div></section>\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"secBtnService\": \"\",\r\n    \"pageActBtn\": \"Jetzt KI-Beratung starten\",\r\n    \"btnService\": \"chat\"\r\n  },\r\n\r\n  \"10061\": {\"type\": \"image\", \r\n    \"path\": \"ki-chatbot-mittelstand-kundenservice-automation.webp\", \r\n    \"m_path\": \"ki-chatbot-mittelstand-kundenservice-automation-mobile.webp\", \r\n    \"name\": \"KI-ChatBot Interface mit 24/7 Kundenbetreuung und Telegram-Integration für KMU\"},\r\n  \r\n  \"304\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"KI-ChatBot für KMU - 24/7 Kundenservice mit 90% Automatisierung\",\r\n    \"meta_title\": \"Intelligenter ChatBot für KMU: 50 Q&A Wissensbasis, unter 10s Antwortzeit, Telegram-Steuerung. 90% Anfragen automatisch. GDPR-konform. Jetzt einbauen.\",\r\n    \"meta\": [],\r\n    \"figcaptions\":[\"\"],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Unser KI-Chatbot automatisiert 90% Ihrer Kundenanfragen, steigert Leads um 40-60% – mobil, rechtssicher, einfach\",\r\n    \"title\": \"Schnelle Antworten, hohe Conversion\",\r\n    \"benefits\": \"<li>+40-60% Leads</li><li><10s Antwortzeit</li><li>GDPR/AI Act konform</li><li>Telegram-Steuerung</li>\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<section><h4 class=\'panel-highline\'>Automatisierung, Effizienz, ROI - Warum KMU intelligente Chat-Systeme benötigen</h4><div class=\'panel-wrap act\'><p>Deutsche KMU verlieren durchschnittlich 30-40% ihrer Website-Besucher durch fehlende Sofort-Beratung. Unser KI-ChatBot automatisiert 90% der ersten Kundenberatung und reduziert den manuellen Support-Aufwand um bis zu 15 Stunden pro Woche.</p><ul class=\'panel-grid\'><li><strong>24/7 Verfügbarkeit:</strong> Kunden erhalten sofortige Antworten auch außerhalb der Geschäftszeiten</li><li><strong>Lead-Generation:</strong> Automatische Kontakterfassung bei qualifizierten Interessenten</li><li><strong>Entlastung des Teams:</strong> Wiederkehrende Fragen werden vollautomatisch beantwortet</li><li><strong>Conversion steigern:</strong> Sofortige Beratung erhöht Abschlusswahrscheinlichkeit um 40-60%</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./it-probleme-mittelstand\' data-level=\'1\' data-screen=\'0\'>IT-Probleme →</a></p></div></section><section><h4 class=\'panel-highline\'>Messbare Chat-Performance und Implementierungsgeschwindigkeit</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Leistungskennzahlen unserer ChatBot-Installationen</h5><ul class=\'panel-grid\'><li><strong>Automatisierungsgrad:</strong> 92% aller Anfragen ohne menschliche Intervention beantwortet</li><li><strong>Antwortgeschwindigkeit:</strong> Durchschnittlich 6 Sekunden bis zur ersten ChatBot-Antwort</li><li><strong>Kundenzufriedenheit:</strong> 87% bewerten die ChatBot-Beratung als hilfreich oder sehr hilfreich</li><li><strong>Lead-Conversion:</strong> 34% mehr qualifizierte Anfragen durch proaktive Chat-Unterstützung</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Installation und Wartung</h5><ul class=\'panel-grid\'><li><strong>Setup-Zeit:</strong> Vollständige ChatBot-Implementation in bestehende Website binnen 1-2 Werktagen</li><li><strong>Wissensbasis-Setup:</strong> 50 Q&A-Paare in durchschnittlich 2 Stunden konfiguriert</li><li><strong>Wartungsaufwand:</strong> Unter 30 Minuten monatlich für Wissensbasis-Updates</li><li><strong>Mobile Steuerung:</strong> Vollständige ChatBot-Verwaltung über Telegram-Commands</li></ul><p class=\'panel-btn-wrap\'><a class=\'panel-btn\' href=\'./stufenweise-integration-ai-oekosystem\' data-level=\'3\' data-screen=\'0\'>Stufenweise Integration →</a></p></div></section><section><h4 class=\'panel-highline\'>KI-Klassifizierung und intelligente Gesprächsführung</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Automatisierte Kundeninteraktion</h5><ul class=\'panel-grid\'><li><strong>Intelligente Klassifizierung:</strong> KI unterscheidet zwischen Informationsanfragen und Verkaufschancen</li><li><strong>Branchenspezifische Antworten:</strong> Vorkonfigurierte Templates für Handwerk, Beratung, Immobilien</li><li><strong>Eskalations-Management:</strong> Komplexe Anfragen werden automatisch an Telegram weitergeleitet</li><li><strong>Kontakterfassung:</strong> GDPR-konforme Sammlung von Namen, Telefon und Anfrage-Details</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Technische ChatBot-Integration</h5><ul class=\'panel-grid\'><li><strong>JavaScript-Modul:</strong> Ein-Zeilen-Integration ohne WordPress oder CMS-Abhängigkeiten</li><li><strong>Responsive Design:</strong> Optimale Darstellung auf Desktop, Tablet und Smartphone</li><li><strong>CRM-Anbindung:</strong> Alle Chat-Leads werden automatisch ins CRM-System übertragen</li><li><strong>Analytics:</strong> Detaillierte Berichte über Chat-Nutzung und Conversion-Rates</li></ul></div></section><section><h4 class=\'panel-highline\'>GDPR-konforme Chat-Erfassung und Datenschutz</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Rechtssichere ChatBot-Implementierung</h5><ul class=\'panel-grid\'><li><strong>Auto-Consent:</strong> Automatische Einverständniserklärung vor Kontaktdatenerfassung</li><li><strong>Datenminimierung:</strong> Speicherung nur von Name, Kontakt und konkreter Anfrage</li><li><strong>Transparenz-Logging:</strong> Alle KI-Entscheidungen werden nachvollziehbar dokumentiert</li><li><strong>Löschungsrecht:</strong> Telegram-Befehl \\\"Lösche Chat ID123\\\" für GDPR-Compliance</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Hosting und Sicherheitsstandards</h5><ul class=\'panel-grid\'><li><strong>EU-Server:</strong> Hosting ausschließlich in deutschen Rechenzentren</li><li><strong>Verschlüsselte Übertragung:</strong> Alle Chat-Nachrichten SSL-verschlüsselt</li><li><strong>Backup-System:</strong> Täglich automatische Sicherung der Wissensbasis</li><li><strong>Uptime-Garantie:</strong> 99,8% Verfügbarkeit mit redundanten Servern</li></ul></div></section><section><div class=\'panel-wrap act offer\'></div><h4 class=\'panel-highline offer\'>Trade-In Aktion - Bestehende Chat-Lösungen werden angerechnet</h4><h5>Migration mit Kostenvorteil</h5><p>Nutzen Sie bereits einen ChatBot oder Live-Chat? Wir rechnen dessen Setup-Kosten mit 30% auf unsere KI-ChatBot-Implementierung an. Ihre bestehende Wissensbasis und Chat-Historie geht nicht verloren.</p><ul class=\'panel-grid\'><li><strong>Wissensbasis-Transfer:</strong> Bestehende FAQ werden automatisch in unser 50 Q&A-System übertragen</li><li><strong>Design-Integration:</strong> ChatBot-Widget passt sich Ihrem Corporate Design an</li><li><strong>Chat-Historie:</strong> Wichtige Kundeninteraktionen werden ins neue System migriert</li><li><strong>Mitarbeiter-Schulung:</strong> Kostenlose Einweisung in Telegram-Steuerung inklusive</li></ul><h5>Parallelbetrieb während Migration</h5><p>Der neue KI-ChatBot wird zunächst parallel zu Ihrem bestehenden System getestet. Erst nach erfolgreicher Validierung und Ihrer Freigabe erfolgt die vollständige Umstellung. Kein Risiko für Ihren laufenden Kundenservice.</p><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'chat\'>Jetzt KI-Beratung starten →</button></div></section><section><h4 class=\'panel-highline\'>KI-ChatBot — intelligenter Kundenservice für maximale Kundenzufriedenheit!</h4><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'faq\'>Häufige Fragen →</button></div></section>\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"secBtnService\": \"\",\r\n    \"pageActBtn\": \"Jetzt KI-Beratung starten\",\r\n    \"btnService\": \"chat\"\r\n  },\r\n\r\n  \"61\": {\"type\": \"image\", \r\n    \"path\": \"integration-digitalstart-humor.webp\", \r\n    \"m_path\": \"integration-digitalstart-humor.webp\", \r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU diskutieren humorvoll über den Start der Digitalisierung mit Analyse und Vorbereitung, wobei sie das Übergangsszenario vom Chaos zum geordneten Chaos im Mittelstand beleuchten.\"},\r\n  \r\n  \"66\": {\"type\": \"image\", \r\n    \"path\": \"integration-flexibel-lachen.webp\", \r\n    \"m_path\": \"integration-flexibel-lachen.webp\", \r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU scherzen über flexible und modulare IT-Lösungen, wobei eine humorvolle Anspielung auf Ausreden bei Deadlines die pragmatische Arbeitsweise im Mittelstand unterstreicht.\"},\r\n  \r\n  \"71\": {\"type\": \"image\", \r\n    \"path\": \"integration-bot-humor-telegram.webp\", \r\n    \"m_path\": \"integration-bot-humor-telegram.webp\", \r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU scherzen über einen Bot, der alles per Telegram steuert, einschließlich humorvoller Anspielungen auf Kaffeebestellungen, um die moderne Automatisierung und Digitalisierung im Mittelstand zu beleuchten.\"},\r\n  \r\n  \"76\": {\"type\": \"image\", \r\n    \"path\": \"integration-telegram-schulung-lachen.webp\", \r\n    \"m_path\": \"integration-telegram-schulung-lachen.webp\", \r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU scherzen über eine Schulung mit einem Telegram-Bot, der sogar einfache IT-Grundlagen erklärt, um die humorvolle Seite der Digitalisierung und Mitarbeiterschulung im Mittelstand zu verdeutlichen.\"},\r\n  \r\n  \"91\": {\"type\": \"image\", \r\n    \"path\": \"integration-ai-multisprache-humor.webp\", \r\n    \"m_path\": \"integration-ai-multisprache-humor.webp\", \r\n    \"name\": \"Zwei Kollegen in einem deutschen KMU scherzen über erweiterte Analytik, Mehrsprachigkeit und AI-Aktionen, wobei eine humorvolle Anspielung auf einen englischsprachigen Drucker die innovative Digitalisierung im Mittelstand verdeutlicht.\"},\r\n  \r\n  \"401\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Analyse und Vorbereitung: Ihr Start in die Digitalisierung\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>Wir analysieren Ihren Betrieb: Website, Kommunikation, CRM (z.B. DATEV/Excel) und Pain Points wie verlorene Leads. Anschließend erstellen wir ein maßgeschneidertes MVP-Konzept für CRM, Website, Landing oder Chatbot – Start in <30 Tagen.</p><ul><li>Bedarfsanalyse für KMU (15-100 Mitarbeiter)</li><li>Schnelles MVP für Branchen wie Handwerk oder Immobilien</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"btnService\": \"\"\r\n  },\r\n  \"402\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Modul-Anschluss: Schnelle Systemintegration\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>Wir verbinden die Module Ihrer AI-Ökosystem ohne Ausfallzeiten – modular und flexibel.</p><ul><li>AI-CRM: Kundenimport, Kanäle (E-Mail, Telegram, Website)</li><li>AI-Website: 20-40 SEO-Seiten für mehr Traffic</li><li>AI-Landing: 5-10 Blöcke für Aktionen mit hoher Konversion</li><li>AI-Chatbot: JS-Modul mit 50 Q&A, verknüpft mit CRM</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"btnService\": \"\"\r\n  },\r\n  \"403\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Automatisierung: Telegram und DATEV im Fokus\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>Ein Telegram-Bot steuert alles auf Deutsch: „Zeige Anfragen“ oder „Erstelle Aktion“. AI automatisiert Lead-Klassifikation, Follow-ups und Berichte.</p><ul><li>DATEV/Excel-Integration für nahtlosen Datentransfer</li><li>GDPR-Compliance: Consent, Data Minimization, Transparenz</li><li>Stripe/PayPal für Zahlungen</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"btnService\": \"\"\r\n  },\r\n  \"404\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Pilot und Test: Agile Einführung\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>Ein 30-tägiger Pilot testet Geschwindigkeit (<4h Reaktion), Lead-Wachstum (+40-60%) und Chatbot-Effizienz.</p><ul><li>Schulungen über Telegram-Bot für >80% User Adoption</li><li>Change Management gegen interne Widerstände</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"btnService\": \"\"\r\n  },\r\n  \"407\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"\",\r\n    \"meta_title\": \"\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"\",\r\n    \"title\": \"Skalierung: Wachstum ohne Komplexität\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<p>Nach dem Pilot erweitern wir: mehr Analytik, Multi-Sprach-Support, AI-Aktionen.</p><ul><li>KPIs: NPS >40, 10-15h Zeitersparnis/Woche</li><li>Deutscher Support, flexible Raten, ROI in 8-15 Monaten</li><li>Branchenspezifische Anpassungen (z.B. Steuerberater)</li></ul>\",\r\n    \"m_text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"\",\r\n    \"btnService\": \"\"\r\n  },\r\n\r\n  \"1056\": {\"type\": \"image\", \r\n    \"path\": \"trade-in-ki-system-upgrade-exchange.webp\", \r\n    \"m_path\": \"trade-in-ki-system-upgrade-exchange-mobile.webp\", \r\n    \"name\": \"Austausch alter Systeme gegen KI-Lösung mit 30% Rabatt\"},\r\n\r\n  \"601\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"Trade-In: KI-System tauschen & 30% sparen | KI-Ökosystem\",\r\n    \"meta_title\": \"Tauschen Sie alte Website, CRM oder Chatbot gegen moderne KI-Lösung. 30% Rabatt beim Wechsel zu unserem KI-Ökosystem.\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Modernisieren Sie Ihre digitale Infrastruktur intelligent – mit unserem Trade-In Programm erhalten Sie 30% Rabatt beim Wechsel\",\r\n    \"title\": \"Smart Upgrade: Aus Alt wird KI-Power mit 30% Ersparnis\",\r\n    \"benefits\": \"<li>30% Rabatt garantiert</li><li>Sofortige Modernisierung</li><li>Alle Module verfügbar</li><li>Keine Altlast-Probleme</li>\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"secBtnService\": \"\",\r\n    \"pageActBtn\": \"Trade-In berechnen\",\r\n    \"btnService\": \"chat\"\r\n  },\r\n\r\n  \"1057\": {\"type\": \"image\", \r\n    \"path\": \"briemchainai-team-walter-viktoria-briem-ki-loesungen.webp\", \r\n    \"m_path\": \"briemchainai-team-walter-viktoria-briem-ki-loesungen-mobile.webp\", \r\n    \"name\": \"Walter und Viktoria Briem, KI-Lösungen von BriemChainAI für deutsche KMU\"},\r\n\r\n  \"701\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"Über ReLanding - Walter & Viktoria Briem | KI-Lösungen für KMU\",\r\n    \"meta_title\": \"ReLanding: Walter & Viktoria Briem entwickeln KI-Automatisierung für deutsche KMU. Geschwisterteam mit 16 Jahren Recht und Webentwicklung seit 2015.\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Walter und Viktoria Briem vereinfachen Geschäftsprozesse und steigern digitale Reichweite\",\r\n    \"title\": \"Gemeinsam entwickelt - Technologie und Recht in einer Familie\",\r\n    \"benefits\": \"\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"<section><h4 class=\'panel-highline\'>Technologie und Recht vereint - Warum wir KI-Lösungen für deutsche KMU entwickeln</h4><div class=\'panel-wrap act\'><p>Als Familienunternehmen bringen Walter und Viktoria Briem unterschiedliche Fachbereiche zusammen, um durchdachte KI-Automatisierung zu schaffen. Unsere gemeinsame Vision ist es, künstliche Intelligenz für kleine und mittelständische Unternehmen zugänglich zu machen, ohne dabei die rechtliche Sicherheit aus den Augen zu verlieren.</p><ul class=\'panel-grid\'><li><strong>Durchdachte KI-Tools:</strong> Künstliche Intelligenz, die speziell für mittelständische Unternehmen entwickelt wird</li><li><strong>Vereinfachte Prozesse:</strong> Automatisierung von Geschäftsabläufen ohne komplizierte technische Integration</li><li><strong>Kostenoptimierung:</strong> Effiziente Lösungen, die langfristig Betriebskosten reduzieren</li><li><strong>Digitale Reichweite:</strong> Erhöhte Online-Sichtbarkeit durch intelligente Automatisierung</li></ul></div></section><section><h4 class=\'panel-highline\'>KI-Personal Business Assistant - Unser modularer Automatisierungsansatz</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Intelligentes Geschäftsmanagement durch durchdachte Technologie</h5><ul class=\'panel-grid\'><li><strong>Automatische Aufgabenverteilung:</strong> KI analysiert Prioritäten und Teamkapazitäten für optimale Ressourcennutzung</li><li><strong>Zentrale Kommunikation:</strong> Integration aller Kanäle - Website, Social Media, E-Mail, Chat in einem System</li><li><strong>Intelligente Analytik:</strong> KI-gestützte Analyse optimiert kontinuierlich Ihre Geschäftsprozesse</li><li><strong>Flexible Skalierung:</strong> Module werden je nach Unternehmenswachstum hinzugefügt</li></ul><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Modularer Aufbau ohne Systemwechsel</h5><p>Unser durchdachter modularer Ansatz ermöglicht es Unternehmen, mit kleinen Automatisierungsschritten zu beginnen und die Plattform schrittweise wachsen zu lassen. Keine kostspieligen Migrationen oder Systemwechsel - nur kontinuierliche Verbesserung der Geschäftsprozesse.</p></div></div></section><section><h4 class=\'panel-highline\'>Das ReLanding-Team - Walter & Viktoria Briem arbeiten gemeinsam</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Walter Briem - Webentwicklung und Automatisierung</h5><ul class=\'panel-grid\'><li><strong>Seit 2015 in der IT-Branche:</strong> Spezialisierung auf Webentwicklung und Automatisierung von Geschäftsprozessen</li><li><strong>Deutsche Ausbildung:</strong> Absolvierte Ausbildung und Zertifizierung in Deutschland</li><li><strong>Technologische Lösungen:</strong> Entwickelt innovative Automatisierungstools für Unternehmen</li><li><strong>Praktische Erfahrung:</strong> Versteht die technischen Herausforderungen von KMU aus erster Hand</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Viktoria Briem - IT- und IP-Rechtsspezialistin</h5><ul class=\'panel-grid\'><li><strong>16 Jahre Erfahrung:</strong> Umfassende Expertise im Schutz von Kundenrechten und digitalen Projekten</li><li><strong>IT- und IP-Recht:</strong> Spezialisierung auf rechtliche Aspekte von Technologieprojekten</li><li><strong>Rechtliche Grundlagen:</strong> Schafft zuverlässige rechtliche Basis für alle digitalen Lösungen</li><li><strong>Compliance-Unterstützung:</strong> Hilft Unternehmen bei der Erfüllung gesetzlicher Anforderungen</li></ul></div></section><section><h4 class=\'panel-highline\'>Unsere gemeinsame Mission - Technologie vereinfachen, nicht verkomplizieren</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>KI soll Unternehmen unterstützen und Prozesse vereinfachen</h5><p>Wir sind überzeugt, dass KI Unternehmen unterstützen und Prozesse vereinfachen sollte, anstatt sie zu verkomplizieren. Unsere Mission ist es, Technologie zu entwickeln, die Unternehmern hilft, Kosten zu senken und Geschäftsprozesse zu optimieren.</p><ul class=\'panel-grid\'><li><strong>Vereinfachung als Ziel:</strong> KI-Tools, die intuitiv und benutzerfreundlich gestaltet sind</li><li><strong>Kostensenkung:</strong> Nachweisbare Reduktion der Betriebskosten durch durchdachte Automatisierung</li><li><strong>Prozessverbesserung:</strong> Kontinuierliche Optimierung durch KI-gestützte Analyse</li><li><strong>Zugänglichkeit:</strong> Moderne Automatisierungstools für Unternehmen zugänglich machen</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Gemeinsam entwickeln wir durchdachte Lösungen</h5><p>Als Familienunternehmen ergänzen wir uns in unseren Fachbereichen und schaffen dadurch Automatisierungslösungen, die sowohl technisch durchdacht als auch rechtlich abgesichert sind. Unser gemeinsamer Ansatz sorgt dafür, dass unsere KI-Tools in der Praxis funktionieren und gleichzeitig alle rechtlichen Anforderungen erfüllen.</p></div></section><section><h4 class=\'panel-highline\'>Warum ReLanding - Technologie-Enthusiasten mit rechtlicher Sicherheit</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Familienunternehmen vereint unterschiedliche Fachbereiche</h5><ul class=\'panel-grid\'><li><strong>Deutsche Gründlichkeit:</strong> Hohe Qualitätsstandards in Entwicklung und rechtlicher Absicherung</li><li><strong>KMU-Verständnis:</strong> Tiefe Kenntnis der Herausforderungen mittelständischer Unternehmen</li><li><strong>Modularer Ansatz:</strong> Flexibles Wachstum ohne kostspielige Systemwechsel</li><li><strong>Rechtliche Sicherheit:</strong> 16 Jahre Erfahrung in IT-Recht und Compliance</li></ul></div><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Familiäre Zusammenarbeit trifft technische Innovation</h5><p>Als Familienunternehmen vereinen wir die Flexibilität individueller Lösungsansätze mit der Zuverlässigkeit langjähriger Zusammenarbeit. Diese einzigartige Konstellation ermöglicht es uns, schnell auf Ihre Geschäftsanforderungen einzugehen und gleichzeitig höchste Qualitäts- und Sicherheitsstandards zu gewährleisten.</p></div></section><section><h4 class=\'panel-highline\'>Lernen Sie unsere KI-Automatisierungslösungen kennen</h4><div class=\'panel-wrap act\'><h5 class=\'panel-highline\'>Erfahren Sie, wie unser KI-Personal Business Assistant arbeitet</h5><p>Wir entwickeln durchdachte KI-Automatisierung für deutsche KMU. Erfahren Sie, wie unser KI-Personal Business Assistant Ihr Unternehmen unterstützen kann, und entdecken Sie die Möglichkeiten moderner Geschäftsautomatisierung für Ihren Erfolg.</p><ul class=\'panel-grid\'><li><strong>Durchdachte Lösungen:</strong> KI-Tools, die speziell für die Bedürfnisse deutscher KMU entwickelt wurden</li><li><strong>Persönlicher Kontakt:</strong> Direkte Beratung durch Walter und Viktoria zu Ihren Automatisierungszielen</li><li><strong>Gemeinsame Entwicklung:</strong> Ihre Rückmeldungen fließen in die Weiterentwicklung unserer Lösungen ein</li><li><strong>Langfristige Betreuung:</strong> Kontinuierliche Unterstützung bei der Optimierung Ihrer KI-Automatisierung</li></ul></div></section><section><h4 class=\'panel-highline\'>ReLanding — Walter & Viktoria Briem entwickeln durchdachte KI-Lösungen für KMU!</h4><div class=\'panel-btn-wrap\'><button class=\'panel-btn\' data-service=\'faq\'>Häufige Fragen →</button></div></section>\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"Unverbindlich Kontakt aufnehmen\",\r\n    \"btnService\": \"chat\"\r\n  },\r\n\r\n  \"1058\": {\"type\": \"image\", \r\n    \"path\": \"entscheidung-ki-oekosystem-starten-erfolg.webp\", \r\n    \"m_path\": \"entscheidung-ki-oekosystem-starten-erfolg-mobile.webp\", \r\n    \"name\": \"Unternehmer startet KI-Ökosystem für automatisierten Geschäftserfolg\"},\r\n\r\n  \"801\": {\r\n    \"type\": \"text\",\r\n    \"page_title\": \"Jetzt entscheiden: KI-Ökosystem für KMU starten\",\r\n    \"meta_title\": \"Letzte Chance: Starten Sie Ihre KI-Automatisierung heute. 40-60% mehr Leads, GDPR-konform.\",\r\n    \"meta\": [],\r\n    \"cost\": \"\",\r\n    \"secCost\": \"\",\r\n    \"promo\": \"Der Moment der Wahrheit: Während Sie überlegen, automatisieren Ihre Konkurrenten bereits ihre Kundengewinnung\",\r\n    \"title\": \"Jetzt handeln: 3x mehr Kunden durch AI-Automatisierung\",\r\n    \"benefits\": \"<li>Sofort mehr Leads</li><li>Konkurrenzvorsprung</li><li>GDPR-Sicherheit</li><li>Mobile Kontrolle</li>\",\r\n    \"subtitle\": \"\",\r\n    \"text\": \"\",\r\n    \"delivery\": \"\",\r\n    \"pageSecActBtn\": \"\",\r\n    \"pageActBtn\": \"Jetzt durchstarten\",\r\n    \"btnService\": \"chat\"\r\n  }\r\n}\r\n', '2025-05-28 11:10:04', '2025-08-30 12:55:27');

-- --------------------------------------------------------

--
-- Структура таблицы `render_main_cache`
--

CREATE TABLE `render_main_cache` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `domain` varchar(255) NOT NULL,
  `language` varchar(10) NOT NULL DEFAULT 'ru',
  `socialMedia` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `legal` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `navStructure` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `render_main_cache`
--

INSERT INTO `render_main_cache` (`id`, `domain`, `language`, `socialMedia`, `legal`, `navStructure`, `created_at`, `updated_at`) VALUES
(1, 'relanding.de', 'de', '[]', '[{\"name\":\"AGB\",\"url\":\"https://relanding.de/legal/terms/\"},{\"name\":\"Datenschutzerklärung\",\"url\":\"https://relanding.de/legal/privacy/\"},\r\n{\"name\":\"Widerrufsbelehrung\",\"url\":\"https://relanding.de/legal/cancellation/\"},{\"name\":\"Impressum\",\"url\":\"https://relanding.de/legal/contact/\"}]', '[]', '2025-05-14 15:24:11', '2025-08-29 18:52:47');

-- --------------------------------------------------------

--
-- Структура таблицы `render_theme_cache`
--

CREATE TABLE `render_theme_cache` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `domain` varchar(255) NOT NULL,
  `language` varchar(10) NOT NULL DEFAULT 'ru',
  `device_type` enum('mobile','desktop') NOT NULL,
  `theme` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Структура таблицы `segment_theme_mapping`
--

CREATE TABLE `segment_theme_mapping` (
  `id` int(11) NOT NULL,
  `segment_id` int(11) NOT NULL,
  `theme_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Структура таблицы `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `docs_link` varchar(255) DEFAULT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `auto_assigned` tinyint(1) DEFAULT 0,
  `created_by` varchar(50) DEFAULT 'user',
  `status` enum('open','in_progress','under_review','completed','cancelled') NOT NULL DEFAULT 'open',
  `created_at` datetime DEFAULT current_timestamp(),
  `client_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `term_synonyms`
--

CREATE TABLE `term_synonyms` (
  `id` int(11) NOT NULL,
  `canonical` varchar(64) DEFAULT NULL,
  `synonyms` text DEFAULT NULL,
  `context` varchar(64) DEFAULT NULL,
  `lang` enum('ru','de','en') DEFAULT 'ru',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `status` enum('open','in_progress','on_hold','resolved','closed') DEFAULT 'open',
  `priority` enum('low','medium','high','critical') DEFAULT 'medium',
  `assigned_to` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `telegram_id` bigint(20) NOT NULL,
  `telegram_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `language` varchar(5) DEFAULT 'orig',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `password_hash` varchar(64) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `telegram_id`, `telegram_name`, `name`, `email`, `language`, `created_at`, `password_hash`, `timezone`) VALUES
(1, 6594349857, 'Pirakuda', 'Walter', NULL, 'ru', '2025-02-28 18:17:10', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `user_organization_roles`
--

CREATE TABLE `user_organization_roles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `level` enum('senior','middle','junior') DEFAULT 'junior',
  `addition` varchar(20) DEFAULT NULL,
  `workload` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `receives_site_analytics` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `user_organization_roles`
--

INSERT INTO `user_organization_roles` (`id`, `user_id`, `organization_id`, `level`, `addition`, `workload`, `created_at`, `receives_site_analytics`) VALUES
(1, 1, 1, 'senior', NULL, 0, '2025-04-09 15:52:29', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `user_roles`
--

CREATE TABLE `user_roles` (
  `user_org_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `user_roles`
--

INSERT INTO `user_roles` (`user_org_id`, `role_id`) VALUES
(1, 121),
(1, 124),
(1, 125),
(1, 130),
(1, 132),
(1, 139),
(1, 143),
(1, 145);

-- --------------------------------------------------------

--
-- Структура таблицы `user_segments`
--

CREATE TABLE `user_segments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visitor_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_anonymous` tinyint(1) DEFAULT 0,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ru',
  `device_type` enum('desktop','mobile','tablet','bot') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'desktop',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `screen_resolution` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'direct',
  `utm_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_medium` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_campaign` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_term` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referrer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `landing_page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exit_page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `segment_id` int(11) DEFAULT NULL,
  `is_returning` tinyint(1) DEFAULT 0,
  `page_views` int(11) DEFAULT 1,
  `session_duration` int(11) DEFAULT 0,
  `bounce` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_activity` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `visitor_geography`
--

CREATE TABLE `visitor_geography` (
  `id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `country_code` varchar(2) DEFAULT NULL,
  `country_name` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `isp` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `website_analytics`
--

CREATE TABLE `website_analytics` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `session_id` varchar(64) NOT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `is_new_visitor` tinyint(1) DEFAULT 0,
  `is_returning` tinyint(1) DEFAULT 0,
  `device_type` varchar(20) DEFAULT NULL,
  `browser` varchar(50) DEFAULT NULL,
  `os` varchar(50) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `utm_source` varchar(100) DEFAULT NULL,
  `utm_medium` varchar(100) DEFAULT NULL,
  `utm_campaign` varchar(100) DEFAULT NULL,
  `referrer` text DEFAULT NULL,
  `landing_page` varchar(500) DEFAULT NULL,
  `exit_page` varchar(500) DEFAULT NULL,
  `session_duration` int(11) DEFAULT 0,
  `page_views` int(11) DEFAULT 1,
  `bounce` tinyint(1) DEFAULT 1,
  `has_conversion` tinyint(1) DEFAULT 0,
  `conversion_entity_type` enum('lead','ticket','task') DEFAULT NULL,
  `conversion_entity_id` int(11) DEFAULT NULL,
  `form_type` varchar(50) DEFAULT NULL,
  `session_date` date NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `last_processed_time` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_processed_id` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `website_daily_stats`
--

CREATE TABLE `website_daily_stats` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `unique_visitors` int(11) DEFAULT 0,
  `total_sessions` int(11) DEFAULT 0,
  `new_visitors` int(11) DEFAULT 0,
  `returning_visitors` int(11) DEFAULT 0,
  `avg_session_duration` decimal(10,2) DEFAULT 0.00,
  `total_time` int(11) DEFAULT 0,
  `bounce_rate` decimal(5,2) DEFAULT 0.00,
  `pages_per_session` decimal(5,2) DEFAULT 0.00,
  `source_direct` int(11) DEFAULT 0,
  `source_google` int(11) DEFAULT 0,
  `source_yandex` int(11) DEFAULT 0,
  `source_social` int(11) DEFAULT 0,
  `source_email` int(11) DEFAULT 0,
  `source_referral` int(11) DEFAULT 0,
  `source_paid` int(11) DEFAULT 0,
  `source_other` int(11) DEFAULT 0,
  `desktop_visitors` int(11) DEFAULT 0,
  `mobile_visitors` int(11) DEFAULT 0,
  `tablet_visitors` int(11) DEFAULT 0,
  `top_country_1` varchar(2) DEFAULT NULL,
  `top_country_1_count` int(11) DEFAULT 0,
  `top_country_2` varchar(2) DEFAULT NULL,
  `top_country_2_count` int(11) DEFAULT 0,
  `top_country_3` varchar(2) DEFAULT NULL,
  `top_country_3_count` int(11) DEFAULT 0,
  `top_page_1` varchar(255) DEFAULT NULL,
  `top_page_1_views` int(11) DEFAULT 0,
  `top_page_2` varchar(255) DEFAULT NULL,
  `top_page_2_views` int(11) DEFAULT 0,
  `top_page_3` varchar(255) DEFAULT NULL,
  `top_page_3_views` int(11) DEFAULT 0,
  `total_conversions` int(11) DEFAULT 0,
  `conversion_rate` decimal(5,2) DEFAULT 0.00,
  `conversions_leads` int(11) DEFAULT 0,
  `conversions_tickets` int(11) DEFAULT 0,
  `conversions_tasks` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `website_hourly_stats`
--

CREATE TABLE `website_hourly_stats` (
  `id` int(11) NOT NULL,
  `organization_id` int(11) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `hour` tinyint(4) NOT NULL,
  `unique_visitors` int(11) DEFAULT 0,
  `total_sessions` int(11) DEFAULT 0,
  `page_views` int(11) DEFAULT 0,
  `avg_session_duration` decimal(10,2) DEFAULT 0.00,
  `conversions` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `analytics_daily_reports`
--
ALTER TABLE `analytics_daily_reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_org_domain_date` (`organization_id`,`domain`,`report_date`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_report_date` (`report_date`);

--
-- Индексы таблицы `analytics_events`
--
ALTER TABLE `analytics_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_visitor_id` (`visitor_id`),
  ADD KEY `idx_session_id` (`session_id`),
  ADD KEY `idx_event_type` (`event_type`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_created_date` (`created_at`);

--
-- Индексы таблицы `analytics_processing_log`
--
ALTER TABLE `analytics_processing_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `org_domain` (`organization_id`,`domain`),
  ADD KEY `processed_at` (`processed_at`);

--
-- Индексы таблицы `anonymous_analytics`
--
ALTER TABLE `anonymous_analytics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_daily_record` (`domain`(191),`event_date`,`page_url`(191),`device_type`);

--
-- Индексы таблицы `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_org_related` (`organization_id`,`related_type`,`related_id`),
  ADD KEY `idx_filename` (`filename`);

--
-- Индексы таблицы `business_facts`
--
ALTER TABLE `business_facts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `source_id` (`source_id`),
  ADD KEY `idx_org_source_page_key` (`organization_id`,`source_id`,`page_slug`,`fact_key`);

--
-- Индексы таблицы `business_profiles`
--
ALTER TABLE `business_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_organization_id` (`organization_id`);

--
-- Индексы таблицы `chat_intents`
--
ALTER TABLE `chat_intents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Индексы таблицы `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_telegram_id` (`telegram_id`);

--
-- Индексы таблицы `client_config`
--
ALTER TABLE `client_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `domain` (`domain`),
  ADD UNIQUE KEY `token` (`token`);

--
-- Индексы таблицы `client_organization`
--
ALTER TABLE `client_organization`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_client_org` (`client_id`,`organization_id`),
  ADD KEY `organization_id` (`organization_id`);

--
-- Индексы таблицы `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_target` (`target_type`,`target_id`),
  ADD KEY `idx_event_id` (`event_id`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `fk_comments_client` (`client_id`);

--
-- Индексы таблицы `conversation_feedback`
--
ALTER TABLE `conversation_feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `organization_id` (`organization_id`);

--
-- Индексы таблицы `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_client_id` (`client_id`),
  ADD KEY `idx_related` (`related_type`,`related_id`),
  ADD KEY `idx_events_duplicate_check` (`client_id`,`received_at`);

--
-- Индексы таблицы `event_ai_analysis`
--
ALTER TABLE `event_ai_analysis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_event` (`event_id`);

--
-- Индексы таблицы `event_logs`
--
ALTER TABLE `event_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- Индексы таблицы `faq_candidates`
--
ALTER TABLE `faq_candidates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status_lang` (`status`,`lang`),
  ADD KEY `idx_page_slug` (`page_slug`);

--
-- Индексы таблицы `faq_entries`
--
ALTER TABLE `faq_entries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_page_slug` (`page_slug`),
  ADD KEY `merged_to` (`merged_to`),
  ADD KEY `fk_faq_source` (`source_id`);

--
-- Индексы таблицы `form_fields`
--
ALTER TABLE `form_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_event_id` (`event_id`);

--
-- Индексы таблицы `invite`
--
ALTER TABLE `invite`
  ADD PRIMARY KEY (`id`),
  ADD KEY `organization_id` (`organization_id`);

--
-- Индексы таблицы `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_client_id` (`client_id`),
  ADD KEY `fk_leads_assigned_to` (`assigned_to`),
  ADD KEY `idx_leads_client_status` (`client_id`,`status`);

--
-- Индексы таблицы `notification_log`
--
ALTER TABLE `notification_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_org_date` (`organization_id`,`sent_at`),
  ADD KEY `idx_entity` (`entity_type`,`entity_id`),
  ADD KEY `idx_telegram` (`telegram_id`);

--
-- Индексы таблицы `organizations`
--
ALTER TABLE `organizations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `idx_chat_id` (`chat_id`),
  ADD KEY `idx_org_name` (`name`),
  ADD KEY `idx_org_level` (`level`,`is_active`);

--
-- Индексы таблицы `organization_sources`
--
ALTER TABLE `organization_sources`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_unique_source` (`organization_id`,`source_type`,`source_value`),
  ADD KEY `idx_source_type_active` (`source_type`,`is_active`);

--
-- Индексы таблицы `org_comments`
--
ALTER TABLE `org_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `source_id` (`source_id`),
  ADD KEY `idx_org_source` (`organization_id`,`source_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_sentiment` (`sentiment`);

--
-- Индексы таблицы `outbox`
--
ALTER TABLE `outbox`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_event_id` (`event_id`),
  ADD KEY `fk_outbox_client` (`client_id`),
  ADD KEY `fk_outbox_organization` (`organization_id`);

--
-- Индексы таблицы `page_views`
--
ALTER TABLE `page_views`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_session_id` (`session_id`),
  ADD KEY `idx_visitor_id` (`visitor_id`),
  ADD KEY `idx_page_slug` (`page_slug`),
  ADD KEY `idx_viewed_date` (`viewed_at`);

--
-- Индексы таблицы `prompt_profiles`
--
ALTER TABLE `prompt_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `source_id` (`source_id`),
  ADD KEY `idx_org_source_page` (`organization_id`,`source_id`,`page_slug`);

--
-- Индексы таблицы `prompt_templates`
--
ALTER TABLE `prompt_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `source_id` (`source_id`),
  ADD KEY `intent_id` (`intent_id`),
  ADD KEY `idx_org_source_page_intent` (`organization_id`,`source_id`,`page_slug`,`intent_id`);

--
-- Индексы таблицы `queue_tasks`
--
ALTER TABLE `queue_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_queue_composite` (`status`,`priority`,`created_at`);

--
-- Индексы таблицы `render_cache`
--
ALTER TABLE `render_cache`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_record` (`domain`,`page_slug`,`language`,`device_type`),
  ADD KEY `idx_domain_page_slug` (`domain`,`page_slug`,`language`,`device_type`);

--
-- Индексы таблицы `render_main_cache`
--
ALTER TABLE `render_main_cache`
  ADD UNIQUE KEY `unique_record` (`domain`,`language`);

--
-- Индексы таблицы `render_theme_cache`
--
ALTER TABLE `render_theme_cache`
  ADD UNIQUE KEY `unique_record` (`domain`,`language`,`device_type`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Индексы таблицы `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_tasks_event_id` (`event_id`),
  ADD KEY `idx_client_id` (`client_id`),
  ADD KEY `idx_tasks_status` (`status`,`created_at`);

--
-- Индексы таблицы `term_synonyms`
--
ALTER TABLE `term_synonyms`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_event_id` (`event_id`),
  ADD KEY `idx_client_id` (`client_id`),
  ADD KEY `idx_assigned_to` (`assigned_to`),
  ADD KEY `idx_tickets_client_status` (`client_id`,`status`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `user_organization_roles`
--
ALTER TABLE `user_organization_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_org` (`user_id`,`organization_id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`organization_id`),
  ADD KEY `organization_id` (`organization_id`);

--
-- Индексы таблицы `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_org_id`,`role_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Индексы таблицы `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_org_date` (`organization_id`,`created_at`),
  ADD KEY `idx_session_visitor` (`session_id`,`visitor_id`),
  ADD KEY `idx_visitor_date` (`visitor_id`,`created_at`),
  ADD KEY `idx_device_source` (`device_type`,`source`),
  ADD KEY `idx_date_only` (`created_at`);

--
-- Индексы таблицы `visitor_geography`
--
ALTER TABLE `visitor_geography`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip_address` (`ip_address`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_country_code` (`country_code`),
  ADD KEY `idx_city` (`city`);

--
-- Индексы таблицы `website_analytics`
--
ALTER TABLE `website_analytics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_org_domain` (`organization_id`,`domain`),
  ADD KEY `idx_session_date` (`session_date`),
  ADD KEY `idx_session_id` (`session_id`),
  ADD KEY `visitor_id` (`visitor_id`),
  ADD KEY `conversion_tracking` (`has_conversion`,`conversion_entity_type`),
  ADD KEY `source_analysis` (`source`,`utm_source`),
  ADD KEY `bounce_analysis` (`bounce`,`device_type`);

--
-- Индексы таблицы `website_daily_stats`
--
ALTER TABLE `website_daily_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_org_domain_date` (`organization_id`,`domain`,`date`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_domain` (`domain`),
  ADD KEY `idx_date` (`date`);

--
-- Индексы таблицы `website_hourly_stats`
--
ALTER TABLE `website_hourly_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_org_domain_date_hour` (`organization_id`,`domain`,`date`,`hour`),
  ADD KEY `idx_organization_id` (`organization_id`),
  ADD KEY `idx_domain` (`domain`),
  ADD KEY `idx_date_hour` (`date`,`hour`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `analytics_daily_reports`
--
ALTER TABLE `analytics_daily_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `analytics_events`
--
ALTER TABLE `analytics_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `analytics_processing_log`
--
ALTER TABLE `analytics_processing_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `anonymous_analytics`
--
ALTER TABLE `anonymous_analytics`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `attachments`
--
ALTER TABLE `attachments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `business_facts`
--
ALTER TABLE `business_facts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `business_profiles`
--
ALTER TABLE `business_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `chat_intents`
--
ALTER TABLE `chat_intents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `client_config`
--
ALTER TABLE `client_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `client_organization`
--
ALTER TABLE `client_organization`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `conversation_feedback`
--
ALTER TABLE `conversation_feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `event_ai_analysis`
--
ALTER TABLE `event_ai_analysis`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `event_logs`
--
ALTER TABLE `event_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `faq_candidates`
--
ALTER TABLE `faq_candidates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `faq_entries`
--
ALTER TABLE `faq_entries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT для таблицы `form_fields`
--
ALTER TABLE `form_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `invite`
--
ALTER TABLE `invite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `leads`
--
ALTER TABLE `leads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `notification_log`
--
ALTER TABLE `notification_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `organizations`
--
ALTER TABLE `organizations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `organization_sources`
--
ALTER TABLE `organization_sources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `org_comments`
--
ALTER TABLE `org_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `outbox`
--
ALTER TABLE `outbox`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `page_views`
--
ALTER TABLE `page_views`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `prompt_profiles`
--
ALTER TABLE `prompt_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `prompt_templates`
--
ALTER TABLE `prompt_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `queue_tasks`
--
ALTER TABLE `queue_tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=172;

--
-- AUTO_INCREMENT для таблицы `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `term_synonyms`
--
ALTER TABLE `term_synonyms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `user_organization_roles`
--
ALTER TABLE `user_organization_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `user_sessions`
--
ALTER TABLE `user_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `visitor_geography`
--
ALTER TABLE `visitor_geography`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `website_analytics`
--
ALTER TABLE `website_analytics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `website_daily_stats`
--
ALTER TABLE `website_daily_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `website_hourly_stats`
--
ALTER TABLE `website_hourly_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
