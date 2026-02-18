/**
 * Модуль для обработки согласия с политикой конфиденциальности
 * Соответствует требованиям ФЗ-152 "О персональных данных"
 */

class PrivacyConsentHandler {
    constructor() {
        this.storageKey = 'privacy_consent_given';
        this.consentVersion = '1.0'; // Версия политики конфиденциальности
        this.consentExpireDays = 365; // Согласие действует год
        this.isRequired = true; // Обязательное согласие для РФ
        
        this.init();
    }

    init() {
        // Проверяем, есть ли уже сохраненное согласие
        const existingConsent = this.getStoredConsent();
        
        if (existingConsent && this.isConsentValid(existingConsent)) {
            console.log('Privacy consent already given and valid');
            this.consentGiven = true;
        } else {
            this.consentGiven = false;
            console.log('Privacy consent required');
        }
    }

    /**
     * Проверка валидности сохраненного согласия
     */
    isConsentValid(consent) {
        if (!consent || !consent.version || !consent.timestamp) {
            return false;
        }

        // Проверяем версию политики
        if (consent.version !== this.consentVersion) {
            return false;
        }

        // Проверяем срок действия согласия
        const consentDate = new Date(consent.timestamp);
        const now = new Date();
        const daysDiff = (now - consentDate) / (1000 * 60 * 60 * 24);

        return daysDiff <= this.consentExpireDays;
    }

    /**
     * Получение сохраненного согласия
     */
    getStoredConsent() {
        try {
            const stored = localStorage.getItem(this.storageKey);
            return stored ? JSON.parse(stored) : null;
        } catch (error) {
            console.warn('Error reading privacy consent:', error);
            return null;
        }
    }

    /**
     * Сохранение согласия
     */
    saveConsent() {
        try {
            const consentData = {
                version: this.consentVersion,
                timestamp: new Date().toISOString(),
                given: true,
                userAgent: navigator.userAgent,
                ip: 'client-side' // IP будет зафиксирован на сервере
            };

            localStorage.setItem(this.storageKey, JSON.stringify(consentData));
            this.consentGiven = true;
            
            console.log('Privacy consent saved successfully');
            return true;
        } catch (error) {
            console.error('Error saving privacy consent:', error);
            return false;
        }
    }

    /**
     * Отзыв согласия
     */
    revokeConsent() {
        try {
            localStorage.removeItem(this.storageKey);
            this.consentGiven = false;
            console.log('Privacy consent revoked');
            return true;
        } catch (error) {
            console.error('Error revoking consent:', error);
            return false;
        }
    }

    /**
     * Проверка необходимости показа чекбокса согласия
     */
    shouldShowConsentCheckbox() {
        return this.isRequired && !this.consentGiven;
    }

    /**
     * Создание HTML элемента согласия
     */
    createConsentCheckbox(containerId) {
        if (!this.shouldShowConsentCheckbox()) {
            return null;
        }

        const container = document.getElementById(containerId);
        if (!container) {
            console.error('Container for privacy consent not found:', containerId);
            return null;
        }

        // Удаляем существующий чекбокс если есть
        const existing = container.querySelector('.privacy-consent-wrapper');
        if (existing) {
            existing.remove();
        }

        const wrapper = document.createElement('div');
        wrapper.className = 'privacy-consent-wrapper';
        wrapper.innerHTML = `
            <label class="privacy-consent-label">
                <input type="checkbox" id="privacy-consent-checkbox" required>
                <span class="checkmark"></span>
                <span class="consent-text">
                    Ich willige in die 
                    <a href="https://relanding.de/legal/privacy" target="_blank" class="privacy-link">Verarbeitung meiner personenbezogenen Daten</a>
                    gemäß der Datenschutz-Grundverordnung (DSGVO) ein.
                </span>
            </label>
        `;

        container.appendChild(wrapper);

        // Добавляем обработчик события
        const checkbox = wrapper.querySelector('#privacy-consent-checkbox');
        checkbox.addEventListener('change', (e) => {
            this.handleConsentChange(e.target.checked);
        });

        container.style.maxHeight = (wrapper.scrollHeight + 2) + "px";

        return wrapper;
    }

    /**
     * Обработка изменения состояния чекбокса
     */
    handleConsentChange(isChecked) {
        if (isChecked) {
            this.saveConsent();
            
            // Скрываем чекбокс после согласия
            const wrapper = document.querySelector('.privacy-consent-wrapper');
            if (wrapper) {
                wrapper.parentElement.style.maxHeight = null;
            }
            
            // Уведомляем другие компоненты о даче согласия
            document.dispatchEvent(new CustomEvent('privacyConsentGiven', {
                detail: { timestamp: new Date().toISOString() }
            }));
        }
    }

    /**
     * Проверка наличия согласия перед отправкой данных
     */
    validateConsentBeforeSubmit() {
        if (!this.isRequired) {
            return true;
        }

        if (this.consentGiven) {
            return true;
        }

        // Проверяем состояние чекбокса
        const checkbox = document.querySelector('#privacy-consent-checkbox');
        if (checkbox && checkbox.checked) {
            this.saveConsent();
            return true;
        }

        // Показываем ошибку
        this.showConsentError();
        return false;
    }

    /**
     * Показ ошибки о необходимости согласия
     */
    showConsentError() {
        const errorMessage = 'Für die Übermittlung personenbezogener Daten ist Ihre Einwilligung in deren Verarbeitung erforderlich';
        
        // Пытаемся найти контейнер для ошибок
        let errorContainer = document.querySelector('.privacy-consent-error');
        
        if (!errorContainer) {
            errorContainer = document.createElement('div');
            errorContainer.className = 'privacy-consent-error';
            errorContainer.style.cssText = `
                color: #e74c3c;
                font-size: 12px;
                margin-top: 5px;
                padding: 8px;
                background: #ffeaea;
                border-radius: 4px;
                border-left: 3px solid #e74c3c;
            `;
            
            const wrapper = document.querySelector('.privacy-consent-wrapper');
            if (wrapper) {
                wrapper.appendChild(errorContainer);
            }
        }
        
        errorContainer.textContent = errorMessage;
        errorContainer.style.display = 'block';
        
        // Скрываем ошибку через 5 секунд
        setTimeout(() => {
            if (errorContainer) {
                errorContainer.style.display = 'none';
            }
        }, 5000);
    }

    /**
     * Получение данных согласия для отправки на сервер
     */
    getConsentDataForServer() {
        const consent = this.getStoredConsent();
        if (!consent || !this.consentGiven) {
            return null;
        }

        return {
            privacy_consent: true,
            consent_version: consent.version,
            consent_timestamp: consent.timestamp,
            consent_user_agent: consent.userAgent
        };
    }
}