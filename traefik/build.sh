[ -n "$(sudo docker network ls -q -f name=traefik-public-network)" ] || sudo docker network create --driver bridge --attachable traefik-public-network

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

env bash ../ca-maker/create_cert.sh

[ -n "$(sudo docker container ls -q -f name=traefik)" ] || sudo docker-compose up -d
