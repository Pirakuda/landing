# 📋 Инструкция по работе с проектом Landing

---

## 🖥️ Конфигурация машин

| Машина | ОС | Проект |
|--------|-----|--------|
| ПК (стационарный) | Ubuntu | `/var/www/landing/` |
| Ноутбук | Windows + XAMPP | `D:\XAMPP\htdocs\web_eco_de\` |

---

## 🚀 Запуск проекта

### Dresden ПК (Ubuntu)

```bash
http://localhost/landing/ # открыть в браузере

cd ~/projects/landing # терминал
mysql -u admin -p'1234567' relanding_db

# Пуш на гитхаб
git add .
git commit -m "описание что сделал"
git push

# Hetzner Landing
cd /var/www/briemchain.ai
sudo git pull

# config edit
sudo nano /var/www/briemchain.ai/config/config.php
```

### ПК (Ubuntu)

```bash
# Проверить что сервисы запущены
sudo systemctl status nginx
sudo systemctl status mysql

# Если не запущены — запустить
sudo systemctl start nginx
sudo systemctl start mysql

# Dresden PC
cd ~/projects/landing
http://localhost/landing/ # открыть в браузере 
```
---

Открыть в браузере: **http://localhost:8080/web_eco_de/**

### Ноутбук (Windows + XAMPP)

1. Открыть **XAMPP Control Panel**
2. Запустить **Apache** и **MySQL**
3. Открыть в браузере: **http://localhost/web_eco_de/**

---

## 🗄️ База данных

### ПК (Ubuntu) — через терминал

```bash
mysql -u admin -p'z2hD!8XFAfUzJHAEgN1BPfjs' bcai_page_db
```

### ПК (Ubuntu) — через phpMyAdmin (если установлен)

```
http://localhost:8080/phpmyadmin/
Логин: admin
Пароль: z2hD!8XFAfUzJHAEgN1BPfjs
```

### Ноутбук — через phpMyAdmin (XAMPP)

```
http://localhost/phpmyadmin/
```

### Когда обновлять дамп БД

Если изменил структуру таблиц — экспортируй дамп и закоммить:

**На ПК:**
```bash
mysqldump -u admin -p'z2hD!8XFAfUzJHAEgN1BPfjs' bcai_page_db > /var/www/landing/database/backups/relanding_db.sql
```

**На ноутбуке** — через phpMyAdmin → Export → Quick → SQL → Go, сохранить в `database/backups/relanding_db.sql`

---

## 🔄 Сценарии синхронизации

---

### 📌 Сценарий 1: Работал на ПК → сохранить на GitHub

```bash
cd /var/www/landing

git add .
git commit -m "описание что сделал"
git push
```

---

### 📌 Сценарий 2: Переключился на ноутбук → подтянуть актуальный код

```bash
cd /d/XAMPP/htdocs/web_eco_de

git pull
```

Продолжаешь работать на ноутбуке. Когда закончил:

```bash
git add .
git commit -m "описание что сделал"
git push
```

---

### 📌 Сценарий 3: Переключился обратно на ПК → подтянуть актуальный код

```bash
cd /var/www/landing

git pull
```

Продолжаешь работать на ПК. Когда закончил:

```bash
git add .
git commit -m "описание что сделал"
git push
```

---

## ⚠️ Важные правила

**Всегда перед началом работы делай `git pull`** — чтобы не работать на устаревшем коде и не получить конфликты.

**Никогда не коммить:**
- `config/config.php` — реальные пароли (уже в `.gitignore`)
- Дампы с реальными данными пользователей

**`config.php` настраивается отдельно на каждой машине** — в git хранится только `config.example.php` с заглушками.

---

## 📁 Структура конфига на каждой машине

### ПК (Ubuntu) — `/var/www/landing/config/config.php`

```php
const SERVERNAME = "localhost";
const USERNAME = "admin";
const PASSWORD = "";
const DBNAME = "bcai_page_db";
```

### Ноутбук (XAMPP) — `D:\XAMPP\htdocs\web_eco_de\config\config.php`

```php
const SERVERNAME = "localhost";
const USERNAME = "root";
const PASSWORD = "";
const DBNAME = "relanding_db";
```

---

## 🛠️ Полезные команды Git

```bash
git status          # что изменилось
git log --oneline   # история коммитов
git diff            # что конкретно изменилось в файлах
git pull            # подтянуть изменения с GitHub
git push            # отправить изменения на GitHub
```
