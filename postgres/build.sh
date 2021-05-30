cd ../ca-maker/
bash build.sh
sudo docker run -ti --rm -v postgres-certs:/certs/server -e OWNER=1001 -e GEN_NAME=postgres ca:local
cd -
sudo docker-compose down -v
sudo docker-compose up -d
