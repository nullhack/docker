cd ../traefik
bash build.sh
cd -
cd ../ca-maker/
bash build.sh
[ -n "$(sudo docker volume ls -q -f name=minio-ca)" ] || sudo docker run -ti --rm -v minio-certs:/certs/server -v minio-ca:/certs/ca -e HOST=localhost -e GEN_NAME_KEY=private -e GEN_NAME_CRT=public ca:local
cd -
[ -n "$(sudo docker network ls -q -f name=minio_network)" ] || sudo docker network create --driver bridge --attachable minio_network
[ -n "$(sudo docker container ls -q -f name=minio)" ] || sudo docker-compose up -d

# Necessary to run Minio python package locally with self signed certificates

[ -n "$(sudo docker volume ls -q -f name=minio-ca)" ] || sudo docker run -ti --rm -v minio-ca:/certs alpine:latest cat /certs/ca.crt > /tmp/ca.crt

export SSL_CERT_FILE=/tmp/ca.crt
