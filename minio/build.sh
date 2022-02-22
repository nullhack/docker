cd ../traefik
bash build.sh
cd -
[ -n "$(sudo docker network ls -q -f name=minio-network)" ] || sudo docker network create --driver bridge --attachable minio-network
[ -n "$(sudo docker container ls -q -f name=minio)" ] || sudo docker-compose up -d

