FROM postgres:11

COPY ./initdb.sh /docker-entrypoint-initdb.d/initdb.sh

USER postgres

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]
