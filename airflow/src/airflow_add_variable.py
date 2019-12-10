#!/usr/bin/python3

import os
import subprocess

prefix = 'AIRFLOW_VAR_'

for k in os.environ.keys():
    if k.startswith(prefix):
        key = k[len(prefix):].lower()
        value = os.environ[k]
        cmd = f"airflow variables -s {key} {value}"
        p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
        p.communicate()

