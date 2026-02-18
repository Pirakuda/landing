<main class="main-wrap pos-abs">
  <div id="lev-wrap" class="level-wrap">
    <?= createLev($pageStructure['activeLevel'], 'level current', $pageStructure); ?>
  </div>
</main>
<script>
	window.pageStructure = <?php echo json_encode($pageStructure); ?>;
   
  // Уведомляем о готовности данных (если используете события)
  window.dispatchEvent(new CustomEvent('pageStructureReady', { 
    detail: window.pageStructure 
  }));
</script>