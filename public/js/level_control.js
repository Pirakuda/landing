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

function createStyle(scrStyleId, styleName, styleVal, pageStructure) {
	if (!pageStructure[scrStyleId][styleName]) return '';
	
	const styleValue = String(pageStructure[scrStyleId][styleName])
	  .replace(/&/g, "&amp;")
	  .replace(/</g, "&lt;")
	  .replace(/>/g, "&gt;")
	  .replace(/"/g, "&quot;")
	  .replace(/'/g, "&#039;");
  
	return `${styleVal}:${styleValue};`;
}

function createCost(scrStyleId, secCost, cost, promo, pageStructure) {
	const styles = scrStyleId ? [
        createStyle(scrStyleId, 'sec_cost_color', '--sec-cost-color', pageStructure),
		createStyle(scrStyleId, 'cost_color', '--cost-color', pageStructure),
		createStyle(scrStyleId, 'promo_color', '--promo-color', pageStructure)
    ].join('') : '';

    const secCostHtml = secCost ? `<div class="cost-sec-wrap">${secCost}</div>` : '';
    const costHtml = cost ? `<div class="cost-first-wrap">${cost}</div>` : '';
    const promoHtml = promo ? `<div class="promo-wrap">${promo}</div>` : '';

	if (!secCostHtml && !costHtml && !promoHtml) return '';

    return `<div class="cost-wrap flex" style="${styles}">
                <div class="cost-card">
                    ${secCostHtml}
                    ${costHtml}
                </div>
                ${promoHtml}
            </div>`;
}

function createTitle(scrStyleId, title, pageStructure) {
	if (!title) return '';
	const style = scrStyleId ? createStyle(scrStyleId, 'title_color', '--title-color', pageStructure) : '';
	return `<h3 class="title" style="${style}">${title}</h3>`;
}

function createBenefits(scrStyleId, benefits, pageStructure) {
	if (!benefits) return '';
	const style = scrStyleId ? createStyle(scrStyleId, 'benefits_color', '--benefits-color', pageStructure) : '';
	return `<ul class="product-benefits" style="${style}">${benefits}</ul>`;
}

function createSubtitle(scrStyleId, subtitle, pageStructure) {
	if (!subtitle) return '';
	const style = scrStyleId ? createStyle(scrStyleId, 'subtitle_color', '--subtitle-color', pageStructure) : '';
	return `<h4 class="subtitle" style="${style}">${subtitle}</h4>`;
}

function createPanelMore(scrStyleId, text, pageStructure) {
	if (!text) return '';
	const style = scrStyleId ? createStyle(scrStyleId, 'text_color', '--text-color', pageStructure) : '';
	return `<div class="panel-more" style="${style}">${text}</div>`
}

function createDelivery(scrStyleId, delivery, pageStructure) {
	if (!delivery) return '';
	const style = scrStyleId ? createStyle(scrStyleId, 'delivery_color', '--delivery-color', pageStructure) : '';
	return `<div class="delivery-wrap" style="${style}">${delivery}</div>`;
}

function createPageActBtn(scrStyleId, textObj, pageActLinkPath, pageActSecBtn, pageActBtn, pageStructure) {
    if (!pageActLinkPath && !pageActSecBtn && !pageActBtn) return '';
    
    // Исправление: правильные имена CSS-переменных для второстепенной кнопки
    let style = '';
	if (scrStyleId) {
		style += createStyle(scrStyleId, 'page_act_btn_bg', '--pageActBtn-bg', pageStructure);
		style += createStyle(scrStyleId, 'page_act_btn_color', '--pageActBtn-color', pageStructure);
	}
    
    // Если есть pageActLink — рендерим только одну ссылку-кнопку
	let linkBtn = '';
    if (pageActLinkPath) {
        const title = textObj.pageActLinkTitle || '';
        linkBtn = `<a href="${pageActLinkPath}" class="pageActBtn shining" style="${style}">${title}</a>`; 
    }
    
    // В остальных случаях рендерим pageActSecBtn и pageActBtn (если есть)
	let secStyle = '';
	if (scrStyleId) {
		secStyle += createStyle(scrStyleId, 'page_act_sec_btn_bg', '--pageActBtn-bg', pageStructure);
		secStyle += createStyle(scrStyleId, 'page_act_sec_btn_color', '--pageActBtn-color', pageStructure);
	}
    const secBtn = pageActSecBtn
        ? `<button class="pageActBtn sec-btn sec-shining" style="${secStyle}" data-service="${textObj.secBtnService || ''}">
                ${pageActSecBtn}
           </button>`
        : '';
    
    const mainBtn = pageActBtn
        ? `<button class="pageActBtn shining" style="${style}" data-service="${textObj.btnService || ''}">
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

	const slideImgPos = (scrObj.img_pos) || 'left-50';
	const slideTextPos = (scrObj.text_pos) || 'right';

	const slider = (scrObj.dataIds.length > 1) ? createHtmlSlider(scrObj, pageStructure) : '';
	
	const textObj = pageStructure[scrObj.textId] || {};
	const { figcaptions, secCost, cost, promo, title, benefits, subtitle, text, delivery, pageActLinkPath, pageSecActBtn, pageActBtn } = textObj;

	const wrapHidClass = (!benefits && !subtitle && !text && (title || pageActBtn)) ? 'hid' : '';
	const textHidClass = text ? '' : 'hid';
    // const fullOut = !benefits && !subtitle && !text && !title && !pageActBtn;

	// console.log("figcaption",figcaptions[0])
	const isActScr = parseInt(levelObj.activeScreen ?? 0) === scrIndex;
	
	return `<article data-index="${scrIndex}" class="screen ${curScrClass}">

				<figure class="sl slide-img ${slideImgPos}">
				  ${createImg(isActScr, scrObj, pageStructure)}
				  ${slider}
				  ${createFigcaption(figcaptions)}
				</figure>

				<div class="sl slide-text ${slideTextPos}">
				  <div class="text-main-wrap ${wrapHidClass}">
					<div class="text-wrap">
					  <div class="text-scroll-wrap">
					    ${createCost(scrStyleId, secCost, cost, promo, pageStructure)}
						<div class="panel-more-wrap ${textHidClass}">
						  ${createTitle(scrStyleId, title, pageStructure)}
						  ${createBenefits(scrStyleId, benefits, pageStructure)}
						  ${createSubtitle(scrStyleId, subtitle, pageStructure)}
                  	      ${createPanelMore(scrStyleId, text, pageStructure)}
					    </div>
					  </div>
					  ${text ? `<button class="more-btn pos-abs act-elem link act-anchor">Подробнее</button>` : ''}
					</div>
					${createDelivery(scrStyleId, delivery, pageStructure)}
					${createPageActBtn(scrStyleId, textObj, pageActLinkPath, pageSecActBtn, pageActBtn, pageStructure)}
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