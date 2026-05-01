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

cd /app
exec ./main
