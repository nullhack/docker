[ -n "$(sudo docker network ls -q -f name=traefik-network)" ] || sudo docker network create --driver bridge --attachable traefik-network

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

env bash ../ca-maker/create_cert.sh

[ -n "$(sudo docker container ls -q -f name=traefik)" ] || sudo docker-compose up -d
