# Быстрый старт (AmneziaWG 3.1)

Минимальные шаги для ветки **`amnezia-wg-docker-v01`** (образ `myceliummesh/amneziawg-ui:3.1`).

## 1. Окружение

```bash
cd /путь/к/amnezia-wg-docker
git checkout amnezia-wg-docker-v01
cp .env.example .env
```

Если рядом лежат данные от **AWG 2.0**, переименуйте каталог:

```bash
mv awg-data awg-data-v2-backup   # если был
```

## 2. Обязательные переменные

| Переменная | Что указать |
|------------|-------------|
| `WEB_UI_PASSWORD` | **base64(SHA-256(пароль))** для входа в панель, не открытый пароль. |
| `WEB_UI_USER` | Логин (по умолчанию `admin`). |
| `DEFAULT_PORT` | UDP-порт VPN (в шаблоне `443`; должен совпасть с пробросом в compose). |

### Сгенерировать WEB_UI_PASSWORD

```bash
printf 'ваш-пароль' | openssl dgst -binary -sha256 | base64
```

Вставьте вывод в `.env` как `WEB_UI_PASSWORD=...`.

В шаблоне лежит хэш от пароля **`changeme`** — смените его.

## 3. DNS и фаервол

- **DNS A-запись** (если используете имя) → IP сервера с Docker.
- **UDP `DEFAULT_PORT`** — открыть клиентам (роутер/фаервол).
- **TCP `WEB_UI_PORT`** — в compose только на `127.0.0.1`, наружу не открывать.

## 4. Запуск

```bash
docker compose pull
docker compose up -d
```

## 5. Веб-интерфейс через SSH

```bash
ssh -f -N -L 54845:127.0.0.1:54845 пользователь@vpn.example.com
```

В браузере на своём ПК: `http://127.0.0.1:54845`  
Логин/пароль — из `.env` (`WEB_UI_USER` + исходный пароль, из которого сделали хэш).

Если в `.env` другой `WEB_UI_PORT`, подставьте его в `-L` и в URL.

## 6. Первый сервер и клиенты

1. В UI создайте VPN-сервер (endpoint = ваш публичный хост, порт = `DEFAULT_PORT`).
2. Создайте клиента, скачайте `.conf` / QR.
3. Импортируйте в **AmneziaVPN ≥ 5.0.1.5**.

Параметры 3.1 (Header Protection, Random Trailers и т.д.) панель включает сама; MTU по умолчанию из `.env` — **1280**.

Скрипт `seed-clients.sh` от стека 2.0 (API awg-easy) **с этой панелью не совместим** — клиентов создавайте в UI.

## Проверка

```bash
docker compose ps
docker compose logs -f
docker exec awg-with-ui awg show
```

Есть `latest handshake` — параметры сошлись. Нет handshake — смотрите совпадение секретов/флагов на клиенте и сервере (см. [статью](https://habr.com/ru/articles/1080342/)).

## Что дальше

Подробности — в **[README.md](README.md)** и **`.env.example`**.
