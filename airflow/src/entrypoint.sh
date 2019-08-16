#!/usr/bin/env bash

CONFIG_FILE="${AIRFLOW_HOME}/airflow.cfg"

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

