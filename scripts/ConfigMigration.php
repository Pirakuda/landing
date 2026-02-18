<?php
/**
 * ConfigMigration - класс для миграции конфигурационного объекта в базу данных
 */
class ConfigMigration {
    private $db;
    private $siteId;

    /**
     * Конструктор класса
     * @param Database $db Экземпляр подключения к базе данных
     */
    public function __construct(Database $db) {
        $this->db = $db;
        $this->db->query("SET NAMES utf8mb4");
    }

    /**
     * Выполняет миграцию конфигурации из JSON-файла
     * @param string $jsonFilePath Путь к JSON-файлу
     * @throws Exception Если файл не найден, JSON некорректен или отсутствует домен
     */
    public function mainMigrate($jsonFilePath) {
        if (!file_exists($jsonFilePath)) {
            throw new Exception("JSON file not found: $jsonFilePath");
        }

        $jsonContent = file_get_contents($jsonFilePath);
        $config = json_decode($jsonContent, true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception("Invalid JSON format: " . json_last_error_msg());
        }

        if (empty($config['domain'])) {
            throw new Exception("Domain is required in configuration");
        }

        try {
            $this->db->beginTransaction();

            $this->determineSiteId($config);

            // $this->migratePages($config['pages'] ?? []);
            // $this->migrateSocialMedia($config['socialMedia'] ?? []);
            // $this->migrateLegal($config['legal'] ?? []);
            // $this->migrateTheme($config);
            
            $mediaIdMap = $this->migrateMedia($config);
            $contentIdMap = $this->migrateContent($config);
            // $styleIdMap = $this->migrateScreenStyles($config);
            
            $this->migrateLevels($config, $mediaIdMap, $contentIdMap);

            $this->db->commit();
        } catch (Exception $e) {
            $this->db->rollBack();
            error_log("Migration failed for domain {$config['domain']}: " . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Определяет siteId на основе домена
     * @param array $config Конфигурация
     * @throws Exception Если не удалось определить siteId
     */
    private function mainDetermineSiteId($config) {
        $domain = $config['domain'];

        $existingSite = $this->db->fetch(
            "SELECT id FROM sites WHERE domain = ? AND is_active = 1",
            [$domain]
        );

        if ($existingSite) {
            $this->siteId = $existingSite['id'];
        } else {
            $this->db->query(
                "INSERT INTO sites (domain, type, brand, slogan, developer_name, developer_link, phone1, version, is_active)
                VALUES (?, ?, ?, ?, ?, ?, ?, 1, 1)",
                [
                    $domain,
                    $config['type'] ?? 'landing',
                    $config['brand'] ?? 'Brand',
                    $config['slogan'] ?? 'Slogan',
                    $config['developerName'] ?? null,
                    $config['developerLink'] ?? null,
                    $config['phone1'] ?? null
                ]
            );
            $this->siteId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];
        }
    }

    private function determineSiteId($config) {
        $domain = $config['domain'];

        $existingSite = $this->db->fetch(
            "SELECT id FROM sites WHERE domain = ? AND is_active = 1",
            [$domain]
        );

        if ($existingSite) {
            $this->siteId = $existingSite['id'];
        } else {
            throw new Exception("No active site found for domain: $domain");
        }
    }

    /**
     * Миграция страниц
     * @param array $pages Массив страниц
     */
    private function migratePages($pages) {
        $this->db->query("DELETE FROM pages WHERE site_id = ?", [$this->siteId]);

        foreach ($pages as $index => $page) {
            if (!isset($page['slug'], $page['name'])) {
                error_log("Skipping page: missing slug or name");
                continue;
            }

            $this->db->query(
                "INSERT INTO pages (site_id, slug, name, display_order)
                VALUES (?, ?, ?, ?)",
                [$this->siteId, $page['slug'], $page['name'], $page['display_order'] ?? $index]
            );
        }
    }

    /**
     * Миграция правовых документов
     * @param array $legals Массив правовых документов
     */
    private function migrateLegal($legals) {
        $this->db->query("DELETE FROM legal WHERE site_id = ?", [$this->siteId]);

        foreach ($legals as $index => $legal) {
            if (!isset($legal['name'], $legal['url'])) {
                continue;
            }
            $this->db->query(
                "INSERT INTO legal (site_id, name, url, display_order)
                VALUES (?, ?, ?, ?)",
                [$this->siteId, $legal['name'], $legal['url'], $index]
            );
        }
    }

    /**
     * Миграция социальных сетей
     * @param array $socialMedia Массив социальных сетей
     */
    private function migrateSocialMedia($socialMedia) {
        $this->db->query("DELETE FROM social_media WHERE site_id = ?", [$this->siteId]);

        foreach ($socialMedia as $index => $media) {
            if (!isset($media['name'], $media['url'])) {
                continue;
            }
            $this->db->query(
                "INSERT INTO social_media (site_id, name, url, display_order)
                VALUES (?, ?, ?, ?)",
                [$this->siteId, $media['name'], $media['url'], $index]
            );
        }
    }

    /**
     * Миграция темы
     * @param array $config Конфигурация
     */
    private function migrateTheme($config) {
        // Проверка обязательных полей
        if (!isset($config['name'])) {
            throw new Exception("Theme name is required in config");
        }

        // Подготовка данных темы
        $themeData = [
            'site_id' => $this->siteId,
            'name' => $config['name'] ?? 'Default Theme',
            'page_bg' => $config['pageBg'] ?? '#444',
            'canvas_bg' => $config['canvasBg'] ?? '#444',
            'canvas_type' => $config['canvasType'] ?? 'circle',
            'bg_url' => $config['bgUrl'] ?? null,
            'header_bg' => $config['headerBg'] ?? '#444',
            'header_color' => $config['headerColor'] ?? '#eee',
            'popup_bg' => $config['popupBg'] ?? '#ddd',
            'popup_color' => $config['popupColor'] ?? '#444',
            'lev_title_bg' => $config['levTitleBg'] ?? '#444',
            'lev_title_color' => $config['levTitleColor'] ?? '#444',
            'menu_color' => $config['menuColor'] ?? '#122c4f',
            'menu_cur_bg' => $config['menuCurBg'] ?? '#c4d3e3',
            'menu_hover_bg' => $config['menuHoverBg'] ?? '#dde3ea',
            'act_btn_bg' => $config['actBtnBg'] ?? 'linear-gradient(135deg, #5b88b2, #122c4f)',
            'act_btn_color' => $config['actBtnColor'] ?? '#eee',
            'act_sec_btn_bg' => $config['actSecBtnBg'] ?? 'linear-gradient(135deg, #fff, #eee)',
            'act_sec_btn_color' => $config['actSecBtnColor'] ?? '#122c4f',
            'text_bg' => $config['textBg'] ?? 'linear-gradient(135deg, #122c4f, #5b88b2)',
            'full_text_bg' => $config['fullTextBg'] ?? 'linear-gradient(135deg, #fff, #eee)',
            'cost_color' => $config['costColor'] ?? '#eee',
            'full_cost_color' => $config['fullCostColor'] ?? '#122c4f',
            'cost_sec_color' => $config['costSecColor'] ?? '#eee',
            'full_cost_sec_color' => $config['fullCostSecColor'] ?? '#122c4f',
            'promo_color' => $config['promoColor'] ?? '#eee',
            'full_promo_color' => $config['fullPromoColor'] ?? '#0b5daa',
            'title_color' => $config['titleColor'] ?? '#eee',
            'full_title_color' => $config['fullTitleColor'] ?? ($config['fullFullColor'] ?? '#122c4f'), // Обработка ошибки
            'benefits_color' => $config['benefitsColor'] ?? '#eee',
            'full_benefits_color' => $config['fullBenefitsColor'] ?? '#122c4f',
            'subtitle_color' => $config['subtitleColor'] ?? '#eee',
            'full_subtitle_color' => $config['fullSubtitleColor'] ?? '#122c4f',
            'text_color' => $config['textColor'] ?? '#eee',
            'full_text_color' => $config['fullTextColor'] ?? '#122c4f',
            'nav_btn_color' => $config['navBtnColor'] ?? '#075197',
            'nav_cur_btn_color' => $config['navCurBtnColor'] ?? '#122c4f',
            'is_default' => isset($config['isDefault']) ? (int)$config['isDefault'] : 1,
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s')
        ];

        // Проверка, существует ли тема с таким именем для данного сайта
        $existingTheme = $this->db->fetch(
            "SELECT id FROM themes WHERE site_id = ? AND name = ?",
            [$this->siteId, $themeData['name']]
        );

        if ($existingTheme) {
            // Обновление существующей темы
            $this->db->query(
                "UPDATE themes SET 
                    page_bg = ?, canvas_bg = ?, canvas_type = ?, bg_url = ?, 
                    header_bg = ?, header_color = ?, popup_bg = ?, popup_color = ?, 
                    lev_title_bg = ?, lev_title_color = ?, menu_color = ?, 
                    menu_cur_bg = ?, menu_hover_bg = ?, act_btn_bg = ?, 
                    act_btn_color = ?, act_sec_btn_bg = ?, act_sec_btn_color = ?, 
                    text_bg = ?, full_text_bg = ?, cost_color = ?, 
                    full_cost_color = ?, cost_sec_color = ?, full_cost_sec_color = ?, 
                    promo_color = ?, full_promo_color = ?, title_color = ?, 
                    full_title_color = ?, benefits_color = ?, full_benefits_color = ?, 
                    subtitle_color = ?, full_subtitle_color = ?, text_color = ?, 
                    full_text_color = ?, nav_btn_color = ?, nav_cur_btn_color = ?, 
                    is_default = ?, updated_at = ?
                WHERE id = ?",
                [
                    $themeData['page_bg'], $themeData['canvas_bg'], $themeData['canvas_type'], $themeData['bg_url'],
                    $themeData['header_bg'], $themeData['header_color'], $themeData['popup_bg'], $themeData['popup_color'],
                    $themeData['lev_title_bg'], $themeData['lev_title_color'], $themeData['menu_color'],
                    $themeData['menu_cur_bg'], $themeData['menu_hover_bg'], $themeData['act_btn_bg'],
                    $themeData['act_btn_color'], $themeData['act_sec_btn_bg'], $themeData['act_sec_btn_color'],
                    $themeData['text_bg'], $themeData['full_text_bg'], $themeData['cost_color'],
                    $themeData['full_cost_color'], $themeData['cost_sec_color'], $themeData['full_cost_sec_color'],
                    $themeData['promo_color'], $themeData['full_promo_color'], $themeData['title_color'],
                    $themeData['full_title_color'], $themeData['benefits_color'], $themeData['full_benefits_color'],
                    $themeData['subtitle_color'], $themeData['full_subtitle_color'], $themeData['text_color'],
                    $themeData['full_text_color'], $themeData['nav_btn_color'], $themeData['nav_cur_btn_color'],
                    $themeData['is_default'], $themeData['updated_at'], $existingTheme['id']
                ]
            );
            $themeId = $existingTheme['id'];
        } else {
            // Вставка новой темы
            $this->db->query(
                "INSERT INTO themes (
                    site_id, name, page_bg, canvas_bg, canvas_type, bg_url, 
                    header_bg, header_color, popup_bg, popup_color, 
                    lev_title_bg, lev_title_color, menu_color, menu_cur_bg, 
                    menu_hover_bg, act_btn_bg, act_btn_color, act_sec_btn_bg, 
                    act_sec_btn_color, text_bg, full_text_bg, cost_color, 
                    full_cost_color, cost_sec_color, full_cost_sec_color, 
                    promo_color, full_promo_color, title_color, full_title_color, 
                    benefits_color, full_benefits_color, subtitle_color, 
                    full_subtitle_color, text_color, full_text_color, 
                    nav_btn_color, nav_cur_btn_color, is_default, created_at, updated_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                array_values($themeData)
            );

            $themeId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];
        }

        // Обновление is_default для других тем
        if ($themeData['is_default']) {
            $this->db->query(
                "UPDATE themes SET is_default = 0 WHERE site_id = ? AND id != ?",
                [$this->siteId, $themeId]
            );
        }

        // Связь темы с сегментами через segment_theme_mapping
        if (strpos($themeData['name'], 'mobile') !== false) {
            // Привязка к мобильным сегментам
            $mobileSegmentIds = $this->db->fetchAll(
                "SELECT id FROM user_segments WHERE name LIKE '%mobile%'"
            );
            foreach ($mobileSegmentIds as $segment) {
                $this->db->query(
                    "INSERT INTO segment_theme_mapping (segment_id, theme_id) VALUES (?, ?) 
                    ON DUPLICATE KEY UPDATE theme_id = ?",
                    [$segment['id'], $themeId, $themeId]
                );
            }
        } else {
            // Привязка к десктопным сегментам
            $desktopSegmentIds = $this->db->fetchAll(
                "SELECT id FROM user_segments WHERE name LIKE '%desktop%'"
            );
            foreach ($desktopSegmentIds as $segment) {
                $this->db->query(
                    "INSERT INTO segment_theme_mapping (segment_id, theme_id) VALUES (?, ?) 
                    ON DUPLICATE KEY UPDATE theme_id = ?",
                    [$segment['id'], $themeId, $themeId]
                );
            }
        }
    }

    /**
     * Миграция медиа
     * @param array $config Конфигурация
     * @return array Карта соответствия старых и новых ID медиа
     */
    private function migrateMedia($config) {
        $idMap = [];

        foreach ($config as $key => $value) {
            if (is_numeric($key) && isset($value['type'], $value['path'], $value['m_path']) && $value['type'] === 'image') {
                $oldMediaId = (int)$key;

                $existingMedia = $this->db->fetch(
                    "SELECT id FROM media WHERE path = ? AND m_path = ? AND type = ?",
                    [$value['path'], $value['m_path'], $value['type']]
                );

                if ($existingMedia) {
                    $newMediaId = $existingMedia['id'];
                } else {
                    $this->db->query(
                        "INSERT INTO media (type, path, m_path, alt)
                        VALUES (?, ?, ?, ?)",
                        [$value['type'], $value['path'], $value['m_path'], $value['name'] ?? 'alt']
                    );
                    $newMediaId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];
                }

                $idMap[$oldMediaId] = $newMediaId;
            }
        }

        return $idMap;
    }

    /**
     * Миграция контента
     * @param array $config Конфигурация
     * @return array Карта соответствия старых и новых ID контента
     */
    private function migrateContent($config) {
        $contentIdMap = [];

        foreach ($config as $key => $value) {
            if (is_numeric($key) && isset($value['type']) && $value['type'] === 'text') {
                $oldContentId = (int)$key;

                $this->db->query(
                    "INSERT INTO contents (
                        type, page_title, meta_title, meta, cost, sec_cost, promo, m_promo, title, benefits, subtitle,
                        text_content, m_text_content, delivery, page_act_link_title, page_act_link_path,
                        page_act_sec_btn, page_act_btn, service_name, language_code
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    [
                        $value['type'],
                        $value['page_title'] ?? null,
                        $value['meta_title'] ?? null,
                        json_encode($value['meta'] ?? []),
                        $value['cost'] ?? null,
                        $value['secCost'] ?? null,
                        $value['promo'] ?? null,
                        $value['m_promo'] ?? null,
                        $value['title'] ?? null,
                        $value['benefits'] ?? null,
                        $value['subtitle'] ?? null,
                        $value['text'] ?? null,
                        $value['m_text'] ?? null,
                        $value['delivery'] ?? null,
                        $value['pageActLinkTitle'] ?? null,
                        $value['pageActLinkPath'] ?? null,
                        $value['pageSecActBtn'] ?? null,
                        $value['pageActBtn'] ?? null,
                        $value['serviceName'] ?? null,
                        'ru'
                    ]
                );

                $newContentId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];
                $contentIdMap[$oldContentId] = $newContentId;
            }
        }

        return $contentIdMap;
    }

    /**
     * Миграция стилей экранов в таблицу screen_style
     * @param array $screenStyles Массив стилей из screen_styles.json
     */
    private function migrateScreenStyles($config) {
        // Обрабатываем массив стилей
        foreach ($config['styles'] ?? [] as $index => $style) {
            // Вставляем стиль в таблицу screen_style
            $this->db->query(
                "INSERT INTO screen_style (
                    cost_sec_color, cost_color, promo_color, promo_size, 
                    title_color, title_size, benefits_color, subtitle_color, 
                    text_bg, text_color, delivery_color, 
                    page_act_sec_btn_bg, page_act_sec_btn_color, 
                    page_act_btn_bg, page_act_btn_color
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                [
                    $style['cost_sec_color'] ?? null,
                    $style['cost_color'] ?? null,
                    $style['promo_color'] ?? null,
                    $style['promo_size'] ?? null,
                    $style['title_color'] ?? null,
                    $style['title_size'] ?? null,
                    $style['benefits_color'] ?? null,
                    $style['subtitle_color'] ?? null,
                    $style['text_bg'] ?? null,
                    $style['text_color'] ?? null,
                    $style['delivery_color'] ?? null,
                    $style['page_act_sec_btn_bg'] ?? null,
                    $style['page_act_sec_btn_color'] ?? null,
                    $style['page_act_btn_bg'] ?? null,
                    $style['page_act_btn_color'] ?? null
                ]
            );
        }
    }

    /**
     * Миграция уровней и экранов
     * @param array $levels Массив уровней
     * @param array $mediaIdMap Карта соответствия ID медиа
     * @param array $contentIdMap Карта соответствия ID контента
     */
    private function migrateLevels($config, $mediaIdMap, $contentIdMap) {
        
        $page = $this->db->fetch(
            "SELECT id FROM pages WHERE site_id = ? AND slug = ? LIMIT 1",
            [$this->siteId, $config['page_slug']]
        );
        if (!$page) {
            throw new Exception("Page not found for site_id: {$this->siteId}, slug: {$config['page_slug']}");
        }
        $pageId = $page['id'];

        $this->db->query("DELETE FROM levels WHERE page_id = ?", [$pageId]);

        $levels = $config['levels'] ?? [];

        foreach ($levels as $index => $level) {

            $this->db->query(
                "INSERT INTO levels (page_id, display_order, title, slug, meta_title, meta, scr_full)
                VALUES (?, ?, ?, ?, ?, ?, ?)",
                [
                    $pageId,
                    $index,
                    $level['title'] ?? 'Title',
                    $level['slug'] ?? null,
                    $level['meta_title'] ?? null,
                    json_encode($level['meta'] ?? []),
                    $level['scrFull'] ?? null
                ]
            );
            $levelId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];

            $this->migrateScreens($level['screens'] ?? [], $levelId, $mediaIdMap, $contentIdMap);
        }
    }

    /**
     * Миграция экранов
     * @param array $screens Массив экранов
     * @param int $levelId ID уровня
     * @param array $mediaIdMap Карта соответствия ID медиа
     * @param array $contentIdMap Карта соответствия ID контента
     */
    private function migrateScreens($screens, $levelId, $mediaIdMap, $contentIdMap) {
        $this->db->query("DELETE FROM screens WHERE level_id = ?", [$levelId]);

        foreach ($screens as $index => $screen) {
            $this->db->query(
                "INSERT INTO screens (
                    site_id, level_id, display_order, slug, has_rating, img_pos, text_pos, style_id
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                [
                    $this->siteId,
                    $levelId,
                    $index,
                    $screen['slug'] ?? null,
                    isset($screen['rating']) && $screen['rating'] === 'true' ? 1 : 0,
                    $screen['img_pos'] ?? null,
                    $screen['text_pos'] ?? null,
                    $screen['style_id'] ?? null
                ]
            );
            $screenId = $this->db->fetch("SELECT LAST_INSERT_ID() as id")['id'];

            $this->migrateScreenMedia($screen['data_ids'] ?? $screen['dataIds'] ?? [], $screenId, $mediaIdMap);
            $this->migrateScreenContent($screen['text_id'] ?? $screen['textId'] ?? '', $screenId, $contentIdMap);
        }
    }

    /**
     * Миграция медиа для экрана
     * @param array $dataIds Массив идентификаторов медиа
     * @param int $screenId ID экрана
     * @param array $mediaIdMap Карта соответствия ID медиа
     */
    private function migrateScreenMedia($dataIds, $screenId, $mediaIdMap) {
        foreach ($dataIds as $index => $oldDataId) {
            if (isset($mediaIdMap[(int)$oldDataId])) {
                $newMediaId = $mediaIdMap[(int)$oldDataId];
                $this->db->query(
                    "INSERT INTO screen_media (screen_id, media_id, display_order)
                    VALUES (?, ?, ?)",
                    [$screenId, $newMediaId, $index]
                );
            }
        }
    }

    /**
     * Миграция контента для экрана
     * @param string $textId Идентификатор контента
     * @param int $screenId ID экрана
     * @param array $contentIdMap Карта соответствия ID контента
     */
    private function migrateScreenContent($textId, $screenId, $contentIdMap) {
        if (empty($textId)) {
            return;
        }

        $oldContentId = (int)$textId;
        if (isset($contentIdMap[$oldContentId])) {
            $newContentId = $contentIdMap[$oldContentId];
            $this->db->query(
                "INSERT INTO screen_contents (screen_id, content_id)
                VALUES (?, ?)",
                [$screenId, $newContentId]
            );
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
// /**
//  * Генерирует уникальный slug
//  * @param string $slug Исходный slug
//  * @param string $table Таблица (pages или screens)
//  * @param string $parentIdField Поле родительского ID (site_id или level_id)
//  * @param int $parentId Значение родительского ID
//  * @return string Уникальный slug
//  */
// private function generateUniqueSlug($slug, $table, $parentIdField, $parentId) {
    // $baseSlug = $slug;
    // $counter = 1;
    // while ($this->db->fetch("SELECT id FROM $table WHERE $parentIdField = ? AND slug = ?", [$parentId, $slug])) {
        // $slug = $baseSlug . '-' . $counter++;
    // }
    // return $slug;
// }