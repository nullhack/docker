cd ../traefik
bash build.sh
cd -
cd ../ca-maker/
bash build.sh
[ -n "$(sudo docker volume ls -q -f name=postgres-certs)" ] || sudo docker run -ti --rm -v postgres-certs:/certs/server -e OWNER=1001 -e GEN_NAME=postgres ca:local
cd -
[ -n "$(sudo docker network ls -q -f name=postgres-network)" ] || sudo docker network create --driver bridge --attachable postgres-network
[ -n "$(sudo docker container ls -q -f name=postgres)" ] || sudo docker-compose up -d
