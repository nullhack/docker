#!/usr/bin/python3

import os
import subprocess

prefix = 'AIRFLOW_CONN_'

for k in os.environ.keys():
    if k.startswith(prefix):
        conn_id = k[len(prefix):].lower()
        conn_uri = os.environ[k]
        cmd = f"airflow connections --delete --conn_id {conn_id}"
        subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
        conn_extra = os.environ.get(f'CONN_EXTRA_{k.upper()}')
        cmd = f"airflow connections --add --conn_id {conn_id} --conn_uri {conn_uri}"
        if conn_extra:
            cmd += f" --conn_extra {conn_extra}"
        subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)

