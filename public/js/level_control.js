// используется при создании элемента в медиаменеджере и слайдере
function createHtmlBgData(dataType, dataUrl) {
	if (dataType === 'image') {
		const url = `./public/store/${dataUrl}`;
		return `<div class="mini-data" style="background-image:url('${url}');"></div>`;
	} else {
		return `<div class="mini-data">&#9658;</div>`;
	}
}

function createImg(isActScr, scrObj, pageStructure) {
	const dataId = scrObj?.dataIds[0] ?? null;
	if (!dataId) return '';
    
	const dataObj = pageStructure[dataId];
	const alt = (dataObj.name || 'Изображение');
    const baseUrl = './public/store/';
	const lazyAttrs = scrObj.scrFull === 'full' && !isActScr ? 'loading="lazy" decoding="async"' : '';

    return `
		<picture class="data-wrap">
		  <source media="(orientation: landscape)" srcset="${baseUrl}${dataObj.path}">
		  <img src="${baseUrl}${dataObj.m_path}" alt="${alt}" ${lazyAttrs} class="data" draggable="false">
		</picture>
	`;
}

function createHtmlSlider(scrObj, pageStructure) {
	const container = scrObj.dataIds
    .filter((id) => id && pageStructure[id] && pageStructure[id].path)
    .map((id, index) => {
        const dataObj = pageStructure[id];
		const dataType = dataObj.type;
		const curClass = index === 0 ? 'cur' : '';
        return `<li id="${id}" class="figure-slider-item ${curClass}" data-index="${index}">
                  ${createHtmlBgData(dataType, dataObj.path)}
                </li>`;
    })
    .join('');

	const count = scrObj.dataIds.length;
	const counter = `<div class="figure-slider-counter"><span>1</span><span>/</span><span>${count}</span></div>`;

	return `<div class="figure-slider-wrap">
			  <button class="figure-slider-btn btn-left hid">&#10094;</button>
			  <div class="figure-slider-container">
			    <ul class="figure-slider-list">
				  ${container}
			    </ul>
			  </div>
			  ${counter}
			  <button class="figure-slider-btn btn-right">&#10095;</button>
			</div>`;
}

function createFigcaption(captions) {
	if (!captions) return ``;
	return `<figcaption class="figcaption">${captions[0]}</figcaption>`;
}

// --- Сбор CSS-переменных экрана в одну строку для контейнера ---

function escapeStyleValue(value) {
	return String(value)
	  .replace(/&/g, "&amp;")
	  .replace(/</g, "&lt;")
	  .replace(/>/g, "&gt;")
	  .replace(/"/g, "&quot;")
	  .replace(/'/g, "&#039;");
}

const SCR_STYLE_MAP = {
	title_color:            '--title-color',
	subtitle_color:         '--subtitle-color',
	text_color:             '--text-color',
	benefits_color:         '--benefits-color',
	delivery_color:         '--delivery-color',
	cost_color:             '--cost-color',
	sec_cost_color:         '--sec-cost-color',
	promo_color:            '--promo-color',
	page_act_btn_bg:        '--pageActBtn-bg',
	page_act_btn_color:     '--pageActBtn-color',
	page_act_sec_btn_bg:    '--pageActSecBtn-bg',
	page_act_sec_btn_color: '--pageActSecBtn-color',
};

function collectScrStyles(scrStyleId, pageStructure) {
	if (!scrStyleId || !pageStructure[scrStyleId]) return '';

	const styleObj = pageStructure[scrStyleId];
	const parts = [];

	for (const key in SCR_STYLE_MAP) {
		if (styleObj[key]) {
			parts.push(`${SCR_STYLE_MAP[key]}:${escapeStyleValue(styleObj[key])}`);
		}
	}

	return parts.join(';');
}

// --- Элементы контента (стили наследуются из контейнера через CSS-каскад) ---

function createCost(secCost, cost, promo) {
    const secCostHtml = secCost ? `<div class="cost-sec-wrap">${secCost}</div>` : '';
    const costHtml = cost ? `<div class="cost-first-wrap">${cost}</div>` : '';
    const promoHtml = promo ? `<div class="promo-wrap">${promo}</div>` : '';

	if (!secCostHtml && !costHtml && !promoHtml) return '';

    return `<div class="cost-wrap flex">
                <div class="cost-card">
                    ${secCostHtml}
                    ${costHtml}
                </div>
                ${promoHtml}
            </div>`;
}

function createTitle(title) {
	if (!title) return '';
	return `<h3 class="title">${title}</h3>`;
}

function createBenefits(benefits) {
	if (!benefits) return '';
	return `<ul class="product-benefits">${benefits}</ul>`;
}

function createSubtitle(subtitle) {
	if (!subtitle) return '';
	return `<h4 class="subtitle">${subtitle}</h4>`;
}

function createPanelMore(text) {
	if (!text) return '';
	return `<div class="panel-more">${text}</div>`;
}

function createDelivery(delivery) {
	if (!delivery) return '';
	return `<div class="delivery-wrap">${delivery}</div>`;
}

function createPageActBtn(textObj, pageActLinkPath, pageActSecBtn, pageActBtn) {
    if (!pageActLinkPath && !pageActSecBtn && !pageActBtn) return '';
    
	let linkBtn = '';
    if (pageActLinkPath) {
        const title = textObj.pageActLinkTitle || '';
        linkBtn = `<a href="${pageActLinkPath}" class="pageActBtn shining">${title}</a>`; 
    }
    
    const secBtn = pageActSecBtn
        ? `<button class="pageActBtn sec-btn sec-shining" data-service="${textObj.secBtnService || ''}">
                ${pageActSecBtn}
           </button>`
        : '';
    
    const mainBtn = pageActBtn
        ? `<button class="pageActBtn shining" data-service="${textObj.btnService || ''}">
                ${pageActBtn}
           </button>`
        : '';
    
    return `<div class="page-action-btn-wrap flex">
                ${secBtn}
				${linkBtn}
                ${mainBtn}
            </div>`;
}

function createBgAbstract(isValid, slideTextPos, scrFull) {
	if (scrFull === '') return '';
	if (isValid === true && slideTextPos === 'center' || isValid === false && slideTextPos === 'right') {
		return `
			<div class=\"slide-bg-abstract-0\"></div>
			<div class=\"slide-bg-abstract-1\"></div>
			<div class=\"curtain-top\"></div>
            <div class=\"curtain-bottom\"></div>
		`;
	}
	return '';
}

function renderScr(levelObj, scrIndex, curScrClass, scrFull, pageStructure) {
	const scrObj = levelObj.screens[scrIndex];
	const scrStyleId = scrObj.styleId ?? null;

	// Все CSS-переменные экрана — один раз на контейнер <article>
	const scrStyles = collectScrStyles(scrStyleId, pageStructure);

	const slideImgPos = (scrObj.img_pos) || 'left-50';
	const slideTextPos = (scrObj.text_pos) || 'right';

	const slider = (scrObj.dataIds.length > 1) ? createHtmlSlider(scrObj, pageStructure) : '';
	
	const textObj = pageStructure[scrObj.textId] || {};
	const { figcaptions, secCost, cost, promo, title, benefits, subtitle, text, delivery, pageActLinkPath, pageSecActBtn, pageActBtn } = textObj;

	const wrapHidClass = (!benefits && !subtitle && !text && (title || pageActBtn)) ? 'hid' : '';
	const textHidClass = text ? '' : 'hid';

	const isActScr = parseInt(levelObj.activeScreen ?? 0) === scrIndex;
	
	return `<article data-index="${scrIndex}" class="screen ${curScrClass}" style="${scrStyles}">

				<figure class="sl slide-img ${slideImgPos}">
				  ${createImg(isActScr, scrObj, pageStructure)}
				  ${slider}
				  ${createFigcaption(figcaptions)}
				</figure>

				<div class="sl slide-text ${slideTextPos}">
				  <div class="text-main-wrap ${wrapHidClass}">
					<div class="text-wrap">
					  <div class="text-scroll-wrap">
					    ${createCost(secCost, cost, promo)}
						<div class="panel-more-wrap ${textHidClass}">
						  ${createTitle(title)}
						  ${createBenefits(benefits)}
						  ${createSubtitle(subtitle)}
                  	      ${createPanelMore(text)}
					    </div>
					  </div>
					  ${text ? `<button class="more-btn pos-abs act-elem link act-anchor">Подробнее</button>` : ''}
					</div>
					${createDelivery(delivery)}
					${createPageActBtn(textObj, pageActLinkPath, pageSecActBtn, pageActBtn)}
				  	${createBgAbstract(true, slideTextPos, scrFull)}
					</div>
				  ${createBgAbstract(false, slideTextPos, scrFull)}
				</div>
			</article>`;
}

function createLev(levIndex, levClass, pageStructure) {

	const levObj = pageStructure.levels[levIndex];
	let actScr = 0;
	
	if (levObj.activeScreen) {
		actScr = parseInt(levObj.activeScreen);
	} else {
		levObj.activeScreen = 0;
	}

	const scrFullClass = levObj.scrFull ? 'full' : '';
	const scrCount = levObj.screens.length || 1;
	let scrContainer = '';
	
	for (let i = 0; i < scrCount; i ++) {
		let curScrClass = '';
		if (i < actScr) {
            curScrClass = 'prev';
        } else if (i === actScr) {
            curScrClass = 'current';
        } else {
            curScrClass = 'queue';
        }
		scrContainer += renderScr(levObj, i, curScrClass, scrFullClass, pageStructure);
	}

	const level = document.createElement('section');
	level.setAttribute('data-index', levIndex);
	level.setAttribute('aria-labelledby', `section-title-${levIndex}`);
	level.className = levClass;
	const header = levObj.title || 'Ebene';

	level.innerHTML = `<h2 id="section-title-${levIndex}" class="level-title">${header}</h2>
					   <div class="scr-wrap ${scrFullClass}">
						 ${scrContainer}
					   </div>`;
	return level;
}

// асинхронная обертка используется при динамичеком создании уровня nextLevel
function createResolveLev(levIndex, levClass, pageStructure) {
	return new Promise((resolve) => {
		const level = createLev(levIndex, levClass, pageStructure);
        resolve(level);
	});
}