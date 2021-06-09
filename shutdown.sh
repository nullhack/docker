cd traefik
sudo docker-compose down -v
cd ..

cd registry 
sudo docker-compose down -v
cd ..

cd minio
sudo docker-compose down -v
cd ..

cd postgres
sudo docker-compose down -v
cd ..

cd redis
sudo docker-compose down -v
cd ..

cd dagster

cd daemon
sudo docker-compose down -v
cd ..
cd repository
sudo docker-compose down -v

cd ..

