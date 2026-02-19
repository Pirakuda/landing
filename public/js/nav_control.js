let metaUpdatePending = false;

function getCurLevObj(pageStructure) {
	const activeLevel = parseInt(pageStructure.activeLevel || 0);
    return pageStructure.levels[activeLevel];
}

function returnNavBlock(btnType) {
	switch (btnType) {
        case 'v': return document.getElementById("navLevWrap").children[0];
        case 'h': return document.getElementById("navScrWrap").children[0];
        case 't': return document.getElementById("nav-top-list");
        default: return null; // Вместо пустого break, явно возвращаем null.
    }
}

function getLevName(levelIndex, pageStructure) {
	const level = pageStructure.levels[levelIndex];
	const name = level?.name || 'Ebene';
  	return name;
}

function сreateNavBtn(btnType, index, actNum, i, pageStructure) {

	const content = btnType !== 't' ? '' : getLevName(index, pageStructure);
    const isActive = actNum === i ? 'location' : 'false';
    const wrapClass = `${btnType !== 't' ? '' : 'link'} ${actNum === i ? 'cur' : ''}`;
    const linkClass = btnType !== 't' ? 'act-anchor-btn' : 'act-anchor';

	return `<li class="act-elem ${wrapClass}">
				<a data-index="${index}" class="${linkClass}" href="#screen${index} aria-current="${isActive}">${content}</a>
			</li>`;
}

function сreateNav(btnType, pageStructure) {
	const dotsTrack = returnNavBlock(btnType);
	dotsTrack.innerHTML = '';

	const curLevIndex = parseInt(pageStructure.activeLevel);
	let totalElems, totalNavElems, curIndex, isValid = true;

	if (btnType !== 'h') {
		totalElems = pageStructure.levels.length;
		curIndex = curLevIndex;
	} else {
		const activeLevel = pageStructure.levels[curLevIndex] || 0;
		totalElems = activeLevel.screens.length;
		curIndex = Number(activeLevel.activeScreen || 0);
		totalNavElems = totalElems > 4 ? 4 : totalElems;
		isValid = totalElems > 1;
	}

	if (isValid) {
		const dotsWidth = (40*totalNavElems - 20) + "px";
		dotsTrack.parentElement.style.width = dotsWidth;

		for (let i = 0; i < totalElems; i++) {
			dotsTrack.insertAdjacentHTML('beforeend', сreateNavBtn(btnType, i, curIndex, i, pageStructure));
		}
		updateDotsPosition(btnType, curIndex, totalElems);
	}
}

function updateDotsPosition(btnType, curIndex, totalElems) {
	const dotsTrack = returnNavBlock(btnType);
	const maxVisibleDots = btnType === 't' ? totalElems : 4;

	const offset = Math.min(
		Math.max(curIndex - Math.floor(maxVisibleDots / 2), 0),
		totalElems - maxVisibleDots
	);

	if (btnType !== 't') {
		dotsTrack.style.transform = btnType === 'h' ? `translateX(-${offset * 40}px)` : `translateY(-${offset * 40}px)`; // 40px
		updateDotVisibility(offset, dotsTrack, maxVisibleDots);
	}

	dotsTrack.querySelectorAll('ul > li').forEach((dotWrap, index) => {
		const isActive = index === curIndex;
		dotWrap.classList.toggle('cur', isActive);
	});
}

// определяем видимость точек
function updateDotVisibility(offset, dotsTrack, maxVisibleDots) {
	dotsTrack.querySelectorAll('LI').forEach((dotWrap, index) => {
		const isVisible = index >= offset && index < offset + maxVisibleDots;
		dotWrap.classList.toggle('hid', !isVisible);
	});
}
// определяем активного элемент
function updateActiveDot(curIndex, dotsTrack) {
	dotsTrack.querySelectorAll('#nav-top-list > li').forEach((dotWrap, index) => {
		const isActive = index === curIndex;
		dotWrap.classList.toggle('cur', isActive);
		dotWrap.children[0].setAttribute('aria-current', isActive ? 'location' : 'false');
	});
}

function delayedAction(callback, delay = 800) {
    let timerId;

    return function (...args) {
        clearTimeout(timerId); // Сброс предыдущего таймера

        timerId = setTimeout(() => {
            callback.apply(this, arguments);
        }, delay);
    };
}

function arrowHandle(pageStructure) {
    const curLevIndex = parseInt(pageStructure.activeLevel);
    const scrCount = pageStructure.levels[curLevIndex].screens.length;
    const shouldShowArrows = scrCount !== 1;
    arrowL.parentElement.classList.toggle('hid', !shouldShowArrows);
    arrowR.parentElement.classList.toggle('hid', !shouldShowArrows);

	const dotsTrack = returnNavBlock('h');
	const dotsTrackWrap = dotsTrack.parentElement;
	const prevSecBtn = dotsTrackWrap.previousElementSibling;
	const nextSecBtn = dotsTrackWrap.nextElementSibling;
	prevSecBtn.classList.toggle('hid', !shouldShowArrows);
    nextSecBtn.classList.toggle('hid', !shouldShowArrows);
}

function showHidRating(pageStructure) {
	const rating = getCurScrObj(pageStructure).rating;
	ratingContainer.classList.toggle('show', Boolean(rating));
}

function lastLevAct(pageStructure) {
	//if (!actionContr.querySelector('.popup-action.show')) actionContr.classList.remove('show');
	const scrNavWrap = document.getElementById('navScrWrap').parentElement;
	scrNavWrap.classList.add('hid');
	setTimeout(() => {scrNavWrap.children[0].children[0].style.transform = '';}, 400);

	// Создаем функцию с задержкой 0.8 секунд
	const delayedFunction = delayedAction(() => {
		arrowHandle(pageStructure);
		showHidRating(pageStructure);
		
		//actionPopupHandler(pageStructure);
		сreateNav('h', pageStructure);
		scrNavWrap.classList.remove('hid');
	}, 800);
		
	// Вызываем функцию с задержкой
	delayedFunction();
}

async function nextLevel(curLevNum, nextLevNum, pageStructure) {
	
	const levelWrap = document.getElementById('lev-wrap');
	levelWrap.querySelectorAll('.level').forEach(function(level) {
		const dataIndex = parseInt(level.getAttribute('data-index'));
		level.className = nextLevNum > dataIndex ? 'level prev' : 'level queue';
	});

	let nextLev = levelWrap.querySelector(`section[data-index='${nextLevNum}']`);
	
	if (nextLev === null) {
		const preloader = document.getElementById('preloader');
		preloader.classList.remove('hid');

		const nextLevClass = nextLevNum > curLevNum ? 'level queue' : 'level prev';
		nextLev = await createResolveLev(nextLevNum, nextLevClass, pageStructure);
        levelWrap.appendChild(nextLev);

		// прикручиваем слушателей к SCREENS
		const screens = nextLev.querySelectorAll('.screen');
		screens.forEach((screen) => { screen.addEventListener("click", screenHandler) });

		// createMainMedias(nextLevNum, preloader, pageStructure);
	}

	setTimeout(() => { nextLev.className = 'level current' }, 100);
}

function levNavHandler(curLevIndex, newLevNum, pageStructure) {
	pageStructure.activeLevel = newLevNum;
	const levCount = pageStructure.levels.length;
	const elem = returnNavBlock('t');
    Promise.all([
        nextLevel(curLevIndex, newLevNum, pageStructure),
		Promise.resolve().then(() => updateActiveDot(newLevNum, elem)),
        Promise.resolve().then(() => updateDotsPosition('v', newLevNum, levCount)),
        Promise.resolve().then(() => queueUpdateScreenMeta(true, pageStructure))
    ]).then(() => {
        lastLevAct(pageStructure);
    });
}

function topLevelContr(e, pageStructure) {
	const curLevIndex = parseInt(pageStructure.activeLevel);
	const target = e.target;

	if (target.closest('.popup-contr, .legal-main-wrap, .menu-toggle, .menu-sec-link')) return;

	if (curLevIndex !== 0) {
		const newLevIndex = (curLevIndex - 1);
		levNavHandler(curLevIndex, newLevIndex, pageStructure);
		const scrIndex = parseInt(pageStructure.levels[newLevIndex].activeScreen ?? 0)
		updateMenuActItem(newLevIndex, scrIndex);
	} else {
		const curLevel = document.querySelector('#lev-wrap .level.current');
		if (curLevel) {
			curLevel.classList.add('top-bounce');
			setTimeout(()=> { curLevel.classList.remove('top-bounce') }, 300);
		}
	}
}

function bottomLevelContr(e, pageStructure) {
	const curLevIndex = parseInt(pageStructure.activeLevel);
	const levCount = pageStructure.levels.length;
	const target = e.target;

	if (target.closest('.popup-contr, .legal-main-wrap, .menu-toggle, .menu-sec-link')) return;
				
	if (curLevIndex != (levCount - 1)) {
		let newLevIndex = (curLevIndex + 1);
		levNavHandler(curLevIndex, newLevIndex, pageStructure);
		const scrIndex = parseInt(pageStructure.levels[newLevIndex].activeScreen ?? 0)
		updateMenuActItem(newLevIndex, scrIndex);
	} else {
		const curLevel = document.querySelector('#lev-wrap .level.current');
		if (curLevel) {
			curLevel.classList.add('bottom-bounce');
			setTimeout(()=> { curLevel.classList.remove('bottom-bounce') }, 300);
		}
	}
}

function wheelyHandler(e) {
	let y = e.deltaY;
    let timeStop = new Date().getTime();
    let timeDiff = timeStop - timeStart;
	
    if (timeDiff > 200) {
        if (y > 0) {
            bottomLevelContr(e, pageStructure);
        } else {
            topLevelContr(e, pageStructure);
        }
    }
    timeStart = timeStop;
}

function wheely(e) {
	const target = e.target;
	stopGuide();
	if (target.closest('.text-main-wrap.show, .popup-contr, .legal-main-wrap, .menu-toggle, .menu-sec-link')) return;

	const elem = target.offsetParent;
	if (elem && (!elem.classList.contains('text-wrap-wrap') || !elem.parentNode.classList.contains('show'))) {
		wheelyHandler(e, pageStructure);
	}
}

function hotkeys(e) {
	stopGuide();

	switch (e.key) {
		case 'Enter':
			// if (e.target.classList.contains('man-title')) {
			// 	e.preventDefault();
            //     // переводим курсор на text
            //     createEndCursor(target.nextElementSibling);
			// } else if (e.target.closest('.page-name-wrap')) {
			// 	e.preventDefault();
			// } else if (e.target.closest('.nav-box')) {
			// 	e.preventDefault();
			// }
			break;
		case 'ArrowLeft':
			leftScreenContr(e, pageStructure);
			break;
		case 'ArrowUp':
			topLevelContr(e, pageStructure);
			break;
		case 'ArrowRight':
			rightScreenContr(e, pageStructure);
			break;
		case 'ArrowDown':
			bottomLevelContr(e, pageStructure);
			break;
		case 'Escape':
			popupList.querySelector('.popup-contr.show')?.classList.remove('show');
			break;
		default:
			break;
	}
}

function createEmptyLevelObj() {
    return {
        activeScreen: 0,
        screens: []
    };
}

function createEmptyScreenObj() {
    return {
        dataType: "view",
        dataIds: [],
        textId: ""
    };
}

async function nextScreen(newScrNum) {
	const scrWrap = document.querySelector('.level.current .scr-wrap');
	if (!scrWrap) return;

	scrWrap.querySelectorAll('.screen').forEach((screen) => {
		const index = parseInt(screen.getAttribute('data-index'));
		screen.className = newScrNum > index ? 'screen prev' : 'screen queue';
	});

	setTimeout(() => {
		showHidRating(pageStructure);

		const nextScr = scrWrap.children[newScrNum];
		nextScr.className = 'screen current';
		if (!scrWrap.classList.contains('full')) updateScroll(newScrNum, scrWrap);
	}, 100);
}

function queueUpdateScreenMeta(isLevAct, pageStructure) {
    if (metaUpdatePending) return;

    metaUpdatePending = true;

    requestIdleCallback?.(() => {
        updateScreenMeta(isLevAct, pageStructure);
        metaUpdatePending = false;
    }) || setTimeout(() => {
        updateScreenMeta(isLevAct, pageStructure);
        metaUpdatePending = false;
    }, 100);
}

function updateScreenMeta(isLevAct, pageStructure) {
	if (typeof window.history.replaceState !== 'function') return;

	const activeLevel = parseInt(pageStructure.activeLevel || 0);
	const levObj = pageStructure.levels[activeLevel];
	if (!levObj) return;

	// Вспомогательная функция обновления URL и META
	function setMeta(title, slug, description) {
		const baseUrl = `${BASE_URL}/${slug}`;

		console.log("result: ", baseUrl)
	
		window.history.replaceState({}, title, baseUrl);
		// window.history.pushState({}, title, baseUrl);

		document.title = title;
		const metaDescription = document.querySelector('meta[name="description"]');
		if (metaDescription) {
			metaDescription.setAttribute('content', description ?? '');
		}
	}

	// Обновление по уровню (если scrFull выключен)
	if (!levObj.scrFull) {
		if (!isLevAct) return;
		const levSlug = levObj.slug;
		const title = levObj.title ?? '';
		const desc = levObj.meta_title ?? '';
		setMeta(title, levSlug, desc);
		return;
	}

	// Обновление по активному экрану
	const actScr = parseInt(levObj.activeScreen || 0);
	const scrObj = levObj.screens[actScr];
	if (!scrObj) return;

	const scrSlug = scrObj.slug;
	const textObj = pageStructure[scrObj.textId] || {};
	const title = textObj.page_title ?? '';
	const desc = textObj.meta_title ?? '';
	setMeta(title, scrSlug, desc);
}

function updateMenuActItem(levIndex, scrIndex) {
	// снимаем активность с итема
	const item = navTopList.querySelector('.submenu > .cur');
	if (item) {
		item.classList.remove('cur');
		item.children[0].setAttribute('aria-current', 'false');
	}

	const curItem = navTopList.children[levIndex]?.children[1]?.children[scrIndex];
	if (curItem) {
		curItem.classList.add('cur');
		curItem.children[0].setAttribute('aria-current', 'location');
	}
}

function scrNavHandler(curLevObj, nextIndex, pageStructure) {
	curLevObj.activeScreen = nextIndex;
	nextScreen(nextIndex).then(() => {
		const curLevIndex = parseInt(pageStructure.activeLevel);
		const activeLevel = pageStructure.levels[curLevIndex] || 0;
		const totalElems = activeLevel.screens.length;
		updateMenuActItem(curLevIndex, nextIndex);
		updateDotsPosition('h', nextIndex, totalElems);
		queueUpdateScreenMeta(false, pageStructure);
	});
}

function rightScreenContr(e, pageStructure) {
	
	const curLevObj = getCurLevObj(pageStructure);
	const scrCount = curLevObj.screens.length;
	const curScrIndex = parseInt(curLevObj.activeScreen || 0);
	const target = e.target;

	if (target.closest('.popup-contr, .legal-main-wrap, .menu-toggle, .menu-sec-link')) return;

	if (curScrIndex !== (scrCount - 1)) {
		const nextIndex = (curScrIndex + 1);
		scrNavHandler(curLevObj, nextIndex, pageStructure);
	} else {
		const curScr = document.querySelector('.level.current .screen.current');
		if (curScr) {
			curScr.classList.add('prev-bounce');
			setTimeout(() => { curScr.classList.remove('prev-bounce') },300);
		}
	}
}

function leftScreenContr(e, pageStructure) {
	const curLevIndex = parseInt(pageStructure.activeLevel || 0);
	const curLevObj = pageStructure.levels[curLevIndex];
	const curScrIndex = parseInt(curLevObj.activeScreen || 0);
	const target = e.target;
	
	if (target.closest('.popup-contr, .legal-main-wrap, .menu-toggle, .menu-sec-link')) return;

	if (curScrIndex !== 0){
		const nextIndex = (curScrIndex - 1);
		scrNavHandler(curLevObj, nextIndex, pageStructure);
	} else {
		const curScr = document.querySelector('.level.current .screen.current');
		if (curScr) {
			curScr.classList.add('queue-bounce');
			setTimeout(() => { curScr.classList.remove('queue-bounce') },300);
		}
	}
}

function updateScroll(scrIndex, scrWrap) {
	scrWrap.scrollTo({
	  left: scrWrap.children[scrIndex].clientWidth * scrIndex,
	  behavior: 'smooth'
	});
}

function menuFeedbackCloseOpenHandler(menuToggle, btn) {
	btn.closest('.popup-contr').classList.remove('show');
	menuToggle.classList.remove('checked');
	document.getElementById('feedback-popup-wrap').classList.add('show');
}

function mobileMenuClose(menuPopupWrap, menuToggle) {
	menuPopupWrap.classList.remove('show');
	menuToggle.classList.remove('checked');
}

// Функция для открытия/закрытия подменю
const toggleSubmenu = (anchor, open) => {
	const parent = anchor.parentElement;
	const submenu = anchor.nextElementSibling;
	if (!submenu) return;

	anchor.setAttribute('aria-expanded', open ? 'true' : 'false');
	parent.classList.toggle('active', open);
	submenu.classList.toggle('show', open);

	if (open) {
		submenu.style.maxHeight = submenu.scrollHeight + "px";
	} else {
		submenu.style.maxHeight = null;
	}
};

// Функция для закрытия всех подменю на одном уровне
const closeSiblingSubmenus = (anchor, levelClass) => {
	if (!levelClass) return;

	const parentLevel = anchor.closest(`.${levelClass}`);
	parentLevel.querySelectorAll(`a.act-anchor[aria-expanded="true"]`).forEach(otherAnchor => {
		if (otherAnchor !== anchor) {
			toggleSubmenu(otherAnchor, false);
		}
	});
};

function escapeHTML(str) {
    return str.replace(/[&<>"']/g, function(match) {
        const escape = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        };
        return escape[match];
    });
}

function loadFAQ(reset = false, faqContainer, loadMoreBtn) {
	let offset = faqContainer.children.length;
	const pageSlug = pageStructure.page_slug;
  
	if (reset) {
	  offset = 0;
	  faqContainer.innerHTML = "";
	}
  
	fetch("./modules/public/get_faq_api.php", {
	  method: "POST",
	  headers: { "Content-Type": "application/json" },
	  body: JSON.stringify({ pageSlug, offset })
	})
	.then(response => response.json())
	.then(data => {
	if (!data.success || !data.faq.length) {
	  if (reset) {
		faqContainer.innerHTML = "<p class='popup-p m-t-20'>FAQ пока нет.</p>";
	  }
	  loadMoreBtn.style.display = "none";
	  return;
	}
  
	const entriesHTML = data.faq.map(faq => {
	  const question = escapeHTML(faq.question);
	  const answer = escapeHTML(faq.answer);
	  return `
		<div class="faq-item popup-p m-t-20" role="listitem">
		  <details>
			<summary><strong>${question}</strong></summary>
			<div class="faq-answer m-t-10">${answer}</div>
		  </details>
		</div>
	  `;
	}).join("");
  
	faqContainer.insertAdjacentHTML("beforeend", entriesHTML);
	loadMoreBtn.style.display = data.hasMore ? "block" : "none";
	})
	.catch(error => {
	console.error("Ошибка загрузки FAQ:", error);
	faqContainer.innerHTML = "<p class='popup-p m-t-20'>Ошибка загрузки FAQ.</p>";
	});
}

function handleInactiveLink(link, pageStructure) {
	const levIndex = parseInt(link.dataset.level ?? 0);
	const curLevIndex = parseInt(pageStructure?.activeLevel ?? 0);
	const scrIndex = parseInt(link.dataset.screen ?? 0);
	const levObj = pageStructure.levels[levIndex];

	if (levIndex !== curLevIndex) {
		// переходим на указанный уровень
		levNavHandler(curLevIndex, levIndex, pageStructure);

		const curScrIndex = levObj.activeScreen;
		if (curScrIndex !== scrIndex) {
			// переходим на указанный экран
			setTimeout(() => { scrNavHandler(levObj, scrIndex, pageStructure) },400);
		} else {
			updateMenuActItem(levIndex, scrIndex);
		}
	} else {
		// переходим на указанный экран
		scrNavHandler(levObj, scrIndex, pageStructure);
	}
}

// Функция для установки слушателя событий
function setupNavEventListeners() {

	const anchor = navTopList.querySelectorAll('a.act-anchor[aria-haspopup="true"]');

	// Обработка наведения (десктоп)
    anchor.forEach(anchor => {
        const parent = anchor.closest('.nav-level-1, .nav-level-2');

        parent.addEventListener('mouseenter', () => {
            if (!isPortraitOrient()) {
                const levelClass = parent.classList.contains('nav-level-1') ? 'nav-level-1' : 'nav-level-2';
                closeSiblingSubmenus(anchor, levelClass);
                toggleSubmenu(anchor, true);
            }
        });

        parent.addEventListener('mouseleave', () => {
            if (!isPortraitOrient()) {
                toggleSubmenu(anchor, false);
            }
        });
    });
	
	// Сброс состояния при ресайзе
	window.addEventListener('resize', () => {
		if (!isMobile() || isPortraitOrient()) {
			anchor.forEach(anchor => {
				toggleSubmenu(anchor, false);
			});
		}
	});

	// Обработка кликов по ссылкам :not([aria-haspopup="true"])
	navTopList.querySelectorAll('a.act-anchor').forEach(link => {
		link.addEventListener('click', async e => {
			e.preventDefault();
			e.stopPropagation();
			const linkWrap = link.parentElement;

			if (!linkWrap.classList.contains('cur')) {
				stopGuide();

				if (!isPortraitOrient()) {
					handleInactiveLink(link, pageStructure);
				} else {
					if (!linkWrap.classList.contains('nav-level-2')) {
						if (!linkWrap.classList.contains('nav-level-1')) {
							// основной итем, переходим в раздел
							const levIndex = parseInt(link.dataset.level ?? 0);
							const curLevIndex = parseInt(pageStructure?.activeLevel ?? 0);
							levNavHandler(curLevIndex, levIndex, pageStructure);
							updateMenuActItem(levIndex, 0);

							// закрываем меню
							mobileMenuClose(menuPopupWrap, menuToggle);
						} else {
							// основной итем, открываем/закрываем подменю
							const isExpanded = link.getAttribute('aria-expanded') === 'true';
							const levelClass = link.closest('.nav-level-1') ? 'nav-level-1' : '';
							closeSiblingSubmenus(link, levelClass);
							toggleSubmenu(link, !isExpanded);
						}
					} else {
						// субменю - итем, переходим в раздел
						handleInactiveLink(link, pageStructure);

						// закрываем меню
						mobileMenuClose(menuPopupWrap, menuToggle);
					}
				}
			} else {
				if (isPortraitOrient()) {
					if (!linkWrap.classList.contains('nav-level-2')) {
						// основной итем, активный, открываем/закрываем подменю
						const isExpanded = link.getAttribute('aria-expanded') === 'true';
						const levelClass = link.closest('.nav-level-1') ? 'nav-level-1' : '';
						closeSiblingSubmenus(link, levelClass);
						toggleSubmenu(link, !isExpanded);
					} else {
						// субменю - активный итем, закрываем меню
						mobileMenuClose(menuPopupWrap, menuToggle);
					}
				}
			}

			return;
		});
	});
		
	navLevWrap.addEventListener('click', function(e) {
		e.preventDefault();
		e.stopPropagation();	
		const target = e.target;
		
		if (target.nodeName === 'A' || target.nodeName === 'LI') {
			stopGuide();
			const anchor = target.nodeName === 'A' ? target : target.children[0];

			if (!anchor.parentElement.classList.contains('cur')) {
				const curLevIndex = parseInt(pageStructure.activeLevel || 0);
				const newLevIndex = parseInt(anchor.getAttribute('data-index'));
				levNavHandler(curLevIndex, newLevIndex, pageStructure);
				const scrIndex = parseInt(pageStructure.levels[newLevIndex].activeScreen ?? 0)
				updateMenuActItem(newLevIndex, scrIndex);
			}
		} else {
			// const btn = target.closest('button');
			// if (btn) {
			// 	btn.classList.toggle('checked');
			// 	const scrWrap = document.querySelector('.level.current .scr-wrap');
			// 	if (!scrWrap) return;
				
			// 	scrWrap.classList.toggle('full');
			// 	const curLevObj = getCurLevObj(pageStructure);

			// 	if (scrWrap.classList.contains('full')) {
			// 		curLevObj.scrFull = 'full';
			// 	} else {
			// 		delete curLevObj.scrFull;
			// 	}

			// 	const scrIndex = parseInt(curLevObj.activeScreen || 0);
			// 	updateSliderScroll(scrIndex, scrWrap);
			// 	updateScroll(scrIndex, scrWrap);
			// }
		}
	});

	navScrWrap.addEventListener('click', function(e) {
		e.preventDefault();
		e.stopPropagation();	
		const target = e.target;

		if (target.nodeName === 'A' || target.nodeName === 'LI') {
			stopGuide();
			const anchor = target.nodeName === 'A' ? target : target.children[0];

			if (!anchor.parentElement.classList.contains('cur')) {
				const curLevObj = getCurLevObj(pageStructure);
				const nextIndex = parseInt(anchor.getAttribute('data-index'));
				scrNavHandler(curLevObj, nextIndex, pageStructure);
			}
		}
	});

	secScrNavBtnPrev.addEventListener('click', function(e) {
		e.preventDefault();
		stopGuide();
		leftScreenContr(e, pageStructure);
	});

	secScrNavBtnNext.addEventListener('click', function(e) {
		e.preventDefault();
		stopGuide();
		rightScreenContr(e, pageStructure);
	});

    arrowL.addEventListener('click', function(e) {
		e.preventDefault();
		stopGuide();
		leftScreenContr(e, pageStructure);
	});

	arrowR.addEventListener('click', function(e) {
		e.preventDefault();
		stopGuide();
		rightScreenContr(e, pageStructure);
	});

	// открытие и загрузка FAQ
	navFaqBtn.addEventListener('click', e => {
		// десктоп - открытие FAQ панели
		const popupClassList = faqPopup.classList;

		if (popupClassList.contains('show')) return;

		if (!popupClassList.contains('loaded')) {
			popupClassList.add('loaded');
			loadFAQ(true, faqContainer, loadMoreFaqBtn);
		}

		if (isPortraitOrient()) {
			menuPopupWrap.classList.remove('show');
			// menuToggle.classList.toggle('checked');
		} else {
			popupCloseHandle(popupList);
		}
		
		popupClassList.add('show');
	});

	// дозагрузка отзывов
    loadMoreFaqBtn.addEventListener("click", () => {
        loadFAQ(false, faqContainer, loadMoreFaqBtn);
    });
}