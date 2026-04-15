function random(number) {
	return Math.floor(Math.random()*number);
}

function randomFloat(min, max) {
	return min + Math.random() * (max - min);
}

/**
 * Парсит rgba/rgb строку цвета в объект {r, g, b, a}
 * @param {string} color — формат "rgba(r,g,b,a)" или "rgb(r,g,b)"
 */
function parseRGBA(color) {
	const match = color.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)/);
	if (!match) return { r: 100, g: 100, b: 100, a: 0.6 };
	return {
		r: parseInt(match[1]),
		g: parseInt(match[2]),
		b: parseInt(match[3]),
		a: parseFloat(match[4] ?? 0.8)
	};
}

// ═══════════════════════════════════════════════════
//  Оригинальные фигуры
// ═══════════════════════════════════════════════════

function circleDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const count = isPortraitOrient() ? 50 : 80;
	const diametr = isPortraitOrient() ? 80 : Math.round(WIDTH/8);
	
	for (let i = 0; i < count; i ++) {
		ctx.beginPath();
		ctx.fillStyle = color;
		ctx.arc(random(WIDTH), random(HEIGHT), random(diametr), 0, 2*Math.PI);
		ctx.fill();
	}
}

function squareDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const count = isPortraitOrient() ? 50 : 80;
	const diametr = isPortraitOrient() ? 80 : Math.round(WIDTH/8);

	for (let i = 0; i < count; i++) {
		ctx.beginPath();
		ctx.fillStyle = color;
		ctx.fillRect(random(WIDTH), random(HEIGHT), random(diametr), random(200));
	}
}

function hexagonDraw(canvas, color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const count = isPortraitOrient() ? 20 : 30;
	const diametr = isPortraitOrient() ? 80 : Math.round(WIDTH/8);

	for (let i = 0; i < count; i++) {
		ctx.beginPath();
		ctx.fillStyle = color;
		drawHexagon(ctx, random(WIDTH), random(HEIGHT), random(diametr));
		ctx.fill();
	}
}

function drawHexagon(ctx, x, y, size) {
	ctx.moveTo(x + size * Math.cos(0), y + size * Math.sin(0));          
	for (var i = 1; i <= 6;i++) {
		ctx.lineTo(x + size * Math.cos(i * 2 * Math.PI / 6), y + size * Math.sin(i * 2 * Math.PI / 6));
	}
	ctx.closePath();
}

// ═══════════════════════════════════════════════════
//  Новые абстрактные паттерны
// ═══════════════════════════════════════════════════

/**
 * Органические blob-фигуры (bezier-кривые)
 * Мягкие, современные формы — lifestyle, creative бренды
 */
function blobsDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const count = isPortraitOrient() ? 6 : 10;

	for (let i = 0; i < count; i++) {
		ctx.beginPath();
		ctx.fillStyle = color;
		const cx = random(WIDTH), cy = random(HEIGHT);
		const size = isPortraitOrient() ? 40 + random(120) : 60 + random(Math.round(WIDTH / 5));
		const points = 5 + random(4);
		const angleStep = (Math.PI * 2) / points;

		for (let j = 0; j <= points; j++) {
			const a = j * angleStep;
			const r1 = size * (0.6 + Math.random() * 0.8);
			const a2 = (j + 0.5) * angleStep;
			const r2 = size * (0.4 + Math.random() * 0.6);

			if (j === 0) {
				ctx.moveTo(cx + r1 * Math.cos(a), cy + r1 * Math.sin(a));
			}
			ctx.bezierCurveTo(
				cx + r2 * Math.cos(a2 - 0.3), cy + r2 * Math.sin(a2 - 0.3),
				cx + r2 * Math.cos(a2 + 0.3), cy + r2 * Math.sin(a2 + 0.3),
				cx + r1 * Math.cos((j + 1) * angleStep), cy + r1 * Math.sin((j + 1) * angleStep)
			);
		}
		ctx.closePath();
		ctx.fill();
	}
}

/**
 * Слоёные волны (синусоиды с разной амплитудой и фазой)
 * Спокойный, профессиональный — SaaS, сервисные лендинги
 */
function wavesDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const c = parseRGBA(color);
	const layers = isPortraitOrient() ? 4 : 6;

	for (let l = 0; l < layers; l++) {
		ctx.beginPath();
		const amp = 30 + random(80);
		const freq = 0.002 + Math.random() * 0.006;
		const phase = Math.random() * Math.PI * 2;
		const baseY = HEIGHT * 0.15 + (HEIGHT * 0.65 / layers) * l;

		ctx.moveTo(0, HEIGHT);
		ctx.lineTo(0, baseY);
		for (let x = 0; x <= WIDTH; x += 4) {
			const y = baseY
				+ Math.sin(x * freq + phase) * amp
				+ Math.sin(x * freq * 2.3 + phase * 1.7) * amp * 0.3;
			ctx.lineTo(x, y);
		}
		ctx.lineTo(WIDTH, HEIGHT);
		ctx.closePath();
		ctx.fillStyle = `rgba(${c.r},${c.g},${c.b},${c.a * (0.12 + l * 0.07)})`;
		ctx.fill();
	}
}

/**
 * Деформированная сетка со случайным смещением узлов
 * Структурированный хаос — tech, startup
 */
function gridDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const c = parseRGBA(color);
	const cols = isPortraitOrient() ? 8 : 14;
	const rows = isPortraitOrient() ? 12 : 8;
	const cellW = WIDTH / cols;
	const cellH = HEIGHT / rows;
	const displace = isPortraitOrient() ? 15 : 25;

	// Горизонтальные линии
	ctx.strokeStyle = `rgba(${c.r},${c.g},${c.b},${c.a * 0.4})`;
	ctx.lineWidth = 1;
	for (let row = 0; row <= rows; row++) {
		ctx.beginPath();
		for (let col = 0; col <= cols; col++) {
			const x = col * cellW + randomFloat(-displace, displace);
			const y = row * cellH + randomFloat(-displace, displace);
			if (col === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
		}
		ctx.stroke();
	}

	// Вертикальные линии
	for (let col = 0; col <= cols; col++) {
		ctx.beginPath();
		for (let row = 0; row <= rows; row++) {
			const x = col * cellW + randomFloat(-displace, displace);
			const y = row * cellH + randomFloat(-displace, displace);
			if (row === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
		}
		ctx.stroke();
	}

	// Случайная заливка ячеек
	for (let row = 0; row < rows; row++) {
		for (let col = 0; col < cols; col++) {
			if (Math.random() > 0.7) {
				ctx.fillStyle = `rgba(${c.r},${c.g},${c.b},${c.a * (0.04 + Math.random() * 0.12)})`;
				ctx.fillRect(col * cellW, row * cellH, cellW, cellH);
			}
		}
	}
}

/**
 * Радиальные лучи из случайной точки
 * Драматичный, привлекает внимание — промо, события
 */
function raysDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const c = parseRGBA(color);
	const cx = random(WIDTH), cy = random(HEIGHT);
	const count = isPortraitOrient() ? 30 : 50;
	const maxLen = Math.max(WIDTH, HEIGHT) * 1.5;

	for (let i = 0; i < count; i++) {
		const angle = (Math.PI * 2 / count) * i + randomFloat(-0.05, 0.05);
		const spread = randomFloat(0.005, 0.04);

		ctx.beginPath();
		ctx.moveTo(cx, cy);
		ctx.lineTo(cx + Math.cos(angle - spread) * maxLen, cy + Math.sin(angle - spread) * maxLen);
		ctx.lineTo(cx + Math.cos(angle + spread) * maxLen, cy + Math.sin(angle + spread) * maxLen);
		ctx.closePath();
		ctx.fillStyle = `rgba(${c.r},${c.g},${c.b},${c.a * (0.04 + Math.random() * 0.12)})`;
		ctx.fill();
	}
}

/**
 * Треугольная сетка (Delaunay-style)
 * Low-poly эстетика — tech, gaming, modern
 */
function trianglesDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const c = parseRGBA(color);
	const count = isPortraitOrient() ? 25 : 40;

	// Генерируем точки + обязательные угловые
	const pts = [];
	for (let i = 0; i < count; i++) pts.push([random(WIDTH), random(HEIGHT)]);
	pts.push([0, 0], [WIDTH, 0], [0, HEIGHT], [WIDTH, HEIGHT]);
	pts.push([WIDTH / 2, 0], [0, HEIGHT / 2], [WIDTH, HEIGHT / 2], [WIDTH / 2, HEIGHT]);

	// Соединяем каждую точку с 3 ближайшими
	for (let i = 0; i < pts.length; i++) {
		const nearest = [];
		for (let j = 0; j < pts.length; j++) {
			if (i === j) continue;
			const d = Math.hypot(pts[i][0] - pts[j][0], pts[i][1] - pts[j][1]);
			nearest.push({ idx: j, d });
		}
		nearest.sort((a, b) => a.d - b.d);

		ctx.beginPath();
		ctx.moveTo(pts[i][0], pts[i][1]);
		for (const n of nearest.slice(0, 3)) {
			ctx.lineTo(pts[n.idx][0], pts[n.idx][1]);
		}
		ctx.closePath();
		ctx.fillStyle = `rgba(${c.r},${c.g},${c.b},${c.a * (0.03 + Math.random() * 0.10)})`;
		ctx.fill();
		ctx.strokeStyle = `rgba(${c.r},${c.g},${c.b},${c.a * 0.2})`;
		ctx.lineWidth = 0.5;
		ctx.stroke();
	}
}

/**
 * Точечная матрица с вариацией размера от центра к краям
 * Минималистичный — подходит для любого бизнеса
 */
function dotsDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const c = parseRGBA(color);
	const spacing = isPortraitOrient() ? 28 : 36;
	const maxR = isPortraitOrient() ? 5 : 8;

	for (let x = spacing / 2; x < WIDTH; x += spacing) {
		for (let y = spacing / 2; y < HEIGHT; y += spacing) {
			const dist = Math.hypot(x - WIDTH / 2, y - HEIGHT / 2) / Math.max(WIDTH, HEIGHT);
			const r = maxR * (0.2 + (1 - dist) * 0.8) * (0.5 + Math.random() * 0.5);

			ctx.beginPath();
			ctx.arc(
				x + randomFloat(-3, 3),
				y + randomFloat(-3, 3),
				Math.max(0.5, r), 0, Math.PI * 2
			);
			ctx.fillStyle = `rgba(${c.r},${c.g},${c.b},${c.a * (0.15 + Math.random() * 0.45)})`;
			ctx.fill();
		}
	}
}

/**
 * Ромбы в шахматном порядке со случайным пропуском
 * Элегантный, структурный — premium бренды
 */
function diamondsDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const c = parseRGBA(color);
	const size = isPortraitOrient() ? 30 : 45;
	const cols = Math.ceil(WIDTH / size) + 2;
	const rows = Math.ceil(HEIGHT / size) + 2;

	for (let row = -1; row < rows; row++) {
		for (let col = -1; col < cols; col++) {
			if (Math.random() > 0.6) continue;

			const cx = col * size + (row % 2) * size / 2;
			const cy = row * size * 0.75;
			const s = size * (0.3 + Math.random() * 0.4);

			ctx.save();
			ctx.translate(cx, cy);
			ctx.rotate(Math.PI / 4);
			ctx.fillStyle = `rgba(${c.r},${c.g},${c.b},${c.a * (0.04 + Math.random() * 0.16)})`;
			ctx.fillRect(-s / 2, -s / 2, s, s);
			ctx.restore();
		}
	}
}

/**
 * Поле потоковых линий (pseudo-Perlin noise)
 * Органичный, художественный — арт, креативные индустрии
 */
function noiseDraw(color) {
	const ctx = canvas.getContext('2d');
	ctx.clearRect(0, 0, WIDTH, HEIGHT);
	const c = parseRGBA(color);
	const lines = isPortraitOrient() ? 50 : 80;
	const seed = Math.random() * 1000;

	for (let i = 0; i < lines; i++) {
		ctx.beginPath();
		let x = random(WIDTH), y = random(HEIGHT);
		ctx.moveTo(x, y);

		const steps = 40 + random(60);
		for (let s = 0; s < steps; s++) {
			const angle = (Math.sin(x * 0.005 + seed) + Math.cos(y * 0.005 + seed)) * Math.PI * 2;
			x += Math.cos(angle) * 4;
			y += Math.sin(angle) * 4;
			ctx.lineTo(x, y);
		}

		ctx.strokeStyle = `rgba(${c.r},${c.g},${c.b},${c.a * (0.08 + Math.random() * 0.18)})`;
		ctx.lineWidth = 1 + Math.random() * 2;
		ctx.stroke();
	}
}

// ═══════════════════════════════════════════════════
//  Точка входа
// ═══════════════════════════════════════════════════

function createMainBG(pageStructure) {

	const canvasType = pageStructure.canvasType || 'triangles';
	const rgbBg = pageStructure.rgbBg;
	const mainColor = `rgba(${rgbBg}, 0.6)`;

	console.log('canvasType:', canvasType)

	switch (canvasType) {
	  // Оригинальные
	  case 'circle':
		circleDraw(mainColor);
	    break;
	  case 'square':
		squareDraw(mainColor);
	    break;
	  case 'hexagon':
		hexagonDraw(canvas, mainColor);
	    break;

	  // Новые абстрактные паттерны
	  case 'blobs':
		blobsDraw(mainColor);
		break;
	  case 'waves':
		wavesDraw(mainColor);
		break;
	  case 'grid':
		gridDraw(mainColor);
		break;
	  case 'rays':
		raysDraw(mainColor);
		break;
	  case 'triangles':
		trianglesDraw(mainColor);
		break;
	  case 'dots':
		dotsDraw(mainColor);
		break;
	  case 'diamonds':
		diamondsDraw(mainColor);
		break;
	  case 'noise':
		noiseDraw(mainColor);
		break;

	  // Не-canvas типы
	  case 'foto':
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
}