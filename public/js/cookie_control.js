/////////////////////////////////////////////////////////////////////
// Глобальные флаги
window.liteAnalytics = null;           // null — нет выбора; true — строгая; false — полная
window.analyticsInitialized = false;   // защита от двойной инициализации

// Упрощенная система аналитики - только URL разделов и время
class SimpleAnalytics {
    constructor() {
        this.currentSection = null;
        this.sessionData = null;
        this.isInitialized = false;
        this.endpoint = '/modules/public/logEvent.php';
        this.organizationId = 141; // Можно сделать динамическим
        this.queue = []; // Очередь для отправки данных
        this.isBot = false;
    }

    // Инициализация с данными сессии
    init(sessionData, pageStructure) {
        if (this.isInitialized) return;
        
        // Проверяем на бота
        if (this.detectBot()) {
            this.isBot = true;
            console.log('Bot detected - analytics disabled');
            return;
        }
        
        this.sessionData = sessionData;
        this.isInitialized = true;
        
        // Запускаем первый раздел
        this.startSection(pageStructure);
        
        // Настраиваем финальную отправку при закрытии
        this.setupFinalFlush();
        
        // Настраиваем обработку очереди
        this.setupQueueProcessing();
    }

    // Простая проверка на бота
    detectBot() {
        const userAgent = navigator.userAgent.toLowerCase();
        const botPatterns = [
            'bot', 'crawler', 'spider', 'scraper',
            'curl', 'wget', 'python', 'java',
            'headless', 'phantom'
        ];
        
        return botPatterns.some(pattern => userAgent.includes(pattern));
    }

    // Получение URL текущего раздела из pageStructure - ИСПРАВЛЕННАЯ ВЕРСИЯ
    getSectionUrl(pageStructure) {
        try {
            const activeLevel = parseInt(pageStructure?.activeLevel || 0);
            const level = pageStructure?.levels?.[activeLevel];
            
            if (!level) return '/';

            if (level.scrFull) {
                // Полноэкранные разделы: /pageSlug/screenSlug
                const activeScreen = parseInt(level.activeScreen || 0);
                const screen = level.screens?.[activeScreen];
                if (screen) {
                    // Убираем лишние слеши
                    const levelSlug = level.slug || '';
                    const screenSlug = screen.slug || '';
                    return `/${levelSlug}/${screenSlug}`.replace(/\/+/g, '/');
                }
                return `/${level.slug || ''}`.replace(/\/+/g, '/');
            } else {
                // Обычные разделы: /pageSlug
                return `/${level.slug || ''}`.replace(/\/+/g, '/');
            }
        } catch (error) {
            console.warn('Error getting section URL:', error);
            return '/unknown';
        }
    }

    // Начало нового раздела
    startSection(pageStructure) {
        // Завершаем предыдущий раздел
        if (this.currentSection) {
            this.endSection();
        }

        const sectionUrl = this.getSectionUrl(pageStructure);
        
        this.currentSection = {
            url: sectionUrl,
            startTime: Date.now()
        };
        
        console.log('Analytics: Started section', sectionUrl);
    }

    // Переход между разделами
    transitionTo(pageStructure) {
        if (!this.isInitialized || this.isBot) return;
        
        const newUrl = this.getSectionUrl(pageStructure);
        
        // Проверяем, действительно ли изменился раздел
        if (this.currentSection && this.currentSection.url === newUrl) {
            return;
        }

        console.log('Analytics: Transition to', newUrl);
        this.startSection(pageStructure);
    }

    // Завершение текущего раздела
    endSection(final = false) {
        if (!this.currentSection) return;

        const now = Date.now();
        const timeSpent = Math.round((now - this.currentSection.startTime) / 1000);

        // Отправляем данные только если пользователь провел время в разделе
        if (timeSpent > 0) {
            this.sendSectionData(this.currentSection.url, timeSpent, final);
        }

        this.currentSection = null;
    }

    // Отправка данных раздела на сервер - УЛУЧШЕННАЯ ВЕРСИЯ
    async sendSectionData(sectionUrl, timeSpent, final = false) {
        if (this.isBot) return;
        
        const eventData = {
            event_type: 'section_view',
            session_id: this.sessionData?.session_id,
            visitor_id: this.sessionData?.visitor_id,
            event_data: {
                section_url: sectionUrl,
                time_spent: timeSpent,
                timestamp: Date.now(),
                organization_id: this.organizationId
            }
        };

        if (final) {
            // Для финальных событий используем sendBeacon или синхронный запрос
            this.sendFinalEvent(eventData);
        } else {
            // Добавляем в очередь для асинхронной отправки
            this.queue.push(eventData);
            this.processQueue();
        }
    }

    // Отправка финального события
    sendFinalEvent(eventData) {
        try {
            if (navigator.sendBeacon) {
                const blob = new Blob([JSON.stringify(eventData)], { type: 'application/json' });
                const success = navigator.sendBeacon(this.endpoint, blob);
                console.log('Analytics: Final beacon sent', success);
                return;
            }
            
            // Fallback: синхронный XMLHttpRequest
            const xhr = new XMLHttpRequest();
            xhr.open('POST', this.endpoint, false); // синхронный
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.send(JSON.stringify(eventData));
            console.log('Analytics: Final sync request sent');
            
        } catch (error) {
            console.warn('Analytics: Failed to send final event', error);
        }
    }

    // Обработка очереди событий
    async processQueue() {
        if (this.queue.length === 0 || this.processing) return;
        
        this.processing = true;
        
        while (this.queue.length > 0) {
            const eventData = this.queue.shift();
            
            try {
                const response = await fetch(this.endpoint, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(eventData)
                });
                
                if (!response.ok) {
                    console.warn('Analytics: Failed to send event', response.status);
                    // Не добавляем обратно в очередь, чтобы избежать бесконечных попыток
                }
                
            } catch (error) {
                console.warn('Analytics: Network error', error);
                // Также не добавляем обратно
            }
            
            // Небольшая задержка между запросами
            await new Promise(resolve => setTimeout(resolve, 100));
        }
        
        this.processing = false;
    }

    // Настройка обработки очереди
    setupQueueProcessing() {
        // Обрабатываем очередь каждые 5 секунд
        setInterval(() => {
            this.processQueue();
        }, 5000);
    }

    // Настройка финальной отправки при закрытии страницы
    setupFinalFlush() {
        const finalFlush = () => {
            if (this.currentSection) {
                this.endSection(true);
            }
            
            // Отправляем оставшиеся события из очереди
            this.queue.forEach(eventData => {
                this.sendFinalEvent(eventData);
            });
            this.queue = [];
        };

        // Различные события закрытия страницы
        document.addEventListener('visibilitychange', () => {
            if (document.visibilityState === 'hidden') {
                finalFlush();
            }
        });

        window.addEventListener('beforeunload', finalFlush);
        window.addEventListener('pagehide', finalFlush);
        
        // Для мобильных устройств
        window.addEventListener('blur', () => {
            setTimeout(() => {
                if (document.visibilityState === 'hidden') {
                    finalFlush();
                }
            }, 100);
        });
    }

    // Обработка кликов по кнопкам
    trackButtonClick(buttonElement, pageStructure) {
        if (!this.isInitialized || this.isBot) return;
        
        const buttonInfo = {
            text: buttonElement.textContent?.trim().substring(0, 50),
            class: buttonElement.className,
            id: buttonElement.id,
            section: this.getSectionUrl(pageStructure)
        };
        
        // Можно добавить в очередь как отдельное событие
        console.log('Analytics: Button click', buttonInfo);
    }
}

// Глобальный экземпляр
window.simpleAnalytics = new SimpleAnalytics();

// Упрощенный инициализатор
const SimpleAnalyticsInit = {
    init(pageStructure) {
        // Проверяем согласие на cookies
        const cookiesAccepted = CookieConsent.getCookie('cookies_accepted');
        
        if (cookiesAccepted === 'true' && pageStructure.analytics) {
            // Полная аналитика с session_id
            window.simpleAnalytics.init(pageStructure.analytics, pageStructure);
            window.liteAnalytics = false;
        } else if (cookiesAccepted === 'false') {
            // Анонимная аналитика без session_id
            const anonymousData = {
                session_id: null,
                visitor_id: null,
                device_type: pageStructure.analytics?.device_type || 'unknown',
                language: pageStructure.analytics?.language || 'ru'
            };
            window.simpleAnalytics.init(anonymousData, pageStructure);
            window.liteAnalytics = true;
        }
        // Если согласие не дано (null), аналитика не запускается
    }
};

// функция инициализации аналитики
function ensureAnalyticsInit() {
    if (window.analyticsInitialized) return;
    if (window.liteAnalytics === null) return; // выбора ещё нет

    if (typeof window.pageStructure !== 'undefined') {
        SimpleAnalyticsInit.init(window.pageStructure);
        window.analyticsInitialized = true;
        console.log('Analytics initialized with mode:', window.liteAnalytics ? 'lite' : 'full');
    }
}

// COOKIES Базовый менеджер cookies для MVP
const CookieConsent = {
    // Конфигурация категорий
    categories: {
        necessary: { required: true, enabled: true },
        analytics: { required: false, enabled: false },
        marketing: { required: false, enabled: false },
        preferences: { required: false, enabled: false }
    },

    getCookie(name) {
        return (document.cookie.split('; ').find(row => row.startsWith(name + '=')) || '')
            .split('=')[1] || null;
    },
    
    setCookie(name, value, days) {
        const expires = new Date(Date.now() + days * 864e5).toUTCString();
        const secure = (location.protocol === 'https:') ? '; secure' : '';
        document.cookie = `${name}=${encodeURIComponent(value)}; expires=${expires}; path=/; SameSite=Lax${secure}`;
    },
    
    // Принятие всех cookies
    acceptAllCookies() {
        const categories = {
            necessary: true,
            analytics: true,
            marketing: true,
            preferences: true
        };
        
        this.saveDetailedConsent(categories, 'accept_all');
        this.closeBanner();
        this.closeSettingsModal();
        this.applySettings(true);
    },
    
    // Отклонение всех необязательных cookies
    declineAllCookies() {
        const categories = {
            necessary: true,
            analytics: false,
            marketing: false,
            preferences: false
        };
        
        this.saveDetailedConsent(categories, 'decline_all');
        this.closeBanner();
        this.closeSettingsModal();
        this.applySettings(false);
    },

    // Сохранение выбранных настроек
    saveSelectedPreferences() {
        const categories = {
            necessary: true, // всегда включено
            analytics: document.getElementById('analytics-cookies')?.checked || false,
            marketing: document.getElementById('marketing-cookies')?.checked || false,
            preferences: document.getElementById('preferences-cookies')?.checked || false
        };
        
        this.saveDetailedConsent(categories, 'custom_selection');
        this.closeBanner();
        this.closeSettingsModal();
        
        const analyticsEnabled = categories.analytics || categories.marketing;
        this.applySettings(analyticsEnabled);
    },

    // Сохранение детального согласия
    saveDetailedConsent(categories, source) {
        const consentData = {
            timestamp: new Date().toISOString(),
            categories: categories,
            version: '1.0',
            source: source
        };
        
        // Сохраняем детальные настройки
        this.setCookie('gdpr_consent_detailed', JSON.stringify(consentData), 365);
        
        // Обратная совместимость со старым форматом
        const hasAnalytics = categories.analytics || categories.marketing;
        this.setCookie('cookies_accepted', hasAnalytics ? 'true' : 'false', 365);
        
        // Обновляем внутреннее состояние
        Object.assign(this.categories, categories);
        
        console.log('Cookie consent saved:', { categories, source });
    },

    // Открытие модального окна настроек
    openSettingsModal() {
        stopGuide(); // останавливаем гайд если активен
        
        const modal = document.getElementById('cookie-settings-popup-wrap');
        if (!modal) {
            console.error('Cookie settings modal not found');
            return;
        }

        // Загружаем текущие настройки в UI
        this.loadCurrentSettingsToUI();
        
        // Показываем модальное окно
        modal.classList.add('show');
        
        // Закрываем другие попапы
        this.closeBanner();
        document.getElementById('menu-popup-wrap')?.classList.remove('show');
        document.getElementById('menu-toggle')?.classList.remove('checked');
    },

    // Загрузка текущих настроек в UI
    loadCurrentSettingsToUI() {
        const consent = this.getCurrentConsent();
        
        if (consent && consent.categories) {
            Object.assign(this.categories, consent.categories);
        }
        
        // Обновляем чекбоксы
        Object.keys(this.categories).forEach(category => {
            const checkbox = document.getElementById(`${category}-cookies`);
            if (checkbox) {
                checkbox.checked = this.categories[category].enabled;
            }
        });
    },

    // Закрытие баннера
    closeBanner() {
        document.getElementById('cookies-popup-wrap')?.classList.remove('show');
    },

    // Закрытие модального окна настроек
    closeSettingsModal() {
        document.getElementById('cookie-settings-popup-wrap')?.classList.remove('show');
    },

    // Применение настроек
    applySettings(analyticsEnabled) {
        // Устанавливаем глобальный флаг для совместимости
        window.liteAnalytics = analyticsEnabled ? false : true;
        
        // Запускаем/перезапускаем аналитику
        setTimeout(() => {
            if (typeof ensureAnalyticsInit === 'function') {
                ensureAnalyticsInit();
            }
        }, 100);

        // Диспетчим событие для других модулей
        document.dispatchEvent(new CustomEvent('cookieConsentUpdated', {
            detail: {
                categories: this.categories,
                analyticsEnabled: analyticsEnabled,
                timestamp: new Date().toISOString()
            }
        }));

        // Показываем уведомление
        if (typeof updateMsg === 'function' && document.getElementById('popup-list')) {
            updateMsg(document.getElementById('popup-list'), 
                'Cookie-Einstellungen wurden erfolgreich gespeichert.');
        }

        console.log('Cookie settings applied:', analyticsEnabled ? 'Full analytics' : 'Lite analytics');
    },

    // Получение текущего состояния согласия
    getCurrentConsent() {
        const detailed = this.getCookie('gdpr_consent_detailed');
        if (detailed) {
            try {
                return JSON.parse(detailed);
            } catch (e) {
                console.warn('Invalid detailed consent data');
            }
        }

        // Fallback к старому формату
        const basic = this.getCookie('cookies_accepted');
        if (basic !== null) {
            return {
                categories: {
                    necessary: true,
                    analytics: basic === 'true',
                    marketing: basic === 'true',
                    preferences: basic === 'true'
                },
                source: 'legacy_format'
            };
        }

        return null;
    },

    // Проверка необходимости показа баннера
    shouldShowBanner() {
        return this.getCurrentConsent() === null;
    },

    init() {
        const consent = this.getCurrentConsent();

        if (consent === null) {
            // Показываем баннер, аналитику НЕ запускаем
            const banner = document.getElementById('cookies-popup-wrap');
            if (banner) {
                banner.classList.add('show');
            }
            window.liteAnalytics = null; // режим ожидания
        } else {
            // Загружаем существующие настройки
            if (consent.categories) {
                Object.assign(this.categories, consent.categories);
            }
            
            // Устанавливаем режим аналитики
            const analyticsEnabled = this.categories.analytics || this.categories.marketing;
            window.liteAnalytics = analyticsEnabled ? false : true;
        }

        // Настраиваем обработчики событий
        this.setupEventListeners();
    },

    // Настройка всех обработчиков событий
    setupEventListeners() {
        // Кнопки основного баннера
        const acceptBtn = document.getElementById('accept-cookies');
        const declineBtn = document.getElementById('decline-cookies');
        const settingsBtn = document.getElementById('cookie-settings-btn');

        if (acceptBtn) {
            acceptBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                this.acceptAllCookies();
            });
        }

        if (declineBtn) {
            declineBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                this.declineAllCookies();
            });
        }

        if (settingsBtn) {
            settingsBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                this.openSettingsModal();
            });
        }

        // Кнопки модального окна настроек
        document.addEventListener('DOMContentLoaded', () => {
            const acceptAllSettingsBtn = document.getElementById('accept-all-settings');
            const declineAllSettingsBtn = document.getElementById('decline-all-settings');
            const savePreferencesBtn = document.getElementById('save-cookie-preferences');

            if (acceptAllSettingsBtn) {
                acceptAllSettingsBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    this.acceptAllCookies();
                });
            }

            if (declineAllSettingsBtn) {
                declineAllSettingsBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    this.declineAllCookies();
                });
            }

            if (savePreferencesBtn) {
                savePreferencesBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    this.saveSelectedPreferences();
                });
            }
        });
    },

    // Утилита для проверки согласия на конкретную категорию
    hasConsentFor(category) {
        return this.categories[category] && this.categories[category].enabled;
    },

    // Получение статистики согласия
    getConsentStats() {
        const consent = this.getCurrentConsent();
        if (!consent) return null;

        const enabled = Object.values(consent.categories).filter(Boolean).length;
        const total = Object.keys(consent.categories).length;
        
        return {
            enabled,
            total,
            percentage: Math.round((enabled / total) * 100),
            timestamp: consent.timestamp,
            source: consent.source
        };
    }
};

function checkCookie(popupList) {
	let elem = popupList.querySelector('#cookies-popup-wrap');
	if (!elem.classList.contains('show')) elem = elem.querySelector('#accept-cookies');
	elem.style.transform = 'translateX(-20px)';
    setTimeout(() => {
        elem.style.transform = 'translateX(0)';

        setTimeout(() => {
            elem.style.removeProperty('transform');
        }, 300);
    }, 300);
}

// Функция для переключения детальной информации о cookies
function toggleCookieDetails(button) {
  const cookiesList = button.parentNode.querySelector('.cookies-list');
  const arrow = button.querySelector('.arrow');
  
  if (cookiesList.classList.contains('show')) {
    cookiesList.classList.remove('show');
    button.classList.remove('active');
    button.innerHTML = 'Details anzeigen <span class="arrow">▼</span>';
  } else {
    cookiesList.classList.add('show');
    button.classList.add('active');
    button.innerHTML = 'Details ausblenden <span class="arrow">▼</span>';
  }
}

// Ожидаем инициализации ChatBot
function waitForChatBot() {
    if (window.chatBot && window.privacyConsent) {
        console.log('ChatBot and privacy consent ready');
        
        // Добавляем обработчик для показа формы
        document.addEventListener('chatFormShow', function() {
            console.log('Chat form show event triggered');
            setTimeout(() => {
                const consentContainer = document.querySelector('.privacy-consent-container');
                if (consentContainer && window.privacyConsent.shouldShowConsentCheckbox()) {
                    console.log('Creating privacy consent checkbox');
                    window.privacyConsent.createConsentCheckbox('privacy-consent-container');
                }
            }, 100);
        });
        
        // Добавляем глобальный обработчик для согласия
        document.addEventListener('privacyConsentGiven', function(event) {
            console.log('Privacy consent given at:', event.detail.timestamp);
            // Можно добавить дополнительную логику при получении согласия
        });
        
    } else {
        // Проверяем каждые 100ms до инициализации
        setTimeout(waitForChatBot, 100);
    }
}

// Функция настройки обработчиков событий для модального окна cookies
function setupCookieSettingsEventListeners() {
    // Кнопки в модальном окне настроек
    const acceptAllSettingsBtn = document.getElementById('accept-all-settings');
    const declineAllSettingsBtn = document.getElementById('decline-all-settings');
    const savePreferencesBtn = document.getElementById('save-cookie-preferences');

    if (acceptAllSettingsBtn) {
        acceptAllSettingsBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            CookieConsent.acceptAllCookies();
        });
    }

    if (declineAllSettingsBtn) {
        declineAllSettingsBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            CookieConsent.declineAllCookies();
        });
    }

    if (savePreferencesBtn) {
        savePreferencesBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            CookieConsent.saveSelectedPreferences();
        });
    }
}

document.addEventListener('DOMContentLoaded', function() {

    CookieConsent.init();
    setTimeout(() => { ensureAnalyticsInit(); }, 100);

    // Инициализируем PrivacyConsent сразу
    if (typeof PrivacyConsentHandler !== 'undefined') {
        window.privacyConsent = new PrivacyConsentHandler();
        console.log('Privacy consent handler initialized');
    } else {
        console.warn('PrivacyConsentHandler not found');
    }

    // Добавляем обработчики для кнопок модального окна настроек cookies
    setupCookieSettingsEventListeners();
    
    // Запускаем ожидание
    waitForChatBot();

    // открытие настроек куков
    manageAnalysisBtn.addEventListener('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		stopGuide();
		popupList.querySelector('.popup-contr.show')?.classList.remove('show');
        popupList.querySelector('.cookie-settings-popup')?.classList.add('show');
	});
});