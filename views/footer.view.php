	  <footer class="footer pos-fxd">
		<div id='footer-wrap' class="footer-wrap pos-rel <?= !empty($themes['footer_bg']) ? '' : 'trans' ?>">
			
			<span class='footer-year pos-abs pos-b-l p-b-10 p-l-20'>
			<?php
				if (!empty($pageStructure['developerName']) && !empty($pageStructure['developerLink'])) {
					$developerName = $pageStructure['developerName'];
					$developerLink = $pageStructure['developerLink'];
			?>
				<div class="developer-link act-elem link m-b-5 m-l-0 m-r-0">
					<a href="<?php echo $developerLink; ?>" target="_blank" class="act-anchor p-l-0 p-r-0"><?php echo $developerName; ?></a>
				</div>
			<?php
				}
			?>
				<span>
				  ©
				  <span id="currentYear"></span> 
				  <span id='footer-page-name'><?= !empty($pageStructure['f_brand']) ? $pageStructure['f_brand'] : 'Фирма' ?></span>
				</span>
			</span>

			<?php
				if (!empty($legal) && is_array($legal)) {
			?>
			<ul class="footer-btn-list flex pos-abs" aria-label="Навигация по юридическим и контактным страницам сайта">
				<?php foreach ($legal as $legalItem) {
					if (!empty($legalItem['name']) && !empty($legalItem['url'])) {
						$name = htmlspecialchars($legalItem['name'], ENT_QUOTES, 'UTF-8');
						$url = htmlspecialchars($legalItem['url'], ENT_QUOTES, 'UTF-8');
				?>
					<li class="act-elem link">
						<a href="<?php echo $url; ?>" class="no-wrap act-anchor"><?php echo $name; ?></a>
					</li>
				<?php
					}
				} ?>
				<li class="act-elem">
					<button id="manage-analysis" class="manage-analysis act-anchor">Analyse verwalten</button>
				</li>
			</ul>
			<?php
				}
			?>

			<div id="social-links-wrap" class="social-links-wrap pos-abs">
          		<?= renderSocialLinks($socialMedia) ?>
        	</div> 

		</div>
	  </footer>

	  <canvas id='canvas' class='canvas'></canvas>
	</div>
	
	<script src="<?= BASE_URL ?>/public/js/background_control.js" defer></script>
	<script src="<?= BASE_URL ?>/public/js/cookie_control.js" defer></script>
	<script src="<?= BASE_URL ?>/modules/chat/PrivacyConsentHandler.js" defer></script>
	<script src="<?= BASE_URL ?>/modules/chat/assets/chat.js" defer></script>
	<script src="<?= BASE_URL ?>/public/js/main_control.js" defer></script>
	<script src="<?= BASE_URL ?>/modules/chat/widget.js" defer></script>
	
	<script src="<?= BASE_URL ?>/public/js/nav_control.js" defer></script>
	<script src="<?= BASE_URL ?>/public/js/level_control.js" defer></script>
	<script src="<?= BASE_URL ?>/public/js/data_control.js" defer></script>
	<script src="<?= BASE_URL ?>/public/js/drag_drop_control.js" defer></script>
  </body>
</html>