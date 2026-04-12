#!/usr/bin/env bash
# Создаёт клиентов из clients.txt через API веб-UI (после docker compose up -d).
# Использование:
#   export ADMIN_PASSWORD='ваш_пароль_от_веб_UI'
#   ./seed-clients.sh
# или:
#   ./seed-clients.sh 'ваш_пароль_от_веб_UI'
#
# Переменные: PORT (по умолчанию 51821), HOST (по умолчанию 127.0.0.1)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLIENTS_FILE="${SCRIPT_DIR}/clients.txt"
HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-51821}"

PASS="${ADMIN_PASSWORD:-${1:-}}"
if [[ -z "${PASS}" ]]; then
  echo "Задайте пароль: export ADMIN_PASSWORD='...' или ./seed-clients.sh 'пароль'" >&2
  exit 1
fi

if [[ ! -f "${CLIENTS_FILE}" ]]; then
  echo "Не найден ${CLIENTS_FILE}" >&2
  exit 1
fi

while IFS= read -r name || [[ -n "${name}" ]]; do
  [[ -z "${name}" || "${name}" =~ ^[[:space:]]*# ]] && continue
  name="$(echo "${name}" | tr -d '\r' | xargs)"
  [[ -z "${name}" ]] && continue

  echo -n "Создаю клиента: ${name} ... "
  curl -fsS -X POST "http://${HOST}:${PORT}/api/wireguard/client" \
    -H "Content-Type: application/json" \
    -H "Authorization: ${PASS}" \
    -d "{\"name\":\"${name}\"}"
  echo " ok"
done < "${CLIENTS_FILE}"

echo "Готово. Откройте http://${HOST}:${PORT} и проверьте список клиентов."
