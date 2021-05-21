sudo docker network create traefik-public

sudo docker volume create ca-cert

sudo docker run -ti --rm -v ca-cert:/ssl -u root bitnami/postgresql:13 bash -c "openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj '/C=US/ST=CA/L=SF/O=docker-ca/CN=postgres.local' -keyout /ssl/postgres.key -out /ssl/postgres.cert && chown 1001:1001 /ssl/postgres.*"

