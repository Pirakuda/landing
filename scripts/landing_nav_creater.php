<?php

/**
 * Генерирует HTML навигационное меню на основе структуры levels
 * 
 * @param array $levels - массив уровней навигации
 * @param string $baseUrl - базовый URL для ссылок (по умолчанию './')
 * @return string HTML код навигационного меню
 */
function generateNavigationMenu($pageStructure, $baseUrl = './') {
    $levels = isset($pageStructure['levels']) ? $pageStructure['levels'] : [];
    $actLevIndex = (Int)$pageStructure['activeLevel'];
    $html = '';
    
    foreach ($levels as $levelIndex => $level) {
        $html .= generateLevelItem($level, $levelIndex, $actLevIndex, $baseUrl, $pageStructure);
    }

    $html .= '<li class="act-elem link"><button id="nav-faq-btn" class="act-anchor" aria-label="Open FAQ">FAQ</button></li>' . PHP_EOL;
    
    return $html;
}

/**
 * Генерирует элемент уровня навигации
 * 
 * @param array $level - данные уровня
 * @param int $levelIndex - индекс уровня
 * @param string $baseUrl - базовый URL
 * @return string HTML код элемента уровня
 */
function generateLevelItem($level, $levelIndex, $actLevIndex, $baseUrl, $pageStructure) {
    $isActive = $levelIndex === $actLevIndex ? true : false;
    $hasSubmenu = count($level['screens']) > 1;
    $class = 'act-elem link' . ($hasSubmenu ? ' nav-level-1' : '') . ($isActive ? ' cur' : '');
    $levelName = htmlspecialchars($level['nav_title'], ENT_QUOTES, 'UTF-8');
    $html = sprintf('<li class="%s">', $class) . PHP_EOL;
    
    // Определяем основную ссылку уровня
    $mainHref = getMainLevelHref($level, $baseUrl);
    
    // Основная ссылка уровня с условными ARIA атрибутами
    if ($hasSubmenu) {
        $html .= sprintf(
            '<a href="%s" data-level="%d" data-screen="0" class="act-anchor" aria-current="%s" aria-haspopup="true" aria-expanded="false">%s</a>',
            $mainHref,
            $levelIndex,
            $isActive ? 'location' : 'false',
            $levelName
        ) . PHP_EOL;
    } else {
        $html .= sprintf(
            '<a href="%s" data-level="%d" data-screen="0" class="act-anchor" aria-current="%s">%s</a>',
            $mainHref,
            $levelIndex,
            $isActive ? 'location' : 'false',
            $levelName
        ) . PHP_EOL;
    }
    
    // Если есть несколько экранов, создаем подменю
    if ($hasSubmenu) {
        $html .= generateSubmenu($level, $levelIndex, $baseUrl, $isActive, $pageStructure);
    }
    
    $html .= '  </li>' . PHP_EOL;
    
    return $html;
}

/**
 * Определяет основную ссылку для уровня
 * 
 * @param array $level - данные уровня
 * @param string $baseUrl - базовый URL
 * @return string ссылка
 */
function getMainLevelHref($level, $baseUrl) {
    // Если есть slug уровня, используем его
    if (!empty($level['slug'])) {
        return $baseUrl . $level['slug'];
    }
    
    // Если нет slug уровня, но есть slug первого экрана
    if (!empty($level['screens'][0]['slug'])) {
        return $baseUrl . $level['screens'][0]['slug'];
    }
    
    // Если ничего нет, возвращаем пустую ссылку
    return '';
}

/**
 * Генерирует подменю для уровня с несколькими экранами
 * 
 * @param array $level - данные уровня
 * @param string $baseUrl - базовый URL
 * @return string HTML код подменю
 */
function generateSubmenu($level, $levelIndex, $baseUrl, $isLevelActive, $pageStructure) {
    $html = '    <ul class="submenu">' . PHP_EOL;
    
    // Получаем индекс активного экрана для активного уровня
    $activeScreenIndex = null;
    if ($isLevelActive && isset($pageStructure['levels'][$levelIndex]['activeScreen'])) {
        $activeScreenIndex = (int)$pageStructure['levels'][$levelIndex]['activeScreen'];
    }
    
    foreach ($level['screens'] as $screenIndex => $screen) {
        $isScreenActive = ($isLevelActive && $activeScreenIndex === $screenIndex);
        
        $html .= generateScreenItem(
            $level, 
            $levelIndex, 
            $screen, 
            $screenIndex, 
            $baseUrl, 
            $isScreenActive
        );
    }
    
    $html .= '    </ul>' . PHP_EOL;
    
    return $html;
}

/**
 * Генерирует элемент экрана в подменю
 * 
 * @param array $level - данные уровня
 * @param array $screen - данные экрана
 * @param int $screenIndex - индекс экрана
 * @param string $baseUrl - базовый URL
 * @return string HTML код элемента экрана
 */
function generateScreenItem($level, $levelIndex, $screen, $screenIndex, $baseUrl, $isActive) {
    $classCurrent = $isActive ? 'cur' : '';
    $html = '<li class="act-elem link nav-level-2 ' . $classCurrent . '">' . PHP_EOL;
    
    // Определяем ссылку для экрана
    $screenHref = getScreenHref($level, $screen, $screenIndex, $baseUrl);

    // Определяем значение для aria-current
    $ariaCurrent = $isActive ? 'location' : 'false';
    
    // Определяем текст ссылки
    $linkText = htmlspecialchars($screen['nav_title'] ?? $level['nav_title'], ENT_QUOTES, 'UTF-8');

    $html .= sprintf(
            '<a href="%s" aria-current="%s" data-level="%d" data-screen="%d" class="act-anchor">%s</a>',
            $screenHref,
            $ariaCurrent,
            $levelIndex,
            $screenIndex,
            $linkText
        ) . PHP_EOL;
    
    $html .= '      </li>' . PHP_EOL;
    
    return $html;
}

/**
 * Определяет ссылку для конкретного экрана
 * 
 * @param array $level - данные уровня
 * @param array $screen - данные экрана
 * @param int $screenIndex - индекс экрана
 * @param string $baseUrl - базовый URL
 * @return string ссылка
 */
function getScreenHref($level, $screen, $screenIndex, $baseUrl) {
    // Если scrFull = "full", каждый экран имеет свой slug
    if ($level['scrFull'] === 'full' && !empty($screen['slug'])) {
        return $baseUrl . $screen['slug'];
    }
    
    // Если scrFull = "", все экраны используют slug уровня
    if ($level['scrFull'] === '' && !empty($level['slug'])) {
        return $baseUrl . $level['slug'];
    }
    
    // Если есть slug экрана, используем его
    if (!empty($screen['slug'])) {
        return $baseUrl . $screen['slug'];
    }
    
    // Если есть slug уровня, используем его
    if (!empty($level['slug'])) {
        return $baseUrl . $level['slug'];
    }
    
    // Возвращаем пустую ссылку
    return '';
}