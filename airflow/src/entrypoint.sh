#!/usr/bin/env bash

CONFIG_FILE="${AIRFLOW_HOME}/airflow.cfg"

AIRFLOW__CORE__FERNET_KEY=${AIRFLOW__CORE__FERNET_KEY:-$(python3 -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")}
AIRFLOW__CORE__EXECUTOR=${AIRFLOW__CORE__EXECUTOR:-SequentialExecutor}
AIRFLOW__CORE__LOAD_EXAMPLES=${AIRFLOW__CORE__LOAD_EXAMPLES:-False}

POSTGRES_HOST=${POSTGRES_HOST:-'postgres'}
POSTGRES_PORT=${POSTGRES_PORT:-'5432'}
POSTGRES_USER=${POSTGRES_USER:-'airflow'}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-'airflow'}
POSTGRES_DB=${POSTGRES_DB:-'airflow'}

REDIS_HOST=${REDIS_HOST:-'redis'}
REDIS_PORT=${REDIS_PORT:-'6379'}
REDIS_PASSWORD=${REDIS_PASSWORD:-''}
if [ -n "$REDIS_PASSWORD" ]
then
    REDIS_PREFIX=:${REDIS_PASSWORD}@
else
    REDIS_PREFIX=
fi

export \
  AIRFLOW__CORE__EXECUTOR \
  AIRFLOW__CELERY__RESULT_BACKEND \
  AIRFLOW__CELERY__BROKER_URL \
  AIRFLOW__CORE__FERNET_KEY \
  AIRFLOW__CORE__LOAD_EXAMPLES \
  AIRFLOW__CORE__SQL_ALCHEMY_CONN 

if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ] || [ "$AIRFLOW__CORE__EXECUTOR" = "LocalExecutor" ]
then
  AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
  AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
  until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -p "$POSTGRES_PORT" -c '\q'
  do
    >&2 echo "Postgres is unavailable - sleeping"
    sleep 3
  done
  >&2 echo "Postgres is available!"
fi

if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ]
then
  AIRFLOW__CELERY__BROKER_URL="redis://$REDIS_PREFIX$REDIS_HOST:$REDIS_PORT/1"
  until redis-cli -u "$AIRFLOW__CELERY__BROKER_URL" ping
  do
    >&2 echo "Redis is unavailable - sleeping"
    sleep 3
  done
  >&2 echo "Redis is available!"
fi

if ([ "$1" = "airflow" ] && [ "$2" = "webserver" ]) || [ "$1" = "run" ]
then
  >&2 echo "Starting webserver"
  airflow initdb
  python3 "${SCRIPTS}/airflow_config.py"
fi

if [ "$1" = "run" ]
then
  >&2 echo "Running standalone"
  airflow scheduler &
  if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ]
  then
    airflow worker &
  fi
  exec airflow webserver
else
  >&2 echo "Executing command"
  exec "$@"
fi


