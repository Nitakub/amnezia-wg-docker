#!/usr/bin/env bash
# Раньше создавал клиентов через API awg-easy (AWG 2.0, ветка main).
#
# Ветка amnezia-wg-docker-v01 использует myceliummesh/amneziawg-ui:3.1 —
# другой UI/API. Массовое создание через этот скрипт пока не поддерживается:
# создайте клиентов в веб-панели (см. quickstart.md).
#
# clients.txt оставлен как список имён «на память» при ручном создании.

set -euo pipefail

echo "seed-clients.sh: для AWG 3.1 (myceliummesh/amneziawg-ui) не используется." >&2
echo "Создайте клиентов в веб-UI: http://127.0.0.1:\${WEB_UI_PORT:-54845}" >&2
echo "Список имён (если нужен): $(dirname "$0")/clients.txt" >&2
exit 1
