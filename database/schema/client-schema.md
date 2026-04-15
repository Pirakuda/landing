# CLIENT-SCHEMA.md — База данных `cy13096_site`

> Auto-documented from SQL migration files 001–014. Last updated: 2026-04-15.

---

## 1. Обзор

База данных **bcai_page_db** обслуживает клиентскую часть веб-приложения: контент экранов и аналитику посетителей.

**Сервер:** MySQL 8.0, charset: `utf8mb4`

**Основные подсистемы:**
- **Кэш рендера** — render_cache, render_main_cache
- **Аналитика** — user_sessions, page_views, analytics_events, anonymous_analytics, visitor_geography, user_segments

**Удалено по сравнению с предыдущей версией:** `themes`, `segment_theme_mapping`, `render_theme_cache` — палитра теперь хранится как строка в `sites.palette`.

---

## 2. Таблицы

### 2.13 `render_cache`
**Файл:** `012_render_caches.sql` | **Collation:** `utf8mb4_general_ci`

Кэш полных данных страницы (`$pageStructure` JSON). Device_type не нужен — различие desktop/mobile решается CSS media queries на клиенте.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | bigint unsigned | NO | AUTO_INCREMENT | PK |
| domain | varchar(255) | NO | — | Домен |
| page_slug | varchar(100) | YES | NULL | Slug страницы |
| language | varchar(10) | NO | 'de' | Язык |
| data | longtext (JSON) | NO | — | JSON `$pageStructure` |
| created_at | datetime | NO | CURRENT_TIMESTAMP | |
| updated_at | datetime | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), UNIQUE(`domain`, `page_slug`, `language`), INDEX(`domain`, `page_slug`, `language`)

---

### 2.14 `render_main_cache`
**Файл:** `012_render_caches.sql` | **Collation:** `utf8mb4_general_ci`

Кэш общих данных сайта: соцсети, юридические ссылки, структура навигации.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | bigint unsigned | NO | AUTO_INCREMENT | PK |
| domain | varchar(255) | NO | — | Домен |
| language | varchar(10) | NO | 'de' | Язык |
| social_media | longtext (JSON) | NO | — | JSON массив соцсетей |
| legal | longtext (JSON) | NO | — | JSON массив юрссылок |
| nav_structure | longtext (JSON) | NO | — | JSON структура навигации |
| created_at | datetime | NO | CURRENT_TIMESTAMP | |
| updated_at | datetime | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** UNIQUE(`domain`, `language`)

---

### 2.15 `user_segments`
**Файл:** `013_analytics_sessions.sql` | **Collation:** `utf8mb4_0900_ai_ci`

Сегменты посетителей для аналитики. `user_sessions.segment_id` → `user_segments.id`.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| name | varchar(100) | NO | — | Системное имя сегмента (UNIQUE) |
| description | varchar(255) | YES | NULL | Описание |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), UNIQUE(`name`)

---

### 2.16 `user_sessions`
**Файл:** `013_analytics_sessions.sql` | **Collation:** `utf8mb4_0900_ai_ci`

Сессии посетителей с полной аналитикой устройства, геолокации и источника трафика.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| session_id | varchar(64) | YES | NULL | ID сессии (UNIQUE) |
| visitor_id | varchar(64) | NO | — | ID посетителя (browser fingerprint) |
| is_anonymous | tinyint(1) | YES | 0 | Анонимный (нет cookie-согласия) |
| ip_address | varchar(45) | NO | — | IP адрес (IPv4/IPv6) |
| user_agent | text | YES | NULL | User-Agent строка |
| country | varchar(2) | YES | NULL | ISO код страны |
| region | varchar(100) | YES | NULL | Регион |
| city | varchar(100) | YES | NULL | Город |
| language | varchar(10) | YES | 'de' | Язык браузера |
| device_type | enum('desktop','mobile','tablet') | YES | 'desktop' | Тип устройства |
| browser | varchar(50) | YES | NULL | Браузер |
| os | varchar(50) | YES | NULL | ОС |
| screen_resolution | varchar(20) | YES | NULL | Разрешение экрана |
| source | varchar(50) | YES | 'direct' | Источник трафика |
| utm_source | varchar(100) | YES | NULL | |
| utm_medium | varchar(100) | YES | NULL | |
| utm_campaign | varchar(100) | YES | NULL | |
| utm_content | varchar(100) | YES | NULL | |
| utm_term | varchar(100) | YES | NULL | |
| referrer | text | YES | NULL | |
| landing_page | varchar(255) | YES | NULL | Страница входа |
| exit_page | varchar(255) | YES | NULL | Страница выхода |
| segment_id | int | YES | NULL | FK → user_segments |
| is_returning | tinyint(1) | YES | 0 | Вернувшийся посетитель |
| page_views | int | YES | 1 | Просмотры за сессию |
| session_duration | int | YES | 0 | Длительность (сек) |
| bounce | tinyint(1) | YES | 1 | Отказ (1 страница) |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | Начало сессии |
| last_activity | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE | Последняя активность |

**Ключи:** PK(`id`), UNIQUE(`session_id`), INDEX(`visitor_id`, `ip_address`, `created_at`, `last_activity`, `source`, `device_type`, `is_returning`)

---

### 2.17 `page_views`
**Файл:** `013_analytics_sessions.sql` | **Collation:** `utf8mb4_0900_ai_ci`

Просмотры страниц в рамках сессий.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| session_id | varchar(64) | NO | — | ID сессии |
| visitor_id | varchar(64) | NO | — | ID посетителя |
| page_slug | varchar(255) | NO | — | Slug страницы |
| page_title | varchar(255) | YES | NULL | Заголовок страницы |
| page_url | text | NO | — | Полный URL |
| time_on_page | int | YES | 0 | Время на странице (сек) |
| scroll_depth | int | YES | 0 | Глубина прокрутки (%) |
| exit_intent | tinyint(1) | YES | 0 | Попытка ухода |
| viewed_at | timestamp | YES | CURRENT_TIMESTAMP | |

**Ключи:** PK(`id`), INDEX(`session_id`, `visitor_id`, `page_slug`, `viewed_at`)

---

### 2.18 `analytics_events`
**Файл:** `014_analytics_events_geo.sql` | **Collation:** `utf8mb4_0900_ai_ci`

Поведенческие события: клики по кнопкам, просмотры экранов, конверсии.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → `relanding_derelandingdb`.`organizations` |
| visitor_id | varchar(64) | NO | — | ID посетителя |
| session_id | varchar(64) | YES | NULL | ID сессии |
| event_type | enum('click','scroll','form_submit','download','video_play','conversion','custom') | NO | — | Тип события |
| event_category | varchar(100) | YES | NULL | |
| event_action | varchar(100) | YES | NULL | |
| event_label | varchar(255) | YES | NULL | |
| event_value | decimal(10,2) | YES | NULL | |
| event_data | json | YES | NULL | Расширенные данные события |
| page_slug | varchar(255) | YES | NULL | |
| element_id | varchar(100) | YES | NULL | |
| element_class | varchar(100) | YES | NULL | |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | |

**Ключи:** PK(`id`), INDEX(`visitor_id`, `session_id`, `event_type`, `organization_id`, `created_at`)

> **Примечание:** для `section_view` поле `event_type = ''`. Данные в `event_data`: `{page_slug, time_on_page, organization_id}`. `organization_id` берётся из `client_config.organization_id` по домену.

---

### 2.19 `anonymous_analytics`
**Файл:** `014_analytics_events_geo.sql` | **Collation:** `utf8mb4_0900_ai_ci`

Агрегированная анонимная аналитика — счётчики по дням без привязки к сессии.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | bigint unsigned | NO | AUTO_INCREMENT | PK |
| domain | varchar(255) | NO | — | Домен |
| event_type | varchar(50) | NO | 'section_view' | Тип события |
| event_date | date | NO | — | Дата |
| device_type | varchar(50) | YES | 'unknown' | Тип устройства |
| language | varchar(10) | YES | 'de' | |
| page_url | varchar(500) | YES | NULL | |
| events_count | int | YES | 1 | Счётчик (инкрементируется ON DUPLICATE KEY) |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | |
| updated_at | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), UNIQUE(`domain`(191), `event_date`, `page_url`(191), `device_type`)

---

### 2.20 `visitor_geography`
**Файл:** `014_analytics_events_geo.sql` | **Collation:** `utf8mb4_0900_ai_ci`

Кэш геолокации по IP-адресам. Заполняется один раз на IP.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| ip_address | varchar(45) | NO | — | IP адрес (UNIQUE) |
| country_code | varchar(2) | YES | NULL | ISO-код страны |
| country_name | varchar(100) | YES | NULL | |
| region | varchar(100) | YES | NULL | |
| city | varchar(100) | YES | NULL | |
| timezone | varchar(50) | YES | NULL | |
| latitude | decimal(10,8) | YES | NULL | |
| longitude | decimal(11,8) | YES | NULL | |
| isp | varchar(255) | YES | NULL | Интернет-провайдер |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | |
| updated_at | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), UNIQUE(`ip_address`), INDEX(`country_code`, `city`)

---

## 3. Связи между таблицами

### Кросс-база (без FK, логические связи)
| Таблица | Поле | Внешняя зависимость |
|---------|------|---------------------|
| `client_config` | `organization_id` | → `relanding_derelandingdb`.`organizations`.`id` |
| `client_config` | `source_id` | → `relanding_derelandingdb`.`organization_sources`.`id` |
| `analytics_events` | `organization_id` | → `relanding_derelandingdb`.`organizations`.`id` |

### Аналитика (без FK, по session_id / visitor_id)
```
page_views.session_id       → user_sessions.session_id
analytics_events.session_id → user_sessions.session_id
user_sessions.ip_address    → visitor_geography.ip_address
user_sessions.segment_id    → user_segments.id
```

---

## 4. Кэш рендера

Двухуровневая система (`render_theme_cache` удалён — палитра хардкоженная).

| Таблица | Содержимое | Ключ уникальности |
|---------|-----------|-------------------|
| `render_main_cache` | Соцсети + юрссылки + навигация | `(domain, language)` |
| `render_cache` | Полный `$pageStructure` JSON | `(domain, page_slug, language)` |

---

## 5. Маппинг JSON ↔ БД

Правило: **БД = snake_case**, **JSON = camelCase**, конвертация только в `ConfigJsonMigration`.

| JSON-ключ | БД-колонка | Таблица |
|-----------|-----------|---------|
| `fBrand` | `footer_brand` | sites |
| `theme` | `palette` | sites |
| `developerName` | `developer_name` | sites |
| `developerLink` | `developer_link` | sites |
| `levels[].navTitle` | `nav_title` | levels |
| `levels[].metaTitle` | `meta_title` | levels |
| `levels[].scrFull` | `scr_full` | levels |
| `screens[].navTitle` | `nav_title` | screens |
| `screens[].styleId` | `style_id` | screens |
| `screens[].rating` | `has_rating` | screens |
| `screens[].phone` | `has_phone` | screens |
| `screens[].imgPos` | `img_pos` | screens |
| `screens[].textPos` | `text_pos` | screens |
| `screens[].displayOrder` | `display_order` | screens |
| `{textId}.pageTitle` | `page_title` | contents |
| `{textId}.metaTitle` | `meta_title` | contents |
| `{textId}.secCost` | `sec_cost` | contents |
| `{textId}.text` | `text_content` | contents |
| `{textId}.pageActLinkTitle` | `page_act_link_title` | contents |
| `{textId}.pageActLinkPath` | `page_act_link_path` | contents |
| `{textId}.pageSecActBtn` | `page_act_sec_btn` | contents |
| `{textId}.secBtnService` | `sec_btn_service` | contents |
| `{textId}.pageActBtn` | `page_act_btn` | contents |
| `{textId}.btnService` | `btn_service` | contents |
| `{dataId}.mobilePath` | `mobile_path` | media |
| `{dataId}.name` | `alt` | media |
| `{styleId}.costColor` | `cost_color` | screen_style |
| `{styleId}.costSecColor` | `cost_sec_color` | screen_style |
| `{styleId}.textBg` | `text_bg` | screen_style |
| `{styleId}.pageActBtnBg` | `page_act_btn_bg` | screen_style |
| `{styleId}.pageActBtnColor` | `page_act_btn_color` | screen_style |

---

## 6. Порядок создания таблиц

```
012_render_caches.sql
013_analytics_sessions.sql (user_segments перед user_sessions)
014_analytics_events_geo.sql
```

---

## 7. Примечания

### Charset / Collation
- Контентные таблицы (001–011): `utf8mb4_unicode_ci`
- Кэш-таблицы (012): `utf8mb4_general_ci`
- Аналитические таблицы (013–014): `utf8mb4_0900_ai_ci`

### Soft-delete
Нет `deleted_at`. Деактивация через `is_visible` (`pages`, `levels`, `screens`) и `is_active` (`sites`, `client_config`).

### Разделение баз
Эта база (`bcai_page_db`) содержит только клиентскую сторону. CRM, пользователи, организации, AI-функции — в основной базе `bcai_db` (см. `SERVER-SCHEMA.md`). Связь через `client_config` (два поля: `organization_id` и `source_id`) и `analytics_events.organization_id`.
