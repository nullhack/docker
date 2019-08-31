#!/usr/bin/python3

import os

airflow_user = os.environ.get('AIRFLOW_USER')
airflow_password = os.environ.get('AIRFLOW_PASSWORD')
airflow_email = os.environ.get('AIRFLOW_EMAIL')

if airflow_user and airflow_password:
    import airflow
    from airflow import models, settings
    from airflow.contrib.auth.backends.password_auth import PasswordUser

    session = settings.Session()

    q = session.query(PasswordUser).filter_by(username=airflow_user)
    
    if q.count():
        user = q.one()
        user.username = airflow_user
        user.password = airflow_password
        user.email = airflow_email
    else:
        user = PasswordUser(models.User())
        user.username = airflow_user
        user.password = airflow_password
        user.email = airflow_email
        user.superuser = True
        session.add(user)

    session.commit()
    session.close()

