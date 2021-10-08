FROM postgis/postgis:13-3.1-alpine
LABEL RiskChanges development

COPY ./initdb.sh /docker-entrypoint-initdb.d/init-user-db.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-user-db.sh