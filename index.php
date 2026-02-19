<?php
define('APP_ROOT', __DIR__);
// define('BASE_URL', 'https://relanding.de'); // на проде
define('BASE_URL', '/web_eco_de'); // локально
//session_start();

// Подключаем конфигурацию и базу данных
require_once APP_ROOT . '/scripts/landing_nav_creater.php';
require_once APP_ROOT . '/scripts/functions.php';
require_once APP_ROOT . '/scripts/Analytics.php';
require_once APP_ROOT . '/config/config.php';
require_once APP_ROOT . '/database/database.php';

try {
  $database = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);
  $database->beginTransaction();

  // Инициализация параметров
  $domain = 'relanding.de';
  $language = 'de';
  $deviceType = 'desktop';

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
  $screenSlug = 'ki-oekosystem-mittelstand';

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
           "domain" => "relanding.ru",
           "deviceType" => $deviceType,
           "page_slug" => "404",
           "type" => "landing",
           "brand" => "ReLanding",
           "slogan" => "Сложные технологии - простые решения",
           "developerName" => "",
           "developerLink" => "",
           "phone1" => "+7 988 153 15 36",
           "activeLevel" => 0,
           "levels" => [
               [
                   "title" => "404 - Страница не найдена",
                   "activeScreen" => "0",
                   "scrFull" => "full",
                   "screens" => [
                       [
                           "slug" => "obzor",
                           "rating" => "true",
                           "img_pos" => "center",
                           "text_pos" => "center",
                           "dataIds" => ["1001"],
                           "textId" => "101",
                           "style_id" => ""
                       ]
                   ]
               ]
           ],
           "1001" => 
             ["type" => "image", 
               "path" => "ai-ekosistema-nedvizhimost-sayt-lendingi-avtomatizatsiya.webp",
               "m_path" => "ai-ekosistema-nedvizhimost-sayt-lendingi-avtomatizatsiya-mobile.webp",
               "name" => "AI-экосистема недвижимости BriemChainAI для Краснодара - интегрированное решение с умным сайтом, персонализированными лендингами, полной автоматизацией продаж и продвижением"],
           "101" => [
               "type" => "text",
               "page_title" => "404 - Страница не найдена | Sikamo",
               "meta_title" => "Страница не найдена на Sikamo. Вернитесь на главную или воспользуйтесь меню.",
               "title" => "Страница не найдена!",
               "subtitle" => "К сожалению, страница, которую вы ищете, не существует или была перемещена."
           ]
       ], JSON_THROW_ON_ERROR)
    ];
  }

  //////////////////////////////////////////////////////////////////////////////
  // Получение данных из render_theme_cache
//   $themeData = $database->fetch(
//       "SELECT theme FROM render_theme_cache WHERE domain = ? AND language = ? AND device_type = ?",
//       [$domain, $language, $deviceType]
//   );
//  $theme = $themeData ? json_decode($themeData['theme'], true, 512, JSON_THROW_ON_ERROR) : null;

  //////////////////////////////////////////////////////////////////////////////
  // Получение данных из render_main_cache
  $mainData = $database->fetch(
        "SELECT socialMedia, legal FROM render_main_cache WHERE domain = ? AND language = ?",
        [$domain, $language]
  );
  $socialMedia = $mainData ? json_decode($mainData['socialMedia'], true, 512, JSON_THROW_ON_ERROR) : null;
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
    header('Location: /ki-oekosystem-mittelstand', true, 301);
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
