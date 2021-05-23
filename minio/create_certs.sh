sudo docker network create traefik-public

sudo docker volume create minio-certs

sudo docker run -ti --rm -v minio-certs:/certs -u root bitnami/minio:2021 bash -c "openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj '/C=US/ST=CA/L=SF/O=docker-ca/CN=minio.local' -keyout /certs/private.key -out /certs/public.crt"

