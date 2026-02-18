
<aside id="contr" class="main-contr popup pos-abs">

  <div id="toggle-wrap" class='popup-btn-wrap pos-abs flex flex-dir-col'>
	<button id='menu-toggle' class='menu-toggle pos-rel flex column sp-between al-it-end' title='Menu'>
		<span class="line"></span>
		<span class="line"></span>
	</button>
  </div>

  <button id="guide-main-btn" class="guide-main-btn popup-btn popup act-elem pos-abs">Guide &#9658;</button>

  <div id="page-rating-container" class="page-rating-container pos-abs" role="region">
    <p class="page-rating-heading">Nutzerbewertungen</p>
    <div id="page-rating-wrap" class="page-rating-wrap flex al-it-center" role="group" aria-label="Средняя оценка страницы">
      <span id="page-rating-stars" class="page-rating-stars"></span>
      <div id="page-rating-counter" class="page-rating-counter" aria-live="polite"></div>
    </div>
  </div>

  <ul id="popup-list">

  <li id="cookies-popup-wrap" class="popup-contr cookies-popup">
    <section class="popup-contr-wrap" aria-label="Cookie-Hinweis">
      <p class="popup-p m-t-10">
      Diese Website nutzt Cookies, um Ihr Nutzungserlebnis zu optimieren, die Seitenperformance zu analysieren und Ihnen passende Inhalte anzuzeigen.
      </p>
      <p class="popup-p m-b-10">
        Mehr erfahren: <a class="popup-link m-l-10" href="./legal/cookies" target="_blank">Datenschutz</a>
      </p>
      <div class="cookie-banner-actions">
        <button id="decline-cookies" type="button" class="popup-btn secondary act-elem">
          Alle ablehnen
        </button>
        <button id="cookie-settings-btn" type="button" class="popup-btn settings act-elem">
          Einstellungen
        </button>
        <button id="accept-cookies" type="button" class="popup-btn primary act-elem">
          Alle akzeptieren
        </button>
      </div>
    </section>
  </li>

  <li id="cookie-settings-popup-wrap" class="popup-contr cookie-settings-popup">
    <section class="popup-contr-wrap" aria-label="Cookie-Einstellungen">
      <div class="modal-header">
        <button class="popup-close-btn" onclick="popupCrossCloseHandle(this)" aria-label="Schließen">×</button>
        <h3 class="modal-title">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M321.5 91.6C320.7 86.2 316.6 81.8 311.2 81C289.1 77.9 266.6 81.9 246.8 92.4L172.8 131.9C153.1 142.4 137.2 158.9 127.4 179L90.7 254.6C80.9 274.7 77.7 297.5 81.6 319.5L96.1 402.3C100 424.4 110.7 444.6 126.8 460.2L187.1 518.6C203.2 534.2 223.7 544.2 245.8 547.3L328.8 559C350.9 562.1 373.4 558.1 393.2 547.6L467.2 508.1C486.9 497.6 502.8 481.1 512.6 460.9L549.3 385.4C559.1 365.3 562.3 342.5 558.4 320.5C557.5 315.2 553.1 311.2 547.8 310.4C496.3 302.2 455 263.3 443.3 213C441.5 205.4 435.3 199.6 427.6 198.4C373 189.7 329.9 146.4 321.4 91.6zM272 208C289.7 208 304 222.3 304 240C304 257.7 289.7 272 272 272C254.3 272 240 257.7 240 240C240 222.3 254.3 208 272 208zM208 400C208 382.3 222.3 368 240 368C257.7 368 272 382.3 272 400C272 417.7 257.7 432 240 432C222.3 432 208 417.7 208 400zM432 336C449.7 336 464 350.3 464 368C464 385.7 449.7 400 432 400C414.3 400 400 385.7 400 368C400 350.3 414.3 336 432 336z"/></svg>
          Cookie-Einstellungen
        </h3>
        <p class="modal-subtitle">
          Verwalten Sie Ihre Cookie-Präferenzen. Sie können Ihre Auswahl jederzeit ändern. 
          Notwendige Cookies können nicht deaktiviert werden.
        </p>
      </div>

      <div class="modal-urgency">
        <span>
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M232.5 136L320 229L407.5 136L232.5 136zM447.9 163.1L375.6 240L504.6 240L448 163.1zM497.9 288L142.1 288L320 484.3L497.9 288zM135.5 240L264.5 240L192.2 163.1L135.6 240zM569.8 280.1L337.8 536.1C333.3 541.1 326.8 544 320 544C313.2 544 306.8 541.1 302.2 536.1L70.2 280.1C62.5 271.6 61.9 258.9 68.7 249.7L180.7 97.7C185.2 91.6 192.4 87.9 200 87.9L440 87.9C447.6 87.9 454.8 91.5 459.3 97.7L571.3 249.7C578.1 258.9 577.4 271.6 569.8 280.1z"/></svg>
        </span>
        30% Trade-In beim Umstieg auf unser System!
      </div>
      
      <div class="popup-content">
        <div class="cookie-categories">
          <!-- Необходимые cookies -->
          <div class="cookie-category required">
            <div class="category-header">
              <div class="category-info">
                <h4 class="category-title">Notwendige Cookies</h4>
                <span class="required-badge">Erforderlich</span>
              </div>
              <label class="toggle-switch">
                <input type="checkbox" id="necessary-cookies" checked disabled>
                <span class="toggle-slider"></span>
              </label>
            </div>
            <p class="category-description">
              Diese Cookies sind für das ordnungsgemäße Funktionieren der Website unerlässlich. 
              Sie ermöglichen grundlegende Funktionen wie Navigation und Sicherheit.
            </p>
            <div class="cookies-details">
              <button class="details-toggle" type="button" onclick="toggleCookieDetails(this)">
                Details anzeigen <span class="arrow">▼</span>
              </button>
              <div class="cookies-list">
                <ul>
                  <li><code>session_id</code><span> - Sitzungsidentifikation (Session)</span></li>
                  <li><code>csrf_token</code><span> - Sicherheitstoken (Session)</span></li>
                  <li><code>cookies_accepted</code><span> - Cookie-Einstellungen (1 Jahr)</span></li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Аналитические cookies -->
          <div class="cookie-category">
            <div class="category-header">
              <div class="category-info">
                <h4 class="category-title">Analyse-Cookies</h4>
              </div>
              <label class="toggle-switch">
                <input type="checkbox" id="analytics-cookies" data-category="analytics">
                <span class="toggle-slider"></span>
              </label>
            </div>
            <p class="category-description">
              Diese Cookies helfen uns zu verstehen, wie Besucher mit unserer Website interagieren. 
              Alle Informationen werden anonym gesammelt.
            </p>
            <div class="cookies-details">
              <button class="details-toggle" type="button" onclick="toggleCookieDetails(this)">
                Details anzeigen <span class="arrow">▼</span>
              </button>
              <div class="cookies-list">
                <ul>
                  <li><code>_analytics_session</code><span> - Analysesitzung (2 Jahre)</span></li>
                  <li><code>page_views</code><span> - Seitenaufrufe (30 Tage)</span></li>
                  <li><code>user_behavior</code><span> - Nutzerverhalten (1 Jahr)</span></li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Маркетинговые cookies -->
          <div class="cookie-category">
            <div class="category-header">
              <div class="category-info">
                <h4 class="category-title">Marketing-Cookies</h4>
              </div>
              <label class="toggle-switch">
                <input type="checkbox" id="marketing-cookies" data-category="marketing">
                <span class="toggle-slider"></span>
              </label>
            </div>
            <p class="category-description">
              Diese Cookies werden verwendet, um Ihnen relevante Werbung zu zeigen und 
              die Wirksamkeit von Kampagnen zu messen.
            </p>
            <div class="cookies-details">
              <button class="details-toggle" type="button" onclick="toggleCookieDetails(this)">
                Details anzeigen <span class="arrow">▼</span>
              </button>
              <div class="cookies-list">
                <ul>
                  <li><code>ad_preferences</code><span> - Werbepräferenzen (1 Jahr)</span></li>
                  <li><code>marketing_id</code><span> - Marketing-ID (2 Jahre)</span></li>
                  <li><code>campaign_tracking</code><span> - Kampagnenverfolgung (6 Monate)</span></li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Предпочтения cookies -->
          <div class="cookie-category">
            <div class="category-header">
              <div class="category-info">
                <h4 class="category-title">Präferenz-Cookies</h4>
              </div>
              <label class="toggle-switch">
                <input type="checkbox" id="preferences-cookies" data-category="preferences">
                <span class="toggle-slider"></span>
              </label>
            </div>
            <p class="category-description">
              Diese Cookies speichern Ihre Einstellungen und Präferenzen, 
              um Ihnen eine personalisierte Erfahrung zu bieten.
            </p>
            <div class="cookies-details">
              <button class="details-toggle" type="button" onclick="toggleCookieDetails(this)">
                Details anzeigen <span class="arrow">▼</span>
              </button>
              <div class="cookies-list">
                <ul>
                  <li><code>language_preference</code><span> - Spracheinstellung (1 Jahr)</span></li>
                  <li><code>theme_choice</code><span> - Design-Auswahl (6 Monate)</span></li>
                  <li><code>layout_settings</code><span> - Layout-Einstellungen (6 Monate)</span></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="popup-actions">
        <div class="action-buttons-group">
          <button id="decline-all-settings" class="popup-btn secondary" type="button">
            Alle ablehnen
          </button>
          <button id="accept-all-settings" class="popup-btn primary" type="button">
            Alle akzeptieren
          </button>
        </div>
        <button id="save-cookie-preferences" class="popup-btn save-btn" type="button">
          Auswahl speichern
        </button>
      </div>

      <div class="popup-footer">
        <p class="footer-text">
          Mehr Informationen finden Sie in unserer 
          <a href="./legal/cookies" target="_blank" class="popup-link">Datenschutz</a>
        </p>
      </div>
    </section>
  </li>

	<li id="rating-popup-wrap" class="popup-contr">
    <section class="popup-contr-wrap">
      <div class="modal-header">
        <button class="popup-close-btn act-elem pos-abs" onclick="popupCrossCloseHandle(this)" aria-label="Закрыть окно">&times;</button>
        <h3 class="modal-title">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M160 368c26.5 0 48 21.5 48 48l0 16 72.5-54.4c8.3-6.2 18.4-9.6 28.8-9.6L448 368c8.8 0 16-7.2 16-16l0-288c0-8.8-7.2-16-16-16L64 48c-8.8 0-16 7.2-16 16l0 288c0 8.8 7.2 16 16 16l96 0zm48 124l-.2 .2-5.1 3.8-17.1 12.8c-4.8 3.6-11.3 4.2-16.8 1.5s-8.8-8.2-8.8-14.3l0-21.3 0-6.4 0-.3 0-4 0-48-48 0-48 0c-35.3 0-64-28.7-64-64L0 64C0 28.7 28.7 0 64 0L448 0c35.3 0 64 28.7 64 64l0 288c0 35.3-28.7 64-64 64l-138.7 0L208 492z"/></svg>
          Ihre Meinung ist uns wichtig!
        </h3>
        <p class="modal-subtitle">Teilen Sie Ihre positiven Erfahrungen und unterstützen Sie andere bei der richtigen Wahl</p>
      </div>

      <div class="modal-urgency">
        <span>
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M232.5 136L320 229L407.5 136L232.5 136zM447.9 163.1L375.6 240L504.6 240L448 163.1zM497.9 288L142.1 288L320 484.3L497.9 288zM135.5 240L264.5 240L192.2 163.1L135.6 240zM569.8 280.1L337.8 536.1C333.3 541.1 326.8 544 320 544C313.2 544 306.8 541.1 302.2 536.1L70.2 280.1C62.5 271.6 61.9 258.9 68.7 249.7L180.7 97.7C185.2 91.6 192.4 87.9 200 87.9L440 87.9C447.6 87.9 454.8 91.5 459.3 97.7L571.3 249.7C578.1 258.9 577.4 271.6 569.8 280.1z"/></svg>
        </span>
        30% Trade-In beim Umstieg auf unser System!
      </div>
      
      <form id="comment-form" method="POST" class="modal-body">

        <fieldset id="popup-stars-wrap" class="popup-stars-wrap m-t-10">
          <legend class="visually-hidden">Bewertung auswählen</legend>
          <button class="rating-star" data-value="1" aria-pressed="false" aria-label="1 звезда">&#9733;</button>
          <button class="rating-star" data-value="2" aria-pressed="false" aria-label="2 звезды">&#9733;</button>
          <button class="rating-star" data-value="3" aria-pressed="false" aria-label="3 звезды">&#9733;</button>
          <button class="rating-star" data-value="4" aria-pressed="false" aria-label="4 звезды">&#9733;</button>
          <button class="rating-star" data-value="5" aria-pressed="false" aria-label="5 звезд">&#9733;</button>
        </fieldset>

        <input type="hidden" name="rating" id="selected-rating" value="0">

        <div class="form-group m-t-10">
            <label class="form-label" for="comment-name-field">Name (optional)</label>
            <input type="text" id="comment-name-field" class="form-input" placeholder="Name">
        </div>

        <div class="form-group">
            <label class="form-label" for="comment-text-field">Bewertung (optional)</label>
            <textarea id="comment-text-field" class="form-textarea" placeholder="Bewertung"></textarea>
        </div>

        <div class="input-block" style="display:none;">
          <input type="text" name="honeypot" id="comment-form-honeypot-field" autocomplete="off" tabindex="-1" />
        </div>

        <label class="consent-label">
          <input class="m-r-5" type="checkbox" id="comment-form-consent" name="consent" required>
          <span class="popup-p confirm-span">Ich stimme der Verarbeitung meiner personenbezogenen Daten gemäß zu
            <a class="popup-link m-l-10 no-wrap phone confirm-anchor" href="./legal/privacy">Datenschutzerklärung</a>
          </span>
        </label>

        <div class="flex al-flex-end m-t-20">
          <button id="save-comment-btn" class="modal-nav-btn modal-act" type="submit">Bewertung absenden</button>
        </div>
      </form>

      <!-- комментарии -->
      <div class="comments-section m-t-20">
        <h3 class="popup-title">Kundenbewertungen</h3>
        <div id="comments-container" class="comments-container m-b-20" role="list" aria-live="polite"></div>
        <div class="flex al-flex-end m-b-20">
          <button id="load-more-comments-btn" class="popup-btn act-elem p-t-5 p-b-5 p-l-20 p-r-20" type="button" style="display: none;">Mehr laden</button>
        </div>
      </div>
    </section>
	</li>

  <li id="faq-popup-wrap" class="popup-contr">
    <section class="popup-contr-wrap">
      <div class="modal-header">
        <button class="popup-close-btn act-elem pos-abs" onclick="popupCrossCloseHandle(this)" aria-label="Закрыть окно">&times;</button>
        <h3 class="modal-title" id="FAQ-title">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M464 256A208 208 0 1 0 48 256a208 208 0 1 0 416 0zM0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256zm169.8-90.7c7.9-22.3 29.1-37.3 52.8-37.3l58.3 0c34.9 0 63.1 28.3 63.1 63.1c0 22.6-12.1 43.5-31.7 54.8L280 264.4c-.2 13-10.9 23.6-24 23.6c-13.3 0-24-10.7-24-24l0-13.5c0-8.6 4.6-16.5 12.1-20.8l44.3-25.4c4.7-2.7 7.6-7.7 7.6-13.1c0-8.4-6.8-15.1-15.1-15.1l-58.3 0c-3.4 0-6.4 2.1-7.5 5.3l-.4 1.2c-4.4 12.5-18.2 19-30.6 14.6s-19-18.2-14.6-30.6l.4-1.2zM224 352a32 32 0 1 1 64 0 32 32 0 1 1 -64 0z"/></svg>
          Häufig gestellte Fragen
        </h3>
        <p class="modal-subtitle">Lösungen für häufige Fragen und Benutzeranleitungen</p>
      </div>
      <div class="modal-urgency">
        <span>
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M232.5 136L320 229L407.5 136L232.5 136zM447.9 163.1L375.6 240L504.6 240L448 163.1zM497.9 288L142.1 288L320 484.3L497.9 288zM135.5 240L264.5 240L192.2 163.1L135.6 240zM569.8 280.1L337.8 536.1C333.3 541.1 326.8 544 320 544C313.2 544 306.8 541.1 302.2 536.1L70.2 280.1C62.5 271.6 61.9 258.9 68.7 249.7L180.7 97.7C185.2 91.6 192.4 87.9 200 87.9L440 87.9C447.6 87.9 454.8 91.5 459.3 97.7L571.3 249.7C578.1 258.9 577.4 271.6 569.8 280.1z"/></svg>
        </span>
        30% Trade-In beim Umstieg auf unser System!
      </div>

      <div class="modal-body faq-section">
        <div id="faq-container" class="faq-container m-b-20" role="list" aria-live="polite"></div>

        <div class="flex al-flex-end m-b-20">
          <button id="load-more-faq-btn" class="modal-nav-btn modal-act" type="button" style="display: none;">Mehr laden</button>
        </div>
      </div>
    </section>
  </li>

  <li id="chat-popup-wrap" class="popup-contr">
    <section class="popup-contr-wrap">
      <div class="modal-header">
        <button class="popup-close-btn act-elem pos-abs" onclick="popupCrossCloseHandle(this)" aria-label="Закрыть окно">&times;</button>
        <h3 class="modal-title">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M434.8 54.1C446.7 62.7 451.1 78.3 445.7 91.9L367.3 288L512 288C525.5 288 537.5 296.4 542.1 309.1C546.7 321.8 542.8 336 532.5 344.6L244.5 584.6C233.2 594 217.1 594.5 205.2 585.9C193.3 577.3 188.9 561.7 194.3 548.1L272.7 352L128 352C114.5 352 102.5 343.6 97.9 330.9C93.3 318.2 97.2 304 107.5 295.4L395.5 55.4C406.8 46 422.9 45.5 434.8 54.1z"/></svg>
          Express-Beratung
        </h3>
        <p class="modal-subtitle">Sekundenschnelle Antwort. KI übernimmt für Sie</p>
      </div>

      <div class="modal-urgency">
        <span>
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M232.5 136L320 229L407.5 136L232.5 136zM447.9 163.1L375.6 240L504.6 240L448 163.1zM497.9 288L142.1 288L320 484.3L497.9 288zM135.5 240L264.5 240L192.2 163.1L135.6 240zM569.8 280.1L337.8 536.1C333.3 541.1 326.8 544 320 544C313.2 544 306.8 541.1 302.2 536.1L70.2 280.1C62.5 271.6 61.9 258.9 68.7 249.7L180.7 97.7C185.2 91.6 192.4 87.9 200 87.9L440 87.9C447.6 87.9 454.8 91.5 459.3 97.7L571.3 249.7C578.1 258.9 577.4 271.6 569.8 280.1z"/></svg>
        </span>
        30% Trade-In beim Umstieg auf unser System!
      </div>

      <div class="chat-container">
        <div class="chat-messages" id="chat-messages"></div>
        <div class="typing-indicator" id="typing-indicator" style="display: none;">
            <div class="typing-dots">
                <span></span><span></span><span></span>
            </div>
            <span class="typing-text">Tippt...</span>
        </div>
      </div>

      <div class="dialog-wrap">
        <div class="quick-buttons" id="quick-buttons">
          <button class="quick-button" data-action="request_callback">
            <span>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M224.2 89C216.3 70.1 195.7 60.1 176.1 65.4L170.6 66.9C106 84.5 50.8 147.1 66.9 223.3C104 398.3 241.7 536 416.7 573.1C493 589.3 555.5 534 573.1 469.4L574.6 463.9C580 444.2 569.9 423.6 551.1 415.8L453.8 375.3C437.3 368.4 418.2 373.2 406.8 387.1L368.2 434.3C297.9 399.4 241.3 341 208.8 269.3L253 233.3C266.9 222 271.6 202.9 264.8 186.3L224.2 89z"/></svg>
            </span>
            Rückruf anfordern
          </button>
          <button class="quick-button" data-action="request_contact">
            <span>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M320 128C241 128 175.3 185.3 162.3 260.7C171.6 257.7 181.6 256 192 256L208 256C234.5 256 256 277.5 256 304L256 400C256 426.5 234.5 448 208 448L192 448C139 448 96 405 96 352L96 288C96 164.3 196.3 64 320 64C443.7 64 544 164.3 544 288L544 456.1C544 522.4 490.2 576.1 423.9 576.1L336 576L304 576C277.5 576 256 554.5 256 528C256 501.5 277.5 480 304 480L336 480C362.5 480 384 501.5 384 528L384 528L424 528C463.8 528 496 495.8 496 456L496 435.1C481.9 443.3 465.5 447.9 448 447.9L432 447.9C405.5 447.9 384 426.4 384 399.9L384 303.9C384 277.4 405.5 255.9 432 255.9L448 255.9C458.4 255.9 468.3 257.5 477.7 260.6C464.7 185.3 399.1 127.9 320 127.9z"/></svg>
            </span>
            Kontakt zum Berater
          </button>
        </div>
        <div class="chat-input-container">
            <textarea 
                class="chat-input" 
                id="chat-input" 
                placeholder="Stellen Sie Ihre Frage..."
                rows="1"
                maxlength="1000"></textarea>
            <button class="chat-send-btn" id="chat-send-btn" type="button">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M2,21L23,12L2,3V10L17,12L2,14V21Z"/>
                </svg>
            </button>
        </div>
        <div class="contact-form" id="contact-form">
            <h4>Hinterlassen Sie Ihre Kontaktdaten</h4>
            <form id="contact-form-data">
                <input type="text" name="name" placeholder="Ihr Name *" required>
                <input type="email" name="email" placeholder="Email">
                <input type="tel" name="phone" placeholder="Telefon">
                <input type="text" name="telegram" placeholder="Telegram (ohne @)">

                <!-- Контейнер для чекбокса согласия (будет заполнен JavaScript) -->
                <div class="privacy-consent-container" id="privacy-consent-container"></div>
                
                <div class="form-buttons">
                    <button type="submit" class="btn-primary">Absenden</button>
                    <button type="button" class="btn-secondary" onclick="chatBot.hideContactForm()">Abbrechen</button>
                </div>
            </form>
        </div>
      </div>

    </section>
	</li>

  <li id="msg-popup-wrap" class="popup-contr msg-popup">
    <section class="popup-contr-wrap" aria-label="Nachricht">
		  <p class="msg-p popup-p m-t-10 m-b-10"></p>
	  </section>
	</li>

  </ul>

</aside>

			