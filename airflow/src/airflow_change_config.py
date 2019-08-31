#!/usr/bin/python3

import configparser
import os

AIRFLOW_HOME = os.environ.get('AIRFLOW_HOME')
CONFIG_PATH = os.path.join(AIRFLOW_HOME, 'airflow.cfg')

config = configparser.ConfigParser(allow_no_value=True)
config.read_file(open(CONFIG_PATH, 'r'))
for k in os.environ.keys():
    if k.startswith('AIRFLOW__'):
        value = os.environ[k]
        _, section, conf = k.lower().split('__')
        config[section][conf] = value
config.write(open(CONFIG_PATH, 'w'))

