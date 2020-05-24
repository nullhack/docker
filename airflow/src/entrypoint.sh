#!/usr/bin/env bash

if [ ! -z "$CUSTOM_PACKAGES" ]
then
  >&2 echo "Installing custom packages"
  pip3 install $(echo $CUSTOM_PACKAGES | tr -s '(,|\n)' ' ' )
fi

if ([ "$1" = "airflow" ] && [ "$2" = "webserver" ]) || [ "$1" = "run" ]
then
  >&2 echo "Configuring webserver"
  airflow initdb
  python3 "${SCRIPTS}/airflow_change_config.py"
  airflow upgradedb
  python3 "${SCRIPTS}/airflow_add_user.py"
  python3 "${SCRIPTS}/airflow_add_connection.py"
  python3 "${SCRIPTS}/airflow_add_variable.py"
  cp -r "/default_dags" "$AIRFLOW__CORE__DAGS_FOLDER"
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

