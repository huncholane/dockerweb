FROM alpine:3.17
RUN apk update && apk upgrade --available
RUN apk add --update python3 nodejs npm postgresql postgresql-jit nginx redis py3-pip
RUN python -m pip install --upgrade pip
RUN mkdir /run/postgresql
RUN chown postgres:postgres /run/postgresql
ENV IS_DOCKER=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY docker-entrypoint.sh /
COPY sample /sample
RUN chmod 777 /docker-entrypoint.sh
RUN pip install -r /sample/backend/requirements.txt
ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 80
EXPOSE 5432
EXPOSE 6379