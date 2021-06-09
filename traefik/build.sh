[ -n "$(sudo docker network ls -q -f name=traefik-public)" ] || sudo docker network create --driver bridge --attachable traefik-public
[ -n "$(sudo docker container ls -q -f name=traefik)" ] || sudo docker-compose up -d
