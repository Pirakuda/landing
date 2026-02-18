<?php
/**
 * SiteController - класс для управления структурой сайта и пользовательскими сессиями
 */
class ConfigJsonMigration {
    private $db;
    private $siteId;
    private $mediaData = [];
    private $contentData = [];
    private $language;
    private $cachedPages = null;

    public function __construct(Database $db, $domain) {
        $this->db = $db;
        $this->siteId = $this->getSiteIdByDomain($domain);
    }

    private function getSiteIdByDomain($domain) {
        $site = $this->db->fetch(
            "SELECT id, type FROM sites WHERE domain = ? AND is_active = 1 LIMIT 1",
            [$domain]
        );
        if (!$site) {
            throw new Exception("Active site version not found for domain: $domain");
        }
        $this->siteType = $site['type'];
        return $site['id'];
    }

    private function getTheme($name) {
        $theme = $this->db->fetch(
            "SELECT * FROM themes
            WHERE name = ? AND site_id = ?
            LIMIT 1",
            [$name, $this->siteId]
        );

        return $theme ?: [];
    }

    private function getSocialMedia() {
        return $this->db->fetchAll(
            "SELECT name, url 
             FROM social_media 
             WHERE site_id = ? 
             ORDER BY display_order",
            [$this->siteId]
        );
    }

    private function getLegal() {
        return $this->db->fetchAll(
            "SELECT name, url 
             FROM legal 
             WHERE site_id = ? 
             ORDER BY display_order",
            [$this->siteId]
        );
    }

    private function getScreens($levelId, $deviceType) {
        $query = "
            SELECT s.id, s.slug, s.img_pos, s.text_pos, s.has_rating, s.style_id, s.display_order,
                c.id AS content_id, c.page_title, c.meta_title, c.meta,
                c.cost, c.sec_cost, c.promo, c.m_promo, c.title AS content_title,
                c.benefits, c.subtitle, c.text_content, c.m_text_content,
                c.delivery, c.page_act_link_title, c.page_act_link_path,
                c.page_act_sec_btn, c.page_act_btn, c.service_name
            FROM screens s
            LEFT JOIN screen_contents sc ON s.id = sc.screen_id
            LEFT JOIN contents c ON sc.content_id = c.id
            WHERE s.level_id = ?
            ORDER BY s.display_order
        ";
        
        return $this->db->fetchAll($query, [$levelId]) ?? [];
    }

    private function getMedia($screenId, $deviceType) {
        $media = $this->db->fetchAll(
            "SELECT m.id, m.type, m.path, m.m_path, m.alt
            FROM screen_media sm
            JOIN media m ON sm.media_id = m.id
            WHERE sm.screen_id = ?
            ORDER BY sm.display_order",
            [$screenId]
        ) ?? [];

        $mediaData = [];
        foreach ($media as $m) {
            $mediaId = (string)$m['id'];
            $mediaData[$mediaId] = [
                'type' => $m['type'],
                'path' => $deviceType === 'mobile' && !empty($m['m_path']) ? $m['m_path'] : $m['path'],
                'name' => $m['alt']
            ];
        }
        
        return $mediaData;
    }

    private function getContent($screen, $deviceType) {
        if (!$screen['content_id']) {
            return null;
        }

        $contentId = (string)$screen['content_id'];
        $content = [
            'type' => 'text',
            'page_title' => $screen['page_title'],
            'meta_title' => $screen['meta_title'],
            'meta' => $screen['meta'] && json_decode($screen['meta'], true) !== null ? json_decode($screen['meta'], true) : [],
            'cost' => $screen['cost'],
            'secCost' => $screen['sec_cost'],
            'promo' => $deviceType === 'mobile' ? null : $screen['promo'],
            'title' => $screen['content_title'],
            'benefits' => $deviceType === 'mobile' ? null : $screen['benefits'],
            'subtitle' => $deviceType === 'mobile' ? null : $screen['subtitle'],
            'text' => $deviceType === 'mobile' && !empty($screen['m_text_content']) ? $screen['m_text_content'] : $screen['text_content'],
            'delivery' => $screen['delivery'],
            'pageActLinkTitle' => $screen['page_act_link_title'],
            'pageActLinkPath' => $screen['page_act_link_path'],
            'pageSecActBtn' => $screen['page_act_sec_btn'],
            'pageActBtn' => $screen['page_act_btn'],
            'serviceName' => $screen['service_name']
        ];

        return ['textId' => $contentId, 'data' => $content];
    }

    public function getPageStructure($domain, $deviceType, $pageSlug) {
        $siteId = $this->siteId;

        $site = $this->db->fetch(
            "SELECT type, brand, slogan, developer_name, developer_link, phone1
            FROM sites 
            WHERE id = ? AND is_active = 1 
            LIMIT 1",
            [$siteId]
        );
        if (!$site) {
            error_log("Site not found for siteId: {$siteId}");
            throw new Exception("Active site version not found for siteId: {$siteId}");
        }

        // Получаем страницу по slug
        $pageQuery = "SELECT id FROM pages WHERE site_id = ? AND slug = ? LIMIT 1";
        $pageParams = [$siteId, $pageSlug];
        $page = $this->db->fetch($pageQuery, $pageParams);

        // Проверка наличия страниц
        if (!$page) {
            error_log("No pages found for site_id: $siteId");
            throw new Exception("No pages found for siteId: $siteId");
        }

        $pageId = $page['id'];

        $levels = $this->db->fetchAll(
            "SELECT id, title, slug, meta_title, meta, scr_full, display_order
             FROM levels 
             WHERE page_id = ? 
             ORDER BY display_order",
            [$pageId]
        ) ?? [];

        $styles = [];
        $this->mediaData = [];
        $this->contentData = [];
        $activeLevel = 0;

        foreach ($levels as $levIndex => &$level) {
            $level['screens'] = $this->getScreens($level['id'], $deviceType);
            $isLevFull = !empty($level['scr_full']) && $level['scr_full'] === 'full';

            foreach ($level['screens'] as $index => &$screen) {
                // загрузка персональных стилей экранов
                if (!empty($screen['style_id']) && !isset($styles[$screen['style_id']])) {
                    $style = $this->db->fetch(
                        "SELECT id, cost_sec_color, cost_color, promo_color, promo_size, 
                                title_color, title_size, benefits_color, subtitle_color, 
                                text_bg, text_color, delivery_color, 
                                page_act_sec_btn_bg, page_act_sec_btn_color, 
                                page_act_btn_bg, page_act_btn_color
                         FROM screen_style
                         WHERE id = ?",
                        [$screen['style_id']]
                    );
                    if ($style) {
                        $styles[$screen['style_id']] = [
                            'cost_color' => $style['cost_color'],
                            'cost_sec_color' => $style['cost_sec_color'],
                            'promo_color' => $style['promo_color'],
                            'promo_size' => $style['promo_size'],
                            'title_color' => $style['title_color'],
                            'title_size' => $style['title_size'],
                            'benefits_color' => $style['benefits_color'],
                            'subtitle_color' => $style['subtitle_color'],
                            'text_bg' => $style['text_bg'],
                            'text_color' => $style['text_color'],
                            'delivery_color' => $style['delivery_color'],
                            'page_act_sec_btn_bg' => $style['page_act_sec_btn_bg'],
                            'page_act_sec_btn_color' => $style['page_act_sec_btn_color'],
                            'page_act_btn_bg' => $style['page_act_btn_bg'],
                            'page_act_btn_color' => $style['page_act_btn_color']
                        ];
                    } else {
                        error_log("Style not found for style_id: {$screen['style_id']}");
                    }
                }

                // Загрузка медиа
                $screen['dataIds'] = [];
                $mediaData = $this->getMedia($screen['id'], $deviceType);
                foreach ($mediaData as $mediaId => $data) {
                    $screen['dataIds'][] = $mediaId;
                    $this->mediaData[$mediaId] = $data;
                }

                // Загрузка контента
                $content = $this->getContent($screen, $deviceType);
                if ($content) {
                    $screen['textId'] = $content['textId'];
                    $this->contentData[$content['textId']] = $content['data'];
                }

                $screen['rating'] = $screen['has_rating'] ? 'true' : 'false';
                $screen['style_id'] = (string)$screen['style_id'];
                unset($screen['id'], $screen['content_id'], $screen['m_promo'], $screen['m_text_content']);
            }
            unset($screen);
        }
        unset($level);

        $pageStructure = [
            'domain' => $domain,
            'page_slug' => $pageSlug,
            'type' => $site['type'],
            'deviceType' => $deviceType,
            'brand' => $site['brand'],
            'slogan' => $site['slogan'],
            'developerName' => $site['developer_name'],
            'developerLink' => $site['developer_link'],
            'phone1' => $site['phone1'],
            'levels' => array_map(function ($level) {
                return [
                    'title' => $level['title'],
                    'slug' => $level['slug'],
                    'meta_title' => $level['meta_title'],
                    'meta' => $level['meta'] && json_decode($level['meta'], true) !== null ? json_decode($level['meta'], true) : [],
                    'scrFull' => $level['scr_full'],
                    'activeScreen' => 0,
                    'screens' => $level['screens']
                ];
            }, $levels)
        ];

        $pageStructure += $styles + $this->mediaData + $this->contentData;

        return $pageStructure;
    }

    public function getNavStructure() {
        $navStructure = [];
    
        // Получение всех страниц для активного сайта
        $pages = $this->getPages();
    
        if (empty($pages)) {
            error_log("No pages found for site_id: {$this->siteId}");
            return $navStructure;
        }
    
        $isFirstPage = true; // Флаг для первой страницы
    
        foreach ($pages as $page) {
            $pageName = $page['name'];
            $pageSlug = $page['slug'];
    
            // Устанавливаем активную страницу: либо по pageSlug, либо первую, если pageSlug = null
            $navStructure[$pageName] = [
                'slug' => $pageSlug,
                'type' => $this->siteType,
                'items' => []
            ];
    
            // Получение уровней для страницы
            $levels = $this->db->fetchAll(
                "SELECT id, title, slug, scr_full
                 FROM levels 
                 WHERE page_id = ? AND is_visible = 1
                 ORDER BY display_order",
                [$page['id']]
            ) ?? [];
    
            foreach ($levels as $level) {
                $levelTitle = $level['title'];
                $isLevFull = !empty($level['scr_full']) && $level['scr_full'] === 'full';
                $navStructure[$pageName]['items'][$levelTitle] = [
                    'level_slug' => $level['slug'],
                    'is_full' => $isLevFull
                ];
    
                if (!$isLevFull) {
                    // Для уровней без scr_full используем title и slug из levels
                    $navStructure[$pageName]['items'][$levelTitle]['title'] = $levelTitle;
                    $navStructure[$pageName]['items'][$levelTitle]['slug'] = $level['slug'];
                } else {
                    // Для уровней с scr_full = 'full' создаём массив screens
                    $navStructure[$pageName]['items'][$levelTitle]['screens'] = [];
                    $screens = $this->db->fetchAll(
                        "SELECT s.slug, c.page_title
                         FROM screens s
                         LEFT JOIN screen_contents sc ON s.id = sc.screen_id
                         LEFT JOIN contents c ON sc.content_id = c.id
                         WHERE s.level_id = ? AND s.is_visible = 1
                         ORDER BY s.display_order",
                        [$level['id']]
                    ) ?? [];
    
                    foreach ($screens as $screen) {
                        // Используем page_title из contents, если есть, иначе title уровня
                        $screenTitle = $screen['page_title'] ?? $levelTitle;
                        $navStructure[$pageName]['items'][$levelTitle]['screens'][] = [
                            'title' => $screenTitle,
                            'slug' => $screen['slug']
                        ];
                    }
                }
            }
    
            $isFirstPage = false; // Сбрасываем флаг после первой страницы
        }
    
        return $navStructure;
    }

    private function getPages() {
        if ($this->cachedPages === null) {
            $this->cachedPages = $this->db->fetchAll(
                "SELECT id, name, slug
                 FROM pages 
                 WHERE site_id = ? AND is_visible = 1
                 ORDER BY display_order",
                [$this->siteId]
            ) ?? [];
        }
        return $this->cachedPages;
    }

    public function getRenderData($themeName) {
        return [
            'themes' => $this->getTheme($themeName),
            'socialMedia' => $this->getSocialMedia(),
            'legal' => $this->getLegal()
        ];
    }
}