cd ../traefik
bash build.sh
cd -
cd ../ca-maker/
bash build.sh
sudo docker run -ti --rm -v redis-certs:/certs -e OWNER=1001 -e GEN_NAME=redis ca:local
cd -
sudo docker-compose down -v
sudo docker-compose up -d

# sudo docker run -ti --rm --network traefik-public -e REDIS_PASSWORD=password -v redis-certs:/certs bitnami/redis:6.2 /bin/bash -c "redis-cli --tls -a password -p 6379 -h redis --cert /certs/client/redis.crt --key /certs/client/redis.key --cacert /certs/ca/ca.crt"
