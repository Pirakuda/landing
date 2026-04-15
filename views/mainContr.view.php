
<div class="main-contr pos-abs">

  <div class="level-nav-wrap pos-abs">
    <div id='navLevWrap' class="nav-wrap">
      <ul class="flex flex-dir-col" aria-label="Liste der Ebenen">
        <?php
          $pageType = htmlspecialchars($pageStructure['type'] ?? 'landing');
          $actLevel = (int)$pageStructure['activeLevel'] ?? 0;
          $levelCount = count($pageStructure['levels'] ?? 1);
        ?>
        <?php if ($levelCount > 1): ?>
			    <?php for ($levIndex = 0; $levIndex < $levelCount; $levIndex ++): ?>
            <?php
            $isActive = ($levIndex === $actLevel) ? 'page' : 'false';
            ?>
            <li class="act-elem <?= ($levIndex === $actLevel) ? 'cur' : ''?> <?= ($levIndex > 3) ? 'hid' : '' ?>">
              <a data-index="<?= $levIndex ?>" 
                class="act-anchor-btn" 
                href="#" 
                aria-current="<?= $isActive ?>" 
                aria-label="Gehe zur nächsten Ebene">
              </a>
            </li>
			    <?php endfor; ?>
			  <?php endif; ?>
      </ul>
    </div>
  </div>

  <?php
    $levObj = $pageStructure['levels'][$actLevel];
    $actScr = (int)$levObj['activeScreen'];
    $hidArrowClass = count($levObj['screens']) > 1 ? '' : 'hid';
  ?>
        
  <div class='scr-nav-wrap'>
    <?php
      $screenCount = isset($pageStructure['levels'][$actLevel]['screens']) ? count($pageStructure['levels'][$actLevel]['screens']) : 0;
      $navWidth = $screenCount > 4 ? '140px' : ($screenCount * 40).'px';
    ?>

    <button id="sec-scr-nav-btn-prev" class="sec-scr-nav-btn left <?=$hidArrowClass?>"><span>&#10094;</span>Zurück</button>

    <div id='navScrWrap' class="nav-wrap flex" style="width:<?=$navWidth?>">
    <ul class="flex nav-screen" aria-label="Liste der Bildschirme" style="transform: translateX(0px);">
      <?php if ($screenCount > 1): ?>
          <?php
          $actScr = isset($pageStructure['levels'][$actLevel]) ? (int)($pageStructure['levels'][$actLevel]['activeScreen'] ?? 0) : 0;
          ?>
          <?php for ($index = 0; $index < $screenCount; $index++): ?>
              <?php
              $isActive = ($index === $actScr) ? 'page' : 'false';
              ?>
              <li class="act-elem <?= ($index === $actScr) ? 'cur' : '' ?> <?= ($index > 3) ? 'hid' : '' ?>">
                  <a data-index="<?= $index ?>" 
                    class="act-anchor-btn" 
                    href="#" 
                    aria-current="<?= $isActive ?>" 
                    aria-label="Zum nächsten Bildschirm wechseln">
                  </a>
              </li>
          <?php endfor; ?>
      <?php endif; ?>
    </ul>
    </div>

    <button id="sec-scr-nav-btn-next" class="sec-scr-nav-btn right <?=$hidArrowClass?>">Nächste<span>&#10095;</span></button>
    
  </div>

  <?php
    $scrObj = $levObj['screens'][$actScr];

    $textId = $scrObj['textId'] ?? null;
    $textObj = $textId ? $pageStructure[$textId] : null;

    $benefits = $textObj['benefits'] ?? '';
    $showBenefitsClass = (
        ($levObj['scrFull'] ?? '') === 'full' &&
        !empty(trim(strip_tags($benefits)))
    ) ? 'show' : '';
  ?>

  <div id="benefits-wrap" class="ticker-wrap">
    <ul class="ticker-track">
    </ul>
  </div>

  <div class="pos-abs arrow-wrap L <?=$hidArrowClass?>">
    <button id="arrow-L" class='arrow-btn act-elem' aria-label="Перейти к предыдущему экрану"><span>&#10094;</span></button>
  </div>

  <div class="pos-abs arrow-wrap R <?=$hidArrowClass?>">
  	<button id="arrow-R" class='arrow-btn act-elem' aria-label="Перейти к следующему экрану"><span>&#10095;</span></button>
  </div>
</div>
			