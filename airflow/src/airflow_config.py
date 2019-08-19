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

airflow_user = os.environ.get('AIRFLOW_USER', False)
airflow_password = os.environ.get('AIRFLOW_PASSWORD', False)
if airflow_user and airflow_password:
    import airflow
    from airflow import models, settings
    from airflow.contrib.auth.backends.password_auth import PasswordUser

    user = PasswordUser(models.User())
    user.username = airflow_user
    user.password = airflow_password
    user.email = os.environ.get('AIRFLOW_EMAIL')
    user.superuser = True
    session = settings.Session()
    session.add(user)
    session.commit()
    session.close()

