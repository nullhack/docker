FROM alpine/openssl:latest

RUN mkdir /app

COPY create_certs.sh /app

WORKDIR /app

ENTRYPOINT ["sh", "/app/create_certs.sh"]
