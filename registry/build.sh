cd ../traefik
bash build.sh
cd -
[ -n "$(sudo docker container ls -q -f name=registry)" ] || sudo docker-compose up -d

# sudo docker login --username user --password password "registry.localhost"

