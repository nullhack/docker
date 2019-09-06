FROM postgres:12

COPY ./initdb.sh /docker-entrypoint-initdb.d/initdb.sh

RUN mkdir /ssl && \
    openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/C=US/ST=CA/L=SF/O=Docker-demo/CN=postgres.local" -keyout /ssl/postgres.key -out /ssl/postgres.cert && \
    chown -R postgres:postgres /ssl/

USER postgres

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]
