[ -n "$(sudo docker container ls -q -f name=watchtower)" ] || sudo docker-compose up -d
