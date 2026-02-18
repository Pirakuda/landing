class ChatBot {
    constructor(config = {}) {
        // ИСПРАВЛЕНО: Безопасное получение данных аналитики
        const analytics = this.getAnalyticsData();

        this.config = {
            apiBase: '/modules/chat/api/',
            domain: window.location.hostname,
            maxMessageLength: 1000,
            typingDelay: 1000,
            retryAttempts: 3,
            debug: true,
            
            endpoints: {
                contact: '/modules/chat/api/clientContact.php',
                message: '/modules/chat/api/clientMessage.php'
            },
            language: analytics.language || 'ru',
            ...config
        };
        
        this.isInitialized = false;
        this.isProcessing = false;
        this.messageQueue = [];
        
        // ИСПРАВЛЕНО: Более надежная инициализация сессии
        this.sessionData = {
            session_id: analytics.session_id || this.generateFallbackSessionId(),
            visitor_id: analytics.visitor_id || this.generateFallbackVisitorId(),
            language: this.config.language,
            device_type: analytics.device_type || this.detectDeviceType(),
            domain: analytics.domain || this.config.domain,
            welcome_message: this.getWelcomeMessage(),
            fallback_mode: !analytics.session_id && !analytics.visitor_id
        };
        
        this.fallbackMode = this.sessionData.fallback_mode;
        
        // Логируем состояние для отладки
        if (this.config.debug) {
            console.log('ChatBot session data:', this.sessionData);
        }
        
        this.elements = {
            popup: null,
            messagesContainer: null,
            messageInput: null,
            sendButton: null,
            typingIndicator: null,
            contactForm: null,
            quickButtons: null
        };
        
        this.init();
    }

    /**
     * НОВОЕ: Безопасное получение данных аналитики с проверками
     */
    getAnalyticsData() {
        try {
            // Проверяем window.pageStructure
            if (window.pageStructure && window.pageStructure.analytics) {
                console.log('Analytics data found in pageStructure');
                return window.pageStructure.analytics;
            }

            // Проверяем глобальную переменную analytics (если используется)
            if (window.analytics) {
                console.log('Analytics data found in window.analytics');
                return window.analytics;
            }

            // Проверяем localStorage как fallback
            const storedSession = localStorage.getItem('chat_session_data');
            if (storedSession) {
                try {
                    const sessionData = JSON.parse(storedSession);
                    console.log('Analytics data restored from localStorage');
                    return sessionData;
                } catch (e) {
                    console.warn('Invalid session data in localStorage');
                }
            }

            console.warn('No analytics data available, using fallback');
            return {};
            
        } catch (error) {
            console.error('Error getting analytics data:', error);
            return {};
        }
    }

    /**
     * НОВОЕ: Генерация fallback session ID
     */
    generateFallbackSessionId() {
        const timestamp = Date.now();
        const random = Math.random().toString(36).substr(2, 9);
        return `fallback_${timestamp}_${random}`;
    }

    /**
     * НОВОЕ: Генерация fallback visitor ID
     */
    generateFallbackVisitorId() {
        // Пытаемся получить из localStorage
        let visitorId = localStorage.getItem('fallback_visitor_id');
        if (!visitorId) {
            const timestamp = Date.now();
            const random = Math.random().toString(36).substr(2, 9);
            visitorId = `visitor_${timestamp}_${random}`;
            localStorage.setItem('fallback_visitor_id', visitorId);
        }
        return visitorId;
    }

    /**
     * НОВОЕ: Определение типа устройства
     */
    detectDeviceType() {
        const userAgent = navigator.userAgent.toLowerCase();
        
        if (/tablet|ipad/.test(userAgent)) {
            return 'tablet';
        } else if (/mobile|android|iphone/.test(userAgent)) {
            return 'mobile';
        } else {
            return 'desktop';
        }
    }

    /**
     * ИСПРАВЛЕНО: Инициализация с улучшенной обработкой ошибок
     */
    async init() {
        try {
            if (this.config.debug) {
                console.log('ChatBot initialization started...');
                console.log('Fallback mode:', this.fallbackMode);
            }
            
            this.findElements();
            this.bindEvents();
            
            // Сохраняем данные сессии для будущих использований
            if (!this.fallbackMode) {
                this.saveSessionData();
            }
            
            this.isInitialized = true;
            
            // Показываем приветственное сообщение
            await this.showWelcomeMessage();
            
            console.log('ChatBot initialized successfully');
            
            // Уведомляем другие компоненты о готовности
            this.dispatchReadyEvent();
            
        } catch (error) {
            console.error('ChatBot initialization failed:', error);
            this.showError('Ошибка инициализации чата');
        }
    }

    /**
     * НОВОЕ: Сохранение данных сессии
     */
    saveSessionData() {
        try {
            const sessionData = {
                session_id: this.sessionData.session_id,
                visitor_id: this.sessionData.visitor_id,
                device_type: this.sessionData.device_type,
                language: this.sessionData.language,
                domain: this.sessionData.domain,
                timestamp: Date.now()
            };
            localStorage.setItem('chat_session_data', JSON.stringify(sessionData));
        } catch (error) {
            console.warn('Failed to save session data:', error);
        }
    }

    /**
     * НОВОЕ: Уведомление о готовности чата
     */
    dispatchReadyEvent() {
        const event = new CustomEvent('chatBotReady', {
            detail: {
                sessionData: this.sessionData,
                fallbackMode: this.fallbackMode,
                isInitialized: this.isInitialized
            }
        });
        document.dispatchEvent(event);
    }

    /**
     * Получение приветственного сообщения
     */
    getWelcomeMessage() {
        if (this.fallbackMode) {
            return 'Willkommen! Unser Server ist momentan nicht erreichbar. Bitte hinterlassen Sie Ihre Anfrage über das Kontaktformular';
        }
        
        return 'Hallo! Ich bin Ihr KI-Assistent. Ich unterstütze Sie bei allen Fragen rund um Websites, Landingpages und KI-CRM-Systeme. Stellen Sie mir einfach Ihre Frage oder wählen Sie eine Option unten aus:';
    }

    /**
     * Поиск элементов DOM
     */
    findElements() {
        this.elements.popup = document.getElementById('chat-popup-wrap');
        if (!this.elements.popup) {
            throw new Error('Chat popup container #chat-popup-wrap not found');
        }

        // Ищем элементы внутри модального окна
        this.elements.messagesContainer = this.elements.popup.querySelector('.chat-messages, #chat-messages');
        this.elements.messageInput = this.elements.popup.querySelector('.chat-input, #chat-input');
        this.elements.sendButton = this.elements.popup.querySelector('.chat-send-btn, #chat-send-btn');
        this.elements.typingIndicator = this.elements.popup.querySelector('.typing-indicator, #typing-indicator');
        this.elements.contactForm = this.elements.popup.querySelector('.contact-form, #contact-form');
        this.elements.quickButtons = this.elements.popup.querySelector('.quick-buttons, #quick-buttons'); // ← ДОБАВЛЕНО

        if (this.elements.messageInput && this.elements.messageInput.getAttribute('maxlength').includes('$')) {
            this.elements.messageInput.setAttribute('maxlength', this.config.maxMessageLength);
        }
    }

    /**
     * Привязка событий
     */
    bindEvents() {
        // Отправка сообщения
        if (this.elements.sendButton) {
            this.elements.sendButton.addEventListener('click', () => this.sendMessage());
        }
        
        // Enter для отправки, Shift+Enter для новой строки
        if (this.elements.messageInput) {
            this.elements.messageInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    this.sendMessage();
                }
            });

            this.elements.messageInput.addEventListener('input', (e) => {
                this.autoResizeTextarea(e.target);
                this.updateSendButtonState();
            });
        }

        // Форма контактов
        const contactForm = this.elements.popup?.querySelector('#contact-form-data');
        if (contactForm) {
            contactForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.submitContactForm();
            });
        }

        // Обработчики для статичных кнопок
        this.bindQuickButtons();

        this.updateSendButtonState();
    }

    /**
     * Инициализация сессии с сервером
     */
    async initializeSession() {
        try {
            if (this.config.debug) {
                console.log('Initializing chat session...');
            }

            const response = await this.apiRequest('clientInit', {
                domain: this.config.domain
            });

            if (response.success) {
                this.sessionData = response.data;
                this.fallbackMode = response.data.fallback_mode || false;
                
                if (this.config.debug) {
                    console.log('Session initialized:', this.sessionData);
                }
                
                // Показываем приветственное сообщение
                this.showWelcomeMessage();
                
            } else {
                throw new Error(response.error || 'Initialisierungsfehler');
            }
        } catch (error) {
            console.error('Session initialization failed:', error);
            
            this.fallbackMode = true;
            this.sessionData = {
                welcome_message: 'Willkommen! Unser Server ist gerade nicht erreichbar. Bitte hinterlassen Sie Ihre Anfrage über das Formular'
            };
            
            this.showWelcomeMessage();
        }
    }

    /**
     * ИСПРАВЛЕНО: Улучшенная отправка сообщений с retry логикой
     */
    async sendMessage(messageText = null) {
        if (this.isProcessing) return;

        const message = messageText || this.elements.messageInput?.value?.trim();
        if (!message) return;

        try {
            this.isProcessing = true;
            
            // Очищаем поле ввода
            if (!messageText && this.elements.messageInput) {
                this.elements.messageInput.value = '';
                this.autoResizeTextarea(this.elements.messageInput);
            }
            this.updateSendButtonState();
            
            // Добавляем сообщение пользователя
            this.addMessage(message, 'user');
            
            // В fallback режиме сразу предлагаем контактную форму
            if (this.fallbackMode) {
                await this.addMessage('Danke für Ihre Nachricht! Um Ihnen antworten zu können, hinterlassen Sie bitte Ihre Kontaktdaten', 'bot');
                setTimeout(() => {
                    this.showContactForm(['name', 'email']);
                }, 1000);
                return;
            }
            
            // Показываем индикатор печати
            this.showTypingIndicator();
            
            // ИСПРАВЛЕНО: Отправляем с полными данными сессии и таймаутом
            const requestData = {
                message: message,
                page_slug: pageStructure.page_slug,
                domain: this.config.domain,
                session_id: this.sessionData.session_id,
                visitor_id: this.sessionData.visitor_id,
                device_type: this.sessionData.device_type,
                language: this.sessionData.language
            };

            if (this.config.debug) {
                console.log('Sending message with data:', requestData);
            }

            const response = await this.apiRequestWithTimeout('clientMessage', requestData, 15000);
            
            this.hideTypingIndicator();
            
            if (response && response.success) {
                const responseMessage = response.message || 'Antwort erhalten, aber der Text ist nicht verfügbar';
                
                await this.addMessage(responseMessage, 'bot');
                
                if (response.buttons && response.buttons.length > 0) {
                    this.renderActionButtons(response.buttons);
                }
                
                if (response.needs_escalation && response.contact_required?.length > 0) {
                    setTimeout(() => {
                        this.showContactForm(response.contact_required);
                    }, 500);
                }
                
            } else {
                const errorMessage = response?.error || 'Bei der Verarbeitung der Anfrage ist ein Fehler aufgetreten';
                this.addMessage(errorMessage, 'error');
                
                if (response?.buttons) {
                    this.renderActionButtons(response.buttons);
                } else {
                    this.showFallbackButtons(message);
                }
            }
            
        } catch (error) {
            this.hideTypingIndicator();
            console.error('Send message error:', error);
            
            this.addMessage('Vorübergehende Verbindungsprobleme. Bitte versuchen Sie es später erneut oder hinterlassen Sie Ihre Kontaktdaten', 'error');
            this.showFallbackButtons(message);
            
        } finally {
            this.isProcessing = false;
            this.updateSendButtonState();
        }
    }

    /**
     * НОВОЕ: API запрос с таймаутом
     */
    async apiRequestWithTimeout(endpoint, data, timeout = 10000) {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeout);

        try {
            const response = await fetch(`${this.config.apiBase}${endpoint}.php`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
                signal: controller.signal
            });

            clearTimeout(timeoutId);

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            return await response.json();

        } catch (error) {
            clearTimeout(timeoutId);
            
            if (error.name === 'AbortError') {
                throw new Error('Server-Timeout');
            }
            
            throw error;
        }
    }

    /**
     * НОВОЕ: Показ fallback кнопок при ошибках
     */
    showFallbackButtons(originalMessage) {
        this.renderActionButtons([
            {
                text: 'Erneut versuchen',
                action: 'retry_message',
                data: { message: originalMessage }
            },
            {
                text: 'Support kontaktieren',
                action: 'request_contact',
                data: { required_fields: ['name', 'email'], type: 'support' }
            },
            {
                text: 'Rückruf anfordern',
                action: 'request_contact',
                data: { required_fields: ['name', 'phone'], type: 'callback' }
            }
        ]);
    }

    /**
     * Добавление сообщения в чат
     */
    async addMessage(text, type = 'bot', delay = true) {
        if (!this.elements.messagesContainer) {
            console.warn('Messages container not found, cannot add message');
            return;
        }

        // ДОБАВИТЬ проверку текста
        if (!text || typeof text !== 'string') {
            console.warn('addMessage: invalid text provided', text);
            text = 'Nachricht kann nicht angezeigt werden';
        }

        const messageElement = document.createElement('div');
        messageElement.className = `message message-${type}`;
        
        const messageContent = document.createElement('div');
        messageContent.className = 'message-content';
        
        if (type === 'bot' && delay && !this.fallbackMode) {
            // Эффект печатания для бота (не в fallback режиме)
            messageContent.textContent = '';
            messageElement.appendChild(messageContent);
            this.elements.messagesContainer.appendChild(messageElement);
            this.scrollToBottom();
            
            await this.typeMessage(messageContent, text);
        } else {
            messageContent.textContent = text;
            messageElement.appendChild(messageContent);
            this.elements.messagesContainer.appendChild(messageElement);
            this.scrollToBottom();
        }
        
        // Добавляем время
        const timeElement = document.createElement('div');
        timeElement.className = 'message-time';
        timeElement.textContent = new Date().toLocaleTimeString('ru-RU', {
            hour: '2-digit',
            minute: '2-digit'
        });
        messageElement.appendChild(timeElement);
    }

    /**
     * Эффект печатания текста
     */
    async typeMessage(element, text, speed = 30) {
        return new Promise(resolve => {
            // ДОБАВИТЬ проверку на undefined/null
            if (!text || typeof text !== 'string') {
                console.warn('typeMessage: text is undefined or not a string', text);
                element.textContent = text || '';
                resolve();
                return;
            }

            let i = 0;
            const timer = setInterval(() => {
                if (i < text.length) {
                    element.textContent += text.charAt(i);
                    i++;
                    this.scrollToBottom();
                } else {
                    clearInterval(timer);
                    resolve();
                }
            }, speed);
        });
    }

    /**
     * Показ индикатора печати
     */
    showTypingIndicator() {
        if (this.elements.typingIndicator) {
            this.elements.typingIndicator.style.display = 'flex';
            this.scrollToBottom();
        }
    }

    /**
     * Скрытие индикатора печати
     */
    hideTypingIndicator() {
        if (this.elements.typingIndicator) {
            this.elements.typingIndicator.style.display = 'none';
        }
    }

    /**
     * Показ приветственного сообщения
     */
    async showWelcomeMessage() {
        if (this.sessionData.welcome_message) {
            await this.addMessage(this.sessionData.welcome_message, 'bot');
        }
    }

    /**
     * Отрисовка кнопок действий
     */
    renderActionButtons(buttons) {
        if (!buttons || buttons.length === 0 || !this.elements.messagesContainer) return;

        const buttonsContainer = document.createElement('div');
        buttonsContainer.className = 'action-buttons';
        
        buttons.forEach(button => {
            const buttonElement = document.createElement('button');
            buttonElement.className = 'action-button';
            buttonElement.textContent = button.text;
            buttonElement.onclick = () => this.handleButtonClick(button);
            buttonsContainer.appendChild(buttonElement);
        });

        this.elements.messagesContainer.appendChild(buttonsContainer);
        this.scrollToBottom();
    }

    /**
     * Обработка нажатия кнопки
     */
    handleButtonClick(button) {
        if (this.config.debug) {
            console.log('Action button clicked:', button);
        }

        if (!button || typeof button !== 'object') {
            console.error('Invalid button data:', button);
            return;
        }

        switch (button.action) {
            case 'send_message':
                if (button.data && button.data.message) {
                    const messageToSend = button.data.message;
                    if (typeof messageToSend === 'string' && messageToSend.trim()) {
                        this.sendMessage(messageToSend);
                    } else {
                        console.error('Invalid message in button data:', button.data);
                    }
                } else {
                    console.error('No message data in send_message button:', button);
                }
                break;
            case 'show_faq':
            case 'get_faq':
                this.handleFaqRequest();
                break;
                
            case 'get_calc':
                this.handleCalculatorRequest();
                break;
                
            case 'get_audit':
            case 'get_detector':
                this.handleAuditRequest();
                break;
                
            case 'request_contact':
            case 'request_callback':
                const requiredFields = button.data?.required_fields || ['email'];
                this.showContactForm(requiredFields);
                break;
                
            case 'new_message':
                if (this.elements.messageInput) {
                    this.elements.messageInput.focus();
                } else {
                    this.addMessage('Stellen Sie Ihre Frage:', 'bot');
                }
                break;
                
            case 'check_status':
                this.sendMessage('Status meiner Anfrage?');
                break;
                
            case 'retry_contact':
                this.showContactForm(['name', 'email']);
                break;
                
            case 'retry_message':
                if (button.data?.message) {
                    this.sendMessage(button.data.message);
                } else {
                    this.addMessage('Stellen Sie Ihre Frage bitte erneut:', 'bot');
                    if (this.elements.messageInput) {
                        this.elements.messageInput.focus();
                    }
                }
                break;
                
            case 'external_contact':
                this.handleExternalContact(button.data?.type);
                break;
                
            default:
                console.warn('Unknown action button action:', button.action);
                // Fallback для неизвестных действий
                this.addMessage('Ausgewählt: ' + (button.text || 'Unbekannte Aktion'), 'user');
                this.addMessage('Wie kann ich sonst noch helfen?', 'bot');
                
                this.renderActionButtons([
                    {
                        text: 'Berater kontaktieren',
                        action: 'request_contact',
                        data: { required_fields: ['email'] }
                    }
                ]);
                break;
        }
    }

    /**
     * Привязка обработчиков к статичным кнопкам
     */
    bindQuickButtons() {
        if (!this.elements.quickButtons) {
            console.warn('Quick buttons container not found');
            return;
        }

        // Находим все кнопки с data-action
        const quickButtons = this.elements.quickButtons.querySelectorAll('[data-action]');
        
        quickButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                const action = button.getAttribute('data-action');
                const text = button.textContent.trim();
                
                if (this.config.debug) {
                    console.log('Quick button clicked:', { action, text });
                }
                
                this.handleQuickButtonClick(action, text, button);
            });
        });

        console.log('Quick buttons bound:', quickButtons.length);
    }

    /**
     * Обработка нажатий на статичные кнопки
     */
    handleQuickButtonClick(action, text, buttonElement) {
        // Добавляем визуальную обратную связь
        this.animateButtonClick(buttonElement);

        switch (action) {
            case 'get_audit':
                this.handleAuditRequest();
                break;
                
            case 'get_calc':
                this.handleCalculatorRequest();
                break;
            
            case 'get_faq':
            case 'show_faq':
                this.handleFaqRequest();
                break;
                
            case 'request_callback':
                this.handleCallbackRequest();
                break;
                
            case 'request_contact':
                this.handleContactRequest();
                break;
                
            default:
                console.warn('Unknown quick button action:', action);
                this.sendMessage(`Выбрано: ${text}`);
        }
    }

    /**
     * Анимация нажатия кнопки
     */
    animateButtonClick(button) {
        button.style.transform = 'scale(0.95)';
        button.style.opacity = '0.7';
        
        setTimeout(() => {
            button.style.transform = '';
            button.style.opacity = '';
        }, 150);
    }

    /**
     * Обработчики для каждого типа кнопок
     */
    handleAuditRequest() {
        // Отправляем сообщение в чат для контекста
        this.addMessage('Express-Audit angefordert', 'user');
        this.addMessage('Ausgezeichnet! Das Express-Audit hilft Ihnen, Ihr Projekt schnell zu bewerten. Wir öffnen jetzt das Audit-Formular …', 'bot');
        
        // Открываем модальное окно аудита
        setTimeout(() => {
            chatPopupOpenHandler('detector', popupList);
        }, 4000);
    }

    handleFaqRequest() {
        // Отправляем сообщение в чат для контекста
        this.addMessage('FAQ angefordert', 'user');
        this.addMessage('Ausgezeichnet! Im FAQ-Bereich finden Sie Antworten auf häufige Fragen. Wir öffnen jetzt das FAQ-Fenster …', 'bot');
        
        // Открываем модальное окно аудита
        setTimeout(() => {
            chatPopupOpenHandler('detector', popupList);
        }, 4000);
    }

    handleCalculatorRequest() {
        this.addMessage('Kostenrechner angefordert', 'user');
        this.addMessage('Mit dem Kostenrechner können Sie die voraussichtlichen Kosten Ihres Projekts ermitteln. Er öffnet sich gleich …', 'bot');
        
        setTimeout(() => {
            chatPopupOpenHandler('calc', popupList);
        }, 4000);
    }

    handleCallbackRequest() {
        this.addMessage('Rückruf angefordert', 'user');
        this.addMessage('Ausgezeichnet! Bitte hinterlassen Sie Ihre Telefonnummer und die für Sie passende Zeit für den Rückruf', 'bot');
        
        // Показываем форму с обязательным полем телефона
        setTimeout(() => {
            this.showContactForm(['name', 'phone']);
        }, 0);
    }

    handleContactRequest() {
        this.addMessage('Kontakt mit einem Berater angefordert', 'user');
        this.addMessage('Unser Berater meldet sich bald bei Ihnen. Hinterlassen Sie einfach Ihre Kontaktdaten', 'bot');
        
        setTimeout(() => {
            this.showContactForm(['name', 'email']);
        }, 0);
    }

    /**
     * Отправка формы контактов
     */
    async submitContactForm() {
        const form = this.elements.popup.querySelector('#contact-form-data');
        if (!form) {
            console.error('Contact form not found');
            return;
        }

        // Проверяем согласие с политикой конфиденциальности
        if (window.privacyConsent && !window.privacyConsent.validateConsentBeforeSubmit()) {
            console.log('Privacy consent validation failed');
            return;
        }

        const formData = new FormData(form);
        const contactData = Object.fromEntries(formData.entries());

        if (this.config.debug) {
            console.log('Contact form data:', contactData);
        }

        // Валидация на клиенте
        if (!contactData.name?.trim()) {
            this.showFormError('Name eingeben');
            return;
        }

        if (!contactData.email?.trim() && !contactData.phone?.trim()) {
            this.showFormError('Bitte geben Sie Ihre E-Mail-Adresse oder Telefonnummer an');
            return;
        }

        if (contactData.email?.trim()) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(contactData.email.trim())) {
                this.showFormError('Bitte geben Sie eine gültige E-Mail-Adresse an');
                return;
            }
        }

        if (contactData.phone?.trim()) {
            const phoneRegex = /^[\+]?[\d\s\-\(\)]{7,15}$/;
            if (!phoneRegex.test(contactData.phone.trim())) {
                this.showFormError('Bitte geben Sie eine gültige Telefonnummer an');
                return;
            }
        }

        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn ? submitBtn.textContent : 'Absenden';

        try {
            // Отключаем форму
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.textContent = 'Wird gesendet...';
            }

            const requestData = {
                domain: this.config.domain,
                contact_data: {
                    name: contactData.name?.trim() || '',
                    email: contactData.email?.trim() || '',
                    phone: contactData.phone?.trim() || '',
                    telegram: contactData.telegram?.trim() || ''
                },
                type: 'consultation'
            };

            // Добавляем данные согласия если есть
            if (window.privacyConsent) {
                const consentData = window.privacyConsent.getConsentDataForServer();
                if (consentData) {
                    requestData.privacy_consent_data = consentData;
                }
            }

            if (this.config.debug) {
                console.log('Sending contact request:', requestData);
            }

            const response = await this.apiRequest('clientContact', requestData);

            if (this.config.debug) {
                console.log('Contact response:', response);
            }

            if (response.success) {
                this.hideContactForm();
                
                const successMessage = response.message || response.data?.message || 
                    'Danke! Ihre Anfrage ist bei uns eingegangen. Wir melden uns in Kürze bei Ihnen';
                
                await this.addMessage(successMessage, 'bot');
                
                // Показываем кнопки если есть
                if (response.buttons && response.buttons.length > 0) {
                    this.renderActionButtons(response.buttons);
                } else if (response.data?.buttons && response.data.buttons.length > 0) {
                    this.renderActionButtons(response.data.buttons);
                }
                
                // Очищаем форму
                form.reset();
                
            } else {
                const errorMessage = response.error || response.message || 'Fehler beim Senden der Daten';
                this.showFormError(errorMessage);
                
                if (this.config.debug) {
                    console.error('Contact form error:', response);
                }
            }

        } catch (error) {
            console.error('Contact form submission error:', error);
            
            let errorMessage = 'Verbindungsfehler. Bitte versuchen Sie es später erneut';
            
            if (error.message?.includes('HTTP 500')) {
                errorMessage = 'Unser Server ist momentan nicht erreichbar. Bitte versuchen Sie es später noch einmal oder rufen Sie uns an';
            } else if (error.message?.includes('HTTP 400')) {
                errorMessage = 'Bitte prüfen Sie, ob das Formular korrekt ausgefüllt ist';
            } else if (error.message?.includes('HTTP 403')) {
                errorMessage = 'Zugriff eingeschränkt. Bitte wenden Sie sich an den Administrator';
            }
            
            this.showFormError(errorMessage);
            
            setTimeout(() => {
                this.renderActionButtons([
                    {
                        text: 'Erneut versuchen',
                        action: 'retry_contact',
                        data: {}
                    },
                    {
                        text: 'Jetzt anrufen',
                        action: 'external_contact',
                        data: { type: 'phone' }
                    },
                    {
                        text: 'E-Mail schreiben',
                        action: 'external_contact',
                        data: { type: 'email' }
                    }
                ]);
            }, 2000);
            
        } finally {
            // Восстанавливаем кнопку
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.textContent = originalText;
            }
        }
    }

    /**
     * Показ формы контактов
     */
    showContactForm(requiredFields = ['email']) {
        const form = this.elements.contactForm;
        if (!form) {
            console.warn('Contact form not found');
            return;
        }

        // Настраиваем поля формы в зависимости от требований
        const emailField = form.querySelector('input[name="email"]');
        const phoneField = form.querySelector('input[name="phone"]');
        
        if (emailField) {
            emailField.required = requiredFields.includes('email');
            emailField.style.display = requiredFields.includes('email') ? 'block' : 'none';
        }
        
        if (phoneField) {
            phoneField.required = requiredFields.includes('phone');
            phoneField.style.display = requiredFields.includes('phone') ? 'block' : 'none';
        }

        // Добавляем чекбокс согласия с политикой конфиденциальности
        if (window.privacyConsent && window.privacyConsent.shouldShowConsentCheckbox()) {
            // Находим форму и добавляем согласие перед кнопками
            const formElement = form.querySelector('form');
            const buttonsContainer = form.querySelector('.form-buttons');
            
            if (formElement && buttonsContainer) {
                // Создаем контейнер для согласия если его нет
                let consentContainer = form.querySelector('.privacy-consent-container');
                if (!consentContainer) {
                    consentContainer = document.createElement('div');
                    consentContainer.className = 'privacy-consent-container';
                    consentContainer.id = 'privacy-consent-container';
                    formElement.insertBefore(consentContainer, buttonsContainer);
                }
                
                // Добавляем чекбокс согласия
                window.privacyConsent.createConsentCheckbox('privacy-consent-container');
            }
        }

        if (!localStorage.getItem('privacy_consent_given')) {
            let consContainer = form.querySelector('.privacy-consent-container');
            const maxFormHeight = form.scrollHeight + consContainer.scrollHeight;
            form.style.maxHeight = (maxFormHeight + 2) + "px";
        } else {
            form.style.maxHeight = form.scrollHeight + "px";
        }
        
        this.scrollToBottom();
        
        // Диспатчим событие для других обработчиков
        document.dispatchEvent(new CustomEvent('chatFormShow'));
        
        // Фокус на первое поле
        const firstField = form.querySelector('input[name="name"]');
        if (firstField) {
            setTimeout(() => firstField.focus(), 100);
        }
    }

    /**
     * Обработка модальных окон (FAQ, калькулятор, аудит)
     */
    handleModalAction(modalType, buttonText) {
        // Добавляем сообщение пользователя в чат для контекста
        this.addMessage(`Angefordert ${buttonText || modalType}`, 'user');
        
        // Сообщения бота в зависимости от типа модального окна
        const modalMessages = {
            'faq': 'Super! Im FAQ-Bereich finden Sie Antworten auf die häufigsten Fragen. Das FAQ-Fenster öffnet sich gleich …',
            'calc': 'Mit dem Kostenrechner können Sie die voraussichtlichen Kosten Ihres Projekts ermitteln. Er öffnet sich gleich …',
            'detector': 'Super! Mit dem Express-Audit können wir Ihr Projekt schnell einschätzen. Das Formular öffnet sich gleich …'
        };
        
        const message = modalMessages[modalType] || `Es wird geöffnet ${modalType}...`;
        this.addMessage(message, 'bot');
        
        // Проверяем доступность функции chatPopupOpenHandler
        if (typeof window.chatPopupOpenHandler === 'function' && typeof window.popupList !== 'undefined') {
            setTimeout(() => {
                try {
                    window.chatPopupOpenHandler(modalType, window.popupList);
                    
                    if (this.config.debug) {
                        console.log(`Modal ${modalType} opened successfully`);
                    }
                } catch (error) {
                    console.error(`Error opening modal ${modalType}:`, error);
                    this.addMessage('Entschuldigung, beim Öffnen des Fensters ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut', 'bot');
                    
                    // Предлагаем альтернативы
                    this.renderActionButtons([
                        {
                            text: 'Berater kontaktieren',
                            action: 'request_contact',
                            data: { required_fields: ['email'] }
                        },
                        {
                            text: 'Im Chat fragen',
                            action: 'new_message',
                            data: {}
                        }
                    ]);
                }
            }, 4000); // Задержка для эффекта "загрузки"
        } else {
            console.error('Modal handler functions not available');
            this.addMessage('Entschuldigung, die Funktion ist vorübergehend nicht verfügbar. Unser Berater wird Ihnen weiterhelfen!', 'bot');
            
            setTimeout(() => {
                this.showContactForm(['name', 'email']);
            }, 1000);
        }
    }

    /**
     * Скрытие формы контактов
     */
    hideContactForm() {
        if (this.elements.contactForm) {
            this.elements.contactForm.style.maxHeight = '0';
        }
    }

    /**
     * Показ ошибки в форме
     */
    showFormError(message) {
        if (!this.elements.contactForm) return;

        // Удаляем предыдущие ошибки
        const existingError = this.elements.contactForm.querySelector('.form-error');
        if (existingError) {
            existingError.remove();
        }

        // Добавляем новую ошибку
        const errorElement = document.createElement('div');
        errorElement.className = 'form-error';
        errorElement.textContent = message;
        
        const form = this.elements.contactForm.querySelector('form');
        if (form) {
            form.insertBefore(errorElement, form.firstChild);
            
            // Убираем ошибку через 5 секунд
            setTimeout(() => {
                if (errorElement.parentNode) {
                    errorElement.remove();
                }
            }, 5000);
        }
    }

    /**
     * Обработка внешних контактов
     */
    handleExternalContact(type) {
        if (this.config.debug) {
            console.log('External contact:', type);
        }

        switch (type) {
            case 'email':
                // Показываем сообщение и открываем email
                this.addMessage('E-Mail-Client wird geöffnet...', 'bot');
                setTimeout(() => {
                    window.location.href = 'mailto:info@relanding.de?subject=Frage from Website&body=Hallo! Ich habe eine Frage...';
                }, 1000);
                break;
                
            case 'phone':
                // Показываем сообщение и предлагаем позвонить
                this.addMessage('Unsere Nummer: +49-1525-94-65-402. Rufen Sie uns gleich an!', 'bot');
                setTimeout(() => {
                    if (confirm(`Unter der Nummer +49-1525-94-65-402 anrufen?`)) {
                        window.location.href = 'tel:+4915259465402';
                    }
                }, 1000);
                break;
                
            case 'telegram':
                // Открываем Telegram
                this.addMessage('Telegram wird geöffnet...', 'bot');
                setTimeout(() => {
                    // Попробуем открыть приложение Telegram, если не получится - веб-версию
                    const telegramApp = 'tg://resolve?domain=briemchainai'; // Замените на реальный
                    const telegramWeb = 'https://t.me/briemchainai'; // Замените на реальный
                    
                    // Сначала пробуем приложение
                    const link = document.createElement('a');
                    link.href = telegramApp;
                    link.click();
                    
                    // Если не сработало, через 2 секунды открываем веб-версию
                    setTimeout(() => {
                        window.open(telegramWeb, '_blank');
                    }, 2000);
                }, 1000);
                break;
                
            default:
                console.warn('Unknown external contact type:', type);
                this.addMessage('Nehmen Sie Kontakt mit uns auf – so, wie es Ihnen am besten passt:', 'bot');
                
                // Показываем все варианты связи
                this.renderActionButtons([
                    {
                        text: 'Anrufen',
                        action: 'external_contact',
                        data: { type: 'phone' }
                    },
                    {
                        text: 'Email',
                        action: 'external_contact',
                        data: { type: 'email' }
                    },
                    {
                        text: 'Telegram',
                        action: 'external_contact',
                        data: { type: 'telegram' }
                    }
                ]);
                break;
        }
    }

    /**
     * Автоизменение размера textarea
     */
    autoResizeTextarea(textarea) {
        if (!textarea) return;
        textarea.style.height = 'auto';
        textarea.style.height = Math.min(textarea.scrollHeight, 120) + 'px';
    }

    /**
     * Обновление состояния кнопки отправки
     */
    updateSendButtonState() {
        if (!this.elements.sendButton || !this.elements.messageInput) return;
        
        const hasText = this.elements.messageInput.value.trim().length > 0;
        const isEnabled = hasText && !this.isProcessing;
        
        this.elements.sendButton.disabled = !isEnabled;
        this.elements.sendButton.className = isEnabled ? 
            'chat-send-btn active' : 'chat-send-btn';
    }

    /**
     * Прокрутка к последнему сообщению
     */
    scrollToBottom() {
        if (this.elements.messagesContainer) {
            this.elements.messagesContainer.scrollTop = this.elements.messagesContainer.scrollHeight;
        }
    }

    /**
     * Показ ошибки в чате
     */
    showError(message) {
        this.addMessage(message, 'error');
    }

    /**
     * API запрос с повторными попытками
     */
    async apiRequest(endpoint, data = {}, attempt = 1) {
        try {
            if (this.config.debug) {
                console.log(`API Request (attempt ${attempt}): ${endpoint}`, data);
            }

            const url = `${this.config.apiBase}${endpoint}.php`;
            
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });

            if (this.config.debug) {
                console.log(`API Response status: ${response.status} ${response.statusText}`);
            }

            if (!response.ok) {
                // Попытаемся получить тело ответа для более детальной ошибки
                let errorBody = '';
                try {
                    errorBody = await response.text();
                    if (this.config.debug) {
                        console.log('Error response body:', errorBody);
                    }
                } catch (e) {
                    // Игнорируем ошибки чтения тела ответа
                }
                
                throw new Error(`HTTP ${response.status}: ${response.statusText}${errorBody ? ' - ' + errorBody.substring(0, 100) : ''}`);
            }

            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                const text = await response.text();
                console.error('Non-JSON response received:', text);
                throw new Error('Server returned non-JSON response');
            }

            const result = await response.json();
            
            if (this.config.debug) {
                console.log(`API Response: ${endpoint}`, result);
            }

            // Дополнительная валидация структуры ответа
            if (typeof result !== 'object' || result === null) {
                throw new Error('Invalid response structure');
            }

            return result;

        } catch (error) {
            console.error(`API request failed (attempt ${attempt}/${this.config.retryAttempts}):`, error);
            
            // Логируем детали ошибки
            if (this.config.debug) {
                console.error('Error details:', {
                    endpoint,
                    data,
                    attempt,
                    error: error.message,
                    stack: error.stack
                });
            }
            
            if (attempt < this.config.retryAttempts) {
                // Exponential backoff
                const delay = Math.pow(2, attempt) * 1000;
                if (this.config.debug) {
                    console.log(`Retrying in ${delay}ms...`);
                }
                await new Promise(resolve => setTimeout(resolve, delay));
                return this.apiRequest(endpoint, data, attempt + 1);
            }
            
            throw error;
        }
    }

    /**
     * Публичные методы для управления чатом
     */
    open() {
        if (!this.elements.popup) return;

        this.elements.popup.classList.add('show', 'active');
        
        // Фокус на поле ввода
        setTimeout(() => {
            if (this.elements.messageInput) {
                this.elements.messageInput.focus();
            }
        }, 300);
    }

    close() {
        if (!this.elements.popup) return;

        // Интеграция с вашей системой модальных окон
        this.elements.popup.classList.remove('show', 'active');
    }

    /**
     * Получение статистики чата
     */
    getChatStats() {
        return {
            isInitialized: this.isInitialized,
            isProcessing: this.isProcessing,
            fallbackMode: this.fallbackMode,
            messagesCount: this.elements.messagesContainer ? 
                          this.elements.messagesContainer.children.length : 0,
            sessionData: this.sessionData
        };
    }

    /**
     * Очистка чата
     */
    clearChat() {
        if (this.elements.messagesContainer) {
            this.elements.messagesContainer.innerHTML = '';
        }
        this.hideContactForm();
    }

    /**
     * Уничтожение экземпляра чата
     */
    destroy() {
        // Очищаем события
        if (this.elements.sendButton) {
            this.elements.sendButton.removeEventListener('click', this.sendMessage);
        }
        if (this.elements.messageInput) {
            this.elements.messageInput.removeEventListener('keydown', this.sendMessage);
        }
        
        // Очищаем данные
        this.sessionData = {};
        this.messageQueue = [];
        this.isInitialized = false;
    }
}

// Создаем глобальный экземпляр для интеграции с widget.js
if (typeof window !== 'undefined') {
    // Ждем готовности DOM и данных
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            setTimeout(() => {
                window.chatBot = new ChatBot();
            }, 100); // Небольшая задержка для инициализации pageStructure
        });
    } else {
        // DOM уже готов
        setTimeout(() => {
            window.chatBot = new ChatBot();
        }, 100);
    }
}