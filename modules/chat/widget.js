/**
 * Chat Widget - Упрощенный виджет для встраивания чата на сайт
 * Версия для тестовой модели - минимальная функциональность
 */

(function() {
    'use strict';
    
    // Конфигурация виджета
    const WIDGET_CONFIG = {
        // Автоматическое открытие через N секунд (0 = не открывать)
        autoOpenDelay: 0,
        
        // Включить звуковые уведомления
        soundNotifications: false,
        
        // Сохранение состояния чата в localStorage
        persistentSession: false,
        
        // Debug режим
        debug: true
    };

    class ChatWidget {
        constructor(config = {}) {
            this.config = { ...WIDGET_CONFIG, ...config };
            this.isLoaded = false;
            this.chatBot = null;
            
            this.init();
        }

        /**
         * Инициализация виджета
         */
        init() {
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', () => this.onDOMReady());
            } else {
                this.onDOMReady();
            }
        }

        /**
         * Обработчик готовности DOM
         */
        onDOMReady() {
            try {
                // Проверяем наличие модального окна чата
                if (!this.checkChatModal()) {
                    console.error('Chat modal #chat-popup-wrap not found');
                    return;
                }

                // Ждем инициализации ChatBot из main_control.js
                this.waitForChatBot();
                
                // Настраиваем автооткрытие
                this.setupAutoOpen();
                
                // Восстанавливаем сессию если включено
                this.restoreSession();
                
                if (this.config.debug) {
                    console.log('Chat widget initialized successfully');
                }
                
            } catch (error) {
                console.error('Chat widget initialization failed:', error);
            }
        }

        /**
         * Проверка наличия модального окна чата
         */
        checkChatModal() {
            return document.getElementById('chat-popup-wrap') !== null;
        }

        /**
         * Ожидание инициализации ChatBot из main_control.js
         */
        waitForChatBot() {
            const checkChatBot = () => {
                if (window.chatBot && typeof window.chatBot.open === 'function') {
                    this.chatBot = window.chatBot;
                    this.isLoaded = true;
                    this.onChatReady();
                } else {
                    // Проверяем каждые 100ms в течение 10 секунд
                    setTimeout(checkChatBot, 100);
                }
            };
            
            checkChatBot();
        }

        /**
         * Обработчик готовности чата
         */
        onChatReady() {
            if (this.config.debug) {
                console.log('Chat widget ready, ChatBot connected');
            }
            
            // Уведомляем другие скрипты о готовности
            const event = new CustomEvent('chatWidgetReady', {
                detail: { 
                    widget: this, 
                    chatBot: this.chatBot,
                    isReady: true
                }
            });
            document.dispatchEvent(event);
        }

        /**
         * Настройка автооткрытия чата
         */
        setupAutoOpen() {
            if (this.config.autoOpenDelay <= 0) {
                return;
            }
            
            // Проверяем, не открывался ли чат в этой сессии
            const hasOpenedBefore = sessionStorage.getItem('chat-auto-opened');
            if (hasOpenedBefore) {
                return;
            }
            
            setTimeout(() => {
                if (this.isLoaded && !this.isChatOpen()) {
                    this.openChat();
                    sessionStorage.setItem('chat-auto-opened', 'true');
                }
            }, this.config.autoOpenDelay * 1000);
        }

        /**
         * Восстановление сессии
         */
        restoreSession() {
            if (!this.config.persistentSession) {
                return;
            }
            
            try {
                const savedSession = localStorage.getItem('chat-session');
                if (savedSession) {
                    const sessionData = JSON.parse(savedSession);
                    if (this.config.debug) {
                        console.log('Chat session restored', sessionData);
                    }
                }
            } catch (error) {
                console.warn('Failed to restore chat session:', error);
            }
        }

        /**
         * Сохранение сессии
         */
        saveSession() {
            if (!this.config.persistentSession || !this.chatBot) {
                return;
            }
            
            try {
                const sessionData = {
                    timestamp: Date.now(),
                    stats: this.chatBot.getChatStats ? this.chatBot.getChatStats() : null
                };
                localStorage.setItem('chat-session', JSON.stringify(sessionData));
            } catch (error) {
                console.warn('Failed to save chat session:', error);
            }
        }

        /**
         * Открытие чата
         */
        openChat() {
            if (!this.isLoaded || !this.chatBot) {
                console.warn('Chat not ready yet');
                return false;
            }
            
            try {
                this.chatBot.open();
                this.trackEvent('chat_opened');
                return true;
            } catch (error) {
                console.error('Failed to open chat:', error);
                return false;
            }
        }

        /**
         * Закрытие чата
         */
        closeChat() {
            if (!this.isLoaded || !this.chatBot) {
                return false;
            }
            
            try {
                this.chatBot.close();
                this.saveSession();
                this.trackEvent('chat_closed');
                return true;
            } catch (error) {
                console.error('Failed to close chat:', error);
                return false;
            }
        }

        /**
         * Проверка, открыт ли чат
         */
        isChatOpen() {
            const modal = document.getElementById('chat-popup-wrap');
            return modal && (
                modal.classList.contains('active') || 
                modal.style.display === 'block' ||
                modal.offsetParent !== null
            );
        }

        /**
         * Отправка сообщения программно
         */
        sendMessage(message) {
            if (!this.isLoaded || !this.chatBot || !this.chatBot.sendMessage) {
                console.warn('Chat not ready for sending messages');
                return false;
            }
            
            try {
                // Открываем чат если закрыт
                if (!this.isChatOpen()) {
                    this.openChat();
                }
                
                // Небольшая задержка для анимации открытия
                setTimeout(() => {
                    this.chatBot.sendMessage(message);
                }, 300);
                
                return true;
            } catch (error) {
                console.error('Failed to send message:', error);
                return false;
            }
        }

        /**
         * Отслеживание событий
         */
        trackEvent(eventName, data = {}) {
            if (this.config.debug) {
                console.log('Chat event:', eventName, data);
            }
            
            // Интеграция с аналитикой
            try {
                // Google Analytics
                if (typeof gtag !== 'undefined') {
                    gtag('event', eventName, {
                        event_category: 'chat_widget',
                        ...data
                    });
                }
                
                // Яндекс.Метрика
                if (typeof ym !== 'undefined' && window.METRIKA_ID) {
                    ym(window.METRIKA_ID, 'reachGoal', eventName, data);
                }
            } catch (error) {
                console.warn('Analytics tracking failed:', error);
            }
        }

        /**
         * Получение статистики виджета
         */
        getStats() {
            return {
                isLoaded: this.isLoaded,
                isChatOpen: this.isChatOpen(),
                config: this.config,
                chatBot: !!this.chatBot,
                chatStats: this.chatBot && this.chatBot.getChatStats ? 
                          this.chatBot.getChatStats() : null
            };
        }

        /**
         * Обновление конфигурации
         */
        updateConfig(newConfig) {
            this.config = { ...this.config, ...newConfig };
            
            if (this.config.debug) {
                console.log('Chat widget config updated:', newConfig);
            }
        }

        /**
         * Проверка готовности
         */
        isReady() {
            return this.isLoaded && !!this.chatBot;
        }

        /**
         * Уничтожение виджета
         */
        destroy() {
            try {
                if (this.chatBot && this.chatBot.destroy) {
                    this.chatBot.destroy();
                }
                
                this.isLoaded = false;
                this.chatBot = null;
                
                if (this.config.debug) {
                    console.log('Chat widget destroyed');
                }
            } catch (error) {
                console.error('Error destroying chat widget:', error);
            }
        }
    }

    // Создаем глобальный экземпляр виджета
    window.chatWidget = new ChatWidget();
    
    // Глобальные функции для совместимости с существующим кодом
    window.openChat = function() {
        if (window.chatWidget) {
            return window.chatWidget.openChat();
        }
        console.warn('Chat widget not available');
        return false;
    };
    
    window.closeChat = function() {
        if (window.chatWidget) {
            return window.chatWidget.closeChat();
        }
        console.warn('Chat widget not available');
        return false;
    };

    // Дополнительные глобальные функции
    window.sendChatMessage = function(message) {
        if (window.chatWidget) {
            return window.chatWidget.sendMessage(message);
        }
        console.warn('Chat widget not available');
        return false;
    };

    window.getChatStats = function() {
        if (window.chatWidget) {
            return window.chatWidget.getStats();
        }
        return null;
    };
    
    // Экспорт для модульных систем
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = ChatWidget;
    }

})();