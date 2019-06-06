#!/usr/bin/python3

import configparser
import os

AIRFLOW_HOME = os.environ.get('AIRFLOW_HOME')
cfg_path = os.path.join(AIRFLOW_HOME, 'airflow.cfg')

config = configparser.ConfigParser(allow_no_value=True)
config.read_file(open(cfg_path, 'r'))
for k in os.environ.keys():
    if k.startswith('AIRFLOW__'):
        value = os.environ[k]
        _, section, conf = k.lower().split('__')
        config[section][conf] = value
config.write(open(cfg_path, 'w'))

airflow_user = os.environ.get('AIRFLOW_USER')
if airflow_user:
    import airflow
    from airflow import models, settings
    from airflow.contrib.auth.backends.password_auth import PasswordUser

    user = PasswordUser(models.User())
    user.username = airflow_user
    user.password = os.environ.get('AIRFLOW_PASSWORD')
    user.email = os.environ.get('AIRFLOW_EMAIL')
    user.superuser = True
    session = settings.Session()
    session.add(user)
    session.commit()
    session.close()
