FROM alpine:3.17
RUN apk update && apk upgrade --available
RUN apk add --update python3 nodejs npm postgresql postgresql-jit nginx redis
RUN mkdir /run/postgresql
RUN chown postgres:postgres /run/postgresql

COPY docker-entrypoint.sh /
COPY sample /sample
RUN chmod 777 /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 80
EXPOSE 5432
EXPOSE 6379