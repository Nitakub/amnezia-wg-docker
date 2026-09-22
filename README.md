# AmneziaWG 3.1 + веб-интерфейс (Docker)

Ветка **`amnezia-wg-docker-v01`**: обвязка вокруг образа
**[myceliummesh/amneziawg-ui:3.1](https://hub.docker.com/r/myceliummesh/amneziawg-ui)** —
userspace AmneziaWG **3.1** (header protection + random trailers) и лёгкая веб-панель.

Ветка **`main`** в этом репозитории остаётся на стеке **AWG 2.0** (`awg-2.0-with-ui`) и этими изменениями не затрагивается.

Конспект миграции 2.0 → 3.1: [Habr](https://habr.com/ru/articles/1080342/).

## Быстрый старт

Пошагово — **[quickstart.md](quickstart.md)**.

## Требования

- **Docker** и **Docker Compose** (plugin `docker compose`).
- **`/dev/net/tun`**, capabilities `NET_ADMIN`, `SYS_MODULE` (см. `docker-compose.yml`).
- **VPN (UDP):** снаружи доступны хост и **`DEFAULT_PORT`** (проброс на роутере/фаерволе).
- **Веб-UI (TCP):** по умолчанию только **`127.0.0.1`** — в интернет не выставлен; доступ через **SSH port forwarding**.
- Клиенты: **AmneziaVPN ≥ 5.0.1.5** (или другой клиент с AWG 3.1). Профили 2.0 / обычный WireGuard **не подойдут**.

## Структура

| Файл / каталог | Назначение |
|----------------|------------|
| `docker-compose.yml` | Сервис `myceliummesh/amneziawg-ui:3.1`, порты, том |
| `.env.example` | Шаблон переменных (можно коммитить) |
| `.env` | Секреты и настройки (**не коммитить**) |
| `awg-data/` | Состояние панели и туннелей на хосте (**не коммитить**) |

## Конфигурация

1. `cp .env.example .env`
2. Сгенерируйте `WEB_UI_PASSWORD` (base64 от SHA-256 пароля) — см. `.env.example` / quickstart.
3. При необходимости смените `DEFAULT_PORT` (UDP VPN), `DEFAULT_MTU` (для 3.1 лучше **1280**), подсеть и DNS.

Параметры обфускации 3.1 (`HeaderProtectionKey`, `RandomTrailers`, `S1`–`S4` ≥ 12 и т.д.)
задаются **в панели при создании сервера**, а не списком `JC`/`H1` как в ветке 2.0.

## Запуск

```bash
docker compose pull
docker compose up -d
```

Логи: `docker compose logs -f`  
Остановка: `docker compose down`

Каталог `./awg-data` при обновлении образа обычно сохраняется. **Не монтируйте сюда данные от AWG 2.0** — протокол другой, нужны новые сервер и клиенты.

## Миграция с AWG 2.0 (main / старый сервер)

1. Оставьте старый контейнер 2.0 работать (другой порт/имя), пока не раздадите ключи 3.1.
2. Поднимите этот стек на **чистом** `./awg-data` (или переименуйте старую папку).
3. В UI создайте сервер, раздайте новые конфиги.
4. Когда все перешли — остановите контейнер 2.0.

Включение header protection на «живом» конфиге 2.0 без перевыпуска клиентов оборвёт всех сразу.

## Безопасность

- Не публикуйте `.env` и `awg-data/`.
- Смените пароль UI (`changeme` из примера).
- Веб-панель по умолчанию только на localhost; наружу — только осознанно.

## Ссылки

- Образ: [myceliummesh/amneziawg-ui](https://hub.docker.com/r/myceliummesh/amneziawg-ui)
- Документация протокола: [AmneziaWG](https://docs.amnezia.org/documentation/amnezia-wg)
- 2.0 → 3.1 под капотом: [Habr](https://habr.com/ru/articles/1080342/)
