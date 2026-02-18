<?php
//session_start();

// Подключаем конфигурацию и базу данных
// require_once __DIR__ . '/config/database.php';
// require_once __DIR__ . '/database/db.php';
// require_once __DIR__ . '/scripts/functions.php';

require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/scripts/ConfigMigration.php';
// require_once $_SERVER['DOCUMENT_ROOT'] . '/scripts/SiteController.php';
// require_once $_SERVER['DOCUMENT_ROOT'] . '/scripts/ConfigJsonMigration.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/scripts/functions.php';

require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/config/config.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/database/database.php';

try {
  $database = new Database(Config::SERVERNAME, Config::USERNAME, Config::PASSWORD, Config::DBNAME);

  // Проверка подключения
  // if (!$database->getConnection()) {
  //     throw new Exception("Failed to connect to database");
  // }

  // Создаем экземпляр SiteController для генерации $pageStructure
  // $domain = 'site.ru';
  // $domain = $_SERVER['HTTP_HOST'];

  // $parsedUrlData = $controller->getParsedUrlData();
  // echo '<pre>Parsed URL Data: ' . json_encode($parsedUrlData, JSON_PRETTY_PRINT) . '</pre>';

  // $controller = new SiteController($database, $domain);
  // $pageStructure = $controller->getPageStructure();
  // $renderData = $controller->getRenderData();
  // $themes = $renderData['themes'];
  // // $socialMedia = $renderData['socialMedia'];
  // $legal = $renderData['legal'];
  // $navStructure = $controller->getNavStructure();

  $migration = new ConfigMigration($database);
  $configPath = $_SERVER['DOCUMENT_ROOT'] . '/web_relanding/scripts/config_page_1.json';
  $migration->mainMigrate($configPath);
  echo "Migration completed successfully";

  // $id = $pageStructure['levels'][0]['screens'][0]['textId'];
  // var_dump($pageStructure[$id]['title']);
  // var_dump($id);

} catch (Exception $e) {
  echo "<pre>" . htmlspecialchars($e->getTraceAsString()) . "</pre>";
  throw new Exception('Ошибка соединения с базой данных');
}

// Закрытие соединений с базами данных
$database->close();

// require_once $_SERVER['DOCUMENT_ROOT'] . '/views/head.view.php';
// require_once $_SERVER['DOCUMENT_ROOT'] . '/views/main.view.php';
// require_once $_SERVER['DOCUMENT_ROOT'] . '/views/mainContr.view.php';
// require_once $_SERVER['DOCUMENT_ROOT'] . '/views/asideContr.view.php';
// require_once $_SERVER['DOCUMENT_ROOT'] . '/views/footer.view.php';

exit();
