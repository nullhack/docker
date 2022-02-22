cd ../traefik
bash build.sh
cd -
cd ../ca-maker/
bash build.sh
[ -n "$(sudo docker volume ls -q -f name=mongodb-certs)" ] || sudo docker run -ti --rm -v mongodb-certs:/certs/server -e OWNER=1001 -e GEN_NAME=mongodb ca:local
cd -
[ -n "$(sudo docker network ls -q -f name=mongodb_network)" ] || sudo docker network create --driver bridge --attachable mongodb_network
[ -n "$(sudo docker container ls -q -f name=mongodb)" ] || sudo docker-compose up -d
