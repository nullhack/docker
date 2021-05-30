cd ../traefik
bash build.sh
cd -
cd ../ca-maker/
bash build.sh
sudo docker run -ti --rm -v minio-certs:/certs/server -v minio-ca:/certs/ca -e HOST=localhost -e GEN_NAME_KEY=private -e GEN_NAME_CRT=public ca:local
cd -
sudo docker-compose down -v
sudo docker-compose up -d

sudo docker run -ti --rm -v minio-ca:/certs alpine:latest cat /certs/ca.crt > /tmp/ca.crt

# Necessary to run Minio python package locally with self signed certificates
export SSL_CERT_FILE=/tmp/ca.crt
