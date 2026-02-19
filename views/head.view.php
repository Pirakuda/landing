<!DOCTYPE html>
<html lang="de">
  	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<title><?= getMeta($pageStructure)['page_title'] ?></title>
		<meta name="description" content="<?= getMeta($pageStructure)['meta_title'] ?>">
		<link rel="canonical" href="https://relanding.de/<?= $pageStructure['screen_slug'] ?>">

		<style>
		  :root {
			--page-bg: <?= $themes['page_bg'] ?? 'linear-gradient(135deg,rgb(40, 45, 51),rgb(0, 1, 2))'?>;
			--canvas-bg: <?= $themes['canvas_bg'] ?? 'linear-gradient(135deg,rgb(79, 79, 80),rgb(0, 1, 2))'?>;
			--canvas-type: <?= $themes['canvas_type'] ?? 'hexagon'?>;
			--bg-url: <?= $themes['bg_url'] ?? ''?>;
			--header-bg: <?= $themes['header_bg'] ?? 'linear-gradient(135deg, #fff, #eee)' ?>;
			--header-color: <?= $themes['header_color'] ?? '#222' ?>;

			--main-border-color: <?= $themes['main-border-color'] ?? '#444' ?>;

			--phone-bg: <?= $themes['phone_bg'] ?? '#DDA63D' ?>;
  			--phone-color: <?= $themes['phone_color'] ?? '#000' ?>;

			--popup-bg: <?= $themes['popup_bg'] ?? 'linear-gradient(135deg, #444, #222)' ?>;
			--popup-color: <?= $themes['popup_color'] ?? '#eee' ?>;
			--popup-btn-bg: <?= $themes['popup_btn_bg'] ?? '#dda63d' ?>;
			--popup-btn-color: <?= $themes['popup_btn_color'] ?? '#000' ?>;
			--popup-border-color-act: <?= $themes['popup-border-color-act'] ?? '#dda63d' ?>;

			--lev-title-bg: <?= $themes['lev_title_bg'] ?? '#DDA63D' ?>;
			--lev-title-color: <?= $themes['lev_title_color'] ?? '#000' ?>;
			
			--menu-color: <?= $themes['menu_color'] ?? '#eee' ?>;
			--menu-cur-bg: <?= $themes['menu_cur_bg'] ?? '#dda63d' ?>;
			--menu-hover-bg: <?= $themes['menu_hover_bg'] ?? '#dde3ea' ?>;

			--pageActBtn-bg: <?= $themes['act_btn_bg'] ?? '#444' ?>;
			--pageActBtn-color: <?= $themes['act_btn_color'] ?? '#DDA63D' ?>;
			--pageActSecBtn-bg: <?= $themes['act_sec_btn_bg'] ?? '#444' ?>;
			--pageActSecBtn-color: <?= $themes['act_sec_btn_color'] ?? '#eee' ?>;

			--text-bg: <?= $themes['text_bg'] ?? '#222' ?>;
			--full-text-bg: <?= $themes['full_text_bg'] ?? '#222' ?>;
			--cost-color: <?= $themes['cost_color'] ?? '#eee' ?>;
			--full-cost-color: <?= $themes['full_cost_color'] ?? '#eee' ?>;
			--cost-sec-color: <?= $themes['cost_sec_color'] ?? '#eee' ?>;
			--full-cost-sec-color: <?= $themes['full_cost_sec_color'] ?? '#eee' ?>;
			--promo-color: <?= $themes['promo_color'] ?? '#bbb' ?>;
			--full-promo-color: <?= $themes['full_promo_color'] ?? '#bbb' ?>;
			--title-color: <?= $themes['title_color'] ?? '#DDA63D' ?>;
			--full-title-color: <?= $themes['full_title_color'] ?? '#DDA63D' ?>;
			--benefits-color: <?= $themes['benefits_color'] ?? '#bbb' ?>;
			--full-benefits-color: <?= $themes['full_benefits_color'] ?? '#bbb' ?>;
			--subtitle-color: <?= $themes['subtitle_color'] ?? '#bbb' ?>;
			--full-subtitle-color: <?= $themes['full_subtitle_color'] ?? '#bbb' ?>;
			--text-color: <?= $themes['text_color'] ?? '#bbb' ?>;
			--full-text-color: <?= $themes['full_text_color'] ?? '#bbb' ?>;

			--panel-wrap-bg: <?= $themes['panel-light-bg'] ?? '#333' ?>;
			--panel-btn-bg: <?= $themes['panel-btn-bg'] ?? 'linear-gradient(135deg, #eee, #dda63d)' ?>;
			--panel-btn-color: <?= $themes['panel-btn-color'] ?? '#333' ?>;

			--offer-panel-bg: <?= $themes['offer-panel-bg'] ?? '#dda63d' ?>;
			--offer-panel-color: <?= $themes['offer-panel-color'] ?? '#222' ?>;
			--offer-panel-btn-bg: <?= $themes['offer-panel-btn-bg'] ?? 'linear-gradient(135deg, #018601, #004900)' ?>;
			--offer-panel-btn-color: <?= $themes['offer-panel-btn-color'] ?? '#eee' ?>;

			--nav-btn-color: <?= $themes['nav_btn_color'] ?? '#eee' ?>;
			--nav-cur-btn-color: <?= $themes['nav_cur_btn_color'] ?? '#eee' ?>;

			--guide-bg: <?= $themes['phone_bg'] ?? '#DDA63D' ?>;
  			--guide-color: <?= $themes['phone_color'] ?? '#000000' ?>;

			--primary: #5b88b2;
			--primary-dark: #0b5daa;

			--secondary: #10b981;
			--secondary-light: #34d399;
			--secondary-dark: #059669;

			--light: #f8fafc;
			--dark: #122c4f;

			--popup-border-color: <?= $themes['popup-border-color'] ?? '#665' ?>;
			--gray: #bbb;

			--danger: #ef4444;
			--warning: #f59e0b;
			--success: #22c55e;
		}
		</style>

		<!-- <link rel="stylesheet" type="text/css" href="/web_eco_de/public/css/styles.min.css"> -->

		<link rel="stylesheet" type="text/css" href="<?= BASE_URL ?>/public/css/styles-atomic.css">

		<!-- Общие стили для мобильных устройств и планшетов в портретной ориентации -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-mobile.css" media="(max-width:767px) and (orientation: portrait)">

		<!-- Стили для планшетов в горизонтальном положении -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-tablet.css" media="(max-width: 1023px) and (orientation: landscape)">

		<!-- мобильные стили, активные элементы -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-action-elem-mobile.css" media="(max-width:1023px)">

		<!-- десктопные стили -->
  		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-desktop.css" media="(min-width: 1024px)">
		<!-- десктопные стили, активные элементы -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-action-elem-desktop.css" media="(min-width: 1024px)">

		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-tablet-ipad-mobile.css" media="(min-width: 768px) and (max-width: 1366px) and (orientation: portrait) and (hover: none) and (pointer: coarse)">
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css//styles-tablet-ipad-desktop.css" media="(min-width: 1024px) and (max-width: 1366px) and (orientation: landscape) and (hover: none) and (pointer: coarse)">
  	
		<!-- interactive elements -->
		<!-- <link rel="stylesheet" type="text/css" href="https://relanding.ru/public/css/interactive-elem.css"> -->
		<!-- <link rel="stylesheet" type="text/css" href="https://relanding.ru/public/css/main-audit.css"> -->
		<!-- <link rel="stylesheet" type="text/css" href="https://relanding.ru/public/css/main-calc.css"> -->
		<link rel="stylesheet" type="text/css" href="<?= BASE_URL ?>/public/css/chat.css">
	<script>const BASE_URL = '<?= BASE_URL ?>';</script>
	</head>
  	<body>
	  <div id="page-bg" class="page-bg">
	    <header class='page-header top-contr pos-abs flex'>
		  <div id="header" class="header">
		    <a id="logo-wrap" class="logo-wrap" href="/" aria-label="Наверх">
				<img src="<?= BASE_URL ?>/public/store/briemchainai-logo-dark-gray.webp" alt="Logo von BriemChainAI, Plattform für AI-CRM, Landingpages und Automatisierung" class="logo">
			</a>
		    <h1 id="pageName" class="page-name-wrap">
			  <span class="page-name"><?= $pageStructure['brand'] ?? 'Brand' ?></span>
			  <span class='concept-name'><?= $pageStructure['slogan'] ?? 'Slogan' ?></span>
			</h1>
			<!-- <div class="header-bg-1"></div>
			<div class="header-bg-2"></div>
			<div class="header-bg-3"></div> -->
		  </div>
		  <?= createPhone($pageStructure); ?>
		</header>
		<nav class='top-contr pos-abs'>
			<div id='menu-popup-wrap' class="popup-contr menu-wrap <?= !empty($themes['nav_bg']) ? '' : 'trans' ?>">
				<h3 class="mobile-menu-header popup-title m-t-10 p-t-5 p-b-10">Menu</h3>
				<button class='popup-close-btn act-elem pos-abs' onclick='popupCrossCloseHandle(this)'>&times;</button>
				<div class="nav-box-wrap <?= !empty($themes['nav_bg']) ? '' : 'trans' ?>">
					<ul id='nav-top-list' class="nav-box nav-burger" aria-label="Seitennavigation">
						<?php
							if (!empty($pageStructure['type']) && $pageStructure['type'] == 'site') {
								echo renderNavBurgerList($pageStructure, $navStructure);
							} else {
								echo generateNavigationMenu($pageStructure);
							}
						?>
					</ul>
				</div>
				<?php
					if (!empty($legal) && is_array($legal)) {
				?>
				<ul id='menu-sec-link' class='menu-sec-link'>
					<?php foreach ($legal as $legalItem) {
						if (!empty($legalItem['name']) && !empty($legalItem['url'])) {
							$name = htmlspecialchars($legalItem['name'], ENT_QUOTES, 'UTF-8');
							$url = htmlspecialchars($legalItem['url'], ENT_QUOTES, 'UTF-8');
					?>
						<li class='act-elem link'>
							<a href="<?php echo $url; ?>" class="no-wrap act-anchor"><?php echo $name; ?></a>
						</li>
					<?php
						}
					} ?>
				</ul>
				<?php
				}
				?>
				<span class='menu-year pos-rel'>
					© 
					<span id="currentYear-menu"></span>
					<span><?= !empty($pageStructure['f_brand']) ? $pageStructure['f_brand'] : 'Unternehmen' ?></span>
				</span>
			</div>
		</nav>
		<div id='preloader' class="preloader" style="display:none">
			<div class='loader'>
				<div class='ball'></div>
				<div class='ball'></div>
				<div class='ball'></div>
				<span>Load ...</span>
			</div>
		</div>