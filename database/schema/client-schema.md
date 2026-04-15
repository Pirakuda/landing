# CLIENT-SCHEMA.md — База данных `cy13096_site`

> Auto-documented from SQL migration files 001–014. Last updated: 2026-04-15.

---

## 1. Обзор

База данных **cy13096_site** обслуживает клиентскую часть веб-приложения: структуру лендинга, контент экранов, медиафайлы, навигацию и аналитику посетителей.

**Сервер:** MySQL 8.0, charset: `utf8mb4`

**Основные подсистемы:**
- **Структура сайта** — sites, pages, levels, screens
- **Контент** — contents, media, screen_contents, screen_media, screen_style
- **Конфигурация** — client_config, social_media, legal
- **Кэш рендера** — render_cache, render_main_cache
- **Аналитика** — user_sessions, page_views, analytics_events, anonymous_analytics, visitor_geography, user_segments

**Удалено по сравнению с предыдущей версией:** `themes`, `segment_theme_mapping`, `render_theme_cache` — палитра теперь хранится как строка в `sites.palette`.

---

## 2. Таблицы

### 2.1 `sites`
**Файл:** `001_sites.sql` | **Collation:** `utf8mb4_unicode_ci`

Корневая таблица сайта. Один домен = одна запись. Палитра выбирается из 32 хардкоженных вариантов по имени.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| domain | varchar(255) | NO | — | Домен сайта (UNIQUE) |
| type | enum('landing','site') | NO | 'landing' | Тип сайта |
| brand | varchar(255) | YES | 'Brand' | Название бренда |
| footer_brand | varchar(255) | YES | NULL | Бренд в футере (`fBrand` в JSON) |
| slogan | varchar(255) | YES | 'Slogan' | Слоган |
| palette | varchar(50) | YES | 'edtech-yellow-dark' | Имя цветовой палитры из 32 вариантов |
| phone | json | YES | NULL | Массив телефонов `["0123","0456"]` |
| developer_name | varchar(255) | YES | NULL | Имя разработчика |
| developer_link | varchar(255) | YES | NULL | Ссылка на разработчика |
| is_active | tinyint(1) | NO | 0 | Активен ли сайт |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), UNIQUE(`domain`), INDEX(`type`, `is_active`)

**Маппинг в JSON:** `footer_brand → fBrand`, `palette → theme`, `developer_name → developerName`, `developer_link → developerLink`

---

### 2.2 `pages`
**Файл:** `002_pages.sql` | **Collation:** `utf8mb4_unicode_ci`

Страницы сайта — разделы первого уровня навигации.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| site_id | int | NO | — | FK → sites |
| slug | varchar(50) | YES | NULL | URL-slug страницы |
| name | varchar(100) | NO | — | Название страницы |
| display_order | int | YES | 0 | Порядок отображения |
| is_visible | tinyint(1) | NO | 1 | Видима ли |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), INDEX(`site_id`), INDEX(`site_id`, `is_visible`, `display_order`)

---

### 2.3 `levels`
**Файл:** `003_levels.sql` | **Collation:** `utf8mb4_unicode_ci`

Уровни — вертикальные секции parallax-архитектуры внутри страниц.

`scr_full = 'full'` → каждый экран на весь viewport, собственные мета-данные на каждом экране.
`scr_full = NULL` → горизонтальная карусель с общими мета уровня.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| page_id | int | YES | NULL | FK → pages |
| display_order | int | YES | 0 | Порядок отображения |
| title | varchar(100) | NO | — | Заголовок уровня |
| nav_title | varchar(100) | NO | — | Заголовок в навигации |
| slug | varchar(100) | YES | NULL | URL-slug уровня |
| meta_title | varchar(255) | YES | NULL | SEO-заголовок уровня |
| scr_full | varchar(20) | YES | NULL | Режим экранов: `'full'` или NULL |
| is_visible | tinyint(1) | NO | 1 | Видим ли уровень |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), INDEX(`page_id`), INDEX(`page_id`, `is_visible`, `display_order`)

**Маппинг в JSON:** `nav_title → navTitle`, `meta_title → metaTitle`, `scr_full → scrFull`

---

### 2.4 `screens`
**Файл:** `004_screens.sql` | **Collation:** `utf8mb4_unicode_ci`

Экраны — атомарные единицы контента внутри уровней. Каждый экран имеет набор медиа (`dataIds`) и текстовый контент (`textId`).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| site_id | int | NO | — | FK → sites |
| level_id | int | NO | — | FK → levels |
| display_order | int | YES | 0 | Порядок отображения |
| slug | varchar(250) | YES | NULL | URL-slug экрана |
| nav_title | varchar(255) | YES | NULL | Заголовок в навигации (для scrFull-экранов) |
| style_id | int | YES | NULL | FK → screen_style.id (per-screen стили) |
| has_rating | tinyint(1) | YES | 0 | Показывать виджет рейтинга |
| has_phone | tinyint(1) | YES | 0 | Показывать телефон |
| img_pos | varchar(50) | YES | 'left' | Позиция изображения |
| text_pos | varchar(50) | YES | 'right' | Позиция текстового блока |
| is_visible | tinyint(1) | NO | 1 | Видим ли экран |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), INDEX(`level_id`), INDEX(`site_id`), INDEX(`level_id`, `is_visible`, `display_order`)

**Маппинг в JSON:** `nav_title → navTitle`, `style_id → styleId`, `has_rating → rating`, `has_phone → phone`, `img_pos → imgPos`, `text_pos → textPos`, `display_order → displayOrder`

---

### 2.5 `contents`
**Файл:** `005_contents.sql` | **Collation:** `utf8mb4_unicode_ci`

Текстовый контент экранов. Один язык = одна запись. Мобильных дублей нет — контент одинаков для всех устройств.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| language_code | varchar(10) | YES | 'de' | Код языка |
| page_title | varchar(255) | YES | NULL | Заголовок вкладки браузера |
| meta_title | varchar(255) | YES | NULL | SEO meta description |
| cost | varchar(100) | YES | NULL | Цена основная |
| sec_cost | varchar(100) | YES | NULL | Цена вторичная |
| promo | varchar(255) | YES | NULL | Промо-текст над заголовком |
| title | varchar(255) | YES | NULL | Заголовок экрана |
| benefits | text | YES | NULL | Список преимуществ (`<li>…</li>`) |
| text_content | text | YES | NULL | Основной текст (HTML) |
| delivery | varchar(255) | YES | NULL | Условия / сроки |
| page_act_link_title | varchar(255) | YES | NULL | Текст ссылки-действия |
| page_act_link_path | varchar(255) | YES | NULL | URL ссылки-действия |
| page_act_sec_btn | varchar(100) | YES | NULL | Текст вторичной кнопки |
| sec_btn_service | enum('chat','form','rating','faq') | YES | NULL | Роутинг вторичной кнопки |
| page_act_btn | varchar(100) | YES | NULL | Текст основной кнопки |
| btn_service | enum('chat','form','rating','faq') | YES | NULL | Роутинг основной кнопки |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), INDEX(`language_code`)

**Маппинг в JSON (ключ `{textId}: {}`):** `page_title → pageTitle`, `meta_title → metaTitle`, `sec_cost → secCost`, `text_content → text`, `page_act_link_title → pageActLinkTitle`, `page_act_link_path → pageActLinkPath`, `page_act_sec_btn → pageSecActBtn`, `sec_btn_service → secBtnService`, `page_act_btn → pageActBtn`, `btn_service → btnService`

---

### 2.6 `media`
**Файл:** `006_media.sql` | **Collation:** `utf8mb4_unicode_ci`

Медиафайлы экранов. `path` — ландшафтный формат. `mobile_path` — портретный формат; если NULL, используется `path`.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| type | varchar(50) | NO | — | Тип: `image`, `video`, `svg` |
| path | varchar(255) | NO | — | Путь (ландшафт / desktop) |
| mobile_path | varchar(255) | YES | NULL | Путь (портрет / mobile) |
| alt | varchar(255) | YES | 'IMAGE' | Alt-текст |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), INDEX(`type`)

**Маппинг в JSON (ключ `{dataId}: {}`):** `mobile_path → mobilePath`, `alt → name`

---

### 2.7 `screen_contents`
**Файл:** `007_screen_contents.sql` | **Collation:** `utf8mb4_unicode_ci`

Связь экран ↔ контент (N:M). Поддерживает мультиязычность: один экран + несколько записей contents с разными `language_code`.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| screen_id | int | NO | — | FK → screens |
| content_id | int | NO | — | FK → contents |

**Ключи:** PK(`id`), UNIQUE(`screen_id`, `content_id`), INDEX(`screen_id`), INDEX(`content_id`)

---

### 2.8 `screen_media`
**Файл:** `008_screen_media.sql` | **Collation:** `utf8mb4_unicode_ci`

Связь экран ↔ медиа (N:M). `display_order` определяет порядок `dataIds` в JSON — несколько медиа на экране образуют галерею.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| screen_id | int | NO | — | FK → screens |
| media_id | int | NO | — | FK → media |
| display_order | int | YES | 0 | Порядок в галерее |

**Ключи:** PK(`id`), UNIQUE(`screen_id`, `media_id`), INDEX(`screen_id`), INDEX(`media_id`)

---

### 2.9 `screen_style`
**Файл:** `009_screen_style.sql` | **Collation:** `utf8mb4_unicode_ci`

Per-screen переопределение цветов поверх глобальной палитры. Запись создаётся только при необходимости кастомных цветов. `screens.style_id (INT NULL)` → `screen_style.id`.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| cost_color | varchar(50) | YES | NULL | Цвет основной цены |
| cost_sec_color | varchar(50) | YES | NULL | Цвет вторичной цены |
| promo_color | varchar(50) | YES | NULL | Цвет промо-текста |
| promo_size | varchar(20) | YES | NULL | Размер промо-текста |
| title_color | varchar(50) | YES | NULL | Цвет заголовка |
| title_size | varchar(20) | YES | NULL | Размер заголовка |
| benefits_color | varchar(50) | YES | NULL | Цвет блока преимуществ |
| text_bg | varchar(255) | YES | NULL | Фон текстового блока |
| text_color | varchar(50) | YES | NULL | Цвет текста |
| delivery_color | varchar(50) | YES | NULL | Цвет блока условий |
| page_act_sec_btn_bg | varchar(255) | YES | NULL | Фон вторичной кнопки |
| page_act_sec_btn_color | varchar(50) | YES | NULL | Цвет вторичной кнопки |
| page_act_btn_bg | varchar(255) | YES | NULL | Фон основной кнопки |
| page_act_btn_color | varchar(50) | YES | NULL | Цвет основной кнопки |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`)

**Маппинг в JSON (ключ `{styleId}: {}`):** все колонки → camelCase, например `cost_color → costColor`, `text_bg → textBg`, `page_act_btn_bg → pageActBtnBg`

---

### 2.10 `social_media`
**Файл:** `010_social_legal.sql` | **Collation:** `utf8mb4_unicode_ci`

Ссылки на соцсети сайта.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| site_id | int | NO | — | FK → sites |
| name | varchar(100) | NO | — | Название соцсети |
| url | varchar(255) | NO | — | URL профиля |
| display_order | int | YES | 0 | Порядок отображения |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), INDEX(`site_id`, `display_order`)

---

### 2.11 `legal`
**Файл:** `010_social_legal.sql` | **Collation:** `utf8mb4_unicode_ci`

Юридические ссылки сайта (Datenschutz, Impressum и т.д.).

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| site_id | int | NO | — | FK → sites |
| name | varchar(100) | NO | — | Название документа |
| url | varchar(255) | NO | — | URL документа |
| display_order | int | YES | 0 | Порядок отображения |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP ON UPDATE | |

**Ключи:** PK(`id`), INDEX(`site_id`, `display_order`)

---

### 2.12 `client_config`
**Файл:** `011_client_config.sql` | **Collation:** `utf8mb4_unicode_ci`

Мост между клиентской и серверной базами. Привязывает домен к организации и конкретному каналу `organization_sources`. Создаётся автоматически при первом вызове `/newPage` после успешной проверки домена.

| Колонка | Тип | Nullable | Default | Описание |
|---------|-----|----------|---------|----------|
| id | int | NO | AUTO_INCREMENT | PK |
| organization_id | int | NO | — | FK → `relanding_derelandingdb`.`organizations`.`id` |
| source_id | int | NO | — | FK → `relanding_derelandingdb`.`organization_sources`.`id` |
| domain | varchar(255) | NO | — | Домен сайта (UNIQUE) |
| token | varchar(255) | NO | — | Токен аутентификации (UNIQUE) |
| is_active | tinyint(1) | YES | 1 | Активна ли конфигурация |
| created_at | timestamp | YES | CURRENT_TIMESTAMP | |

**Ключи:** PK(`id`), UNIQUE(`domain`), UNIQUE(`token`), INDEX(`organization_id`), INDEX(`source_id`)

> **Жизненный цикл:** при `/newPage//domain//profile//lang` бот проверяет `organization_sources` на сервере (is_confirmed=1, is_active=1), получает `source_id` и `organization_id`, затем создаёт запись `client_config` если её ещё нет. Оба FK кросс-базовые — соблюдаются на уровне приложения.

---

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

### Иерархия контента (1:N)
```
sites
 └─ pages            (site_id → sites.id)
     └─ levels       (page_id → pages.id)
         └─ screens  (level_id → levels.id, site_id → sites.id)
```

### Контент и медиа (N:M через связующие)
| Связующая таблица | Таблица A | Таблица B | Примечание |
|-------------------|-----------|-----------|------------|
| screen_contents | screens | contents | Мультиязычность через language_code |
| screen_media | screens | media | display_order = порядок в dataIds |

### Стили (1:1 опциональная)
```
screens.style_id (INT NULL) → screen_style.id (INT AUTO_INCREMENT)
```

### Навигация (1:N от sites)
```
sites → social_media
sites → legal
```

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
001_sites.sql
002_pages.sql              (depends: sites)
003_levels.sql             (depends: pages)
004_screens.sql            (depends: levels, sites)
005_contents.sql
006_media.sql
007_screen_contents.sql    (depends: screens, contents)
008_screen_media.sql       (depends: screens, media)
009_screen_style.sql
010_social_legal.sql       (depends: sites)
011_client_config.sql
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
Эта база (`cy13096_site`) содержит только клиентскую сторону. CRM, пользователи, организации, AI-функции — в основной базе `relanding_derelandingdb` (см. `SERVER-SCHEMA.md`). Связь через `client_config` (два поля: `organization_id` и `source_id`) и `analytics_events.organization_id`.
