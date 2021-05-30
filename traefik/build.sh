sudo docker network ls | grep traefik-public > /dev/null || sudo docker network create --driver bridge --attachable traefik-public
sudo docker-compose up -d
