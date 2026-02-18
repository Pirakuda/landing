
  // работа с комментариями
  function toggleButtons(activeButton, inactiveButton) {
      activeButton.classList.add('cur');
      activeButton.setAttribute('aria-pressed', 'true');
  
      inactiveButton.classList.remove('cur');
      inactiveButton.setAttribute('aria-pressed', 'false');
  }
  function loadComments(reset = false, commentsContainer, loadMoreBtn) {
      let offset = commentsContainer.children.length;
  
      if (reset) {
          offset = 0; // Сбрасываем offset при смене режима
          commentsContainer.innerHTML = ""; // Очищаем контейнер
      }
  
      fetch("./test/modules/public/getComment_api.php", {
          method: "POST",
          headers: { "Content-Type": "application/json" }, // Важно!
          body: JSON.stringify({ offset })
      })
      .then(response => response.json())
      .then(data => {
          if (!data.success || !data.comments.length) {
              if (reset) commentsContainer.innerHTML = "<p class='popup-p m-t-20'>Комментариев пока нет.</p>";
              loadMoreBtn.style.display = "none"; // Скрываем кнопку, если комментариев больше нет
              return;
          }
  
          commentsContainer.innerHTML += data.comments.map(comment => `
              <div class="popup-p m-t-20" role="listitem">
                  <span class="comment-stars-wrap" aria-hidden="true">
                      ${"&#9733;".repeat(comment.rating)}${"&#9734;".repeat(5 - comment.rating)}
                  </span>
                  <p class="comment-text">${comment.message}</p>
                  <span class="comment-author">${comment.author_name || "Гость"}</span>
                  <time datetime="${comment.created_at}">
                      ${new Date(comment.created_at).toLocaleDateString()}
                  </time>
              </div>
          `).join("");
  
          loadMoreBtn.style.display = data.hasMore ? "block" : "none"; // Показываем кнопку, если есть еще комментарии
      })
      .catch(error => {
          console.error("Ошибка загрузки комментариев:", error);
          commentsContainer.innerHTML = "<p class='popup-p m-t-5'>Ошибка загрузки комментариев.</p>";
      });
  }
  
  // Функция для установки слушателя событий
  function setupActionEventListeners() {
  
      const pageRatingStars = document.getElementById("page-rating-stars");
      const pageRatingCounter = document.getElementById("page-rating-counter");
      const loadMoreBtn = document.getElementById("load-more-comments-btn");
      const commentsContainer = document.getElementById("comments-container");
      const ratingPopup = document.getElementById('rating-popup-wrap');
  
      // отзывы - формирование количества и средняя оценка на странице
      fetch("./modules/public/countComment_api.php", {
          method: "POST"
      })
      .then(response => response.json())
      .then(data => {
          if (!data.success) {
              console.error("Ошибка API:", data.message);
              return;
          }
  
          // Получаем средний рейтинг и количество отзывов
          const totalReviews = data.total_reviews;
          const avgRating = data.avg_rating;
  
          // Обновляем отображение рейтинга
          pageRatingStars.innerHTML = "&#9733;".repeat(Math.floor(avgRating)) + "&#9734;".repeat(5 - Math.floor(avgRating));
          // pageRatingCounter.innerHTML = `${totalReviews}/${avgRating}`;
          pageRatingCounter.innerHTML = `${avgRating}`;
      })
      .catch(error => console.error("Ошибка загрузки комментариев:", error));
  
      // выводим рэйтинг при начальной загрузке страницы
      showHidRating(pageStructure);
  
      // открытие окна с отзывами при клике по звездам
      ratingContainer.addEventListener('click', function(e) {
          const popupClassList = ratingPopup.classList;
  
          if (popupClassList.contains('show')) return;
  
          if (!popupClassList.contains('loaded')) {
              popupClassList.add('loaded');
              loadComments(true, commentsContainer, loadMoreBtn);
          }
  
          popupCloseHandle(popupList);
          if (isPortraitOrient()) menuToggle.classList.toggle('checked');
          
          popupClassList.add('show');
      });
  
      // дозагрузка отзывов
      loadMoreBtn.addEventListener("click", () => {
          loadComments(false, commentsContainer, loadMoreBtn);
      });
  
      /////////////////////////////////////////////////////////////
      const popupStarsWrap = commentForm.querySelector('#popup-stars-wrap');
      const stars = popupStarsWrap.querySelectorAll(".rating-star");
      const ratingInput = commentForm.querySelector("#selected-rating");
      const nameField = commentForm.querySelector("#comment-name-field");
      const commentField = commentForm.querySelector("#comment-text-field");
      let selectedRating = 0; // Храним выбранный рейтинг
  
      // Функция подсветки звезд
      function highlightStars(value) {
          stars.forEach(star => {
              const starValue = parseInt(star.getAttribute("data-value"));
              star.classList.toggle("selected", starValue <= value);
              star.setAttribute("aria-pressed", starValue === value ? "true" : "false");
          });
      }
  
      // Обработчик наведения (hover)
      stars.forEach(star => {
          star.addEventListener("mouseover", (e) => {
              highlightStars(e.currentTarget.getAttribute("data-value"));
          });
  
          // Обработчик клика - фиксируем оценку
          star.addEventListener("click", (e) => {
              e.preventDefault();
              selectedRating = e.currentTarget.getAttribute("data-value");
              highlightStars(selectedRating);
          });
      });
  
      // Убираем подсветку, если пользователь убрал мышь
      popupStarsWrap.addEventListener("mouseleave", () => {
          highlightStars(selectedRating);
      });
  
      // Обработчик отправки формы
      commentForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Предотвращаем стандартное поведение формы

        const honeypotField = document.getElementById('comment-form-honeypot-field');
		if (honeypotField.value) {
			const msg = 'Ошибка проверки. Пожалуйста, обновите страницу и попробуйте снова.';
			updateMsg(popupList, msg);
			return;
		}

        if (selectedRating === 0 && !commentField.value.trim()) {
            const msg = "Пожалуйста, выберите количество звезд для оценки или оставьте отзыв.";
            updateMsg(popupList, msg);
            return;
        }

        menuToggle.classList.remove('checked');
        const initialMsg = 'Спасибо, что поделились своим мнением! Мы всегда рады услышать ваши предложения и замечания.';
		updateMsg(popupList, initialMsg);

        // Формируем объект данных
        const formData = {
            rating: selectedRating === 0 ? null : selectedRating,
            name: nameField.value.trim(),
            message: commentField.value.trim(),
        };

        const rating = selectedRating === 0 ? null : selectedRating;
        const name = nameField.value.trim();
        const message = commentField.value.trim();

        // console.log('rating', rating, 'name', name, 'message', message);

        fetch("./modules/public/setComment_api.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(formData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                commentField.value = ""; // Очищаем поле ввода
                nameField.value = "";
                highlightStars(0); // Сбрасываем звезды
                selectedRating = 0;
                ratingInput.value = 0;
            } else {
                // const initialMsg = 'Ошибка отправки отзыва. Попробуйте позже.';
		        // updateMsg(popupList, initialMsg);
            }
        })
        .catch(error => {
            const initialMsg = 'Ошибка при отправке отзыва.';
		    updateMsg(popupList, initialMsg);
        });
    });
  
  } /* line 916 - 837 - 804 - 786 - 707 - 728 - 584 - 650 */

  /**
 * Дополнительная функция для программного управления чатом
 * Может быть полезна для интеграции с другими компонентами
 */
// function initializeChatIntegration() {
//     // Проверяем готовность всех компонентов
//     const componentsReady = {
//         chatBot: !!window.chatBot,
//         privacyConsent: !!window.privacyConsent,
//         popupHandler: typeof window.chatPopupOpenHandler === 'function',
//         popupList: typeof window.popupList !== 'undefined'
//     };
    
//     console.log('Chat integration status:', componentsReady);
    
//     // Если что-то не готово, выводим предупреждения
//     if (!componentsReady.chatBot) {
//         console.warn('ChatBot not initialized');
//     }
//     if (!componentsReady.privacyConsent) {
//         console.warn('Privacy consent handler not initialized');
//     }
//     if (!componentsReady.popupHandler || !componentsReady.popupList) {
//         console.warn('Modal popup handlers not available - dynamic buttons for modals will fallback to contact form');
//     }
    
//     return componentsReady;
// }

// /**
//  * Функция для тестирования интеграции согласия
//  * Вызовите в консоли для отладки: testPrivacyConsent()
//  */
// function testPrivacyConsent() {
//     if (!window.privacyConsent) {
//         console.error('Privacy consent not initialized');
//         return;
//     }
    
//     console.log('=== Privacy Consent Test ===');
//     console.log('Should show checkbox:', window.privacyConsent.shouldShowConsentCheckbox());
//     console.log('Stored consent:', window.privacyConsent.getStoredConsent());
//     console.log('Consent data for server:', window.privacyConsent.getConsentDataForServer());
    
//     // Тест отзыва согласия
//     const originalConsent = window.privacyConsent.getStoredConsent();
//     console.log('Testing consent revocation...');
//     window.privacyConsent.revokeConsent();
//     console.log('After revocation - should show checkbox:', window.privacyConsent.shouldShowConsentCheckbox());
    
//     // Восстанавливаем если было согласие
//     if (originalConsent) {
//         localStorage.setItem('privacy_consent_given', JSON.stringify(originalConsent));
//         console.log('Original consent restored');
//     }
// }

// /**
//  * Функция для тестирования модальных окон
//  * Вызовите в консоли: testModalIntegration()
//  */
// function testModalIntegration() {
//     const testButtons = [
//         { text: 'Тест FAQ', action: 'get_faq', data: {} },
//         { text: 'Тест Калькулятор', action: 'get_calc', data: {} },
//         { text: 'Тест Аудит', action: 'get_audit', data: {} }
//     ];
    
//     if (window.chatBot && window.chatBot.renderActionButtons) {
//         console.log('Rendering test modal buttons...');
//         window.chatBot.renderActionButtons(testButtons);
//     } else {
//         console.error('ChatBot not available for testing');
//     }
// }

// // Делаем функции доступными глобально для отладки
// window.initializeChatIntegration = initializeChatIntegration;
// window.testPrivacyConsent = testPrivacyConsent;
// window.testModalIntegration = testModalIntegration;