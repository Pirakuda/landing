
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `source_id` (`source_id`),
  KEY `idx_org_source_page_key` (`organization_id`,`source_id`,`page_slug`,`fact_key`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

CREATE TABLE IF NOT EXISTS `form_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `field_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `field_value` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
)

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

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

CREATE TABLE IF NOT EXISTS `term_synonyms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `canonical` varchar(64) DEFAULT NULL,
  `synonyms` text,
  `context` varchar(64) DEFAULT NULL,
  `lang` enum('ru','de','en') DEFAULT 'ru',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

CREATE TABLE IF NOT EXISTS `user_roles` (
  `user_org_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_org_id`,`role_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=315 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
