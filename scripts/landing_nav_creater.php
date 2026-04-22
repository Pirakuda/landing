<?php

/**
 * Извлекает контент-объект по textId из pageStructure.
 * Единая точка доступа к мультиязычным текстовым данным level/screen.
 * 
 * @param array $pageStructure - полная структура страницы
 * @param string|int|null $textId - идентификатор контент-объекта
 * @return array контент-объект или пустой массив, если textId отсутствует
 */
function getContent($pageStructure, $textId) {
    if ($textId === null || $textId === '') return [];
    return $pageStructure[(string)$textId] ?? [];
}

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
    
    // Контент уровня — navTitle из level.textId
    $levelContent = getContent($pageStructure, $level['textId'] ?? null);
    $levelName = htmlspecialchars($levelContent['navTitle'] ?? '', ENT_QUOTES, 'UTF-8');
    
    $html = sprintf('<li class="%s">', $class) . PHP_EOL;
    
    // Определяем основную ссылку уровня
    $mainHref = getMainLevelHref($level, $baseUrl, $pageStructure);
    
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
function getMainLevelHref($level, $baseUrl, $pageStructure) {
    // Контент уровня
    $levelContent = getContent($pageStructure, $level['textId'] ?? null);
    
    // Если есть slug уровня (карусельный режим) — используем его
    if (!empty($levelContent['slug'])) {
        return $baseUrl . $levelContent['slug'];
    }
    
    // Если slug уровня нет — берём slug первого экрана (scrFull режим)
    if (!empty($level['screens'][0])) {
        $firstScreenContent = getContent($pageStructure, $level['screens'][0]['textId'] ?? null);
        if (!empty($firstScreenContent['slug'])) {
            return $baseUrl . $firstScreenContent['slug'];
        }
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
            $isScreenActive,
            $pageStructure
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
function generateScreenItem($level, $levelIndex, $screen, $screenIndex, $baseUrl, $isActive, $pageStructure) {
    $classCurrent = $isActive ? 'cur' : '';
    $html = '<li class="act-elem link nav-level-2 ' . $classCurrent . '">' . PHP_EOL;
    
    // Определяем ссылку для экрана
    $screenHref = getScreenHref($level, $screen, $screenIndex, $baseUrl, $pageStructure);

    // Определяем значение для aria-current
    $ariaCurrent = $isActive ? 'location' : 'false';
    
    // Контент экрана и fallback на контент уровня
    $screenContent = getContent($pageStructure, $screen['textId'] ?? null);
    $levelContent = getContent($pageStructure, $level['textId'] ?? null);
    $linkText = htmlspecialchars(
        $screenContent['navTitle'] ?? $levelContent['navTitle'] ?? '',
        ENT_QUOTES, 
        'UTF-8'
    );

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
function getScreenHref($level, $screen, $screenIndex, $baseUrl, $pageStructure) {
    $levelContent = getContent($pageStructure, $level['textId'] ?? null);
    $screenContent = getContent($pageStructure, $screen['textId'] ?? null);
    
    // Если scrFull = "full" — URL каждого экрана свой (из screen.textId)
    if (($level['scrFull'] ?? '') === 'full' && !empty($screenContent['slug'])) {
        return $baseUrl . $screenContent['slug'];
    }
    
    // Если scrFull != "full" (карусель) — URL общий для уровня
    if (($level['scrFull'] ?? '') === '' && !empty($levelContent['slug'])) {
        return $baseUrl . $levelContent['slug'];
    }
    
    // Fallback: сначала пробуем screen.slug
    if (!empty($screenContent['slug'])) {
        return $baseUrl . $screenContent['slug'];
    }
    
    // Затем level.slug
    if (!empty($levelContent['slug'])) {
        return $baseUrl . $levelContent['slug'];
    }
    
    // Если ничего нет, возвращаем пустую ссылку
    return '';
}