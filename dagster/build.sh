cd ../registry
bash build.sh
cd -

cd ../traefik
bash build.sh
cd -

[ -n "$(sudo docker network ls -q -f name=dagster_network)" ] || sudo docker network create --driver bridge --attachable dagster_network

cd daemon
[ -n "$(sudo docker image ls -q -f reference=registry.localhost/dagster_console:local)" ] || sudo docker build -t "registry.localhost/dagster_console:local" .
sudo docker push registry.localhost/dagster_console:local
[ -n "$(sudo docker container ls -q -f name=dagster_dagit)" ] || sudo docker-compose up -d
cd -

cd repository
[ -n "$(sudo docker image ls -q -f reference=registry.localhost/dagster_repo:local)" ] || sudo docker build -t "registry.localhost/dagster_repo:local" .
sudo docker push registry.localhost/dagster_repo:local
[ -n "$(sudo docker container ls -q -f name=dagster_pipelines)" ] || sudo docker-compose up -d
cd -

