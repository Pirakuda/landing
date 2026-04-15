# SERVER-SCHEMA.md — База данных `relanding_derelandingdb`

## 1. Обзор

База данных **relanding_derelandingdb** обслуживает серверную часть AI-экосистемы: мультитенантность, CRM, AI-чат, аналитику, уведомления и управление контентом. Целевая аудитория — немецкий Mittelstand (малый и средний бизнес).

**Сервер:** MySQL 8.0 / MariaDB 10.6, charset: `utf8mb4`

**Основные подсистемы:**
- **Организации и пользователи** — мультитенантность, RBAC, приглашения
- **CRM** — клиенты, события, лиды, тикеты, задачи, комментарии
- **AI/Chat** — интенты, промпт-профили, шаблоны, обратная связь
- **Контент** — бизнес-профили, бизнес-факты, FAQ, отзывы
- **Аналитика** — сессии посетителей, агрегированная статистика
- **Уведомления/Outbox** — очередь исходящих, лог уведомлений, очередь задач

---

## 2. Таблицы

### 2.1 `organizations`
**Назначение:** Центральная таблица мультитенантности. Каждая организация — отдельный клиент системы.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| name | varchar(255) | NO | — | Название организации (UNIQUE) |
| chat_id | bigint | YES | NULL | Telegram chat ID группы |
| terms_url | varchar(255) | YES | NULL | URL пользовательского соглашения |
| privacy_url | varchar(255) | YES | NULL | URL политики конфиденциальности |
| token | varchar(32) | YES | NULL | API-токен организации (UNIQUE) |
| bot_token | varchar(255) | YES | NULL | Telegram bot token |
| model_id | varchar(100) | YES | NULL | ID AI-модели |
| auto_reply_mode | enum('auto','manual') | NO | 'manual' | Режим автоответов |
| assignment_mode | enum('auto','manual') | NO | 'manual' | Режим назначения задач |
| level | enum('basic','pro') | NO | 'basic' | Уровень подписки |
| is_active | tinyint(1) | YES | 1 | Активна ли |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), UNIQUE(`name`), UNIQUE(`token`), INDEX(`chat_id`, `name`, `level`+`is_active`)

---

### 2.2 `organization_sources`
**Назначение:** Источники данных организации — каналы входящих сообщений (email, сайт, telegram и т.д.).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| source_type | enum('email','phone','social','website','chat','telegram','other') | NO | — | Тип источника |
| source_value | varchar(500) | NO | — | Значение (email, домен, …) |
| role | varchar(50) | YES | NULL | Роль источника |
| config | json | YES | NULL | Конфигурация канала |
| is_confirmed | tinyint(1) | YES | 0 | Подтверждён ли |
| confirm_token | varchar(255) | YES | NULL | Токен подтверждения |
| source_name | varchar(255) | YES | NULL | Отображаемое имя |
| source_url | varchar(500) | YES | NULL | URL источника |
| is_active | tinyint(1) | YES | 1 | Активен ли |
| has_api | tinyint(1) | NO | 0 | Есть ли API-интеграция |

**Ключи:** PK(`id`), UNIQUE(`organization_id`, `source_type`, `source_value`), INDEX(`source_type`, `is_active`)

---

### 2.3 `users`
**Назначение:** Пользователи системы — операторы и менеджеры организаций, привязка через Telegram.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| telegram_id | bigint | NO | — | Telegram user ID |
| telegram_name | varchar(255) | YES | NULL | Telegram username |
| name | varchar(255) | NO | — | Имя пользователя |
| email | varchar(255) | YES | NULL | Email |
| language | varchar(5) | YES | 'orig' | Язык интерфейса |
| password_hash | varchar(64) | YES | NULL | Хеш пароля |
| timezone | varchar(50) | YES | NULL | Часовой пояс |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата регистрации |

**Ключи:** PK(`id`)

---

### 2.4 `user_organization_roles`
**Назначение:** Связь пользователь ↔ организация с уровнем доступа и нагрузкой.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| user_id | int | NO | — | FK → users |
| organization_id | int | NO | — | FK → organizations |
| level | enum('senior','middle','junior') | YES | 'junior' | Уровень |
| addition | varchar(20) | YES | NULL | Доп. пометка |
| workload | int | NO | 0 | Текущая нагрузка (кол-во задач) |
| receives_site_analytics | tinyint(1) | YES | 0 | Получать ли аналитику сайта |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата назначения |

**Ключи:** PK(`id`), UNIQUE(`user_id`, `organization_id`), INDEX(`organization_id`)

---

### 2.5 `roles`
**Назначение:** Справочник профессиональных ролей (52+ записи: CEO, Developer, SEO, …).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| role_name | varchar(50) | NO | — | Название роли (UNIQUE) |

**Ключи:** PK(`id`), UNIQUE(`role_name`)

---

### 2.6 `user_roles`
**Назначение:** Связь user_organization_roles ↔ roles (N:M) — профессиональные роли сотрудника в организации.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| user_org_id | int | NO | — | FK → user_organization_roles |
| role_id | int | NO | — | FK → roles |

**Ключи:** PK(`user_org_id`, `role_id`), INDEX(`role_id`)

---

### 2.7 `invite`
**Назначение:** Приглашения пользователей в организацию через Telegram.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| invitee_nick | varchar(255) | NO | — | Telegram-ник приглашённого |
| invitee_name | varchar(255) | NO | — | Имя приглашённого |
| role_name | varchar(50) | NO | — | Роль |
| organization_id | int | NO | — | FK → organizations |
| organization_name | varchar(255) | NO | — | Название организации (денормализовано) |
| inviter_id | bigint | NO | — | Telegram ID пригласившего |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`organization_id`)

---

### 2.8 `clients`
**Назначение:** Контакты/клиенты, поступающие через все каналы.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| telegram_id | bigint | YES | NULL | Telegram ID клиента |
| telegram_name | varchar(255) | YES | NULL | Telegram username |
| name | varchar(255) | NO | — | Имя |
| email | varchar(255) | YES | NULL | Email (UNIQUE) |
| phone | varchar(20) | YES | NULL | Телефон |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), UNIQUE(`email`), INDEX(`telegram_id`)

---

### 2.9 `client_organization`
**Назначение:** Связь клиент ↔ организация (N:M) с ролью и статусом.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| client_id | int | NO | — | FK → clients |
| organization_id | int | NO | — | FK → organizations |
| role | enum('customer','partner','supplier') | NO | 'customer' | Роль клиента |
| status | enum('active','inactive','pending') | YES | 'active' | Статус |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), UNIQUE(`client_id`, `organization_id`), INDEX(`organization_id`)

---

### 2.10 `events`
**Назначение:** Входящие события из всех каналов — центральный объект CRM-потока.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| external_id | varchar(255) | YES | NULL | Внешний ID (дедупликация) |
| source_type | enum('email','phone','social','websiteComments','websiteForm','websiteChat','telegramChat','websiteReviews','other') | NO | — | Тип источника |
| source_value | varchar(255) | NO | — | Конкретный источник (email, домен, …) |
| from_name | varchar(255) | YES | NULL | Имя отправителя |
| from_contact | varchar(128) | YES | NULL | Контакт отправителя |
| client_id | int | YES | NULL | FK → clients |
| organization_id | int | YES | NULL | FK → organizations |
| subject | text | YES | NULL | Тема |
| message | mediumtext | YES | NULL | Содержание |
| is_first_contact | tinyint(1) | YES | 1 | Первый контакт? |
| preferred_channel | enum('email','telegram','sms','chat','webhook','phone') | YES | NULL | Предпочтительный канал ответа |
| related_type | varchar(20) | YES | NULL | Тип связанной сущности (полиморфно) |
| related_id | int | YES | NULL | ID связанной сущности |
| received_at | timestamp | YES | CURRENT_TIMESTAMP | Время получения |

**Ключи:** PK(`id`), INDEX(`organization_id`, `client_id`, `related_type`+`related_id`, `client_id`+`received_at`)

> **source_type отличие от client-базы:** здесь добавлен вариант `telegramChat`, отсутствующий в клиентской БД.

---

### 2.11 `event_ai_analysis`
**Назначение:** AI-анализ входящего события — тональность, срочность, намерение, рекомендованное действие.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | NO | — | FK → events (UNIQUE) |
| ai_type | enum('new','reply','continued','forwarded','attachment','other') | YES | 'new' | Тип сообщения |
| ai_intent | enum('order','question','complaint','feedback','cancel','error','spam','check','followup') | YES | NULL | Намерение |
| ai_tone | enum('positive','neutral','negative') | YES | NULL | Тональность |
| ai_urgency | enum('low','medium','high','critical') | YES | NULL | Срочность |
| ai_confidence | float | YES | NULL | Уверенность AI (0..1) |
| ai_recommended_action | enum('create_lead','create_ticket','create_task','add_comment','archive','manual_review') | YES | 'manual_review' | Рекомендованное действие |
| ai_summary | text | YES | NULL | Краткое описание события |
| processed_at | datetime | YES | CURRENT_TIMESTAMP | Время обработки |

**Ключи:** PK(`id`), UNIQUE(`event_id`)

---

### 2.12 `event_logs`
**Назначение:** Лог действий над событиями (аудит).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | YES | NULL | FK → events |
| action | varchar(100) | YES | NULL | Действие |
| actor | varchar(100) | YES | NULL | Кто выполнил |
| details | json | YES | NULL | Детали действия |
| created_at | datetime | YES | CURRENT_TIMESTAMP | Время |

**Ключи:** PK(`id`), INDEX(`event_id`)

---

### 2.13 `form_fields`
**Назначение:** Поля форм из входящих событий (websiteForm).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | NO | — | FK → events |
| field_name | varchar(255) | NO | — | Имя поля |
| field_value | text | YES | NULL | Значение |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`event_id`)

---

### 2.14 `leads`
**Назначение:** Лиды — потенциальные клиенты, созданные из событий.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | YES | NULL | FK → events |
| client_id | int | YES | NULL | FK → clients |
| assigned_to | int | YES | NULL | FK → users |
| status | enum('new','in_progress','waiting','closed') | YES | 'new' | Статус |
| description | text | YES | NULL | Описание |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |
| updated_at | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE | Дата обновления |

**Ключи:** PK(`id`), INDEX(`client_id`, `assigned_to`, `client_id`+`status`)

---

### 2.15 `tickets`
**Назначение:** Тикеты поддержки.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | YES | NULL | FK → events |
| client_id | int | YES | NULL | FK → clients |
| status | enum('open','in_progress','on_hold','resolved','closed') | YES | 'open' | Статус |
| priority | enum('low','medium','high','critical') | YES | 'medium' | Приоритет |
| assigned_to | int | YES | NULL | FK → users (user ID) |
| description | text | YES | NULL | Описание |
| created_at | datetime | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`event_id`, `client_id`, `assigned_to`, `client_id`+`status`)

---

### 2.16 `tasks`
**Назначение:** Внутренние задачи, создаваемые вручную или автоматически.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | YES | NULL | FK → events |
| title | varchar(255) | NO | — | Заголовок |
| description | text | YES | NULL | Описание |
| docs_link | varchar(255) | YES | NULL | Ссылка на документацию |
| assigned_to | int | YES | NULL | FK → users (user ID) |
| auto_assigned | tinyint(1) | YES | 0 | Авто-назначена? |
| created_by | varchar(50) | YES | 'user' | Кем создана (`user`, `ai`, …) |
| status | enum('open','in_progress','under_review','completed','cancelled') | NO | 'open' | Статус |
| client_id | int | YES | NULL | FK → clients |
| created_at | datetime | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`event_id`, `client_id`, `status`+`created_at`)

---

### 2.17 `comments`
**Назначение:** Комментарии к лидам, тикетам и задачам.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | YES | NULL | FK → events |
| target_type | enum('lead','ticket','task') | NO | — | Тип целевой сущности |
| target_id | int | NO | — | ID целевой сущности |
| message | text | NO | — | Текст комментария |
| created_by | int | YES | NULL | FK → users |
| client_id | int | YES | NULL | FK → clients |
| created_at | datetime | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`target_type`+`target_id`, `event_id`, `created_by`, `client_id`)

> **Полиморфная связь:** `target_type` + `target_id` — без FK, ссылается на `leads`, `tickets` или `tasks`.

---

### 2.18 `attachments`
**Назначение:** Файловые вложения к событиям и сущностям.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | YES | NULL | FK → events |
| organization_id | int | NO | — | FK → organizations |
| related_type | varchar(50) | YES | NULL | Тип связанной сущности |
| related_id | int | YES | NULL | ID связанной сущности |
| filename | varchar(255) | NO | — | Имя файла |
| file_url | text | NO | — | URL файла |
| content_type | varchar(100) | YES | NULL | MIME-тип |
| file_size | int | YES | NULL | Размер в байтах |
| metadata | json | YES | NULL | Метаданные |
| uploaded_by | int | YES | NULL | FK → users |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата загрузки |

**Ключи:** PK(`id`), INDEX(`organization_id`+`related_type`+`related_id`, `filename`)

---

### 2.19 `outbox`
**Назначение:** Очередь исходящих сообщений (email, telegram, sms, webhook).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| event_id | int | YES | NULL | FK → events |
| recipient_type | enum('email','telegram','sms','chat','webhook') | YES | NULL | Тип получателя |
| recipient | varchar(255) | NO | — | Адрес получателя |
| sender | varchar(255) | YES | NULL | Адрес отправителя |
| sender_type | enum('email','telegram','sms','webhook') | YES | NULL | Тип отправителя |
| subject | text | YES | NULL | Тема |
| body | text | YES | NULL | Тело сообщения |
| generated_by | enum('ai','human') | YES | 'ai' | Источник генерации |
| status | enum('sent','queued','failed') | YES | 'queued' | Статус отправки |
| client_id | int | YES | NULL | FK → clients |
| organization_id | int | YES | NULL | FK → organizations |
| created_at | datetime | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`event_id`, `client_id`, `organization_id`)

---

### 2.20 `notification_log`
**Назначение:** Лог Telegram-уведомлений с метриками времени реакции.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| telegram_id | bigint | NO | — | Telegram user ID получателя |
| entity_type | enum('lead','ticket','task') | NO | — | Тип сущности |
| entity_id | int | NO | — | ID сущности |
| notification_type | enum('new_entity','comment','update') | YES | 'new_entity' | Тип уведомления |
| summary_confidence | decimal(3,2) | YES | 0.00 | Уверенность AI-саммари |
| summary_tags | text | YES | NULL | Теги |
| response_time | int | YES | NULL | Время реакции (сек) |
| clicked_action | varchar(100) | YES | NULL | Нажатое действие |
| sent_at | timestamp | YES | CURRENT_TIMESTAMP | Время отправки |
| responded_at | timestamp | YES | NULL | Время ответа |

**Ключи:** PK(`id`), INDEX(`organization_id`+`sent_at`, `entity_type`+`entity_id`, `telegram_id`)

---

### 2.21 `queue_tasks`
**Назначение:** Очередь фоновых задач для обработчиков (скриптов).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| script_name | varchar(50) | NO | — | Имя скрипта-обработчика |
| request_id | int | NO | — | ID запроса |
| organization_id | int | NO | — | ID организации |
| status | enum('waiting','processing','completed','failed') | YES | 'waiting' | Статус |
| priority | enum('high','medium','low') | YES | 'medium' | Приоритет |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`status`+`priority`+`created_at`)

---

### 2.22 `business_profiles`
**Назначение:** Бизнес-профиль организации (описание, услуги, контакты).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations (UNIQUE) |
| description | mediumtext | YES | NULL | Описание бизнеса |
| services | text | NO | — | Перечень услуг |
| contact_info | text | NO | — | Контактная информация |
| faq | text | YES | NULL | FAQ (текстовый блок) |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), UNIQUE(`organization_id`)

---

### 2.23 `business_facts`
**Назначение:** Структурированные бизнес-факты для AI-генерации контента (JSON-значения с периодом действия).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| source_id | int | YES | NULL | FK → organization_sources |
| page_slug | varchar(128) | YES | NULL | Slug страницы |
| fact_key | varchar(64) | YES | NULL | Ключ факта |
| fact_value | json | YES | NULL | Значение (JSON) |
| valid_from | date | YES | NULL | Действителен с |
| valid_until | date | YES | NULL | Действителен до |
| is_active | tinyint(1) | YES | 1 | Активен ли |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`source_id`, `organization_id`+`source_id`+`page_slug`+`fact_key`)

---

### 2.24 `faq_entries`
**Назначение:** FAQ-записи, привязанные к страницам и источникам.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| page_slug | varchar(255) | NO | — | Slug страницы |
| question | text | NO | — | Вопрос |
| answer | text | NO | — | Ответ |
| lang | varchar(10) | NO | — | Язык |
| merged_to | int | YES | NULL | Self-ref FK → faq_entries (объединена с) |
| organization_id | int | NO | — | FK → organizations |
| source_id | int | NO | — | FK → organization_sources |
| is_active | tinyint(1) | YES | 1 | Активна ли |
| created_at | datetime | YES | CURRENT_TIMESTAMP | Дата создания |
| updated_at | datetime | YES | CURRENT_TIMESTAMP ON UPDATE | Дата обновления |

**Ключи:** PK(`id`), INDEX(`page_slug`, `merged_to`, `source_id`)

---

### 2.25 `faq_candidates`
**Назначение:** Кандидаты FAQ — предложения из чат-бота, ожидающие модерации.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| page_slug | varchar(255) | NO | — | Slug страницы |
| domain | varchar(255) | NO | — | Домен сайта |
| question | text | NO | — | Вопрос |
| answer_suggestion | text | YES | NULL | Предложенный ответ |
| lang | varchar(10) | NO | — | Язык |
| status | enum('pending','approved','merged','rejected') | YES | 'pending' | Статус модерации |
| created_at | datetime | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`status`+`lang`, `page_slug`)

---

### 2.26 `org_comments`
**Назначение:** Отзывы посетителей сайта организации с AI-тональностью и модерацией.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| source_id | int | NO | — | FK → organization_sources |
| author_name | varchar(255) | YES | 'Гость' | Имя автора |
| author_email | varchar(255) | YES | NULL | Email автора |
| message | text | YES | NULL | Текст отзыва |
| rating | tinyint(1) | YES | NULL | Оценка (1–5) |
| user_ip | varchar(45) | YES | NULL | IP адрес |
| sentiment | enum('positive','neutral','negative','spam') | YES | 'neutral' | AI-тональность |
| status | enum('pending','approved','rejected','spam') | YES | 'pending' | Статус модерации |
| is_published | tinyint(1) | YES | 0 | Опубликован ли |
| telegram_message_id | bigint | YES | NULL | ID Telegram-сообщения для управления |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |
| updated_at | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE | Дата обновления |

**Ключи:** PK(`id`), INDEX(`source_id`, `organization_id`+`source_id`, `status`, `sentiment`)

---

### 2.27 `chat_intents`
**Назначение:** Интенты чат-бота — паттерны для классификации входящих вопросов.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| code | varchar(64) | YES | NULL | Уникальный код (UNIQUE) |
| title | varchar(128) | YES | NULL | Название |
| trigger_patterns | json | YES | NULL | Триггер-паттерны |
| required_terms | json | YES | NULL | Обязательные термины |
| forbidden_terms | json | YES | NULL | Запрещённые термины |
| priority | tinyint | YES | 0 | Приоритет сопоставления |
| fallback_action | varchar(32) | YES | NULL | Действие по умолчанию |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), UNIQUE(`code`)

---

### 2.28 `prompt_profiles`
**Назначение:** Профили AI-генерации — тон, голос бренда, статические данные для промптов.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| source_id | int | YES | NULL | FK → organization_sources |
| page_slug | varchar(128) | YES | NULL | Slug страницы |
| title | varchar(128) | YES | NULL | Название профиля |
| lang | enum('ru','de','en') | YES | 'ru' | Язык |
| tone | varchar(64) | YES | 'профессиональный' | Тон общения |
| brand_voice | text | YES | NULL | Описание голоса бренда |
| static_data | json | YES | NULL | Статические данные для промпта |
| is_active | tinyint(1) | YES | 1 | Активен ли |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`source_id`, `organization_id`+`source_id`+`page_slug`)

---

### 2.29 `prompt_templates`
**Назначение:** Шаблоны промптов, привязанные к интентам — system_prompt, few-shots, guardrails.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| source_id | int | YES | NULL | FK → organization_sources |
| page_slug | varchar(128) | YES | NULL | Slug страницы |
| intent_id | int | NO | — | FK → chat_intents |
| version | varchar(16) | YES | 'v1' | Версия шаблона |
| system_prompt | mediumtext | YES | NULL | Системный промпт |
| few_shots | json | YES | NULL | Few-shot примеры |
| output_format | json | YES | NULL | Формат вывода |
| guardrails | text | YES | NULL | Ограничения |
| default_action | varchar(32) | YES | NULL | Действие по умолчанию |
| priority | tinyint | YES | 0 | Приоритет |
| is_active | tinyint(1) | YES | 1 | Активен ли |
| conversion_rate | decimal(5,2) | YES | 0.00 | Конверсия шаблона (%) |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`source_id`, `intent_id`, `organization_id`+`source_id`+`page_slug`+`intent_id`)

---

### 2.30 `term_synonyms`
**Назначение:** Справочник синонимов терминов для AI-классификации.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| canonical | varchar(64) | YES | NULL | Каноническая форма |
| synonyms | text | YES | NULL | Синонимы |
| context | varchar(64) | YES | NULL | Контекст использования |
| lang | enum('ru','de','en') | YES | 'ru' | Язык |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`)

---

### 2.31 `conversation_feedback`
**Назначение:** Обратная связь от посетителей чат-бота (оценки, конверсии).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | YES | NULL | FK → organizations |
| session_id | varchar(64) | YES | NULL | ID сессии чата |
| question | text | YES | NULL | Вопрос пользователя |
| intent_detected | varchar(64) | YES | NULL | Обнаруженный интент |
| template_used | int | YES | NULL | ID использованного шаблона |
| ai_response | text | YES | NULL | Ответ AI |
| user_rating | tinyint | YES | NULL | Оценка (1–5) |
| user_comment | text | YES | NULL | Комментарий пользователя |
| converted | tinyint(1) | YES | 0 | Была ли конверсия |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`organization_id`)

---

### 2.32 `user_sessions`
**Назначение:** Сессии посетителей сайта — серверная копия с привязкой к организации.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| session_id | varchar(64) | YES | NULL | ID сессии |
| visitor_id | varchar(64) | NO | — | ID посетителя |
| is_anonymous | tinyint(1) | YES | 0 | Анонимный ли |
| ip_address | varchar(45) | NO | — | IP адрес |
| user_agent | text | YES | NULL | User Agent |
| country | varchar(2) | YES | NULL | Код страны |
| region | varchar(100) | YES | NULL | Регион |
| city | varchar(100) | YES | NULL | Город |
| language | varchar(10) | YES | 'ru' | Язык |
| device_type | enum('desktop','mobile','tablet','bot') | YES | 'desktop' | Тип устройства |
| browser | varchar(50) | YES | NULL | Браузер |
| os | varchar(50) | YES | NULL | ОС |
| screen_resolution | varchar(20) | YES | NULL | Разрешение экрана |
| source | varchar(50) | YES | 'direct' | Источник трафика |
| utm_source/medium/campaign/content/term | varchar(100) | YES | NULL | UTM-метки |
| referrer | text | YES | NULL | Реферер |
| landing_page | varchar(255) | YES | NULL | Страница входа |
| exit_page | varchar(255) | YES | NULL | Страница выхода |
| segment_id | int | YES | NULL | Сегмент посетителя |
| is_returning | tinyint(1) | YES | 0 | Вернувшийся |
| page_views | int | YES | 1 | Просмотры страниц |
| session_duration | int | YES | 0 | Длительность (сек) |
| bounce | tinyint(1) | YES | 1 | Отказ |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Начало сессии |
| last_activity | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE | Последняя активность |

**Ключи:** PK(`id`), INDEX(`organization_id`+`created_at`, `session_id`+`visitor_id`, `visitor_id`+`created_at`, `device_type`+`source`, `created_at`)

> **Отличие от клиентской БД:** добавлен `organization_id`; `device_type` включает значение `'bot'`.

---

### 2.33 `website_analytics`
**Назначение:** Обработанные данные сессий с конверсиями — итоговая запись после агрегации.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → organizations |
| domain | varchar(255) | NO | — | Домен |
| session_id | varchar(64) | NO | — | ID сессии |
| visitor_id | varchar(64) | NO | — | ID посетителя |
| is_new_visitor | tinyint(1) | YES | 0 | Новый посетитель |
| is_returning | tinyint(1) | YES | 0 | Вернувшийся |
| device_type | varchar(20) | YES | NULL | Тип устройства |
| browser | varchar(50) | YES | NULL | Браузер |
| os | varchar(50) | YES | NULL | ОС |
| language | varchar(10) | YES | NULL | Язык |
| source | varchar(50) | YES | NULL | Источник трафика |
| utm_source/medium/campaign | varchar(100) | YES | NULL | UTM-метки |
| referrer | text | YES | NULL | Реферер |
| landing_page | varchar(500) | YES | NULL | Страница входа |
| exit_page | varchar(500) | YES | NULL | Страница выхода |
| session_duration | int | YES | 0 | Длительность (сек) |
| page_views | int | YES | 1 | Просмотры |
| bounce | tinyint(1) | YES | 1 | Отказ |
| has_conversion | tinyint(1) | YES | 0 | Есть конверсия |
| conversion_entity_type | enum('lead','ticket','task') | YES | NULL | Тип конверсии |
| conversion_entity_id | int | YES | NULL | ID конверсии |
| form_type | varchar(50) | YES | NULL | Тип формы |
| session_date | date | NO | — | Дата сессии |
| ip_address | varchar(45) | YES | NULL | IP |
| last_processed_time | int | YES | NULL | Unix-timestamp обработки |
| last_processed_id | int | YES | 0 | ID последней обработки |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), INDEX(`organization_id`+`domain`, `session_date`, `session_id`, `visitor_id`, `has_conversion`+`conversion_entity_type`, `source`+`utm_source`, `bounce`+`device_type`)

---

### 2.34 `website_daily_stats`
**Назначение:** Агрегированная дневная статистика сайта по организации и домену.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | ID организации |
| domain | varchar(255) | NO | — | Домен |
| date | date | NO | — | Дата |
| unique_visitors | int | YES | 0 | Уникальные посетители |
| total_sessions | int | YES | 0 | Всего сессий |
| new_visitors | int | YES | 0 | Новые посетители |
| returning_visitors | int | YES | 0 | Вернувшиеся |
| avg_session_duration | decimal(10,2) | YES | 0.00 | Ср. длительность (сек) |
| total_time | int | YES | 0 | Суммарное время (сек) |
| bounce_rate | decimal(5,2) | YES | 0.00 | Показатель отказов (%) |
| pages_per_session | decimal(5,2) | YES | 0.00 | Страниц за сессию |
| source_direct/google/yandex/social/email/referral/paid/other | int | YES | 0 | Разбивка по источникам |
| desktop/mobile/tablet_visitors | int | YES | 0 | Разбивка по устройствам |
| top_country_1..3 | varchar(2) | YES | NULL | Топ-3 страны (код) |
| top_country_1..3_count | int | YES | 0 | Визиты из топ-3 стран |
| top_page_1..3 | varchar(255) | YES | NULL | Топ-3 страницы |
| top_page_1..3_views | int | YES | 0 | Просмотры топ-3 страниц |
| total_conversions | int | YES | 0 | Всего конверсий |
| conversion_rate | decimal(5,2) | YES | 0.00 | Конверсия (%) |
| conversions_leads/tickets/tasks | int | YES | 0 | Конверсии по типам |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |
| updated_at | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE | Дата обновления |

**Ключи:** PK(`id`), UNIQUE(`organization_id`, `domain`, `date`), INDEX(`organization_id`, `domain`, `date`)

---

### 2.35 `website_hourly_stats`
**Назначение:** Почасовая статистика сайта.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | ID организации |
| domain | varchar(255) | NO | — | Домен |
| date | date | NO | — | Дата |
| hour | tinyint | NO | — | Час (0–23) |
| unique_visitors | int | YES | 0 | Уникальные посетители |
| total_sessions | int | YES | 0 | Всего сессий |
| page_views | int | YES | 0 | Просмотры страниц |
| avg_session_duration | decimal(10,2) | YES | 0.00 | Ср. длительность (сек) |
| conversions | int | YES | 0 | Конверсии |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Дата создания |

**Ключи:** PK(`id`), UNIQUE(`organization_id`, `domain`, `date`, `hour`), INDEX(`organization_id`, `domain`, `date`+`hour`)

---

### 2.36 `analytics_daily_reports`
**Назначение:** Лог отправки ежедневных аналитических отчётов.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | ID организации |
| domain | varchar(255) | NO | — | Домен |
| report_date | date | NO | — | Дата отчёта |
| sent_at | timestamp | YES | CURRENT_TIMESTAMP | Время отправки |

**Ключи:** PK(`id`), UNIQUE(`organization_id`, `domain`, `report_date`), INDEX(`organization_id`, `report_date`)

---

### 2.37 `analytics_processing_log`
**Назначение:** Лог последней обработки аналитики по домену (для инкрементальной агрегации).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | ID организации |
| domain | varchar(255) | NO | — | Домен |
| last_processed_time | int | NO | — | Unix-timestamp последней обработки |
| records_processed | int | YES | 0 | Количество обработанных записей |
| processed_at | timestamp | YES | CURRENT_TIMESTAMP | Время обработки |

**Ключи:** PK(`id`), UNIQUE(`organization_id`, `domain`), INDEX(`processed_at`)

---

## 3. Связи между таблицами

### Иерархия организаций (1:N)
```
organizations
 ├─ organization_sources      (organization_id)
 ├─ business_profiles         (organization_id) — 1:1
 ├─ business_facts            (organization_id, source_id)
 ├─ faq_entries               (organization_id, source_id)
 ├─ org_comments              (organization_id, source_id)
 ├─ prompt_profiles           (organization_id, source_id)
 ├─ prompt_templates          (organization_id, source_id, intent_id)
 ├─ conversation_feedback     (organization_id)
 ├─ events                    (organization_id)
 ├─ outbox                    (organization_id)
 ├─ notification_log          (organization_id)
 ├─ queue_tasks               (organization_id)
 ├─ user_sessions             (organization_id)
 ├─ website_analytics         (organization_id)
 ├─ website_daily_stats       (organization_id)
 ├─ website_hourly_stats      (organization_id)
 ├─ analytics_daily_reports   (organization_id)
 └─ analytics_processing_log  (organization_id)
```

### Пользователи и роли (N:M)
```
users ──── user_organization_roles ──── organizations
                    │
                user_roles ──── roles
```

### CRM-поток (события → сущности)
```
events
 ├─ event_ai_analysis   (1:1)
 ├─ event_logs          (1:N)
 ├─ form_fields         (1:N)
 ├─ leads               (1:N)
 ├─ tickets             (1:N)
 ├─ tasks               (1:N)
 ├─ comments            (через полиморфные target_type/target_id)
 ├─ attachments         (1:N)
 └─ outbox              (1:N)
```

### AI-цепочка
```
chat_intents ──── prompt_templates ──── organization_sources
prompt_profiles ── organization_sources
term_synonyms (глобальный справочник, без FK)
```

### Полиморфные связи (без FK)
| Поле | Возможные значения | Ссылается на |
|------|--------------------|--------------|
| `comments.target_type` + `target_id` | lead / ticket / task | leads / tickets / tasks |
| `events.related_type` + `related_id` | любая сущность | произвольно |
| `attachments.related_type` + `related_id` | любая сущность | произвольно |
| `notification_log.entity_type` + `entity_id` | lead / ticket / task | leads / tickets / tasks |
| `website_analytics.conversion_entity_type` + `conversion_entity_id` | lead / ticket / task | leads / tickets / tasks |

---

## 4. ENUM-значения

| Таблица | Поле | Значения |
|---------|------|----------|
| organizations | auto_reply_mode | `auto`, `manual` |
| organizations | assignment_mode | `auto`, `manual` |
| organizations | level | `basic`, `pro` |
| organization_sources | source_type | `email`, `phone`, `social`, `website`, `chat`, `telegram`, `other` |
| events | source_type | `email`, `phone`, `social`, `websiteComments`, `websiteForm`, `websiteChat`, `telegramChat`, `websiteReviews`, `other` |
| events | preferred_channel | `email`, `telegram`, `sms`, `chat`, `webhook`, `phone` |
| event_ai_analysis | ai_type | `new`, `reply`, `continued`, `forwarded`, `attachment`, `other` |
| event_ai_analysis | ai_intent | `order`, `question`, `complaint`, `feedback`, `cancel`, `error`, `spam`, `check`, `followup` |
| event_ai_analysis | ai_tone | `positive`, `neutral`, `negative` |
| event_ai_analysis | ai_urgency | `low`, `medium`, `high`, `critical` |
| event_ai_analysis | ai_recommended_action | `create_lead`, `create_ticket`, `create_task`, `add_comment`, `archive`, `manual_review` |
| client_organization | role | `customer`, `partner`, `supplier` |
| client_organization | status | `active`, `inactive`, `pending` |
| leads | status | `new`, `in_progress`, `waiting`, `closed` |
| tickets | status | `open`, `in_progress`, `on_hold`, `resolved`, `closed` |
| tickets | priority | `low`, `medium`, `high`, `critical` |
| tasks | status | `open`, `in_progress`, `under_review`, `completed`, `cancelled` |
| comments | target_type | `lead`, `ticket`, `task` |
| outbox | recipient_type | `email`, `telegram`, `sms`, `chat`, `webhook` |
| outbox | sender_type | `email`, `telegram`, `sms`, `webhook` |
| outbox | generated_by | `ai`, `human` |
| outbox | status | `sent`, `queued`, `failed` |
| org_comments | sentiment | `positive`, `neutral`, `negative`, `spam` |
| org_comments | status | `pending`, `approved`, `rejected`, `spam` |
| faq_candidates | status | `pending`, `approved`, `merged`, `rejected` |
| notification_log | entity_type | `lead`, `ticket`, `task` |
| notification_log | notification_type | `new_entity`, `comment`, `update` |
| prompt_profiles | lang | `ru`, `de`, `en` |
| term_synonyms | lang | `ru`, `de`, `en` |
| queue_tasks | status | `waiting`, `processing`, `completed`, `failed` |
| queue_tasks | priority | `high`, `medium`, `low` |
| user_organization_roles | level | `senior`, `middle`, `junior` |
| user_sessions | device_type | `desktop`, `mobile`, `tablet`, `bot` |
| website_analytics | conversion_entity_type | `lead`, `ticket`, `task` |

---

## 5. Примечания

### Soft-delete
Нет `deleted_at`. Деактивация через `is_active` в: `organizations`, `organization_sources`, `business_facts`, `faq_entries`, `prompt_profiles`, `prompt_templates`. Модерация через `status` в: `org_comments`, `faq_candidates`.

### Charset / Collation
- Основные таблицы аналитики: `utf8mb4_0900_ai_ci`
- CRM-таблицы (`comments`, `event_ai_analysis`, `org_comments`, …): `utf8mb4_general_ci`
- Уведомления и сессии: `utf8mb4_unicode_ci`
- JSON-поля: `utf8mb4_bin`

### JSON-поля
`business_facts.fact_value`, `attachments.metadata`, `chat_intents.trigger_patterns/required_terms/forbidden_terms`, `event_logs.details`, `organization_sources.config`, `prompt_profiles.static_data`, `prompt_templates.few_shots/output_format`.

### Связь с клиентской базой
Эта база (`relanding_derelandingdb`) не содержит структуры страниц и контента. Привязка к клиентской базе `cy13096_site` осуществляется через `cy13096_site.client_config.organization_id` → `organizations.id` и через общий `domain`. Данные аналитики (`user_sessions`, `website_analytics`) дублируются в обеих базах: клиентская хранит сессии без `organization_id`, серверная — с ним.
