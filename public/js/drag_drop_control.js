
function dragStartHandler(e) {
    
    if (e.type === "touchstart") {
        // Получаем точку начала касания
        const touch = e.touches[0];
        startPointY = touch.pageY;
        startPointX = touch.pageX;
    } else {
        // Для событий мыши используем свойства события напрямую
        startPointY = e.pageY;
        startPointX = e.pageX;
    }

    dragY = 0;
    dragX = 0;

	document.addEventListener("mousemove", dragMove);
    document.addEventListener("touchmove", dragMove);
}

function dragStart(e) {
    const target = e.target;
    if (target.closest('.popup-contr, .legal-main-wrap, .menu-toggle, .menu-sec-link, .email-icon-wrap')) return;
    const elem = target.offsetParent;
    
    if (elem && (!elem.classList.contains('text-wrap-wrap') &&
        !elem.classList.contains('data-select-contr') && 
        !elem.classList.contains('select-data-elem') && 
        !elem.classList.contains('nav-box-wrap') &&
        !elem.closest('.text-main-wrap')?.classList.contains('show'))) {
            dragStartHandler(e);
        // } else {
            //     if (!elem.parentNode.classList.contains('show')) {
            //         dragStartHandler(e);
                // } else {
                //     console.log('var3 elemClass ' + elem.className)
                //     const textWrap = elem.children[0];
                //     const clientHeight = textWrap.scrollTop + textWrap.clientHeight;
                //     const scrollHeight = textWrap.scrollHeight;
                //     const scrollTop = textWrap.scrollTop;


                //     console.log('scrolTop ' + scrollTop + ' clientHeight ' + clientHeight + ' scrollHeight ' + scrollHeight)

                //     if (scrollTop === 0 || clientHeight >= scrollHeight) {
                //         dragStartHandler(e);
                //     }
                // }
        // }
    }
}

function dragMove(e) {
    if (e.target) {
        let movePointY;
        let movePointX;

        if (e.type === "touchmove") {
            movePointY = e.touches[0].pageY;
            movePointX = e.touches[0].pageX;
        } else {
            movePointY = e.pageY;
            movePointX = e.pageX;
        }

        const levWrap = document.getElementById("lev-wrap");
        dragY = ((movePointY - startPointY) / levWrap.offsetHeight) * 100;
        dragX = ((movePointX - startPointX) / levWrap.offsetWidth) * 100;

        if (Math.abs(dragX) > Math.abs(dragY)) {
            document.getElementById('lev-wrap').classList.add('dragging');
            const scrWrap = document.querySelector('.level.current .scr-wrap');
            
            if (!scrWrap.classList.contains('full') && !IS_MOBILE) {
                // const screens = scrWrap.querySelectorAll('.screen');
                // screens.forEach(screen => { 
                //     screen.style.transform = `translateX(${dragX}px)`;
                //     screen.style.transition = "0ms";
                //     screen.style.opacity = `${1 + dragX / 200}`;
                // });
            } else {
                if (dragX > 0) {
                    prevScreenDrag();
                } else {
                    nextScreenDrag();
                }
            }
        } else {
            if (dragY > 0) {
                prevLevelDrag();
            } else {
                nextLevelDrag();
            }
        }
    }
}

function nextScreenDrag() {
    document.getElementById('lev-wrap').classList.add('dragging');
    const curScreen = document.querySelector('.level.current .screen.current');
    if (!curScreen) return;

    curScreen.style.transition = "0ms";
    curScreen.style.opacity = `${1 - Math.abs(dragX / 200)}`;
    curScreen.style.transform = `translateX(${dragX / 2}%)`;
    
    // let nextScreen = curScreen.nextElementSibling;
    // if (nextScreen !== null) nextScreen.style.transform = `translateX(${100 + dragX}%)`;
}

function prevScreenDrag() {
    document.getElementById('lev-wrap').classList.add('dragging');
    const curScreen = document.querySelector('.level.current .screen.current');
    if (!curScreen) return;
    
    curScreen.style.transition = "0ms";
    curScreen.style.opacity = `${1 - Math.abs(dragX / 200)}`;
    curScreen.style.transform = `translateX(${dragX}%)`;
    
    // const prevScreen = curScreen.previousElementSibling;
    // if (prevScreen) prevScreen.style.transform = `translateX(${(-50 + dragX / 2)}%)`;
}

function nextLevelDrag() {
	document.getElementById('lev-wrap').classList.add('dragging');
	const curLevel = document.querySelector('.level.current');
    if (!curLevel) return;

    curLevel.style.transition = "0ms";
    curLevel.style.opacity = `${1 - Math.abs(dragX / 200)}`;
    curLevel.style.transform = `translateY(${dragY / 2}%)`;
    
    // const nextLevel = curLevel.nextElementSibling;
    // if (nextLevel) nextLevel.style.transform = `translateY(${100 + dragY}%)`;
}

function prevLevelDrag() {
	document.getElementById('lev-wrap').classList.add('dragging');
	const curLevel = document.querySelector('.level.current');
    if (!curLevel) return;

    curLevel.style.transition = "0ms";
    curLevel.style.opacity = `${1 - Math.abs(dragX / 200)}`;
    curLevel.style.transform = `translateY(${dragY}%)`;
    
    // const prevLevel = curLevel.previousElementSibling;
    // if (prevLevel) prevLevel.style.transform = `translateY(${(-50 + dragY / 2)}%)`;
}

function remFullStyle() {
    document.querySelectorAll('.level-wrap .level').forEach(level => {
        level.removeAttribute('style');
        level.querySelectorAll('.screen').forEach(screen => {screen.removeAttribute('style')});
    });
}

function dragEnd(e) {
    document.removeEventListener("touchmove", dragMove);
    document.removeEventListener("mousemove", dragMove);
    remFullStyle();

    if (Math.abs(dragX) > Math.abs(dragY)) {
        if (dragX > 10) leftScreenContr(e, pageStructure);
        if (dragX < -10) rightScreenContr(e, pageStructure);
    } else {
        if (dragY < -10) bottomLevelContr(e, pageStructure);
        if (dragY > 10) topLevelContr(e, pageStructure);
    }

    setTimeout(() => { document.getElementById('lev-wrap').classList.remove('dragging') }, 10);
}