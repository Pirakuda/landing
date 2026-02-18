
function random(number) {
	return Math.floor(Math.random()*number);
}

function circleDraw() {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const count = isPortraitOrient() ? 50 : 80;
	const diametr = isPortraitOrient() ? 80 : Math.round(WIDTH/8);
	const color = pageStructure.canvasBg ? pageStructure.canvasBg : 'rgba(238,238,238,0.5)';
	
	for (let i = 0; i < count; i ++) {
		ctx.beginPath(); // Начинаем путь для отрисовки круга
		ctx.fillStyle = color;
		ctx.arc(random(WIDTH), random(HEIGHT), random(diametr), 0, 2*Math.PI); // Указываем координаты центра круга и радиус
		ctx.fill(); // Заполняем круг заданным цветом
	}
}

function squareDraw() {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const count = isPortraitOrient() ? 50 : 80;
	const diametr = isPortraitOrient() ? 80 : Math.round(WIDTH/8);
	const color = pageStructure.canvasBg ? pageStructure.canvasBg : 'rgba(238,238,238,0.5)';

	for (let i = 0; i < count; i++) {
		ctx.beginPath(); // Начинаем путь для отрисовки квадрата
		ctx.fillStyle = color;
		ctx.fillRect(random(WIDTH), random(HEIGHT), random(diametr), random(200)); // Указываем координаты верхнего левого угла и ширину/высоту квадрата
	}
}

function hexagonDraw(canvas) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const count = isPortraitOrient() ? 20 : 30;
	const diametr = isPortraitOrient() ? 80 : Math.round(WIDTH/8);
	const color = pageStructure.canvaBg ? pageStructure.canvaBg : 'rgba(79, 79, 80, 0.7)';

	for (let i = 0; i < count; i++) {
		ctx.beginPath(); // Начинаем путь для отрисовки шестиугольника
		ctx.fillStyle = color;
		drawHexagon(ctx, random(WIDTH), random(HEIGHT), random(diametr)); // Указываем координаты центра и радиус шестиугольника
		ctx.fill();
	}
}

function drawHexagon(ctx, x, y, size) {
	ctx.moveTo(x + size * Math.cos(0), y + size * Math.sin(0));          
	for (var i = 1; i <= 6;i++) {
		ctx.lineTo(x + size * Math.cos(i * 2 * Math.PI / 6), y + size * Math.sin(i * 2 * Math.PI / 6));
	}
	ctx.closePath(); // Закрываем путь
}

function createTheme(curThema, pageStructure) {
	pageStructure.theme = curThema !== '0' ? "1" : "0";
	// const root = document.querySelector(':root');

	// root.style.setProperty('--header-bg', pageStructure.headerBg);
	// root.style.setProperty('--header-color', pageStructure.headerColor);

	// root.style.setProperty('--nav-bg', pageStructure.navBg);
	// root.style.setProperty('--nav-color', pageStructure.navColor);

	// root.style.setProperty('--main-bg', pageStructure.mainBg);
	// root.style.setProperty('--main-color', pageStructure.mainColor);

	// root.style.setProperty('--footer-bg', pageStructure.footerBg);
	// root.style.setProperty('--footer-color', pageStructure.footerColor);

	// root.style.setProperty('--popup-bg', pageStructure.popupBg);
	// root.style.setProperty('--popup-color', pageStructure.popupColor);
}

function createMainBG(curThema, pageStructure) {

	// const imgUrl = isPortraitOrient() ? 'https://sikamo.ru/public/store/bg-mobile-white.webp' : 'https://sikamo.ru/public/store/bg-desktop-white.webp';
    // document.getElementById('page-bg').style.backgroundImage = `url('${imgUrl}')`;


	//canvas.classList.add('hid');
	const canvasType = pageStructure.canvasType || 'hexagon';
	createTheme(curThema, pageStructure);
	// console.log('canvasType', canvasType);

	switch (canvasType) {
	  case 'circle':
		circleDraw();
	    break;
	  case 'square':
		squareDraw();
	    break;
	  case 'hexagon':
		hexagonDraw(canvas);
		// hexagonDraw(canvasBack);
	    break;
	  case 'foto':
		// const rootStyles = getComputedStyle(document.documentElement);
  		// const imgUrl = rootStyles.getPropertyValue('--bg-url').trim();
		const imgUrl = pageStructure.bgUrl;
        document.getElementById('page-bg').style.backgroundImage = `url('${imgUrl}')`;
	    break;
	  case 'dynamic':
		const dynamicBg = `<div class="stripe"></div>
						   <div class="stripe sec"></div>`;
		document.getElementById('page-bg').insertAdjacentHTML('beforeend', dynamicBg);
		break;
	  case 'video':
		const bgHTML = `<video class="video-data" autoplay loop muted type="video/mp4" draggable="false" onended="this.currentTime = 0; this.play();">
        				  <source type="video/mp4" src="./public/store/${pageStructure.path}">
    					</video>`;
		document.body.insertAdjacentHTML('beforeend', bgHTML);
	  	break;
	  default:
		break;
	}

	//if (canvasType !== 'no' && canvasType !== 'foto' && canvasType !== 'video') setTimeout(() => {canvas.classList.remove('hid')},500);
}

/* 208 - 198*/