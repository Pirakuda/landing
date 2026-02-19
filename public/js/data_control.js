function callManPanel() {
    const manToggle = document.getElementById('man-toggle');
	popupCloseOpenHandler('man', manToggle);
	manToggle.classList.toggle('checked');
}

function createVideo(isLastElem, dataObj, preloader) {

	const video = document.createElement('video');
    video.className = 'video-data';
    video.controls = false;
    video.autoplay = true;
    video.loop = false; // Убираем loop, чтобы была возможность автопрокрутки
    video.type = 'video/mp4';
    video.draggable = false;

    const onload = () => {
        if (isLastElem) preloader.classList.add('hid');
        video.oncanplaythrough = null;
        video.onerror = null;
    };

    video.oncanplaythrough = onload;
    video.onerror = onload;

    // Автопрокрутка
    video.onended = () => {
        // Переключаемся на следующее видео, если isLastElem = false
        if (!isLastElem) {
            const nextVideoEvent = new CustomEvent('nextVideo');
            video.dispatchEvent(nextVideoEvent);
        } else {
            video.currentTime = 0; // Повтор текущего видео, если это последний элемент
            video.play();
        }
    };

    const source = document.createElement('source');
    source.type = 'video/mp4'; // mimeType
    source.src = `${BASE_URL}/public/store/${dataObj.path}`;
    video.appendChild(source);

    return video;
}

// function createImg(isLastElem, dataObj, preloader) {
// 	const elem = document.createElement('img');
// 	elem.className = 'data';
//     elem.alt = dataObj.name || 'Изображение';
//     elem.draggable = false;
//     elem.style.width = "100%";
//     elem.style.height = "100%";

//     const onLoad = () => {
//         if (isLastElem) preloader.classList.add('hid');
//         elem.onload = null;
//         elem.onerror = null;
//     };

//     elem.onload = onLoad;
//     elem.onerror = onLoad;

//     elem.src = `./public/store/${dataObj.path || null}`;
// 	return elem;
// }

// создание медиа элемента
// используется при динамическом создании уровня nextLevel
// при перегрузке страниц
// function createMainMedias(levIndex, preloader, pageStructure) {
//     preloader.classList.remove('hid');

// 	const scrWrap = document.getElementById('lev-wrap').querySelector(`section[data-index='${levIndex}']`).children[1];
//     const levObj = pageStructure.levels[levIndex];
//     const scrCount = (levObj.screens.length - 1);
    
//     for (let i = 0; i <= scrCount; i++) {
//         const scrObj = levObj.screens[i];
//         const dataId = scrObj.dataIds[0];
//         const dataWrap = scrWrap.children[i].children[0].children[0];
        
//         if (dataId) {
//             const manager = pageStructure[dataId];
//             if (manager && manager.path) {
//                 const data = manager.type === 'image' ? createImg(i === scrCount, manager, preloader) : createVideo(i === scrCount, manager, preloader);
//                 dataWrap.appendChild(data);
//             }
//         } else {
//             // dataWrap.innerHTML = emptyHtmlData();
//             preloader.classList.add('hid');
//         }
//     }
// }

/* galery slider handle */
// оработка клика мыши по стрелкам в широком формате
function updateSliderArrows(sliderList, sliderWrap, direction, scrollAmount) {
    const scrollLeftBtn = sliderWrap.children[0];
    const scrollRightBtn = sliderWrap.children[3];

    const scrollLeft = sliderList.scrollLeft;
    const scrollWidth = sliderList.scrollWidth;
    const clientWidth = sliderList.clientWidth;

    if (direction === 1) {
        if (scrollLeft === 0) scrollLeftBtn.classList.remove('hid');
        //if (scrollLeft * 2 + scrollAmount >= scrollWidth) scrollRightBtn.classList.add('hid');
        scrollRightBtn.classList.add('hid');
    } else {
        if (scrollLeft <= clientWidth) scrollLeftBtn.classList.add('hid');
        if (scrollLeft + clientWidth === scrollWidth) scrollRightBtn.classList.remove('hid');
    }
}

// оработка клика мыши по стрелкам в узком формате
function updateSliderArrowsAndImg(sliderWrap, sliderList, direction, figcaptions, pageStructure) {
    const scrollLeftBtn = sliderWrap.children[0];
    const scrollRightBtn = sliderWrap.children[3];
    const counterWrap = sliderWrap.children[2];

    const slideCount = parseInt(counterWrap.children[2].innerHTML || 1);
    const curIndexWrap = counterWrap.children[0];
    const curIndex = parseInt(curIndexWrap.innerHTML || 1);
    let nextIndex = direction === 1 ? curIndex + 1 : curIndex - 1;
    curIndexWrap.innerHTML = nextIndex;

    if (direction === 1) {
        if (nextIndex === 2) scrollLeftBtn.classList.remove('hid');
        if (nextIndex === slideCount) scrollRightBtn.classList.add('hid');
    } else {
        if (nextIndex === 1) scrollLeftBtn.classList.add('hid');
        if (curIndex === slideCount) scrollRightBtn.classList.remove('hid');
    }

    // переопределяем активную миниатюру в слайдере
    sliderList.querySelector('.cur').classList.remove('cur');
    const nextElemWrap = sliderList.children[nextIndex - 1];
    nextElemWrap.classList.add('cur');

    // получаем и передаем картинку на большой экран
    createMainData(nextElemWrap, pageStructure);

    // console.log('figcaption', figcaptions.length)

    // обновляем figcaption
    if (figcaptions.length > 0) {
        const figcaption = sliderWrap.nextElementSibling;
        // console.log("nextIndex",nextIndex)
        if (figcaption) {
            const text = figcaptions[nextIndex - 1];
            if (text) figcaption.innerHTML = text;
        }
    }
}

// распределитель-контроллер стрелок для широкого и свернутого экрана
function sliderArrowsHandler(btn, direction, pageStructure) {
    const sliderWrap = btn.parentElement;
    const sliderList = sliderWrap.children[1].children[0];
    const scrWrap = sliderWrap.closest('.scr-wrap');

    const textId = getCurScrObj(pageStructure)?.['textId'];
    const textObj = pageStructure[textId] || {};
    const figcaptions = textObj.figcaptions || [];

    //console.log('textId', textId)

    if (isPortraitOrient()) {
        // оработка клика мыши по стрелкам для мобильного устройства
        updateSliderArrowsAndImg(sliderWrap, sliderList, direction, figcaptions, pageStructure);
    } else {
        if (scrWrap.classList.contains('full')) {
            // оработка клика мыши по стрелкам в широком формате
            const scrollAmount = sliderList.clientWidth; // /4
            sliderList.scrollBy({
                left: direction * scrollAmount,
                behavior: 'smooth'
            });
            
            updateSliderArrows(sliderList, sliderWrap, direction, scrollAmount);
        } else {
            // оработка клика мыши по стрелкам в узком формате
            updateSliderArrowsAndImg(sliderWrap, sliderList, direction, figcaptions, pageStructure);
        }
    }
}

// создание большого медиаэлемента при клике по миниатюре или по стрелке в слайдере
function createMainData(elemWrap, pageStructure) {
    const elemId = elemWrap.getAttribute('id');
    const manager = pageStructure[elemId];
    if (!manager) return;

    const figure = elemWrap.closest('.slide-img');
    let data = figure.querySelector('.data');

    if (manager.type !== 'image') {
        if (data.nodeName !== 'VIDEO') {
            // dataWrap.replaceChild(createVideo(true, manager, preloader), data);
        } else {
            const path = `${BASE_URL}/public/store/${manager.path}`;
            data.children[0].setAttribute('src', path);
        }
    } else {
        if (data.nodeName !== 'IMG') {
            // dataWrap.replaceChild(createImg(true, manager, preloader), data);
        } else {
            const baseUrl = `${BASE_URL}/public/store/`;
            const source = figure.querySelector('source');
            
            // Обновляем source для landscape ориентации
            if (source && manager.path) {
                source.setAttribute('srcset', `${baseUrl}${manager.path}`);
            }
            
            // Обновляем img (fallback) для portrait ориентации
            if (data && manager.m_path) {
                data.setAttribute('src', `${baseUrl}${manager.m_path}`);
            }
        }
    }
}

// обработка клика по картинке в ленте слайдера
function sliderImgHandler(elem, pageStructure) {
    const elemWrap = elem.parentElement;
    createMainData(elemWrap, pageStructure);

    // переопределяем активную миниатюру
    const sliderList = elemWrap.parentElement;
    sliderList.querySelector('.cur').classList.remove('cur');
    elemWrap.classList.add('cur');
    
    // передаем в счетчик актуальное значение изображения
    const elemIndex = parseInt(elemWrap.getAttribute('data-index') || 0);
    sliderList.parentElement.nextElementSibling.children[0].innerHTML = (elemIndex + 1);
}

// определение состояния стрелок при переключении режимов
function updateSliderScroll(scrIndex, scrWrap) {
    const screen = scrWrap.children[scrIndex];
    const sliderWrap = screen.children[0].children[1];

    // если слайдер есть, определяем его состояние
    if (sliderWrap.classList.contains('figure-slider-wrap')) {
        const scrollLeftBtn = sliderWrap.children[0];
        const scrollRightBtn = sliderWrap.children[3];
        const counterWrap = sliderWrap.children[2];

        const slideCount = parseInt(counterWrap.children[2].innerHTML || 1);
        const curIndexWrap = counterWrap.children[0];
        const curIndex = parseInt(curIndexWrap.innerHTML || 1);
        
        if (!scrWrap.classList.contains('full')) {
            // переход в узкий экран
            if (curIndex === 1) {
                scrollLeftBtn.classList.add('hid');
                scrollRightBtn.classList.remove('hid');
            } else {
                scrollLeftBtn.classList.remove('hid');
                scrollRightBtn.classList.toggle('hid', curIndex === slideCount);
            }
        } else {
            // переход в широкий экран
            if (slideCount !== 4) {
                const sliderList = sliderWrap.children[1].children[0];

                sliderList.scrollTo({
	            left: sliderList.clientWidth / 4 * (curIndex - 1),
                behavior: 'smooth'
                });

                scrollLeftBtn.classList.toggle('hid', curIndex === 1);
                scrollRightBtn.classList.toggle('hid', curIndex + 4 >= slideCount);
            
            } else {
                scrollLeftBtn.classList.add('hid');
                scrollRightBtn.classList.add('hid');
            }
        }
    }
}

/* video controlls *********************************************************************/
function videoContrOn(figure) {

    const video = figure.querySelector('VIDEO');
    const play = figure.classList.contains('play');

    // Проверяем, произошло ли уже событие loadedmetadata
    if (video.readyState >= 1) handleLoadedMetadata();

    // Добавляем слушатели событий
    video.addEventListener("timeupdate", handleTimeUpdate);
    video.addEventListener("loadedmetadata", handleLoadedMetadata);
    
    document.getElementById('video-play-btn').innerHTML = (play) ? '&#10074;&#10074;' : '&nbsp;&#9658;';

    // Создаем функцию с задержкой 0.8 секунд
    const delayedFunction = delayedAction(() => {
        document.getElementById('video-contr').classList.remove('hid');
		if (play) video.play();
    }, 1);
        
    // Вызываем функцию с задержкой
    delayedFunction();
}

function videoContrOut(figure) {
    document.getElementById('video-contr').classList.add('hid');
    const video = figure.querySelector('VIDEO');
    
    if (video) {
        video.pause();

        // Удаляем слушатели событий
        video.removeEventListener("timeupdate", handleTimeUpdate);
        video.removeEventListener("loadedmetadata", handleLoadedMetadata);
    }
}

// Функция для установки слушателя событий
function setupDataEventListeners() {

    // Обработчик события для изменения положения на seekbar
    // videoSeekbar.addEventListener("input", function() {
    //     const figure = getFigure();
    //     const video = figure.children[0];

    //     var value = videoSeekbar.value * video.duration / 100;
    //     video.currentTime = value;

    //     const videoCurTime = document.getElementById('video-curTime');
    //     videoCurTime.textContent = formatTime(value);
    // });

    // // Обработчик события для кнопки Play/Pause
    // videoPlayBtn.addEventListener("click", function() {
    //     const figure = getFigure();
    //     const video = figure.children[0];

    //     if (figure.classList.contains('play')) {
    //         this.innerHTML = '&nbsp;&#9658;'; // play character
    //         video.pause();
    //         figure.classList.remove('play');
    //     } else {
    //         this.innerHTML = '&#10074;&#10074;'; // pause character
    //         video.play();
    //         figure.classList.add('play');
    //     }
    // });


    // cardPlayBtn.addEventListener('click', function(e) {
    //     e.stopPropagation();	
    //     playPauseHandler(this);
    // });


    // cardPrevBtn.addEventListener('click', function(e) {
    //     e.stopPropagation();	
    //     prevSlideHandler();
    //     prevCardChange();
    // });


    // cardNextBtn.addEventListener('click', function(e) {
    //     e.stopPropagation();
    //     nextSlideHandler();
    //     nextCardChange();
    // });
}
/* 394 - 361 - 338*/