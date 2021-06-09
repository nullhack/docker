cd ../traefik
bash build.sh
cd -
cd ../ca-maker/
bash build.sh
[ -n "$(sudo docker volume ls -q -f name=redis-certs)" ] || sudo docker run -ti --rm -v redis-certs:/certs -e OWNER=1001 -e GEN_NAME=redis ca:local
cd -
[ -n "$(sudo docker network ls -q -f name=redis_network)" ] || sudo docker network create --driver bridge --attachable redis_network
[ -n "$(sudo docker container ls -q -f name=redis)" ] || sudo docker-compose up -d

# sudo docker run -ti --rm --network redis_network -e REDIS_PASSWORD=password -v redis-certs:/certs bitnami/redis:6.2 /bin/bash -c "redis-cli --tls -a password -p 6379 -h redis --cert /certs/client/redis.crt --key /certs/client/redis.key --cacert /certs/ca/ca.crt"
