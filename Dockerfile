FROM unibee/api:v1.9.0

RUN apk add --no-cache mysql-client curl

RUN curl -sL "https://raw.githubusercontent.com/UniBee-Billing/unibee/main/mysql/structure.sql" -o /app/structure.sql

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8088

ENTRYPOINT ["/entrypoint.sh"]
