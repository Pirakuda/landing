<!DOCTYPE html>
<html lang="de">
  	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<title><?= getMeta($pageStructure)['pageTitle'] ?></title>
		<meta name="description" content="<?= getMeta($pageStructure)['metaTitle'] ?>">
		<link rel="canonical" href="<?= BASE_URL ?>/<?= $pageStructure['screenSlug'] ?>">

		<style>
		  :root {
			--page-bg: <?= $p[3] ?>;
			--page-color: <?= $p[0] ?>;
			--page-border-color: <?= $p[7] ?>;
			--abstract-color: <?= $p[5] ?>;

			--header-color: <?= $p[0] ?>;

			--modal-header-color: <?= $p[1] ?>;
			--modal-urgency-color: <?= $p[6] ?>;

			--cost-color: <?= $p[1] ?>;
			--cost-sec-color: <?= $p[1] ?>;
			--promo-color: <?= $p[1] ?>;
			--title-color: <?= $p[6] ?>;
			--benefits-color: <?= $p[1] ?>;

			--text-bg: <?= $p[4] ?>;
			--text-color: <?= $p[1] ?>;
			--text-border-color: <?= $p[6] ?>;

			--offer-bg: <?= $p[4] ?>;
			--offer-color: <?= $p[6] ?>;
			--offer-border-color: <?= $p[6] ?>;

			--btn-color: <?= $p[1] ?>;
			--btn-border-color: <?= $p[7] ?>;

			--btn-sec-color: <?= $p[8] ?>;
			--btn-sec-border-color: <?= $p[7] ?>;

			--btn-main-bg: <?= $p[11] ?>;
			--btn-main-color: <?= $p[9] ?>;
			--btn-main-border-color: <?= $p[7] ?>;

			--msg-error-color: <?= $p[10] ?>;

			--canvas-type: <?= $themes['canvasType'] ?? 'hexagon'?>;
			--bg-url: <?= $themes['bgUrl'] ?? ''?>;
		  }

		</style>

		<!-- <link rel="stylesheet" type="text/css" href="/web_eco_de/public/css/styles.min.css"> -->

		<link rel="stylesheet" type="text/css" href="<?= BASE_URL ?>/public/css/styles-atomic.css">

		<!-- Общие стили для мобильных устройств и планшетов в портретной ориентации -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-mobile.css" media="(max-width:699px) and (orientation: portrait)">

		<!-- Стили для планшетов в горизонтальном положении -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-tablet.css" media="(max-width: 1023px) and (orientation: landscape)">

		<!-- мобильные стили, активные элементы -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-action-elem-mobile.css" media="(max-width:1023px)">

		<!-- десктопные стили -->
  		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-desktop.css" media="(min-width: 1024px)">
		<!-- десктопные стили, активные элементы -->
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-action-elem-desktop.css" media="(min-width: 1024px)">

		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-tablet-ipad-mobile.css" media="(min-width: 700px) and (max-width: 1366px) and (orientation: portrait) and (hover: none) and (pointer: coarse)">
		<link rel="stylesheet" href="<?= BASE_URL ?>/public/css/styles-tablet-ipad-desktop.css" media="(min-width: 1024px) and (max-width: 1366px) and (orientation: landscape) and (hover: none) and (pointer: coarse)">
  	
		<script>const BASE_URL = '<?= BASE_URL ?>';</script>
	</head>
  	<body>
	  <div id="page-bg" class="page-bg">
	    <header id="header-wrap" class='page-header top-contr pos-abs flex'>
		  <div id="header" class="header">
		    <a id="logo-wrap" class="logo-wrap" href="/" aria-label="Наверх">
				<img src="<?= BASE_URL ?>/public/store/briemchainai-logo-dark-gray.webp" alt="Logo von BriemChainAI, Plattform für AI-CRM, Landingpages und Automatisierung" class="logo">
			</a>
		    <h1 id="pageName" class="page-name-wrap">
			  <span class="page-name"><?= $pageStructure['brand'] ?? 'Brand' ?></span>
			  <span class='concept-name'><?= $pageStructure['slogan'] ?? 'Slogan' ?></span>
			</h1>
		  </div>
		</header>
		<nav class='top-contr pos-abs'>
			<div id='menu-popup-wrap' class="popup-contr menu-wrap">
				<h3 class="mobile-menu-header popup-title m-t-10 p-t-5 p-b-10">Menu</h3>
				<button class='popup-close-btn act-elem pos-abs' onclick='popupCrossCloseHandle(this)'>&times;</button>
				<div class="nav-box-wrap">
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
					<li class='act-elem link'>
						<button id="mobile-manage-analysis" class="manage-analysis no-wrap act-anchor"  onclick='menuAnalysePopupOpenHandler()'>Analyse verwalten</button>
					</li>
				</ul>
				<?php
				}
				?>
				<span class='menu-year pos-rel'>
					© 
					<span id="currentYear-menu"></span>
					<span><?= !empty($pageStructure['footerBrand']) ? $pageStructure['footerBrand'] : 'Unternehmen' ?></span>
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