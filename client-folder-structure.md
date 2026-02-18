bcai-client/                        # Клиентский сайтЫ
├── config/config.php
│
├── database/
│   ├── backups/schema.sql
│   ├── database.php
│   └── schema/
│       └── tables/
│           ├── analytics_events_buffer.sql     # Буфер аналитических событий
│           ├── local_daily_stats.sql           # Агрегированная локальная статистика
│           └── web_sessions.sql
│
├── modules/
│   ├── api/
│   │   └── analytics/
│   │       └── logEvent.php
│   ├── chat/
│   │   ├── api/
│   │   │   ├── client-message.js
│   │   │   └── client-contact.js
│   │   ├── assets/chat.js
│   │   ├── PrivacyConsentHandler.js
│   │   └── widget.js
│   └── public/
│       └── get_faq_api.php                    # обработка событий и буферизация
│
├── public/
│   ├── css/
│   │   ├── chat.css
│   │   └── styles.min.css
│   ├── fonts/montserrat_medium.ttf
│   ├── js
│   │   ├── action_control.js
│   │   ├── background_control.js
│   │   ├── cookie_control.js
│   │   ├── data_control.js
│   │   ├── drag_drop_control.js
│   │   ├── level_control.js
│   │   ├── main_control.js
│   │   ├── msg_control.js
│   │   ├── nav_control.js
│   │   └── nav_site_control.js
│   └── store/
│
├── scripts/
│   ├── Analytics.php
│   └── functions.php
│
├── views/
│   ├── asideContr.view.php
│   ├── footer.view.php
│   ├── head.view.php
│   ├── main.view.php
│   └── mainContr.view.php
│
├── .htaccess
├── favicon.ico
├── index.php
├── robots.txt
└── sitemap.xml