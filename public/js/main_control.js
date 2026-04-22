
const BASE_PATH = '';

let pageBg;

// переменные DRAG and DROP
let dragY;
let dragX;

// определение времени с моментат нажатия на кнопку, используется для моюильной версии
let lastTap = 0;
let timeStart = 0;

const canvas = document.getElementById('canvas');
const WIDTH = document.documentElement.clientWidth - 30;
const HEIGHT = document.documentElement.clientHeight - 30;
canvas.width = WIDTH;
canvas.height = HEIGHT;
const isMobile = () => window.innerWidth <= 768;
const IS_MOBILE = () => window.innerWidth <= 768;
// let deviceType;

let headerWrap;
let preloader;

let navTopList;
let menuSecLink;

let toggleWrap;
let menuToggle;
let menuPopupWrap;
let popupList;

// let actionContr;
let ratingContainer;
let phoneWrap;
let benefitsWrap;

let guideMainBtn;
let IS_GUIDE_ACT = false;

let secScrNavBtnPrev;
let secScrNavBtnNext;
let arrowL;
let arrowR;
let navLevWrap;
let navScrWrap;

// обратная связь, отправка сообщения пользователем
let feedbackForm;
let commentForm;

/* FAQ-popup ****/
let navFaqBtn;
let loadMoreFaqBtn;
let faqContainer;
let faqPopup;

let manageAnalysisBtn;

/**
 * Извлекает контент-объект по textId из pageStructure.
 * Единая точка доступа к мультиязычным текстовым данным level/screen.
 * @param {object} pageStructure - полная структура страницы
 * @param {string|number|null|undefined} textId - идентификатор контент-объекта
 * @returns {object} контент-объект или пустой объект, если textId отсутствует
 */
function getContent(pageStructure, textId) {
  if (textId === null || textId === undefined || textId === '') return {};
  return pageStructure[String(textId)] ?? {};
}

////////////////////////////////////////////////////////////////////////////////////
// функция для совместимости с nav_control.js
function trackSectionTransition(pageStructure) {
    if (window.simpleAnalytics && window.simpleAnalytics.isInitialized) {
        window.simpleAnalytics.transitionTo(pageStructure);
    }
}

function getCurScrObj(pageStructure) {
    const activeLevel = parseInt(pageStructure.activeLevel || 0);
    const levelObj = pageStructure.levels[activeLevel];
    const activeScreen = parseInt(levelObj.activeScreen || 0);
    return levelObj.screens[activeScreen];
}

function updateMsg(popupList, msg) {
	popupCloseHandle(popupList);
	const msgWrap = popupList.querySelector('#msg-popup-wrap');
	msgWrap.querySelector('.msg-p').innerHTML = msg;
	msgWrap.classList.add('show');
	setTimeout(()=> msgWrap.classList.remove('show'), 4000);
}

function mobileMoreCloseHandler() {
	pageBg.classList.remove('full');
}

function moreCloseHandler(btn) {
	pageBg.classList.remove('full');

	const textMainWrap = btn.closest('.text-main-wrap');
	const slide = textMainWrap.parentElement;
	const textScrollWrap = textMainWrap.querySelector('.text-scroll-wrap');
	const panelMore = textMainWrap.querySelector('.panel-more');
	panelMore.style.maxHeight = null;
	panelMore.style.minHeight = null;
	textScrollWrap.style.maxHeight = textScrollWrap.offsetHeight;
	setTimeout(() => {textScrollWrap.style.maxHeight = null}, 1000);

	const moreBtn = textScrollWrap.querySelector('.more-btn');
	moreBtn.innerHTML = 'Weiter lesen';

	slide.classList.remove('show');
	textMainWrap.classList.remove('show');
}

function moreHandler(btn) {
	const textMainWrap = btn.closest('.text-main-wrap');
	const slide = textMainWrap.parentElement;
	const textScrollWrap = textMainWrap.querySelector('.text-scroll-wrap');
	const panelMore = textMainWrap.querySelector('.panel-more');
	
	if (textMainWrap.classList.contains('show')) {
		// закрываем панель

		pageBg.classList.remove('full');

		panelMore.style.maxHeight = null;
		panelMore.style.minHeight = null;

		textScrollWrap.style.maxHeight = textScrollWrap.offsetHeight;
		setTimeout(() => {textScrollWrap.style.maxHeight = null}, 1000);

		btn.innerHTML = 'Weiter lesen';
	} else {
		// открываем панель

		const screen = slide.parentElement;
		const scrWrap = screen.parentElement;

		let panelMoreH = panelMore.scrollHeight;
		let screenHeight;

		if (scrWrap.classList.contains('full')) {
			pageBg.classList.add('full');
			const viewportHeight = window.innerHeight;
			const viewportH = window.visualViewport?.height || viewportHeight;
			screenHeight = Math.max(screen.offsetHeight, viewportH);
		} else {
			if (!isPortraitOrient()) {
				if (window.matchMedia('(min-width: 768px) and (max-width: 1366px)').matches && (navigator.maxTouchPoints > 0)) {
					pageBg.classList.add('full');
					screenHeight = Math.max(screen.offsetHeight) - 40;
				} else {
					const style = getComputedStyle(textMainWrap);
					screenHeight = slide.offsetHeight - parseFloat(style.borderTopWidth) - parseFloat(style.borderBottomWidth);
				}
			} else {
				pageBg.classList.add('full');
				screenHeight = Math.max(screen.offsetHeight);
				console.log('screenHeight',screenHeight)
			}
		}

		if (panelMoreH < screenHeight) {
			const moreTitle = textScrollWrap.querySelector('.title');
			const moreBtn = textScrollWrap.querySelector('.more-btn');
			let moreTitleH = moreTitle.offsetHeight;
			const moreBtnH = moreBtn.offsetHeight;
		    panelMoreH = (screenHeight - moreTitleH - moreBtnH);
			panelMore.style.minHeight = `${panelMoreH}px`;

			// после раскрытия отнимаем высоту заголовка
			setTimeout(() => {
				moreTitleH = moreTitle.offsetHeight;
				h = (screenHeight - moreTitleH - moreBtnH) + "px";
				panelMore.style.minHeight = h;
				panelMore.style.maxHeight = h;
			}, 600);
		}
		
		let duration = panelMoreH * 0.0009;
		duration = Math.max(2,Math.min(duration, 2));
		panelMore.style.transition = `max-height ${duration}s ease, min-height ${duration}s ease`;

		panelMore.style.maxHeight = `${panelMoreH}px`;
		textScrollWrap.style.maxHeight = `${screenHeight}px`;
		btn.innerHTML = 'Verbergen';
	}

	slide.classList.toggle('show');
	textMainWrap.classList.toggle('show');
}

/* popup btn open/close handler */
function popupCrossCloseHandle(btn) {
	stopGuide();
	btn.closest('.popup-contr').classList.remove('show');
	menuToggle.classList.remove('checked');
}
function popupCloseOpenHandler(btn, menuPopupWrap, popupList) {
	stopGuide();
	if (btn.classList.contains('checked')) {
		// попап открыт, закрываем
		menuPopupWrap.classList.remove('show');
		popupList.querySelector('.popup-contr.show')?.classList.remove('show');
	} else {
		// попап закрыт, открываем
		menuPopupWrap.classList.add('show');
	}
}
// открытие попара из чата
function chatPopupOpenHandler(prefix, popupList) {
    stopGuide();

	// при открытии FAQ проверяем загружен ли FAQ
	if (prefix === 'faq' && !popupClassList.contains('loaded')) {
		loadFAQ(true, faqContainer, loadMoreFaqBtn);
		popupClassList.add('loaded');
	}

	// при открытии калькулятора проверяем RenderStep
	if (prefix === 'detector') {
		renderStep();
	}

    popupList.querySelector('#chat-popup-wrap')?.classList.remove('show', 'active');
    popupList.querySelector(`#${prefix}-popup-wrap`)?.classList.add('show');
}
function popupCloseHandle(popupList) {
	stopGuide();
	// if (!popupList.querySelector('.cookies-popup.show'));
	// if (!CookieConsent.getCookie('userConsent')) {
	// 	checkCookie(popupList);
	// 	return;
	// }
	popupList.querySelector('.popup-contr.show')?.classList.remove('show');
}

function screenHandler(e) {
	e.stopPropagation();
	e.preventDefault();
	const target = e.target;

	if (target && target.closest('.popup-contr, .legal-main-wrap, .menu-toggle, .menu-sec-link, .figure-slider-img')) return;
	stopGuide();
	const cookiesPopup = popupList.querySelector('#cookies-popup-wrap');

	if (cookiesPopup.classList.contains('show')) {
		checkCookie(popupList);
		return;
	}
	
	popupList.querySelector('.popup-contr.show')?.classList.remove('show');

	switch (target.nodeName) {
		case 'BUTTON':
			const classList = target.classList;
			
			if (classList.contains('more-btn')) {
				moreHandler(target);
			} else if (classList.contains('pageActBtn') || classList.contains('panel-btn')) {
				if (isPortraitOrient()) menuToggle.classList.toggle('checked');

				const dataService = target.getAttribute('data-service');
				const popupWrap = popupList.querySelector(`#${dataService}-popup-wrap`);

				if (!popupWrap) return;

				const popupClassList = popupWrap.classList;

				if (dataService === 'rating' && !popupClassList.contains('loaded')) {
					const commentsContainer = popupWrap.querySelector('#comments-container');
					const loadMoreBtn = popupWrap.querySelector('#load-more-comments-btn');
					loadComments(true, commentsContainer, loadMoreBtn);
					popupClassList.add('loaded');
				}

				if (dataService === 'faq' && !popupClassList.contains('loaded')) {
					loadFAQ(true, faqContainer, loadMoreFaqBtn);
					popupClassList.add('loaded');
				}

				if (dataService === 'detector') {
					renderStep();
				}

				popupClassList.add('show');

			} else if (classList.contains('btn-left')) {
				sliderArrowsHandler(target, -1, pageStructure);
			} else if (classList.contains('btn-right')) {
				sliderArrowsHandler(target, 1, pageStructure);
			}
			break;
		case 'DIV':
			if (target.classList.contains('mini-data')) sliderImgHandler(target, pageStructure);
			break;
		case 'IMG':
			if (isPortraitOrient() && menuToggle.classList.contains('checked')) {
				menuToggle.classList.remove('checked');
				if (menuPopupWrap.classList.contains('show')) menuPopupWrap.classList.remove('show');
			}

			// переключение активного скрина
			const scrColl = this.parentNode;
			if (!scrColl.classList.contains('full') && !this.classList.contains('current')) {
				const curLevObj = getCurLevObj(pageStructure);
				const nextIndex = parseInt(this.getAttribute('data-index'));
				scrNavHandler(curLevObj, nextIndex, pageStructure);
			}
			break;
		case 'A':
			// переход по ссылке из текстового материала
			if (target.classList.contains('panel-btn')) {
				// сворачиваем экран
				moreCloseHandler(target);

				// Получаем значения data-level и data-screen
				const levIndex = parseInt(target.getAttribute('data-level') ?? 0);
				const curLevIndex = parseInt(pageStructure.activeLevel || 0);

				// переключаем уровень
				levNavHandler(curLevIndex, levIndex, pageStructure);

				// переключаем экран
				const levObj = getCurLevObj(pageStructure);
				const scrIndex = parseInt(target.getAttribute('data-screen') ?? 0);
				setTimeout(() => { scrNavHandler(levObj, scrIndex, pageStructure) },0);
			}
			break;
		default:
			break;
	}
}

// универсальная функция для отправки сообщений с сайта
function handleFormSubmission(prefix, formElement, popupContainer, endpointUrl, mainMsg) {
	formElement.addEventListener('submit', function (e) {
		e.preventDefault();

		// Антиспам (honeypot)
		const honeypotField = formElement.querySelector(`#${prefix}-honeypot-field`);
		if (honeypotField && honeypotField.value) {
			updateMsg(popupContainer, 'Ошибка проверки. Пожалуйста, обновите страницу и попробуйте снова.');
			return;
		}

		// Проверка чекбокса согласия
		const consentCheckbox = formElement.querySelector(`#${prefix}-consent`);
		if (consentCheckbox && !consentCheckbox.checked) {
			updateMsg(popupContainer, 'Для отправки сообщения активируйте, пожалуйста, согласие на обработку данных.');
			return;
		}

		menuToggle.classList.remove('checked');
		updateMsg(popupContainer, mainMsg);

		// Сбор данных формы
		const formData = new FormData(formElement);
		const jsonData = {};
		formData.forEach((value, key) => {
			jsonData[key] = value;
		});

		// Отправка данных
		// fetch(endpointUrl, {
		// 	method: 'POST',
		// 	headers: {'Content-Type': 'application/json'},
		// 	body: JSON.stringify(jsonData)
		// })
		// .then(response => response.json())
		// .then(result => {
		// 	// if (result.success) {
		// 	// 	updateMsg(popupContainer, mainMsg);
		// 	// } else {
		// 	// 	const errorMsg = result.message || 'Произошла ошибка при отправке сообщения.';
		// 	// 	updateMsg(popupContainer, errorMsg);
		// 	// }
		// })
		// .catch(error => {
		// 	updateMsg(popupContainer, 'Ошибка обработки запроса к базе данных');
		// 	console.error('Ошибка отправки формы:', error);
		// });
	});
}

/* PAGE GUIDE *********************/
function screensClassUpload(curLevIndex) {
	const curLevel = document.querySelectorAll('#lev-wrap .level')[curLevIndex];
	if (!curLevel) return;

	const scrWrap = curLevel.querySelector('.scr-wrap');
	scrWrap.querySelectorAll('.screen').forEach((screen, index) => {
		screen.className = index === 0 ? 'screen current' : 'screen queue';
	});

	if (!scrWrap.classList.contains('full')) updateScroll(0, scrWrap);
}
function stopGuide() {
	if (IS_GUIDE_ACT) {
		guideMainBtn.innerHTML = 'Guide &nbsp;&#9658;'; // pause character
		IS_GUIDE_ACT = false;
	}
}
function guidePopupHandler(btn, pageStructure) {
	const curLevObj = getCurLevObj(pageStructure);
	const scrCount = curLevObj.screens.length;
	const curScrIndex = parseInt(curLevObj.activeScreen || 0);

	if (scrCount > 1 && curScrIndex < scrCount - 1) {
		scrNavHandler(curLevObj, curScrIndex + 1, pageStructure);
	} else {
		const curLevIndex = parseInt(pageStructure.activeLevel || 0);
		const levCount = pageStructure.levels.length;

		curLevObj.activeScreen = 0;
		setTimeout(() => { screensClassUpload(curLevIndex) }, 1000);

		if (curLevIndex != (levCount - 1)) {
			levNavHandler(curLevIndex, curLevIndex + 1, pageStructure);
		} else {
			btn.innerHTML = 'Guide &nbsp;&#9658;';
			IS_GUIDE_ACT = false;
			//pageStructure.activeLevel 
			levNavHandler(curLevIndex, 0, pageStructure);
		}
	}

	setTimeout(() => {
		if (!IS_GUIDE_ACT) return;
		guidePopupHandler(btn, pageStructure);
	}, 2000);
}

// Analyse popup open handler
function menuAnalysePopupOpenHandler() {
	menuPopupWrap.classList.remove('show');
	popupList.querySelector('#cookie-settings-popup-wrap')?.classList.add('show');
}
function footerAnalysePopupOpenHandler() {
	stopGuide();
	popupList.querySelector('.popup-contr.show')?.classList.remove('show');
	popupList.querySelector('#cookie-settings-popup-wrap')?.classList.add('show');
}

function isPortraitOrient() {
	return window.innerHeight > window.innerWidth;
}

// телефон в портретной ориентации (< 700px)
function isPhonePortrait() {
    return window.innerWidth < 700 && window.matchMedia('(orientation: portrait)').matches;
}

// планшет в портретной ориентации (700-1366px, touch-устройство)
function isTabletPortrait() {
    return window.innerWidth >= 700
        && window.innerWidth <= 1366
        && window.matchMedia('(orientation: portrait)').matches
        && window.matchMedia('(hover: none) and (pointer: coarse)').matches;
}

document.addEventListener('DOMContentLoaded', function() {

	pageBg = document.getElementById('page-bg');

	// console.log(window.innerWidth, window.devicePixelRatio);
	//////////////////////////////////////////////////////////////////////////////////////
	headerWrap = document.getElementById('header-wrap');
	
	preloader = document.getElementById('preloader');

	navTopList = document.getElementById('nav-top-list');
	menuSecLink = document.getElementById('menu-sec-link');

	toggleWrap = document.getElementById('toggle-wrap');
	menuToggle = document.getElementById('menu-toggle');
	menuPopupWrap = document.getElementById('menu-popup-wrap');

	popupList = document.getElementById('popup-list');
	feedbackForm = popupList.querySelector('#feedback-form');
	commentForm = popupList.querySelector('#comment-form');

	// actionContr = document.getElementById('action-contr');
	phoneWrap = document.getElementById('phone-wrap');
	ratingContainer = document.getElementById('page-rating-container');
	
	benefitsWrap = document.getElementById('benefits-wrap');

	guideMainBtn = document.getElementById('guide-main-btn');
	
	secScrNavBtnPrev = document.getElementById("sec-scr-nav-btn-prev");
    secScrNavBtnNext = document.getElementById('sec-scr-nav-btn-next');
	
	arrowL = document.getElementById('arrow-L');
	arrowR = document.getElementById('arrow-R');

	navLevWrap = document.getElementById('navLevWrap');
	navScrWrap = document.getElementById('navScrWrap');

	navFaqBtn = document.getElementById("nav-faq-btn");
	loadMoreFaqBtn = document.getElementById("load-more-faq-btn");
    faqContainer = document.getElementById("faq-container");
    faqPopup = document.getElementById('faq-popup-wrap');

	manageAnalysisBtn = document.getElementById('manage-analysis');
		
	// первый запуск create page background ////////////////////////////////////////////////////////////////////////////
	//console.log('canvasType:', pageStructure.canvasType);
	createMainBG(pageStructure);

	// прикручиваем слушателей к SCREENS
	const screens = document.querySelectorAll('.screen');
	screens.forEach((screen) => { screen.addEventListener("click", screenHandler) });

	///////////////////////////////////////////////////////////////////
	menuToggle.addEventListener('click', function(e) {
		e.stopPropagation();

		popupCloseOpenHandler(this, menuPopupWrap, popupList);
		this.classList.toggle('checked');
	});

	guideMainBtn.addEventListener('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		//stopGuide();

		if (!IS_GUIDE_ACT) {
			this.innerHTML = 'Guide &#10074;&#10074;'; // play character
			IS_GUIDE_ACT = true;
			setTimeout(() => { guidePopupHandler(this, pageStructure) }, 400);
		} else {
			this.innerHTML = 'Guide &nbsp;&#9658;'; // pause character
			IS_GUIDE_ACT = false;
		}
	});

	document.getElementById('currentYear-menu').innerHTML = new Date().getFullYear();
	document.getElementById('currentYear').innerHTML = new Date().getFullYear();

	// Добавление обработчика для события прокрутки колеса мыши
	document.addEventListener("wheel", wheely);

	// Добавление обработчика для событий клавиатуры
	document.addEventListener("keydown", hotkeys);

	// Добавление обработчиков для начала перетаскивания
	// Отдельно для сенсорных устройств и для мыши
	document.addEventListener("touchstart", dragStart);
	document.addEventListener("mousedown", dragStart);

	// Добавление обработчиков для окончания перетаскивания
	// Также отдельно для сенсорных устройств и для мыши
	document.addEventListener("touchend", dragEnd);
	document.addEventListener("mouseup", dragEnd);

	// функция установки слушателя навигации по странице
	setupNavEventListeners();

	// функция установки слушателя по работе с видео и картинками
    setupDataEventListeners();
});