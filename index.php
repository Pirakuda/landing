<?php
//session_start();

require_once __DIR__ . '/config/config.php';
define('APP_ROOT', __DIR__);
define('BASE_URL', Config::BASE_URL);

// Подключаем конфигурацию и базу данных
require_once APP_ROOT . '/scripts/landing_nav_creater.php';
require_once APP_ROOT . '/scripts/functions.php';
require_once APP_ROOT . '/scripts/Analytics.php';
require_once APP_ROOT . '/database/database.php';

try {
  $database = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);
  $database->beginTransaction();

  // Инициализация параметров
  // test-variant
  if (Config::ENV === 'local') {
    $domain = Config::DOMAIN;
  } else {
    $host = $_SERVER['HTTP_HOST'] ?? Config::DOMAIN;
    $host = preg_replace('/^www\./', '', strtolower($host));
    $domain = $host;
  }
  
  $language = 'de';
  $deviceType = 'desktop';

  // Палитра цветов 32ps
  $colorPalettes = [
    // DARK MOD 21ps ////////////////////////

    // Технологии / SaaS / AI
    'saas-indigo-dark'      => ['#eee','#bbb','207,208,255','#57588e','#43447a','#2f3066','#eee','#57588e','#eee','#2f3066','#DDA63D'],
    'saas-cyan-dark'        => ['#eee','#eee','150,201,214','#1e515e','#0a3d4a','#002936','#22d3ee','#1e515e','#eee','#002936','#DDA63D'],
    'saas-emerald-dark'     => ['#eee','#eee','166,211,189','#2e5b45','#1a4731','#06331d','#52f1b7','#426f59','#eee','#002913','#DDA63D'],

    // Финансы / FinTech / Крипто
    'fintech-navy-dark'     => ['#eee','#eee','160,188,225','#324e73','#1e3a5f','#0a264b','#88cdff','#3c587d','#eee','#0a264b','#DDA63D'],
    'fintech-amber-dark'    => ['#eee','#ddd','181,165,130','#51411e','#3d2d0a','#291900','#fcd34d','#6f5f3c','#eee','#3d2d0a','#fcd34d'],

    // Здоровье / Wellness / Медицина
    'wellness-plum-dark'     => ['#eee','#bbb','188,185,229','#5f5184','#4B3D70','#37295C','#eee','#695b8e','#eee','#4B3D70','#DDA63D'],
    'wellness-pine-dark'     => ['#eee','#eee','65,232,211','#064214','#00380a','#002400','#8cc496','#1e5628','#eee','#00380a','#DDA63D'],
    'wellness-sage-dark'     => ['#eee','#eee','65,232,211','#2b503b','#173c27','#032813','#a0d8aa','#2b503b','#eee','#173c27','#DDA63D'],
    'wellness-teal-dark'     => ['#eee','#eee','155,230,220','#236e64','#0f5a50','#003c32','#5ffff1','#236e64','#eee','#0f5a50','#DDA63D'],
    'wellness-lavender-dark' => ['#eee','#eee','212,152,255','#4f4372','#3b2f5e','#271b4a','#f2b6ff','#4f4372','#eee','#3b2f5e','#DDA63D'],

    // E-commerce / Продукты / Lifestyle
    'commerce-velvet-dark'  => ['#eee','#eee','230,183,255','#643588','#502174','#3c0d60','#e6b7ff','#643588','#eee','#502174','#DDA63D'],
    'commerce-rose-dark'    => ['#eee','#eee','255,143,163','#5e2644','#4a1230','#36001c','#ff8fa3','#5e2644','#eee','#4a1230','#b00'],
    'commerce-orange-dark'  => ['#eee','#eee','251,146,60','#57281b','#431407','#1c1b18','#fb923c','#57281b','#bbb','#431407','#b00'],
    'commerce-claret-dark'  => ['#eee','#eee','255,180,180','#8e1414','#7a0000','#660000','#ffb4b4','#8e1414','#bbb','#7a0000','#DDA63D'],
    'commerce-magenta-dark' => ['#eee','#eee','255,160,227','#971457','#830043','#6f002f','#d9b3ff','#971457','#eee','#830043','#DDA63D'],
    'commerce-mocha-dark'   => ['#eee','#eee','217,208,188','#584637','#443223','#301e0f','#d9d0bc','#584637','#eee','#443223','#DDA63D'],

    // Образование / EdTech / Контент
    'edtech-yellow-dark'    => ['#eee','#bbb','164,164,164','#111','#222','#333','#eee','#555','#DDA63D','#222','#fb5a69','#DDA63D'],
    'edtech-navy-dark'      => ['#eee','#bbb','186,182,224','#151325','#1f1d2f','#333143','#eee','#333143','#eee','#24204a','#DDA63D','#eee'],
    'edtech-midnight-dark'  => ['#eee','#bbb','186,182,224','#38345e','#2e2a54','#1A1640','#eee','#38345e','#eee','#2e2a54','#DDA63D'],
    'edtech-sky-dark'       => ['#eee','#eee','56,189,248','#164475','#0c3a6b','#002657','#a2d0ff','#164475','#eee','#0c3a6b','#DDA63D'],
    'edtech-lime-dark'      => ['#eee','#eee','166,198,148','#2e4e1c','#1a3a08','#062600','#a6c694','#2e4e1c','#eee','#1a3a08','#DDA63D'],


    // LIGHT MOD 11ps ///////////////////////

    // Технологии / SaaS / AI
    'saas-blue-light'       => ['#2f4ac2','#3b5bdb','59,91,219','#f8fdff','#eef3ff','#c7d7fd','#2f4ac2','#c7d7fd','#2f4ac2','#f8fdff','#DDA63D'],
    'saas-violet-light'     => ['#6d28d9','#7c3aed','124,58,237','#fafafe','#f0effe','#d9d6fe','#6d28d9','#d9d6fe','#6d28d9','#fafafe','#DDA63D'],
    'saas-mint-light'       => ['#047857','#059669','5,150,105','#f7fffe','#edfcf9','#aaecd8','#047857','#aaecd8','#047857','#f7fffe','#DDA63D'],

    // Финансы / FinTech / Крипто
    'fintech-arctic-light'  => ['#1e40af','#1d4ed8','29,78,216','#f5f9ff','#e8f1fe','#bad4fd','#1e40af','#bad4fd','#1e40af','#f5f9ff','#DDA63D'],
    'fintech-gold-light'    => ['#b45309','#d97706','217,119,6','#fffcf5','#fef3c7','#f3dcb0','#b45309','#e9d2a6','#b45309','#fffcf5','#DDA63D'],

    // Здоровье / Wellness / Медицина
    'wellness-aqua-light'   => ['#0f766e','#0d9488','13,148,136','#f4fdfb','#e6faf5','#99e9d8','#0f766e','#a3f3e2','#0f766e','#f4fdfb','#DDA63D'],
    'wellness-blush-light'  => ['#be123c','#e11d48','225,29,72','#fff8fa','#ffe4ee','#fecdd3','#be123c','#fecdd3','#be123c','#fff8fa','#DDA63D'],

    // E-commerce / Продукты / Lifestyle
    'commerce-ivory-light'  => ['#78350f','#92400e','146,64,14','#fafaf8','#f4f1eb','#d9d0bc','#78350f','#d9d0bc','#78350f','#fafaf8','#DDA63D'],
    'commerce-peach-light'  => ['#c2410c','#ea5b0c','234,91,12','#fffaf7','#fff0e6','#fdcba4','#c2410c','#fdcba4','#c2410c','#fffaf7','#DDA63D'],

    // Образование / EdTech / Контент
    'edtech-parliament-light'      => ['#444','#01699d','2,132,199','#fff','#ccc','#eee','#022e50','#bbb','#022e50','#f4ffff','#DDA63D','#022e50'],
    'edtech-sky-light'      => ['#0369a1','#0284c7','2,132,199','#f4ffff','#e0f2fe','#91e7ff','#004b83','#91e7ff','#0369a1','#f4ffff','#DDA63D','#004b83'],
    'edtech-lime-light'     => ['#4d7c0f','#4d7c0f','101,163,13','#f9feee','#f1fccb','#cbf36a','#4d7c0f','#cbf36a','#4d7c0f','#f9feee','#DDA63D'],
  ];

  // Получаем REQUEST_URI и удаляем параметры запроса (?key=value)
  $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
  $uri = trim($uri, '/');

  // Определяем базовый путь
  $basePath = defined('BASE_PATH') ? BASE_PATH : 'test';
  if ($basePath && strpos($uri, $basePath) === 0) {
    $uri = substr($uri, strlen($basePath));
    $uri = trim($uri, '/');
  }

  // Разбиваем URI на части
  $parts = explode('/', $uri);
  $pageSlug = null;
  $screenSlug = null;

  // Проверяем количество частей в URI
  if (count($parts) === 1 && !empty($parts[0])) {
      $screenSlug = $parts[0]; // Только screenSlug (например, landing.ru/screenSlug)
  } elseif (count($parts) === 2) {
      $language = $parts[0];   // Первая часть - язык
      $screenSlug = $parts[1]; // Вторая часть - screenSlug (например, landing.ru/en/screenSlug)
  }
  
  // test-variant
  if (Config::ENV === 'local') $screenSlug = 'ki-oekosystem-mittelstand';

  // Валидация
  if ($screenSlug && !preg_match('/^[a-z0-9-]+$/', $screenSlug)) $screenSlug = null;

  // Инициализация аналитики
  $analytics = new Analytics($database, $domain, $language);
  $session = $analytics->initSession();
  $deviceType = $session['device_type']; // device_type из сессии
  $deviceType = 'desktop';

  //////////////////////////////////////////////////////////////////////////////
  // Получение данных из render_cache
  $pageData = $database->fetch(
      "SELECT data FROM render_cache WHERE domain = ? AND language = ? AND device_type = ? LIMIT 1",
      [$domain, $language, $deviceType]
  );
  
  if ($pageData) {
    $pageStructure = json_decode($pageData['data'], true, 512, JSON_THROW_ON_ERROR);
  } else {
    // PAGE 404
    $pageStructure = [
       'data' => json_encode([
           "domain" => Config::DOMAIN,
           "pageSlug" => "PAGE 404",
           "type" => "landing",
           "brand" => Config::DOMAIN,
           "slogan" => "",
           "developerName" => "",
           "developerLink" => "",
           "phone" => [],
           "activeLevel" => 0,
           "levels" => [
               [
                   "title" => "PAGE 404",
                   "activeScreen" => "0",
                   "scrFull" => "full",
                   "screens" => [
                       [
                           "slug" => "PAGE 404",
                           "imgPos" => "",
                           "textPos" => "",
                           "dataIds" => ["1001"],
                           "textId" => "101",
                           "styleId" => ""
                       ]
                   ]
               ]
           ],
           "1001" => 
             ["type" => "image", 
               "path" => "PAGE-404.webp",
               "mobilePath" => "PAGE-404-mobile.webp",
               "name" => "PAGE 404"],
           "101" => [
               "pageTitle" => "PAGE 404",
               "metaTitle" => "PAGE 404",
               "title" => "PAGE 404"
           ]
       ], JSON_THROW_ON_ERROR)
    ];
  }

  $paletteName = $pageStructure['palette'] ?? 'edtech-yellow-dark';
  $p = $colorPalettes[$paletteName];
  $rgbBg = $p[2];
  $pageStructure['rgbBg'] = $rgbBg;

  //////////////////////////////////////////////////////////////////////////////
  // Получение данных из render_main_cache
  $mainData = $database->fetch(
        "SELECT social_media, legal FROM render_main_cache WHERE domain = ? AND language = ?",
        [$domain, $language]
  );
  $socialMedia = $mainData ? json_decode($mainData['social_media'], true, 512, JSON_THROW_ON_ERROR) : null;
  $legal = $mainData ? json_decode($mainData['legal'], true, 512, JSON_THROW_ON_ERROR) : null;
  
  // Простая подготовка данных для клиента
  $cookiesAccepted = isset($_COOKIE['cookies_accepted']) && $_COOKIE['cookies_accepted'] === 'true';
  $analyticsData = [
    'session_id' => $cookiesAccepted ? ($session['session_id'] ?? null) : null,
    'visitor_id' => $cookiesAccepted ? ($session['visitor_id'] ?? null) : null,
    'device_type' => $session['device_type'] ?? 'desktop',
    'language' => $session['language'] ?? 'de',
    'is_anonymous' => !$cookiesAccepted
  ];
  $pageStructure['analytics'] = $analyticsData;

  // $pageStructure['screen_slug'] = $screenSlug ?? 'ai-ekosistema-nedvizhimosti';
  createActLevScrNum($pageStructure, $screenSlug);

  // Логирование просмотра страницы
  // $analytics->logPageView($session, $pageSlug, $screenSlug);

  // Редиректы на канонические URL
  // Обработка корневого URL
  if (empty($screenSlug)) {
    header('Location: /' . $pageStructure['levels'][0]['screens'][0]['slug'], true, 301);
    exit();
  }

  $database->commit();

} catch (JsonException $e) {
    $database->rollBack();
    error_log("JSON encoding/decoding error: " . $e->getMessage());
} catch (PDOException $e) {
    $database->rollBack();
    error_log("Database error: " . $e->getMessage());
} catch (Exception $e) {
    $database->rollBack();
    error_log("General error: " . $e->getMessage());
} finally {
    $database->close();
}

require_once APP_ROOT . '/views/head.view.php';
require_once APP_ROOT . '/views/main.view.php';
require_once APP_ROOT . '/views/mainContr.view.php';
require_once APP_ROOT . '/views/asideContr.view.php';
require_once APP_ROOT . '/views/footer.view.php';
