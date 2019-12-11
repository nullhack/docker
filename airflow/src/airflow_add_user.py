#!/usr/bin/python3

import os
import subprocess
import json
import re

prefix = 'AIRFLOW_USER_'

for k in os.environ.keys():
    if k.startswith(prefix):
        v = os.environ[k]
        v = v.replace('{', '{"')
        v = v.replace('}', '"}')
        v = v.replace(':', '":"')
        v = v.replace(',', '","')
        v = v.replace(' ', '')
        v = v.replace("'", '"')
        v = re.sub('["]+', '"', v)
        params = json.loads(v)
        role = params.get('role', 'Admin')
        username = params.get('username', 'admin')
        password = params['password']
        email = params.get('email', f'{username}@local')
        firstname = params.get('firstname', f'{username}')
        lastname = params.get('lastname', '.')
        cmd = f'airflow delete_user --username {username}'
        p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
        p.communicate()
        cmd = f'airflow create_user --role {role} --username {username} --password {password} --email {email} --firstname {firstname} --lastname {lastname}'
        p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
        p.communicate()

