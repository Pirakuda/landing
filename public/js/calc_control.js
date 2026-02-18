const packagePricing = {
    start: {
        initial: 280000,
        monthly: 45000,
        name: 'AI-СТАРТ'
    },
    profi: {
        initial: 520000,
        monthly: 85000,
        name: 'AI-ПРОФИ'
    },
    empire: {
        initial: 750000,
        monthly: 120000,
        name: 'AI-ИМПЕРИЯ'
    }
};

const optionPricing = {
    integration: { monthly: 15000, initial: 0, name: 'Интеграция с Авито/ЦИАН' },
    multiregion: { monthly: 30000, initial: 0, name: 'Мультирегиональность' },
    analytics: { monthly: 25000, initial: 0, name: 'Расширенная аналитика' },
    vip: { monthly: 20000, initial: 0, name: 'VIP-поддержка' },
    landings: { monthly: 0, initial: 75000, name: 'Дополнительные лендинги' }
};

let selectedPackage = 'profi';
let selectedPayment = 'full';
let selectedOptions = {};

// Функция для установки слушателя событий
function setupCalcEventListeners() {

    const calcWrap = popupList.querySelector(`#calc-popup-wrap`);
    const calcToAuditBtn = calcWrap.querySelector('#calc-to-audit-btn');
    const calcToFeedbackBtn = calcWrap.querySelector('#calc-to-feedback-btn');

    // Инициализация при загрузке
    calculateTotal();

    // Выбор пакета
    function selectPackage(packageName) {
        selectedPackage = packageName;
        
        calcWrap.querySelectorAll('.package-card').forEach(card => {
            card.classList.remove('selected');
        });
        calcWrap.querySelector(`[data-package="${packageName}"]`).classList.add('selected');
        
        calculateTotal();
    }

    // Выбор способа оплаты
    function selectPayment(paymentType) {
        selectedPayment = paymentType;
        
        calcWrap.querySelectorAll('.payment-option').forEach(option => {
            option.classList.remove('selected');
        });
        calcWrap.querySelector(`[data-payment="${paymentType}"]`).classList.add('selected');
        
        calculateTotal();
    }

    // Переключение опций
    function toggleOption(optionName) {
        const toggle = calcWrap.querySelector(`[data-option="${optionName}"]`);
        
        if (selectedOptions[optionName]) {
            delete selectedOptions[optionName];
            toggle.classList.remove('active');
        } else {
            selectedOptions[optionName] = true;
            toggle.classList.add('active');
        }
        
        calculateTotal();
    }

    function calculateTotal() {
        const package = packagePricing[selectedPackage];
        let totalInitial = package.initial;
        let totalMonthly = package.monthly;
        let packageName = package.name;
        
        // Добавляем опции
        let optionsInitial = 0;
        let optionsMonthly = 0;
        
        Object.keys(selectedOptions).forEach(optionName => {
            const option = optionPricing[optionName];
            optionsInitial += option.initial;
            optionsMonthly += option.monthly;
        });
        
        totalInitial += optionsInitial;
        totalMonthly += optionsMonthly;
        
        const yearlySubscription = totalMonthly * 12;
        const totalBeforeDiscount = totalInitial + yearlySubscription;
        
        // Расчет скидки
        let discountPercent = 35; // Базовая скидка
        if (selectedPayment === 'full') {
            discountPercent += 15; // Дополнительная скидка за полную оплату
        }
        
        const discountAmount = Math.floor(totalBeforeDiscount * (discountPercent / 100));
        const finalTotal = totalBeforeDiscount - discountAmount;
        
        // Обновление UI
        calcWrap.querySelector('#calcPackageName').textContent = 'Пакет ' + packageName + ':';
        calcWrap.querySelector('#packageCost').textContent = formatPrice(package.initial);
        calcWrap.querySelector('#optionsCost').textContent = formatPrice(optionsInitial);
        calcWrap.querySelector('#subscriptionCost').textContent = formatPrice(yearlySubscription);
        calcWrap.querySelector('#discountAmount').textContent = '-' + formatPrice(discountAmount);
        calcWrap.querySelector('#totalCost').textContent = formatPrice(finalTotal);
        calcWrap.querySelector('#savingsAmount').textContent = formatPrice(discountAmount);
    }

    function formatPrice(price) {
        return new Intl.NumberFormat('ru-RU').format(price) + ' ₽';
    }

    // Выбор пакета
    const optionPackage = calcWrap.querySelectorAll('.package-card');
    optionPackage.forEach(toggle => {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const packageName = this.dataset.package;
            if (packageName) {
                selectPackage(packageName);
            }
        });
    });

    // Выбор способа оплаты
    const optionPayment = calcWrap.querySelectorAll('.payment-option');
    optionPayment.forEach(toggle => {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const paymentType = this.dataset.payment;
            if (paymentType) {
                selectPayment(paymentType);
            }
        });
    });

    // Переключение опций
    const optionToggles = calcWrap.querySelectorAll('.option-toggle');
    optionToggles.forEach(toggle => {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const optionName = this.dataset.option;
            if (optionName) {
                toggleOption(optionName);
            }
        });
    });

    // возврат к аудиту
    calcToAuditBtn.addEventListener('click', () => {
        popupList.querySelector('.popup-contr.show')?.classList.remove('show');
        renderStep();
        popupList.querySelector('#detector-popup-wrap')?.classList.add('show');
    });

    // возврат к аудиту
    calcToFeedbackBtn.addEventListener('click', () => {
        popupList.querySelector('.popup-contr.show')?.classList.remove('show');
        popupList.querySelector('#feedback-popup-wrap')?.classList.add('show');
    });
}