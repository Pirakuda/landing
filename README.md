# web_eco_de — PHP Landing

PHP-лендинг с встроенным чат-виджетом, аналитикой и API модулями.

---

## Стек

- **Backend:** PHP
- **Database:** MySQL
- **AI:** OpenAI API
- **Local server:** XAMPP (Apache)

---

## Структура проекта

```
web_eco_de/
│
├── config/
│   ├── config.php              # Конфигурация (не в git — см. config.example.php)
│   └── config.example.php      # Шаблон конфигурации с заглушками
│
├── database/
│   ├── database.php            # Подключение к БД
│   ├── backups/                # SQL-дампы
│   └── schema/tables/          # Схемы таблиц
│
├── modules/
│   ├── api/
│   │   ├── analytics/          # Экспорт и логирование событий
│   │   ├── analyzeEventIntent.php
│   │   └── website/
│   │
│   ├── chat/                   # Чат-виджет
│   │   ├── api/                # clientContact.php, clientMessage.php
│   │   ├── assets/chat.js
│   │   ├── widget.js
│   │   └── PrivacyConsentHandler.js
│   │
│   └── public/                 # Публичные API
│       ├── getComment_api.php
│       ├── setComment_api.php
│       ├── get_faq_api.php
│       ├── getSessionData.php
│       └── setWebsiteFeedback_api.php
│
├── public/
│   ├── css/                    # Стили
│   ├── js/                     # Контроллеры (nav, calc, data, action...)
│   ├── fonts/
│   └── store/                  # Медиафайлы
│
├── views/                      # PHP-шаблоны
│   ├── main.view.php
│   ├── mainContr.view.php
│   ├── asideContr.view.php
│   ├── head.view.php
│   └── footer.view.php
│
├── scripts/                    # Утилиты и миграции
│   ├── functions.php
│   ├── Analytics.php
│   ├── ConfigMigration.php
│   └── landing_nav_creater.php
│
├── index.php                   # Точка входа
├── .htaccess
├── robots.txt
└── sitemap.xml
```

---

## Установка

**1. Клонировать репозиторий**

```bash
git clone git@github.com:Pirakuda/landing.git
cd landing
```

**2. Создать конфиг из шаблона**

```bash
cp config/config.example.php config/config.php
```

Открыть `config/config.php` и заполнить реальными данными:

```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'your_db_name');
define('DB_USER', 'your_db_user');
define('DB_PASS', 'your_db_password');
define('OPENAI_API_KEY', 'sk-...');
```

**3. Создать базу данных**

```sql
CREATE DATABASE your_db_name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Импортировать схему:

```bash
mysql -u your_db_user -p your_db_name < database/schema/tables/analytics_events_buffer.sql
mysql -u your_db_user -p your_db_name < database/schema/tables/web_sessions.sql
mysql -u your_db_user -p your_db_name < database/schema/tables/local_daily_stats.sql
```

**4. Запустить через XAMPP**

Положить проект в `htdocs/`, запустить Apache + MySQL в XAMPP, открыть в браузере:

```
http://localhost/web_eco_de/
```

---

## Безопасность

- `config/config.php` добавлен в `.gitignore` — никогда не коммитится
- Все секреты (DB, OpenAI) хранятся только локально
- `.htaccess` закрывает служебные директории

---

## База данных

| Таблица | Описание |
|--------|----------|
| `web_sessions` | Сессии пользователей |
| `analytics_events_buffer` | Буфер аналитических событий |
| `local_daily_stats` | Дневная статистика |

---
## Синхронизация с базой данных
cd /d/XAMPP/htdocs/web_eco_de
git add .
git commit -m "описание что сделал"
git push
