<?php
function getWelcomeMessage($organization) {
    $orgName = htmlspecialchars($organization['name'] ?? 'Наша компания', ENT_QUOTES, 'UTF-8');
    return "Здравствуйте! Я ИИ-ассистент компании {$orgName}. " .
           "Готов помочь вам с вопросами о наших услугах: " .
           "создание сайтов и лендингов, " .
           "ИИ-CRM системы с управлением через Telegram, " .
           "автоматизация бизнес-процессов " .
           "и интеграция ИИ-решений. " .
           "Задайте ваш вопрос или выберите одну из опций ниже:";
}

function navNumCreate($curNum, $count) {
    $num = 0;

    if ($count > 4) {
        if (($curNum - 2) > 0) {
            $num = ($curNum - 2);
        }
        $count = (($num + 3) < $count) ? ($num + 4) : $count;
    }

    return [$num, $count];
}

function getCurObj(array $pageStructure): ?array {
    $activeLevel = isset($pageStructure['activeLevel']) ? (int)$pageStructure['activeLevel'] : 0;

    if (!isset($pageStructure['levels'][$activeLevel])) return null;
    $levelObj = $pageStructure['levels'][$activeLevel];

    $activeScreen = isset($levelObj['activeScreen']) ? (int)$levelObj['activeScreen'] : 0;

    if (!isset($levelObj['screens'][$activeScreen])) return null;
    $scrObj = $levelObj['screens'][$activeScreen];

    if (!isset($scrObj['textId']) || !isset($pageStructure[$scrObj['textId']])) return null;

    return $pageStructure[$scrObj['textId']];
}

function getMeta(array $pageStructure): ?array {
    $activeLevel = (int)($pageStructure['activeLevel'] ?? 0);
    $levelObj = $pageStructure['levels'][$activeLevel];
    $scrFull = $levelObj['scrFull'] ?? false;

    if ($scrFull) {
        $activeScreen = (int)($levelObj['activeScreen'] ?? 0);
        $scrObj = $levelObj['screens'][$activeScreen];
        return $pageStructure[$scrObj['textId']] ?? [];
    } else {
        return $levelObj ?? [];
    }
}

function createDefaultScrSlug(array &$pageStructure, ?string $curScrSlug): void {
    if (!isset($pageStructure['levels'][0])) return; // Если уровни отсутствуют, завершаем выполнение

    $level = $pageStructure['levels'][0];
        
    if ($level['scrFull'] === 'full') {
        if (!isset($level['screens'][0])) return; // Если экраны отсутствуют, завершаем выполнение
        
        $screen = $level['screens'][0];
        $pageStructure['screen_slug'] = $screen['slug'];
    } else {
        $pageStructure['screen_slug'] = $level['slug'];
    }
    return;
}

// определение активного уровня и экрана и передача в структуру
function createActLevScrNum(array &$pageStructure, ?string $curScrSlug): void {

    if (!$curScrSlug) createDefaultScrSlug($pageStructure, $curScrSlug);

    $isDefined = false;

    foreach ($pageStructure['levels'] as $levelIndex => &$level) {
        // Check if level has scrFull set to "full"
        if ($level['scrFull'] === 'full') {
            // For scrFull levels, check screens' slug
            foreach ($level['screens'] as $screenIndex => $screen) {
                if ($screen['slug'] === $curScrSlug) {
                    $pageStructure['activeLevel'] = $levelIndex;
                    $level['activeScreen'] = $screenIndex;
                    $pageStructure['screen_slug'] = $curScrSlug;
                    $isDefined = true;
                    return;
                }
            }
        } else {
            // For non-scrFull levels, check level's slug
            if ($level['slug'] === $curScrSlug) {
                $pageStructure['activeLevel'] = $levelIndex;
                $level['activeScreen'] = 0; // Default to first screen
                $pageStructure['screen_slug'] = $curScrSlug;
                $isDefined = true;
                return;
            }
        }
    }

    if (!$isDefined) createDefaultScrSlug($pageStructure, $curScrSlug);
}

/**
 * Рендеринг навигационного меню в виде бургер-листа
 * @param array $navStructure Структура навигации
 * @return string HTML-код меню
 */
function renderNavBurgerList(array $pageStructure, array $navStructure): string {
    $html = '' . PHP_EOL;
    $actLev = (Int)$pageStructure['activeLevel'];
    $curPageSlug = $pageStructure['page_slug'];

    // Проходим по всем основным страницам (первый уровень)
    foreach ($navStructure as $mainPage => $pageData) {
        $globalLevelNum = 0; // Глобальный счётчик уровней
        $pageSlug = htmlspecialchars($pageData['slug'], ENT_QUOTES, 'UTF-8');
        $isActive = $curPageSlug === $pageSlug ? true : false;
        $class = 'act-elem link nav-level-1' . ($isActive ? ' cur' : '');
        $mainItemHref = "/webwagen_site/{$pageSlug}/";

        $html .= sprintf('<li class="%s" role="menuitem">', $class) . PHP_EOL;

        $html .= sprintf(
            '<a href="%s" data-index="%d" class="act-anchor" aria-current="%s" aria-haspopup="true" aria-expanded="false">%s</a>',
            $mainItemHref,
            $globalLevelNum,
            $isActive ? 'page' : 'false',
            htmlspecialchars($mainPage, ENT_QUOTES, 'UTF-8')
        ) . PHP_EOL;

        $html .= '<ul class="submenu" role="menu" aria-label="Submenu for ' . htmlspecialchars($mainPage, ENT_QUOTES, 'UTF-8') . '">' . PHP_EOL;
        
        // Проходим по разделам страницы (второй уровень)
        foreach ($pageData['items'] as $sectionKey => $section) {

            $curClass = $isActive && $globalLevelNum === $actLev ? 'cur' : '';
            $html .= '<li class="act-elem link nav-level-2 '.$curClass.'">' . PHP_EOL;

            // Условие для уровней с is_full = false или с одним экраном
            if (!$section['is_full'] || (isset($section['screens']) && count($section['screens']) === 1)) {
                

                // Определяем title и slug
                if (!$section['is_full']) {
                    $itemSlug = htmlspecialchars($section['slug'] ?? '#', ENT_QUOTES, 'UTF-8');
                    $itemTitle = htmlspecialchars($section['title'] ?? $sectionKey, ENT_QUOTES, 'UTF-8');
                } else {
                    $itemSlug = htmlspecialchars($section['screens'][0]['slug'] ?? '#', ENT_QUOTES, 'UTF-8');
                    $itemTitle = htmlspecialchars($section['screens'][0]['title'] ?? $sectionKey, ENT_QUOTES, 'UTF-8');
                }
                $itemHref = "/webwagen_site/{$pageSlug}/{$itemSlug}";

                $html .= sprintf(
                    '<a href="%s" data-index="%d" class="act-anchor">%s</a>',
                    $itemHref,
                    $globalLevelNum,
                    $itemTitle
                ) . PHP_EOL;
            } else {
                $itemSlug = htmlspecialchars($section['screens'][0]['slug'] ?? '#', ENT_QUOTES, 'UTF-8');
                $itemHref = "/webwagen_site/{$pageSlug}/{$itemSlug}";

                $html .= sprintf(
                    '<a href="%s" data-index="%d" class="act-anchor">%s</a>',
                    $itemHref,
                    $globalLevelNum,
                    $sectionKey
                ) . PHP_EOL;
            }

            $globalLevelNum++; // Увеличиваем глобальный счётчик уровней
            $html .= '</li>' . PHP_EOL;
        }

        $html .= '</ul>' . PHP_EOL;
        $html .= '</li>' . PHP_EOL;
    }

    // Добавляем статический пункт FAQ
    if (isset($pageStructure['page_slug']) && $pageStructure['page_slug'] !== 'o-kompanii' && $pageStructure['page_slug'] !== 'portfolio') {
        $html .= '<li class="act-elem link" role="menuitem"><button id="nav-faq-btn" class="act-anchor" aria-label="Open FAQ">FAQ</button></li>' . PHP_EOL;
    } else {
        $html .= '<li style="display:none" class="act-elem link" role="menuitem"><button id="nav-faq-btn" class="act-anchor" aria-label="Open FAQ">FAQ</button></li>' . PHP_EOL;
    }
    
    return $html;
}

function createRaiting() {
    global $totalReviews, $avgRating;

    // Если нет отзывов, не отображаем блок
    if ($totalReviews == 0) {
        return "";
    }

    // Формируем звезды
    $fullStars = str_repeat("&#9733;", floor($avgRating)); // Полные звезды
    $emptyStars = str_repeat("&#9734;", 5 - floor($avgRating)); // Пустые звезды

    return "<div id=\"page-rating-container\" class=\"page-rating-container flex al-it-center m-t-10\" role=\"group\" aria-label=\"Средняя оценка страницы\">
              <span class=\"page-rating-stars\">{$fullStars}{$emptyStars}</span>
              <div class=\"page-rating-counter\" aria-live=\"polite\">{$totalReviews}/{$avgRating}</div>
            </div>";
}

function createPhoneAnchor($phone, $secClass) {
    $path = 'M790 5084 c-118 -19 -185 -59 -295 -176 -218 -231 -368 -525 -436 -858 -21 -101 -24 -143 -24 -350 0 -259 6 -308 60 -505 41 -147 131 -338 223 -474 104 -152 417 -563 619 -812 360 -444 829 -883 1388 -1298 99 -74 205 -153 235 -176 158 -120 300 -204 505 -296 45 -20 174 -57 240 -69 39 -6 90 -16 115 -22 25 -5 128 -12 230 -15 148 -5 208 -2 305 12 119 18 342 73 400 100 252 115 363 184 516 319 160 141 209 227 209 370 0 80 -11 130 -43 196 -15 32 -147 171 -467 492 -435 437 -447 448 -525 485 -78 37 -83 38 -190 38 -107 0 -112 -1 -190 -39 -73 -35 -96 -54 -251 -212 -121 -123 -178 -174 -194 -174 -13 0 -77 30 -144 67 -416 230 -786 542 -1066 899 -146 186 -390 581 -390 632 0 10 14 31 31 48 17 16 103 104 189 196 195 206 204 224 204 398 1 109 -1 119 -32 185 -30 64 -63 100 -470 508 -240 241 -457 451 -482 467 -25 16 -64 36 -85 43 -44 16 -146 27 -185 21z m95 -283 c47 -21 818 -778 865 -849 24 -36 30 -56 30 -97 0 -67 -16 -89 -200 -270 -213 -211 -255 -286 -230 -412 11 -55 75 -193 126 -275 13 -21 24 -40 24 -43 0 -18 199 -311 299 -440 137 -176 413 -458 574 -585 228 -180 628 -430 749 -469 63 -21 138 -17 208 9 60 22 80 38 250 206 102 100 195 187 207 193 42 21 115 13 164 -18 24 -15 225 -210 445 -432 430 -433 423 -424 410 -513 -7 -46 -30 -72 -158 -178 -179 -149 -455 -276 -673 -310 -109 -16 -349 -21 -455 -9 -134 16 -253 44 -325 76 -16 7 -55 23 -85 34 -77 30 -96 40 -175 92 -38 25 -81 52 -95 59 -14 7 -50 32 -80 55 -30 23 -145 109 -255 191 -276 205 -525 406 -684 554 -73 69 -149 138 -168 154 -118 99 -537 581 -749 861 -321 424 -415 564 -475 707 -17 40 -37 87 -44 103 -56 128 -85 305 -85 519 0 177 15 275 71 456 86 278 346 642 464 649 6 0 28 -8 50 -18z';
    $icon = renderSvgIcon('512', 'svg-icon', $path, '2.1978vh');
    $cleanPhone = str_replace(' ', '', $phone);

    return "<a href=\"tel:{$cleanPhone}\" class=\"hpone-anchor flex {$secClass}\">
              <span class=\"phone-icon\">{$icon}</span>
              <span class=\"phone-span\">{$phone}</span>
            </a>";
}

function createPhone($pageStructure) {

    $phoneAnchor1 = !empty($pageStructure['phone1']) ? createPhoneAnchor($pageStructure['phone1'], '') : '';
    $phoneAnchor2 = !empty($pageStructure['phone2']) ? createPhoneAnchor($pageStructure['phone2'], 'hpone-sec') : '';
    
    return "<div class=\"phone-wrap\">
              {$phoneAnchor1}
              {$phoneAnchor2}
            </div>";
}

function createDataHTML($levelObj, $isActScr, $scrObj, $pageStructure) {
    $dataId = $scrObj['dataIds'][0] ?? null;
    if (empty($dataId)) return '';

    $dataObj = $pageStructure[$dataId] ?? null;
    if (empty($dataObj)) return '';

    $baseUrl = './public/store/';
    $url = './public/store/' . $dataObj['path'];
    $isImage = $dataObj['type'] === 'image';

    if ($isImage) {
        $alt = htmlspecialchars($dataObj['name'] ?? 'Изображение');
        $lazyAttrs = ($levelObj['scrFull'] ?? '') === 'full' && !$isActScr ? 'loading="lazy" decoding="async"' : '';
        
        return '
            <picture class="data-wrap">
              <source media="(orientation: landscape)" srcset="'. $baseUrl . $dataObj['path'] .'">
              <img src="'. $baseUrl . $dataObj['m_path'] .'" alt="'. $alt .'" '. $lazyAttrs .' class="data" draggable="false">
            </picture>';

    } else {
        return '
            <div class=\"data-wrap\">
              <video class="video-data" controls autoplay="false" type="video/mp4" draggable="false">
                <source type="video/mp4" src="' . $url . '">
              </video>
            </div>';
    }
}

function createHtmlBgData($dataType, $path) {
    $path = "./public/store/" . $path;
    return "<div class='mini-data' data-type='{$dataType}' style='background-image: url({$path});'></div>";
}

function createHtmlSlider($scrObj, $pageStructure) {
    $container = '';
    foreach ($scrObj['dataIds'] as $index => $id) {
        if (!empty($id) && isset($pageStructure[$id]) && isset($pageStructure[$id]['path'])) {
            $dataObj = $pageStructure[$id];
            $dataType = $dataObj['type'];
            $curClass = ($index === 0) ? 'cur' : '';

            $container .= "<li id=\"" . $id . "\" class=\"figure-slider-item {$curClass}\" data-index=\"{$index}\">" .
                createHtmlBgData($dataType, $dataObj['path']) .
                "</li>";
        }
    }

    $count = count($scrObj['dataIds']);
    $counter = "<div class=\"figure-slider-counter\"><span>1</span><span>/</span><span>{$count}</span></div>";

    return "<div class=\"figure-slider-wrap\">
              <button class=\"figure-slider-btn btn-left hid\">&#10094;</button>
              <div class=\"figure-slider-container\">
                <ul class=\"figure-slider-list\">
                  {$container}
                </ul>
              </div>
              {$counter}
              <button class=\"figure-slider-btn btn-right\">&#10095;</button>
            </div>";
}

function createFigcaption($captions) {
    if (empty($captions)) return "";
    return "<figcaption class=\"figcaption visually-hidden\">".$captions[0]."</figcaption>";
}

function createStyle(array $scrStyleId, string $styleName, string $styleVal, array $pageStructure): string {
    if (empty($pageStructure[$scrStyleId][$styleName])) return '';
    $styleValue = htmlspecialchars($pageStructure[$scrObj['style_id']][$styleName]);
    return "{$styleVal}:{$styleValue};";
}

function createCost($scrStyleId, $secCost, $cost, $promo, $pageStructure) {
    $styles = [];
    if (!empty($scrStyleId)) {
        $styles[] = createStyle($scrStyleId, 'sec_cost_color', '--sec-cost-color', $pageStructure);
        $styles[] = createStyle($scrStyleId, 'cost_color', '--cost-color', $pageStructure);
        $styles[] = createStyle($scrStyleId, 'promo_color', '--promo-color', $pageStructure);
        $styles[] = createStyle($scrStyleId, 'promo_size', '--promo-size', $pageStructure);
    }
    $styleAttr = implode('', $styles);

    $secCostHtml = !empty($secCost) ? "<div class=\"cost-sec-wrap\">{$secCost}</div>" : '';
    $costHtml = !empty($cost) ? "<div class=\"cost-first-wrap\">{$cost}</div>" : '';
    $promoHtml = !empty($promo) ? "<div class=\"promo-wrap\">{$promo}</div>" : '';

    if (empty($secCostHtml) && empty($costHtml) && empty($promoHtml)) return '';

    return "<div class=\"cost-wrap flex\" style=\"{$styleAttr}\">
                <div class=\"cost-card\">
                    {$secCostHtml}
                    {$costHtml}
                </div>
                {$promoHtml}
            </div>";
}

function createTitle($scrStyleId, $title, $pageStructure) {
    if (empty($title)) return "";
    $style = !empty($scrStyleId) ? createStyle($scrStyleId, 'title_color', '--title-color', $pageStructure) : '';
    return "<h3 class=\"title\" style=\"{$style}\">{$title}</h3>";
}

function createBenefits($scrStyleId, $benefits, $pageStructure) {
    if (empty($benefits)) return "";
    $style = !empty($scrStyleId) ? createStyle($scrStyleId, 'benefits_color', '--benefits-color', $pageStructure) : '';
    return "<ul class=\"product-benefits\" style=\"{$style}\">{$benefits}</ul>";
}

function createSubtitle($scrStyleId, $subtitle, $pageStructure) {
    if (empty($subtitle)) return "";
    $style = !empty($scrStyleId) ? createStyle($scrStyleId, 'subtitle_color', '--subtitle-color', $pageStructure) : '';
    return "<h4 class=\"subtitle\" style=\"{$style}\">{$subtitle}</h4>";
}

function createPanelMore($scrStyleId, $text, $pageStructure) {
    if (empty($text)) return "";
    $style = !empty($scrStyleId) ? createStyle($scrStyleId, 'text_color', '--text-color', $pageStructure) : '';
    return "<div class=\"panel-more\" style=\"{$style}\">{$text}</div>";
}

function createDelivery($scrStyleId, $delivery, $pageStructure) {
    if (empty($delivery)) return "";
    $style = !empty($scrStyleId) ? createStyle($scrStyleId, 'delivery_color', '--delivery-color', $pageStructure) : '';
    return "<div class=\"delivery-wrap\" style=\"{$style}\">{$delivery}</div>";
}

function createPageActBtn($scrStyleId, $textObj, $pageActLinkPath, $pageActSecBtn, $pageActBtn, $pageStructure) {
    if (empty($pageActLinkPath) && empty($pageActSecBtn) && empty($pageActBtn)) return '';
    
    // Стили для основной и вторичной кнопок должны быть разделены
    $mainStyles = [];
    if (!empty($scrStyleId)) {
        $mainStyles[] = createStyle($scrStyleId, 'page_act_btn_bg', '--pageActBtn-bg', $pageStructure);
        $mainStyles[] = createStyle($scrStyleId, 'page_act_btn_color', '--pageActBtn-color', $pageStructure);
    }
    $mainStyleAttr = implode('', $mainStyles);

    $linkBtn = '';
    if (!empty($pageActLinkPath)) {
        $title = htmlspecialchars($textObj['pageActLinkTitle'] ?? '');
        $linkBtn = '<a href="' . htmlspecialchars($pageActLinkPath) . '" class="pageActBtn shining" style="' . $mainStyleAttr . '">' . $title . '</a>';
    }
    
    // Кнопка действия (вторичная)
    $secBtn = '';
    if (!empty($pageActSecBtn)) {
        $secStyles = [];
        if (!empty($scrStyleId)) {
            $secStyles[] = createStyle($scrStyleId, 'page_act_sec_btn_bg', '--pageActBtn-bg', $pageStructure);
            $secStyles[] = createStyle($scrStyleId, 'page_act_sec_btn_color', '--pageActBtn-color', $pageStructure);
        }
        $secStyleAttr = implode('', $secStyles);

        $secBtn = '<button class="pageActBtn sec-btn sec-shining" style="' . $secStyleAttr . '" data-service="' . htmlspecialchars($textObj['secBtnService'] ?? '') . '">' .
                    htmlspecialchars($pageActSecBtn) .
                  '</button>';
    }
    
    // Кнопка действия (основная)
    $mainBtn = '';
    if (!empty($pageActBtn)) {
        $mainBtn = '<button class="pageActBtn shining" style="' . $mainStyleAttr . '" data-service="' . htmlspecialchars($textObj['btnService'] ?? '') . '">' .
                    htmlspecialchars($pageActBtn) .
                   '</button>';
    }
    
    return '<div class="page-action-btn-wrap flex">' . $secBtn . $linkBtn . $mainBtn . '</div>';
}

function createBgAbstract(bool $isValid, string $slideTextPos, string $scrFull): string {
    if ($scrFull === '') return '';
    
    if (($isValid === true && $slideTextPos === 'center') || ($isValid === false && $slideTextPos === 'right')) {
        return '
            <div class="slide-bg-abstract-0"></div>
            <div class="slide-bg-abstract-1"></div>
            <div class="curtain-top"></div>
            <div class="curtain-bottom"></div>
        ';
    }
    return '';
}

function renderScr($isActScr, $levelObj, $scrIndex, $curScrClass, $scrFull, $pageStructure) {
    $scrObj = $levelObj['screens'][$scrIndex];
    $scrStyleId = $scrObj['styleId'] ?? null;

    $slideImgPos = $scrObj['img_pos'] ?? 'left-50';
    $slideTextPos = $scrObj['text_pos'] ?? 'right';

    $dataHTML = createDataHTML($levelObj, $isActScr, $scrObj, $pageStructure);
    $slider = (count($scrObj['dataIds']) > 1) ? createHtmlSlider($scrObj, $pageStructure) : '';

    $textId = $scrObj['textId'] ?? null;
    $textObj = $pageStructure[$textId] ?? [];

    $figcaptions = $textObj['figcaption'] ?? null;
    $cost = $textObj['cost'] ?? null;
    $secCost = $textObj['sec_cost'] ?? null;
    $promo = $textObj['promo'] ?? null;
    $title = $textObj['title'] ?? null;
    $benefits = $textObj['benefits'] ?? null;
    $subtitle = $textObj['subtitle'] ?? null;
    $text = $textObj['text'] ?? null;
    $delivery = $textObj['delivery'] ?? null;
    $pageActLinkPath = $textObj['pageActLinkPath'] ?? null;
    $pageSecActBtn = $textObj['pageSecActBtn'] ?? null;
    $pageActBtn = $textObj['pageActBtn'] ?? null;

    $wrapHidClass = (!$benefits && !$subtitle && !$text && ($title || $pageActBtn)) ? 'hid' : '';
    $textHidClass = !empty($text) ? '' : 'hid';
    //$fullOut = !$benefits && !$subtitle && !$text && !$title && !$pageActBtn;

    return "<article data-index=\"$scrIndex\" class=\"screen $curScrClass\">

                <figure class=\"sl slide-img $slideImgPos main\">
                        $dataHTML
                        $slider
                    " . createFigcaption($figcaptions) . "
                </figure>

                <div class=\"sl slide-text $slideTextPos\">
                    <div class=\"text-main-wrap $wrapHidClass\">
                      <div class=\"text-wrap\">
                        <div class=\"text-scroll-wrap\">
                          " . createCost($scrStyleId, $secCost, $cost, $promo, $pageStructure) . "
                          <div class=\"panel-more-wrap {$textHidClass}\">
                            " . createTitle($scrStyleId, $title, $pageStructure) . "
                            " . createBenefits($scrStyleId, $benefits, $pageStructure) . "
                            " . createSubtitle($scrStyleId, $subtitle, $pageStructure) . "
                            " . createPanelMore($scrStyleId, $text, $pageStructure) . "
                          </div>
                        </div>
                        " . (!empty($text) ? "<button class=\"more-btn pos-abs act-elem link act-anchor\">Подробнее</button>" : '') . "
                      </div>
                      " . createDelivery($scrStyleId, $delivery, $pageStructure) . "
                      " . createPageActBtn($scrStyleId, $textObj, $pageActLinkPath, $pageSecActBtn, $pageActBtn, $pageStructure) . "
                      " . createBgAbstract(true, $slideTextPos, $scrFull) . "
                    </div>
                    " . createBgAbstract(false, $slideTextPos, $scrFull) . "
                </div>
            </article>";
}

function createLev($levIndex, $levClass, $pageStructure) {
    if ($levIndex === null) $levIndex = 0;
    $levObj = $pageStructure['levels'][$levIndex] ?? [];

    if (!empty($levObj['activeScreen']) && $levObj['activeScreen']) {
		$actScrIndex = (Int)$levObj['activeScreen'];
	} else {
		$levObj['activeScreen'] = 0;
        $actScrIndex = 0;
	}

    $scrFull = !empty($levObj['scrFull']) ? 'full' : '';
    $screens = $levObj['screens'] ?? [];
    if (!is_array($screens)) $screens = [];
    $scrCount = count($screens) ?: 1;
    $scrContainer = '';
    $isActScr = false;

    for ($i = 0; $i < $scrCount; $i++) {
        
        if ($i < $actScrIndex) {
            $curScrClass = 'prev';
        } elseif ($i === $actScrIndex) {
            $isActScr = true;
            $curScrClass = 'current';
        } else {
            $curScrClass = 'queue';
        }

        $scrContainer .= renderScr($isActScr, $levObj, $i, $curScrClass, $scrFull, $pageStructure);
    }

    $header = $levObj['title'] ?? 'Ebene';

    return "<section data-index=\"$levIndex\" class=\"$levClass\" aria-labelledby=\"section-title-$levIndex\">
                <h2 id=\"section-title-$levIndex\" class=\"level-title\">$header</h2>
                <div class=\"scr-wrap $scrFull\">
                    $scrContainer
                </div>
            </section>";
}

// создание навигации 
function generateNavHTML($count) {
    list($startIndex, $endIndex) = navNumCreate(0, $count);
    $html = '';

    if ($count !== 1) {
        for ($startIndex; $startIndex < $endIndex; $startIndex++) {
            $isActive = ($startIndex === 0) ? 'cur' : '';
            $html .= '<li class="act-elem btn main-color ' . $isActive . '">
                        <a data-index="' . $startIndex . '" class="act-anchor-btn" href="#" aria-label="Go to element ' . $startIndex . '"></a>
                      </li>';
        }
    }

    return $html;
}

function renderSvgIcon($type, $svgClass, $path, $width) {
    return "
      <svg class='$svgClass' version='1.1' xmlns='http://www.w3.org/2000/svg' width='$width' height='$width' viewBox='0 0 512 $type' preserveAspectRatio='xMidYMid meet'>
        <g transform='translate(0, $type) scale(0.100000,-0.100000)' stroke='none'>
          <path d='$path'/>
        </g>
      </svg>
    ";
}

function createFooterSocialLink($networkName, $url) {
  
    // Ассоциативный массив для хранения путей SVG
    $socialPaths = [
        'VKontakte' => '<path d="M275 2890 c-40 -16 -50 -40 -49 -115 1 -39 9 -98 19 -131 28 -95 56 -178 64 -189 4 -5 13 -28 20 -50 22 -65 110 -253 169 -360 50 -91 96 -170 101 -175 3 -3 13 -18 21 -35 25 -49 158 -244 236 -345 107 -139 308 -328 409 -384 17 -9 44 -25 60 -36 44 -28 174 -90 188 -90 7 0 17 -4 22 -9 14 -12 138 -46 225 -61 159 -28 356 -8 404 40 20 19 21 34 26 259 5 254 7 263 58 282 30 11 113 -17 179 -62 26 -18 50 -35 53 -38 3 -3 45 -39 93 -80 48 -41 93 -82 100 -91 16 -23 196 -217 226 -244 13 -11 29 -26 35 -32 6 -5 26 -18 45 -27 29 -15 68 -17 275 -17 206 1 246 3 275 18 74 36 64 143 -25 280 -32 48 -61 89 -65 92 -4 3 -25 29 -47 59 -42 56 -141 164 -306 335 -99 103 -114 133 -96 180 9 24 63 109 80 126 3 3 10 12 15 22 6 9 31 48 58 87 26 39 47 75 47 81 0 5 4 10 8 10 5 0 14 10 21 23 6 12 20 36 31 52 11 17 23 38 26 48 4 9 10 17 14 17 4 0 13 14 20 30 7 17 15 30 19 30 3 0 15 19 26 43 11 23 22 44 25 47 11 9 100 197 100 211 0 8 7 23 15 33 8 11 15 41 15 67 0 106 -8 109 -310 109 -158 0 -249 -4 -263 -11 -29 -15 -87 -70 -87 -83 0 -5 -14 -39 -31 -75 -82 -174 -93 -196 -98 -201 -4 -3 -12 -16 -18 -30 -15 -30 -51 -94 -78 -135 -45 -71 -130 -200 -135 -205 -3 -3 -25 -30 -49 -60 -71 -91 -172 -167 -206 -154 -43 17 -45 42 -45 479 l0 417 -29 29 -29 29 -339 0 -340 0 -24 -26 c-37 -39 -33 -108 9 -154 18 -19 32 -38 32 -42 0 -3 6 -13 13 -20 18 -19 37 -74 54 -153 11 -55 13 -135 11 -365 -4 -299 -9 -341 -43 -354 -33 -12 -114 50 -186 144 -18 25 -37 47 -41 48 -5 2 -8 8 -8 13 0 11 -42 72 -52 77 -5 2 -8 7 -8 12 0 5 -19 41 -43 82 -72 123 -180 349 -231 486 -9 23 -23 61 -32 85 -37 98 -57 128 -102 155 -25 14 -493 17 -527 2z"/>',
        'Facebook' => '<path d="M2233 3394 c-90 -19 -171 -64 -229 -126 -100 -105 -134 -216 -134 -435 l0 -143 -120 0 -120 0 0 -250 0 -250 120 0 120 0 0 -600 0 -600 250 0 250 0 0 600 0 600 178 2 177 3 12 158 c7 87 17 192 23 233 5 42 10 82 10 90 0 11 -35 14 -192 16 l-193 3 -3 70 c-5 98 5 150 34 185 l25 29 157 3 157 3 3 213 2 212 -232 -1 c-156 -1 -254 -6 -295 -15z"/>',
        'Twitter' => '<path d="M1116 3218 c5 -7 194 -262 421 -565 227 -304 413 -556 413 -559 0 -6 -108 -125 -330 -364 -191 -205 -484 -524 -499 -543 -13 -16 -7 -17 81 -17 l95 0 139 152 c76 84 175 191 219 238 177 189 314 337 345 373 17 20 35 37 40 37 4 0 142 -180 306 -400 l299 -400 329 0 c312 0 328 1 314 18 -8 9 -109 143 -223 297 -115 154 -309 414 -432 578 -123 164 -223 301 -223 305 0 4 76 88 168 188 506 548 612 663 612 668 0 3 -42 6 -92 6 l-93 -1 -180 -196 c-326 -355 -497 -538 -505 -541 -4 -1 -76 91 -161 205 -85 114 -208 280 -275 368 l-120 160 -328 3 c-262 2 -326 0 -320 -10z m895 -560 c178 -238 475 -636 661 -885 186 -248 338 -454 338 -457 0 -3 -66 -6 -147 -6 l-148 1 -235 316 c-129 174 -419 562 -644 862 -224 300 -417 558 -428 574 l-19 27 149 0 150 0 323 -432z"/>',
        'Instagram' => '<path d="M1685 3389 c-300 -24 -495 -142 -599 -363 -73 -154 -87 -306 -82 -901 2 -276 8 -470 15 -520 53 -343 249 -536 596 -587 127 -18 1044 -18 1169 0 340 50 532 231 592 560 10 53 16 197 20 462 7 422 -5 744 -32 850 -47 188 -165 339 -325 417 -103 50 -187 70 -344 83 -141 11 -866 11 -1010 -1z m1137 -232 c100 -24 152 -50 213 -108 74 -69 109 -145 129 -274 13 -83 15 -189 12 -615 -3 -562 -6 -596 -63 -708 -31 -62 -112 -140 -176 -171 -106 -51 -161 -55 -737 -55 -457 0 -546 2 -611 16 -152 33 -244 100 -304 221 -56 113 -63 193 -63 732 0 568 10 668 78 775 75 118 179 177 352 199 35 5 297 8 583 6 436 -2 531 -5 587 -18z"/><path d="M2783 2970 c-54 -24 -83 -70 -83 -130 0 -84 57 -140 142 -140 60 0 105 30 130 86 31 72 1 146 -76 183 -52 26 -60 26 -113 1z"/><path d="M2035 2792 c-107 -33 -185 -80 -265 -161 -91 -91 -141 -181 -170 -305 -24 -105 -25 -141 -4 -237 55 -252 241 -438 493 -493 96 -21 132 -20 237 4 231 54 411 227 469 451 26 96 17 271 -18 361 -66 170 -194 299 -365 365 -90 35 -284 43 -377 15z m330 -231 c89 -41 148 -99 192 -188 34 -70 36 -79 36 -172 0 -89 -3 -104 -31 -164 -167 -358 -682 -288 -754 102 -29 157 57 333 200 409 75 40 117 49 215 46 63 -2 91 -9 142 -33z"/>',
        'LinkedIn' => '<path d="M1220 3391 c-86 -28 -151 -83 -191 -161 -35 -68 -33 -186 3 -256 77 -147 244 -204 386 -134 133 67 195 201 157 337 -36 128 -138 211 -266 219 -35 2 -75 0 -89 -5z"/><path d="M2683 2636 c-107 -25 -190 -72 -275 -158 l-78 -78 0 100 0 100 -235 0 -235 0 0 -800 0 -800 235 0 235 0 0 428 c0 446 6 531 41 613 53 123 198 185 347 147 60 -15 131 -84 158 -153 17 -46 19 -91 24 -540 l5 -490 245 0 245 0 0 560 c0 508 -2 567 -18 640 -64 278 -245 429 -527 441 -69 2 -126 -1 -167 -10z"/><path d="M1050 1800 l0 -800 245 0 245 0 0 800 0 800 -245 0 -245 0 0 -800z"/>',
        'YouTube' => '<path d="M1343 3145 c-100 -7 -188 -17 -195 -22 -7 -6 -25 -13 -40 -17 -63 -15 -150 -89 -182 -156 -69 -142 -86 -296 -86 -757 0 -352 15 -576 40 -624 6 -10 10 -25 10 -34 0 -9 14 -46 31 -83 25 -56 40 -75 94 -115 35 -26 73 -47 84 -47 12 0 21 -4 21 -8 0 -13 142 -32 325 -42 267 -15 1311 -12 1570 5 229 15 275 21 275 36 0 5 7 9 15 9 15 0 66 32 115 73 31 27 90 138 90 170 0 10 4 27 10 37 5 10 12 42 15 72 4 29 11 89 16 133 20 170 10 811 -15 975 -18 112 -71 238 -117 277 -45 38 -98 73 -112 73 -7 0 -25 7 -42 16 -21 11 -89 20 -235 30 -263 17 -1421 17 -1687 -1z m904 -722 c7 -6 88 -48 180 -93 93 -46 174 -87 181 -93 17 -14 -55 -58 -273 -168 -99 -50 -193 -98 -210 -107 -16 -10 -56 -32 -88 -50 -32 -18 -70 -37 -83 -42 l-24 -10 0 365 0 364 152 -77 c84 -42 158 -82 165 -89z"/>',
        'Pinterest' => '<path d="M2105 3440 c6 -10 0 -12 -105 -30 -269 -47 -541 -218 -688 -432 -81 -118 -142 -276 -162 -420 -11 -75 -10 -258 0 -258 4 0 12 -27 18 -59 18 -87 85 -213 143 -271 59 -59 161 -114 194 -106 19 5 29 23 53 102 32 103 32 111 -5 162 -13 18 -36 58 -51 90 -25 53 -27 67 -27 192 0 158 6 197 44 295 78 202 245 359 456 431 72 24 95 27 230 28 83 1 170 -2 195 -7 227 -38 409 -199 464 -413 16 -61 17 -71 17 -179 1 -130 -2 -175 -11 -175 -6 0 -8 -11 -4 -24 7 -28 -25 -167 -61 -261 -70 -186 -208 -330 -336 -351 -19 -3 -49 -8 -67 -11 -18 -3 -39 0 -47 7 -8 6 -19 9 -24 6 -17 -11 -99 34 -132 71 -43 49 -51 77 -51 163 0 60 8 102 42 210 89 287 106 389 78 481 -15 52 -70 115 -113 130 -19 7 -35 17 -35 21 0 4 -22 8 -50 8 -27 0 -50 -4 -50 -9 0 -5 -13 -12 -29 -16 -16 -3 -47 -19 -69 -36 -134 -99 -185 -341 -117 -555 l17 -50 -100 -404 c-124 -500 -121 -486 -130 -596 -10 -125 -1 -153 72 -211 20 -17 124 -17 139 -1 7 7 33 58 59 113 46 99 77 198 138 446 l32 126 52 -52 c30 -30 78 -64 116 -82 84 -40 208 -67 262 -58 22 4 52 9 67 10 344 44 631 365 702 788 7 42 16 77 20 77 3 0 6 79 6 175 -1 96 -4 175 -7 175 -3 0 -11 26 -18 58 -47 225 -243 467 -469 581 -106 53 -257 101 -316 101 -15 0 -31 8 -36 18 -6 9 -11 12 -11 5 0 -15 -270 -17 -270 -3 0 6 -7 10 -16 10 -8 0 -12 -4 -9 -10z"/>',
        'TikTok' => '<path d="M2238 2573 c-1 -511 -2 -942 -3 -958 -6 -93 -115 -225 -219 -264 -64 -24 -174 -28 -241 -10 -101 28 -208 139 -239 248 -20 69 -20 109 0 188 41 163 173 267 339 268 39 0 85 -4 103 -8 l32 -9 1 109 c0 59 2 171 2 248 l2 140 -125 3 c-154 3 -227 -12 -365 -79 -114 -54 -203 -123 -270 -207 -25 -31 -49 -61 -53 -67 -14 -18 -78 -130 -79 -138 0 -4 -7 -27 -15 -50 -8 -23 -20 -58 -26 -78 -15 -45 -16 -375 -2 -384 6 -3 10 -17 10 -30 0 -13 5 -36 12 -52 6 -15 12 -30 13 -33 6 -25 72 -137 108 -185 113 -149 267 -255 445 -306 88 -25 305 -27 401 -3 148 36 334 149 418 252 77 95 149 214 156 259 1 10 6 23 10 29 4 7 14 45 23 85 13 60 17 169 23 572 l6 497 38 -25 c130 -89 316 -150 515 -170 l62 -7 0 226 c0 173 -3 226 -12 227 -112 12 -243 55 -343 113 -25 15 -73 54 -106 86 -71 70 -141 207 -165 322 -8 40 -16 83 -19 96 -5 22 -6 22 -220 22 l-215 0 -2 -927z"/>',
        'Snapchat' => '<path d="M1990 3426 c-137 -41 -225 -92 -323 -185 -160 -152 -233 -325 -244 -572 l-6 -135 -57 4 c-137 10 -220 -65 -220 -199 0 -108 50 -170 179 -222 45 -18 71 -34 71 -44 0 -32 -66 -148 -111 -194 -50 -51 -126 -94 -230 -128 -151 -50 -194 -181 -95 -289 31 -35 91 -63 185 -87 l84 -21 15 -50 c7 -27 24 -63 37 -80 42 -56 75 -64 252 -64 l158 0 90 -50 c209 -116 324 -160 425 -160 101 0 215 43 424 159 l90 50 171 3 c169 3 172 3 207 30 36 27 67 80 77 132 6 27 12 31 91 51 95 24 155 52 186 87 99 108 56 239 -95 289 -104 34 -180 77 -230 128 -45 46 -111 162 -111 194 0 10 26 26 71 44 129 52 179 114 179 222 0 133 -78 207 -210 199 l-67 -3 -6 135 c-7 150 -27 241 -78 343 -105 209 -281 356 -500 417 -108 29 -305 28 -409 -4z m401 -139 c42 -14 103 -42 136 -61 80 -47 194 -169 237 -253 59 -118 68 -161 75 -360 6 -174 8 -183 31 -208 26 -27 61 -32 120 -15 85 25 140 5 140 -49 0 -45 -25 -66 -127 -106 -54 -21 -108 -47 -120 -58 -66 -59 22 -285 160 -413 67 -63 132 -99 239 -134 38 -12 70 -26 74 -31 23 -38 -49 -77 -193 -105 -51 -9 -97 -20 -104 -24 -6 -4 -14 -37 -18 -73 -11 -106 -13 -107 -205 -107 -182 0 -182 0 -358 -102 -225 -130 -331 -130 -556 0 -176 102 -176 102 -358 102 -190 0 -188 -1 -203 105 -6 37 -15 71 -21 75 -6 4 -52 15 -103 24 -111 22 -184 51 -193 78 -8 26 -1 32 76 58 120 42 173 73 246 145 136 136 215 344 152 402 -13 11 -63 35 -111 54 -99 38 -137 68 -137 109 0 55 55 75 140 50 59 -17 94 -12 120 15 23 25 25 34 31 208 7 198 16 243 74 357 83 162 235 284 413 332 96 25 241 19 343 -15z"/>',
        'Reddit' => '<path d="M2916 3348 c-17 -6 -41 -23 -55 -39 -25 -27 -28 -27 -108 -22 -46 3 -83 9 -83 13 0 4 -25 10 -57 13 -31 3 -59 11 -63 17 -4 6 -57 13 -126 17 -143 7 -154 1 -154 -77 0 -27 -5 -50 -10 -52 -6 -2 -13 -33 -17 -71 -3 -37 -9 -67 -13 -67 -4 0 -10 -27 -14 -60 -4 -33 -11 -60 -16 -60 -4 0 -11 -34 -15 -75 -4 -41 -11 -75 -15 -75 -4 0 -10 -28 -13 -62 -3 -34 -10 -64 -16 -66 -6 -2 -11 -14 -11 -26 0 -22 -4 -23 -112 -30 -62 -4 -117 -11 -123 -15 -5 -5 -37 -12 -70 -16 -33 -4 -63 -11 -66 -17 -3 -5 -25 -12 -48 -15 -22 -3 -41 -9 -41 -14 0 -4 -13 -10 -30 -14 -17 -4 -30 -10 -30 -15 0 -4 -16 -11 -35 -14 -19 -4 -35 -11 -35 -16 0 -4 -14 -11 -30 -15 -17 -4 -30 -11 -30 -16 0 -5 -11 -11 -25 -15 -14 -3 -25 -10 -25 -15 0 -5 -7 -9 -15 -9 -9 0 -18 -7 -21 -15 -5 -12 -10 -10 -25 9 -12 15 -34 27 -59 31 -22 4 -42 11 -46 16 -7 12 -164 12 -164 0 0 -5 -14 -11 -31 -15 -19 -3 -53 -28 -90 -65 -64 -65 -79 -104 -79 -214 0 -54 18 -127 32 -127 4 0 8 -6 8 -14 0 -18 72 -92 98 -100 17 -6 20 -18 24 -117 3 -66 9 -113 16 -118 6 -3 14 -27 18 -51 4 -25 13 -51 21 -58 7 -7 13 -22 13 -33 0 -10 4 -19 10 -19 5 0 12 -11 16 -24 3 -14 12 -27 20 -30 8 -3 14 -10 14 -16 0 -13 153 -170 165 -170 4 0 18 -11 31 -25 12 -13 34 -27 48 -31 14 -3 26 -10 26 -14 0 -4 12 -11 26 -14 15 -4 33 -14 41 -21 8 -8 23 -15 34 -15 10 0 19 -4 19 -9 0 -5 13 -12 30 -16 16 -4 30 -10 30 -15 0 -4 24 -11 53 -15 28 -4 55 -12 58 -17 3 -5 26 -12 50 -15 24 -3 46 -9 49 -14 7 -10 241 -29 368 -29 124 0 334 18 342 29 3 4 29 11 59 14 30 4 57 11 60 16 3 4 25 12 49 16 23 4 42 11 42 15 0 5 14 11 30 15 17 4 30 10 30 15 0 5 14 11 30 15 17 4 30 10 30 15 0 5 14 11 30 15 17 4 30 11 30 16 0 5 11 11 25 15 14 3 25 10 25 15 0 5 6 9 13 9 7 0 24 13 37 30 14 16 30 29 36 30 14 0 94 77 94 90 0 5 16 24 35 43 19 19 35 39 35 46 0 6 4 11 9 11 5 0 12 14 16 30 4 17 10 30 15 30 5 0 11 13 15 30 4 16 10 30 15 30 5 0 12 25 15 55 4 30 11 55 16 55 5 0 9 39 9 87 l0 86 59 57 c32 32 63 72 70 90 14 42 14 173 0 224 -10 35 -94 136 -113 136 -4 0 -14 7 -22 15 -12 12 -41 15 -127 15 -95 0 -118 -3 -152 -21 -22 -12 -43 -27 -47 -33 -6 -8 -10 -8 -16 1 -4 6 -19 14 -34 18 -15 4 -29 13 -32 21 -3 8 -12 14 -21 14 -8 0 -15 4 -15 9 0 5 -13 12 -30 16 -16 4 -30 10 -30 15 0 4 -18 10 -40 14 -22 3 -40 10 -40 16 0 5 -16 12 -35 16 -19 3 -35 10 -35 14 0 4 -19 10 -41 13 -23 3 -45 10 -48 15 -3 5 -33 12 -66 16 -33 4 -64 11 -69 16 -6 6 -52 10 -103 10 -86 0 -93 1 -93 20 0 11 4 20 9 20 4 0 12 32 15 70 4 39 11 70 16 70 4 0 12 35 15 78 4 42 12 80 17 83 4 3 11 35 15 72 3 37 9 67 13 67 4 0 10 27 14 60 4 33 11 60 16 60 6 0 10 -4 10 -9 0 -5 35 -13 78 -16 42 -4 80 -12 83 -17 3 -4 35 -11 72 -15 37 -3 67 -10 67 -14 0 -5 15 -9 33 -9 42 0 53 -8 60 -47 7 -34 79 -113 103 -113 8 0 14 -4 14 -10 0 -6 33 -10 80 -10 47 0 80 4 80 10 0 6 5 10 11 10 20 0 89 77 89 99 0 11 5 21 10 21 6 0 10 28 10 65 0 37 -4 65 -10 65 -5 0 -10 6 -10 14 0 19 -75 95 -106 106 -33 13 -131 11 -168 -2z m-1049 -1230 c24 -23 43 -48 43 -55 0 -7 3 -13 8 -13 5 0 -1 -141 -7 -157 -6 -13 -66 -63 -77 -63 -8 0 -14 -4 -14 -10 0 -6 -32 -10 -75 -10 -43 0 -75 4 -75 10 0 6 -6 10 -14 10 -19 0 -76 57 -76 76 0 8 -4 14 -10 14 -6 0 -10 28 -10 65 0 37 4 65 10 65 6 0 10 6 10 14 0 7 17 32 38 54 l37 40 85 1 84 1 43 -42z m853 32 c0 -5 5 -10 11 -10 19 0 78 -66 85 -94 3 -14 10 -26 15 -26 5 0 9 -20 9 -45 0 -25 -4 -45 -10 -45 -5 0 -10 -9 -10 -19 0 -11 -21 -41 -47 -66 l-47 -47 -82 4 c-77 4 -83 6 -118 40 -20 19 -36 40 -36 47 0 6 -3 11 -7 11 -5 0 -7 37 -5 82 l3 83 47 48 46 47 73 0 c42 0 73 -4 73 -10z m-904 -654 c3 -8 16 -17 30 -20 13 -4 24 -11 24 -16 0 -5 18 -13 40 -16 22 -4 45 -13 51 -20 6 -8 20 -14 30 -14 10 0 21 -4 24 -10 4 -6 76 -10 183 -10 140 1 181 4 196 15 11 8 30 15 42 15 21 0 83 27 94 41 3 4 16 10 30 14 13 4 30 14 38 21 14 15 49 18 76 8 21 -8 21 -54 1 -54 -8 0 -23 -9 -32 -20 -10 -11 -23 -20 -30 -20 -7 0 -13 -4 -13 -9 0 -5 -13 -12 -30 -16 -16 -4 -30 -11 -30 -16 0 -5 -13 -9 -29 -9 -16 0 -36 -6 -44 -14 -7 -8 -39 -17 -70 -21 -32 -4 -57 -11 -57 -16 0 -5 -63 -9 -140 -9 -77 0 -140 4 -140 9 0 5 -25 12 -57 16 -31 4 -63 13 -70 21 -8 8 -23 14 -34 14 -10 0 -19 5 -19 10 0 6 -11 10 -25 10 -14 0 -28 6 -31 14 -3 8 -16 17 -30 20 -38 10 -64 38 -64 68 0 26 3 28 40 28 26 0 43 -5 46 -14z"/>',
        'WhatsApp' => '<path d="M1966 3484 c-112 -21 -276 -77 -365 -126 -122 -66 -190 -116 -290 -212 -195 -189 -305 -378 -372 -641 -21 -79 -23 -114 -24 -290 0 -176 3 -211 23 -295 25 -102 80 -250 117 -315 l23 -40 -90 -328 c-49 -181 -87 -331 -85 -334 3 -2 90 18 194 45 374 99 465 122 479 122 8 0 37 -11 65 -25 266 -135 643 -163 943 -68 189 60 373 171 515 312 111 110 178 199 245 331 126 246 170 509 130 777 -42 289 -156 516 -364 724 -177 178 -353 280 -599 345 -83 23 -121 27 -281 30 -135 3 -206 -1 -264 -12z m349 -204 c242 -28 438 -119 615 -287 226 -215 339 -473 340 -776 0 -415 -227 -784 -599 -972 -30 -15 -102 -43 -160 -62 -101 -35 -113 -36 -277 -41 -161 -4 -178 -3 -280 23 -68 16 -152 47 -223 81 -62 30 -121 54 -131 54 -10 0 -62 -12 -116 -26 -243 -64 -274 -70 -274 -60 0 6 11 52 25 101 13 50 36 134 50 187 l27 97 -41 68 c-113 191 -164 423 -142 643 13 120 23 166 57 261 151 422 540 702 994 717 25 1 86 -3 135 -8z"/><path d="M1684 2791 c-71 -43 -131 -151 -141 -253 -15 -171 104 -387 343 -619 162 -157 277 -228 482 -295 95 -32 116 -35 187 -32 64 4 92 11 141 35 107 55 154 127 154 236 l0 48 -144 70 c-79 38 -155 69 -169 69 -20 0 -37 -14 -71 -59 -66 -85 -101 -112 -130 -101 -164 62 -316 182 -413 325 -60 89 -61 97 -15 147 53 60 72 89 72 114 0 32 -117 307 -137 322 -26 19 -123 15 -159 -7z"/>',
        'Telegram' => '<path d="M3270 3265 c-55 -24 -184 -74 -480 -186 -85 -33 -164 -64 -175 -69 -11 -5 -121 -48 -245 -96 -124 -47 -317 -122 -430 -166 -253 -98 -386 -150 -705 -273 -319 -124 -335 -133 -335 -204 0 -57 -2 -56 500 -215 80 -25 149 -46 154 -46 5 0 73 40 150 88 78 49 238 148 356 222 118 73 242 150 275 171 97 61 461 287 582 361 116 71 178 95 172 65 -3 -12 -745 -696 -1171 -1079 l-75 -68 -11 -97 c-12 -100 -19 -180 -27 -314 -4 -70 -3 -79 19 -102 32 -34 67 -42 102 -24 16 9 105 87 197 175 l168 160 147 -112 c193 -148 417 -313 456 -337 47 -29 126 -26 158 6 41 41 56 89 113 370 31 149 57 277 60 285 2 8 31 146 64 305 168 804 192 922 198 940 3 11 8 62 10 113 5 92 4 94 -23 123 -25 26 -34 29 -88 28 -40 -1 -80 -9 -116 -24z"/>',
        'Tumblr' => '<path d="M2026 3484 c-3 -9 -6 -31 -6 -50 0 -37 -16 -96 -56 -204 -64 -174 -192 -315 -357 -394 -51 -25 -104 -48 -119 -51 l-28 -7 0 -214 0 -214 175 0 175 0 1 -417 c1 -230 3 -431 5 -448 9 -100 26 -177 51 -232 44 -96 159 -228 228 -263 17 -8 38 -21 48 -29 9 -8 17 -11 17 -7 0 3 13 0 29 -9 64 -32 195 -45 472 -45 l269 0 0 255 0 255 -135 0 c-165 0 -229 18 -287 79 -64 68 -68 97 -68 503 l0 358 240 0 240 0 0 245 0 245 -237 2 -238 3 -3 328 -2 327 -204 0 c-177 0 -205 -2 -210 -16z"/>',
        'Vimeo' => '<path d="M2885 3221 c-168 -50 -279 -134 -381 -288 -34 -52 -92 -174 -108 -229 l-6 -21 72 19 c130 34 218 16 271 -54 28 -37 26 -143 -3 -221 -50 -134 -196 -361 -292 -455 -94 -92 -147 -82 -208 38 -58 116 -94 258 -155 606 -25 143 -54 289 -64 326 -55 193 -169 287 -331 276 -57 -4 -83 -13 -157 -53 -48 -26 -122 -72 -163 -103 -84 -63 -435 -356 -445 -372 -7 -11 17 -46 76 -113 l34 -38 90 56 c49 30 100 55 114 55 34 0 84 -34 114 -77 66 -96 101 -195 287 -828 88 -298 145 -413 255 -513 77 -70 140 -90 245 -74 183 27 352 133 591 371 369 369 653 774 743 1060 47 148 45 341 -3 455 -27 61 -94 132 -156 164 -47 25 -59 27 -205 29 -126 2 -166 -1 -215 -16z"/>',
        'Flickr' => '<path d="M1365 2743 c-33 -13 -68 -26 -77 -29 -10 -4 -18 -10 -18 -15 0 -5 -7 -9 -15 -9 -7 0 -47 -33 -88 -72 -58 -58 -83 -92 -118 -162 l-44 -89 -3 -148 c-3 -141 -2 -150 24 -215 15 -37 40 -88 56 -113 32 -52 153 -171 173 -171 7 0 15 -5 17 -10 2 -6 39 -24 83 -40 75 -28 88 -30 209 -29 193 2 286 40 412 171 123 127 158 223 152 416 -4 117 -6 133 -38 206 -26 63 -49 96 -108 158 -79 83 -144 126 -239 159 -87 30 -293 26 -378 -8z"/><path d="M2637 2745 c-172 -59 -314 -216 -363 -399 -18 -67 -17 -217 1 -286 48 -180 187 -332 360 -395 61 -22 86 -25 195 -25 108 0 134 3 194 25 96 35 131 58 213 140 118 119 163 229 163 401 0 97 -4 123 -26 186 -33 92 -77 159 -151 229 -71 67 -110 92 -199 124 -60 22 -85 25 -194 24 -104 0 -136 -4 -193 -24z"/>',
        'Medium' => '<path d="M990 3005 l0 -145 50 0 c56 0 104 -20 120 -49 6 -13 10 -229 10 -626 l0 -606 -25 -24 c-21 -22 -33 -25 -90 -25 l-65 0 0 -145 0 -145 365 0 365 0 0 145 0 145 -85 0 -85 0 1 608 c1 338 5 589 9 566 10 -50 187 -680 201 -712 5 -13 9 -34 9 -47 0 -14 34 -143 76 -287 42 -145 86 -298 97 -340 l21 -78 166 0 166 0 21 78 c11 42 39 140 62 217 22 77 41 147 41 156 0 16 15 68 145 519 30 107 62 226 70 263 12 59 48 187 75 267 5 14 9 -246 9 -592 l1 -618 -90 0 -90 0 0 -145 0 -145 435 0 435 0 0 145 0 145 -65 0 c-57 0 -69 3 -90 25 l-25 24 0 611 0 612 29 29 c26 26 36 29 90 29 l61 0 0 145 0 145 -455 0 -454 0 -17 -57 c-9 -32 -22 -76 -29 -98 -6 -22 -22 -83 -35 -135 -21 -88 -144 -538 -193 -707 -12 -40 -24 -73 -27 -73 -4 0 -24 62 -45 138 -21 75 -54 191 -72 257 -66 231 -83 297 -84 318 0 12 -22 96 -48 187 l-47 165 -457 3 -457 2 0 -145z"/>',
        'Quora' => '<path d="M1867 3433 c-16 -8 -39 -16 -50 -18 -36 -5 -134 -42 -200 -76 -148 -75 -202 -114 -312 -223 -91 -92 -120 -129 -168 -214 -31 -56 -57 -109 -57 -117 0 -7 -4 -16 -8 -19 -5 -3 -16 -33 -26 -68 -10 -35 -22 -71 -27 -80 -5 -10 -9 -27 -9 -38 0 -11 -4 -20 -9 -20 -5 0 -9 -85 -10 -190 -2 -150 1 -190 11 -190 9 0 9 -3 -2 -10 -10 -7 -12 -12 -4 -17 6 -5 13 -19 17 -33 28 -131 116 -328 179 -404 92 -110 113 -133 148 -161 20 -16 61 -49 90 -73 85 -69 177 -118 294 -157 145 -48 248 -66 377 -64 93 1 236 20 259 34 4 3 19 -14 33 -37 37 -63 65 -96 131 -161 55 -53 179 -127 212 -127 8 0 14 -4 14 -10 0 -6 57 -10 150 -10 93 0 150 4 150 10 0 6 6 10 13 10 8 0 41 13 74 30 86 43 181 145 218 235 16 39 32 72 36 75 4 3 7 44 8 93 l2 87 -91 0 c-81 0 -90 -2 -90 -19 0 -33 -29 -88 -60 -114 -93 -79 -268 -23 -352 111 l-20 33 84 82 c114 112 140 147 195 257 25 52 53 107 60 123 8 15 12 27 9 27 -3 0 1 15 9 34 39 93 73 408 49 448 -4 6 -8 25 -9 42 -9 127 -97 349 -191 476 -68 93 -235 244 -329 297 -122 70 -207 107 -295 129 -41 11 -77 22 -78 27 -2 4 -92 7 -200 6 -150 -1 -204 -5 -225 -16z m351 -228 c194 -39 335 -167 392 -355 12 -41 25 -82 28 -90 7 -18 6 -15 27 -165 13 -93 16 -162 11 -305 -6 -194 -9 -226 -27 -294 -6 -22 -12 -48 -13 -56 -2 -8 -5 -22 -8 -30 -3 -8 -11 -34 -17 -58 l-12 -43 -43 58 c-77 105 -182 175 -311 208 -77 20 -230 19 -309 -1 -80 -20 -226 -91 -226 -109 0 -20 61 -145 71 -145 4 0 31 5 59 11 136 29 278 -63 376 -244 l41 -76 -41 -7 c-22 -4 -84 -7 -137 -7 -157 1 -283 49 -376 145 -56 56 -133 193 -133 234 0 13 -4 24 -9 24 -6 0 -9 8 -9 18 1 26 -24 166 -31 172 -3 3 -7 30 -7 60 -5 227 -5 362 0 367 3 4 6 23 6 44 0 20 9 81 20 135 10 53 17 101 14 106 -3 4 -1 8 5 8 5 0 14 20 19 44 12 58 75 169 123 217 123 123 318 173 517 134z"/>',
        'Discord' => '<path d="M1688 3174 c-3 -3 -34 -12 -68 -20 -68 -16 -81 -21 -245 -100 -192 -92 -197 -97 -272 -259 -35 -77 -78 -178 -94 -225 -43 -121 -115 -407 -134 -530 -8 -58 -20 -129 -25 -159 -6 -30 -10 -116 -10 -191 0 -124 2 -139 20 -155 11 -10 20 -24 20 -31 0 -7 21 -31 46 -53 159 -140 401 -241 573 -241 64 1 67 2 91 36 14 20 46 62 73 94 26 33 47 63 47 69 0 5 -17 15 -37 21 -57 18 -173 72 -173 80 0 5 -21 22 -47 38 -27 17 -63 47 -82 66 l-34 35 74 -39 c41 -21 98 -48 128 -60 30 -11 74 -30 97 -41 57 -26 223 -65 359 -85 147 -22 398 -15 539 15 150 32 219 51 244 67 13 9 54 27 90 40 37 14 101 43 142 65 l75 40 -40 -36 c-22 -19 -60 -50 -85 -67 -25 -17 -47 -35 -50 -39 -9 -12 -105 -57 -162 -75 -32 -10 -58 -21 -58 -26 0 -8 112 -159 138 -187 17 -17 161 -7 239 17 17 6 34 8 37 4 3 -3 6 0 6 7 0 8 7 10 20 6 12 -4 20 -2 20 5 0 6 5 8 11 4 6 -3 14 -3 18 2 3 5 44 28 91 52 102 51 195 123 251 194 l41 52 -5 150 c-9 306 -103 734 -217 981 -20 44 -52 116 -71 159 -31 72 -39 82 -94 118 -53 35 -157 88 -290 149 -64 29 -163 52 -245 56 -67 4 -78 2 -95 -17 -26 -29 -11 -41 95 -75 88 -28 310 -131 345 -160 19 -16 19 -16 -4 -4 -48 23 -258 90 -341 109 -180 40 -314 53 -484 47 -185 -7 -290 -18 -429 -48 -102 -21 -299 -84 -354 -113 -63 -32 -32 -7 46 38 84 48 204 100 316 136 39 12 74 26 80 31 5 5 17 9 27 9 21 0 24 20 6 38 -12 12 -149 17 -160 6z m190 -910 c62 -41 111 -124 113 -194 2 -59 -10 -130 -22 -130 -6 0 -8 -4 -5 -8 3 -5 -4 -18 -14 -30 -11 -12 -20 -25 -20 -29 0 -13 -64 -53 -101 -63 -150 -43 -289 72 -289 240 0 73 56 182 109 213 63 37 173 38 229 1z m840 7 c9 -5 29 -22 44 -38 152 -162 60 -433 -147 -433 -83 0 -171 57 -206 135 -21 45 -25 157 -8 202 30 81 99 142 174 153 43 6 114 -3 143 -19z"/>',
        'WeChat' => '<path d="M1605 3372 c-38 -8 -72 -17 -75 -21 -3 -4 -24 -13 -47 -19 -148 -44 -294 -133 -410 -251 -78 -79 -146 -167 -148 -191 -1 -3 -10 -26 -22 -51 -41 -92 -58 -177 -57 -304 0 -138 15 -202 74 -330 29 -63 57 -103 107 -156 37 -39 71 -76 75 -83 4 -7 32 -32 62 -55 l54 -42 -59 -126 c-33 -69 -57 -128 -54 -132 6 -6 3 -7 190 70 72 29 136 59 144 66 13 13 44 10 66 -7 16 -13 130 -40 169 -40 35 0 36 1 29 28 -4 15 -7 74 -7 132 0 106 23 227 46 241 6 4 7 12 4 18 -4 6 -3 11 2 11 5 0 20 24 32 53 65 151 226 309 404 396 57 28 173 71 191 71 8 0 15 4 15 9 0 8 53 21 160 38 25 5 105 8 178 7 72 0 132 3 132 6 0 17 -41 122 -73 190 -29 61 -56 96 -145 185 -102 104 -115 114 -233 172 -68 35 -146 68 -174 75 -27 7 -52 16 -55 20 -24 32 -490 56 -490 26 0 -9 -3 -9 -8 -2 -5 7 -28 6 -77 -4z m-25 -387 c16 -9 36 -29 45 -45 43 -84 -13 -180 -105 -180 -92 0 -148 96 -105 180 29 55 105 76 165 45z m680 0 c16 -9 36 -29 45 -45 43 -84 -13 -180 -105 -180 -92 0 -148 96 -105 180 29 55 105 76 165 45z"/> <path d="M2505 2525 c-38 -7 -82 -18 -97 -24 -16 -6 -28 -9 -28 -6 0 6 -133 -54 -140 -63 -8 -12 -60 -43 -60 -37 0 4 -21 -9 -46 -27 -56 -40 -185 -178 -178 -190 3 -4 1 -8 -5 -8 -15 0 -67 -117 -80 -178 -14 -65 -14 -202 -1 -262 16 -68 50 -148 66 -154 9 -3 12 -10 9 -16 -3 -5 -1 -10 6 -10 7 0 10 -3 6 -6 -7 -7 10 -28 98 -118 48 -50 91 -83 138 -106 37 -19 67 -37 67 -41 0 -7 90 -48 119 -54 44 -9 118 -28 139 -36 14 -5 22 -5 22 2 0 6 6 6 19 -1 26 -13 243 -13 313 1 52 10 59 9 126 -20 39 -17 73 -31 77 -31 12 0 200 -84 205 -91 8 -11 101 -41 107 -35 8 8 -17 76 -28 76 -6 0 -8 4 -5 9 4 5 2 11 -3 13 -6 1 -33 50 -61 108 l-50 105 26 20 c53 39 174 149 174 157 0 4 15 31 34 60 63 101 79 159 80 293 0 106 -3 129 -27 195 -15 41 -39 91 -52 112 -14 21 -25 41 -25 46 0 12 -150 146 -206 183 -27 18 -51 36 -54 40 -11 16 -180 77 -235 85 -16 3 -52 9 -78 14 -67 14 -288 10 -372 -5z m16 -398 c94 -63 50 -217 -62 -217 -58 0 -94 22 -113 70 -9 22 -16 47 -16 56 0 28 31 75 63 94 42 26 86 25 128 -3z m501 3 c14 -10 27 -17 30 -15 3 3 11 -13 18 -34 30 -93 -19 -171 -108 -171 -57 0 -87 19 -107 67 -23 54 -19 88 15 127 43 48 110 60 152 26z"/>'
    ];
  
    // Получаем путь для указанной социальной сети
    $path = isset($socialPaths[$networkName]) ? $socialPaths[$networkName] : '';
  
    return '
        <li id="social-link-' . $networkName . '" class="social-link-item">
            <a class="social-link-anchor" href="' . $url . '" title="перейти на страницу ' . $networkName . '" target="_blank">
                <svg class="svg-icon" version="1.1" xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 440.000000 440.000000" preserveAspectRatio="xMidYMid meet">
                    <g transform="translate(0.000000,440.000000) scale(0.100000,-0.100000)" stroke="none">
                        ' . $path . '
                    </g>
                </svg>
            </a>
        </li>
    ';
}
  
function renderSocialLinks($socialMedia) {
  if (empty($socialMedia) || !is_array($socialMedia)) return '';

  $html = '<ul id="social-links-list" class="social-links flex">';

  foreach ($socialMedia as $socialNetwork) {
    $html .= createFooterSocialLink($socialNetwork['name'], $socialNetwork['url']);
  }

  $html .= '</ul>';

  return $html;
}

// function renderNavBurgerList(array $navStructure): string {
//     $html = '' . PHP_EOL;

//     // Проходим по всем основным страницам (первый уровень)
//     foreach ($navStructure as $mainPage => $pageData) {
//         $isActive = $pageData['is_active'] ?? false;
//         $pageSlug = htmlspecialchars($pageData['slug'] ?? '#', ENT_QUOTES, 'UTF-8');
//         $class = 'act-elem link nav-level-1' . ($isActive ? ' cur' : '');

//         $html .= sprintf('<li class="%s" role="menuitem">', $class) . PHP_EOL;

//         $html .= sprintf(
//             '<button class="act-anchor" aria-current="%s" aria-haspopup="true" aria-expanded="false">%s</button>',
//             $isActive ? 'page' : 'false',
//             htmlspecialchars($mainPage, ENT_QUOTES, 'UTF-8')
//         ) . PHP_EOL;

//         $html .= '<ul class="submenu" role="menu" aria-label="Submenu for ' . htmlspecialchars($mainPage, ENT_QUOTES, 'UTF-8') . '">' . PHP_EOL;

//         $globalLevelNum = 0; // Глобальный счётчик уровней
        
//         // Проходим по разделам страницы (второй уровень)
//         foreach ($pageData['items'] as $sectionKey => $section) {

//             // Условие для уровней с is_full = false или с одним экраном
//             if (!$section['is_full'] || (isset($section['screens']) && count($section['screens']) === 1)) {
//                 $html .= '<li class="act-elem link nav-level-2">' . PHP_EOL;

//                 // Определяем title и slug
//                 if (!$section['is_full']) {
//                     $itemSlug = htmlspecialchars($section['slug'] ?? '#', ENT_QUOTES, 'UTF-8');
//                     $itemTitle = htmlspecialchars($section['title'] ?? $sectionKey, ENT_QUOTES, 'UTF-8');
//                 } else {
//                     $itemSlug = htmlspecialchars($section['screens'][0]['slug'] ?? '#', ENT_QUOTES, 'UTF-8');
//                     $itemTitle = htmlspecialchars($section['screens'][0]['title'] ?? $sectionKey, ENT_QUOTES, 'UTF-8');
//                 }
//                 $itemHref = "/{$pageSlug}/{$itemSlug}";

//                 $html .= sprintf(
//                     '<a href="%s" data-index="%d" class="act-anchor">%s</a>',
//                     $itemHref,
//                     $globalLevelNum,
//                     $itemTitle
//                 ) . PHP_EOL;
//             } else {
//                 $html .= '<li class="act-elem link nav-level-2" role="menuitem">' . PHP_EOL;
                
//                 // Для уровней с is_full = true и более чем одним экраном рендерим подменю
//                 $html .= sprintf(
//                     '<button class="act-anchor" aria-haspopup="true" aria-expanded="false">%s</button>',
//                     htmlspecialchars($sectionKey, ENT_QUOTES, 'UTF-8')
//                 ) . PHP_EOL;
//                 $html .= '<ul class="submenu-items nav-level-3" role="menu" aria-label="Items for ' . htmlspecialchars($sectionKey, ENT_QUOTES, 'UTF-8') . '">' . PHP_EOL;

//                 foreach ($section['screens'] as $screenNum => $item) {
//                     $itemSlug = htmlspecialchars($item['slug'] ?? '#', ENT_QUOTES, 'UTF-8');
//                     $itemTitle = htmlspecialchars($item['title'] ?? $sectionKey, ENT_QUOTES, 'UTF-8');
//                     $itemHref = "/{$pageSlug}/{$itemSlug}";

//                     $html .= '<li class="act-elem link" role="menuitem">' . PHP_EOL;
//                     $html .= sprintf(
//                         '<a href="%s" data-index="%d-%d" class="act-anchor">%s</a>',
//                         $itemHref,
//                         $globalLevelNum,
//                         $screenNum,
//                         $itemTitle
//                     ) . PHP_EOL;
//                     $html .= '</li>' . PHP_EOL;
//                 }

//                 $html .= '</ul>' . PHP_EOL;
//             }

//             $globalLevelNum++; // Увеличиваем глобальный счётчик уровней
//             $html .= '</li>' . PHP_EOL;
//         }

//         $html .= '</ul>' . PHP_EOL;
//         $html .= '</li>' . PHP_EOL;
//     }

//     // Добавляем статический пункт FAQ
//     $html .= '<li class="act-elem link" role="menuitem"><button class="act-anchor" aria-label="Open FAQ">FAQ</button></li>' . PHP_EOL;
    
//     return $html;
// }