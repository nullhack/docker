cd ../traefik
bash build.sh
cd -
[ -n "$(sudo docker volume ls -q -f name=registry-htpasswd)" ] || sudo docker run -v registry-htpasswd:/auth -ti --rm registry:2.7.0 /bin/sh -c "htpasswd -Bbn user password  > /auth/registry.auth"
[ -n "$(sudo docker container ls -q -f name=registry)" ] || sudo docker-compose up -d

