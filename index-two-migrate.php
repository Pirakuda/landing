<?php
//session_start();

// Подключаем конфигурацию и базу данных
// require_once __DIR__ . '/config/database.php';
// require_once __DIR__ . '/database/db.php';
// require_once __DIR__ . '/scripts/functions.php';

require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/scripts/ConfigJsonMigration.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/scripts/functions.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/config/config.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/database/database.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/scripts/ConfigMigration.php';

try {
  $database = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);

  // Инициализация параметров
  // $domain = $_SERVER['HTTP_HOST'];
  $domain = 'site.ru';
  $pageSlug = 'glavnaya';
  $language = 'ru';
  $deviceType = 'desktop';
  $themeName = 'desktop-standart';

  // Инициализация контроллера
  $controller = new ConfigJsonMigration($database, $domain);

  // Получение данных, если кэш отсутствует или устарел
  $pageStructure = null;
  $renderData = null;
  $navStructure = null;

  $pageStructure = $controller->getPageStructure($domain, $deviceType, $pageSlug);
  $renderData = $controller->getRenderData($themeName);
  $navStructure = $controller->getNavStructure();

  // Начало транзакции
  $database->beginTransaction();

  // Запись в render_cache
  $pageStructureJson = json_encode($pageStructure, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);

  $queryRenderCache = "
      INSERT INTO render_cache (
          domain, page_slug, language, device_type, data, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, NOW(), NOW())
      ON DUPLICATE KEY UPDATE
          data = VALUES(data),
          updated_at = NOW()
  ";
  $database->query($queryRenderCache, [
      $domain,
      $pageSlug,
      $language,
      $deviceType,
      $pageStructureJson
  ]);

  // Запись в render_main_cache
  // $themeJson = json_encode($renderData['themes'], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
  // $queryThemeCache = "
  //     INSERT INTO render_theme_cache (
  //         domain, language, device_type, theme, created_at, updated_at
  //     ) VALUES (?, ?, ?, ?, NOW(), NOW())
  //     ON DUPLICATE KEY UPDATE
  //         theme = VALUES(theme),
  //         updated_at = NOW()
  // ";
  // $database->query($queryThemeCache, [
  //     $domain,
  //     $language,
  //     $deviceType,
  //     $themeJson
  // ]);

  // Запись в render_main_cache
  $socialMediaJson = json_encode($renderData['socialMedia'], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
  $legalJson = json_encode($renderData['legal'], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
  $navStructureJson = json_encode($navStructure, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);

  $queryMainCache = "
      INSERT INTO render_main_cache (
          domain, language, socialMedia, legal, navStructure, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, NOW(), NOW())
      ON DUPLICATE KEY UPDATE
          socialMedia = VALUES(socialMedia),
          legal = VALUES(legal),
          navStructure = VALUES(navStructure),
          updated_at = NOW()
  ";
  $database->query($queryMainCache, [
      $domain,
      $language,
      $socialMediaJson,
      $legalJson,
      $navStructureJson
  ]);

  // Завершение транзакции
  $database->commit();
  echo "Data successfully cached in render_cache and/or render_main_cache.\n";
} catch (JsonException $e) {
    $database->rollBack();
    error_log("JSON encoding error: " . $e->getMessage());
    echo "Error: Failed to encode JSON data: " . $e->getMessage() . "\n";
} catch (PDOException $e) {
    $database->rollBack();
    error_log("Database error: " . $e->getMessage());
    echo "Error: Database error: " . $e->getMessage() . "\n";
} catch (Exception $e) {
    $database->rollBack();
    error_log("General error: " . $e->getMessage());
    echo "Error: " . $e->getMessage() . "\n";
} finally {
    $database->close();
}
