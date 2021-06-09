cd ca-maker
bash build.sh
cd -

cd traefik
bash build.sh
cd -

cd registry 
bash build.sh
cd -

cd minio
bash build.sh
cd -

cd postgres
bash build.sh
cd -

cd redis
bash build.sh
cd -

cd dagster
bash build.sh
cd -

