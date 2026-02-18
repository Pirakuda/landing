/*
messanger option
*/

function asOpenOpenHandle(asMainWrap, msg, closeMsgHandle) {

	const asMsgWrap = asMainWrap.children[0];

	const updateMsg = delayedAction(() => {
		asMsgWrap.querySelector('p').innerHTML = msg;
		asMsgWrap.classList.add('show');
		closeMsgHandle(asMsgWrap);
	}, 1);

	// убираем панель
	asMsgWrap.classList.remove('show');

	// функция с задержкой
	updateMsg();
}

// работа по контроллеру, перегрузка сообщения
function updateAsMsg(asMainWrap, msg) {
	const asMsgWrap = asMainWrap.children[0];

	// функция закрытия панели с задержкой
	const closeMsgHandle = delayedAction((wrap) => { wrap.classList.remove('show') }, 6000);

	if (asMsgWrap.classList.contains('show')) {
		// панель откыта
		asOpenOpenHandle(asMainWrap, msg, closeMsgHandle);
	} else {
		// панель закрыта
		asMsgWrap.children[0].innerHTML = msg;
		asMsgWrap.classList.add('show');
		closeMsgHandle(asMsgWrap);
	}
}

// Функция для установки слушателя событий
function setupMsgEventListeners() {

	asMainWrap.addEventListener('click', function (e) {
		e.stopPropagation();
		const btn = e.target;
	
		if (btn.nodeName === 'BUTTON') {
			const btnId = btn.id;
			let preference;
	
			switch (btnId) {
				case 'cookie-cancel-btn': // Отказаться от всех cookies
					preference = {
						necessary: true,
						functional: false,
						analytical: false,
						marketing: false,
					};
					setPreference('cookieConsent', preference);
					break;
				case 'cookie-ok-btn': // Принять все cookies
					preference = {
						necessary: true,
						functional: true,
						analytical: true,
						marketing: true,
					};
					setPreference('cookieConsent', preference);
					break;
				case 'cookie-customize-btn': // Переход в настройки
					asMainWrap.querySelector('#as-cookie-wrap').classList.remove('show');
					asMainWrap.querySelector('#as-cookie-settings-wrap').classList.add('show');
					return;
				case 'cookie-settings-save': // Сохранить пользовательские настройки
					const functional = asMainWrap.querySelector('#functional-checkbox').checked;
					const analytical = asMainWrap.querySelector('#analytical-checkbox').checked;
					const marketing = asMainWrap.querySelector('#marketing-checkbox').checked;
	
					preference = {
						necessary: true, // Обязательные cookies всегда активны
						functional,
						analytical,
						marketing,
					};
					// Сохраняем предпочтения в localStorage
					setPreference('cookieConsent', preference);
					// Применяем настройки
    				applyPreferences(preference);
					break;
				default:
					break;
			}
	
			if (preference) {
				applyPreferences(preference); // Применяем настройки
			}
	
			btn.closest('.as-msg-wrap').classList.remove('show'); // Закрываем баннер
		}
	});
}
/* 621 - 414*/