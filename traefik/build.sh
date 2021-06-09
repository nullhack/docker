[ -n "$(sudo docker network ls -q -f name=traefik_network)" ] || sudo docker network create --driver bridge --attachable traefik_network
[ -n "$(sudo docker container ls -q -f name=traefik)" ] || sudo docker-compose up -d
