#!/bin/sh

environment_docker_image=airflow:1.10.3
environment_password_size=32
environment_base_env_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
environment_source_rel_path=../..
environment_file_name=${1:-env.default}

[ ! -z $(docker images -q ${environment_docker_image}) ] || docker build -t ${environment_docker_image} "${environment_base_env_path}/${environment_source_rel_path}/src"

echo "# creating environment ${environment_base_env_path}/${environment_file_name}"

# host configuration
export REL_HOST_PATH=${environment_source_rel_path}
export AIRFLOW_HOST_PORT=8080
export FLOWER_HOST_PORT=5555

# airflow configuration
export AIRFLOW__CORE__DAGS_FOLDER=/dags
export AIRFLOW__CORE__EXECUTOR=CeleryExecutor
export AIRFLOW__CORE__FERNET_KEY=$(docker run --rm --entrypoint='' ${environment_docker_image} python3 -c 'from cryptography.fernet import Fernet; FERNET_KEY=Fernet.generate_key().decode(); print(str(FERNET_KEY))')
export AIRFLOW__CORE__LOAD_EXAMPLES=True
export AIRFLOW_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export AIRFLOW_USER=airflow-user
export AIRFLOW__WEBSERVER__AUTH_BACKEND=airflow.contrib.auth.backends.password_auth
export AIRFLOW__WEBSERVER__AUTHENTICATE=True
export AIRFLOW__WEBSERVER__BASE_URL=http://0.0.0.0:8080
export AIRFLOW__WEBSERVER__WEB_SERVER_PORT=8080

# flower configuration
export FLOWER_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export FLOWER_PORT=5555
export FLOWER_USER=flower-user

# postgres configuration
export PGDATA=/var/lib/postgresql/data
export POSTGRES_DB=airflow
export POSTGRES_HOST=postgres
export POSTGRES_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export POSTGRES_PORT=5432
export POSTGRES_USER=airflow

# redis configuration
export REDIS_HOST=redis
export REDIS_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export REDIS_PORT=6379

# traefik configuration
export TRAEFIK_AUTH_USER=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export TRAEFIK_AUTH_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export TRAEFIK_AUTH_BASIC=$(docker run --rm --entrypoint htpasswd registry:2 -Bbn ${TRAEFIK_AUTH_USER} ${TRAEFIK_AUTH_PASSWORD})
export TRAEFIK_AIRFLOW_DOMAIN=airflow.localhost
export TRAEFIK_FLOWER_DOMAIN=flower.localhost
export TRAEFIK_ENABLE=true


printenv | sort | sed -e "s/^[^#].*/export &/g" | sed -e "s/.*/&'/g" | sed "s/=/='/" > "${environment_base_env_path}/${environment_file_name}"


