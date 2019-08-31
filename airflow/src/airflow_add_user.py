#!/usr/bin/python3

import os

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

