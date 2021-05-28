cd ../traefik
sudo docker-compose up -d
cd -
cd ../ca-maker/
sudo docker build -t localhost:5000/ca:registry .
sudo docker run -ti --rm -v minio-certs:/certs/server -v minio-ca:/certs/ca -e HOST=localhost -e GEN_NAME_KEY=private -e GEN_NAME_CRT=public localhost:5000/ca:registry
cd -
sudo docker-compose down -v
sudo docker-compose up -d

sudo docker run -ti --rm -v minio-ca:/certs ubuntu cat /certs/ca.crt > /tmp/ca.crt
export SSL_CERT_FILE=/tmp/ca.crt
