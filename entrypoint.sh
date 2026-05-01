#!/bin/sh
set -e

cat > /app/config.yaml <<CONF
server:
  address: ":${PORT:-8088}"
  openapiPath: "/api.json"
  swaggerPath: ""

database:
  default:
    link: "mysql:${DB_USER:-root}:${DB_PASSWORD}@tcp(${DB_HOST:-127.0.0.1}:${DB_PORT:-3306})/${DB_DATABASE:-unibee}?charset=utf8mb4"
    debug: false

redis:
  default:
    address: "${REDIS_HOST:-127.0.0.1}:${REDIS_PORT:-6379}"
    pass: "${REDIS_PASSWORD}"
    db: 0
    idleTimeout: "1d"
    maxIdle: 500
    minIdle: 10

logger:
  level: "all"
  stdout: true
CONF

TABLE_CHECK=$(mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -p"${DB_PASSWORD}" -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${DB_DATABASE}' AND table_name='merchant'" 2>/dev/null || echo "0")

if [ "$TABLE_CHECK" = "0" ]; then
  echo "Importing UniBee schema..."
  mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -p"${DB_PASSWORD}" "${DB_DATABASE}" < /app/structure.sql
  echo "Schema imported successfully."
else
  echo "Schema already exists, skipping import."
fi

cd /app
exec ./main
