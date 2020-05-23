#!/usr/bin/python3

import os

from airflow.models import DagBag

prefix = 'AIRFLOW_DAGS_'

for k in os.environ.keys():
    if k.startswith(prefix):
         dag_dir = os.environ[k]
         dag_bag = DagBag(os.path.expanduser(dag_dir))

         if dag_bag:
             for dag_id, dag in dag_bag.dags.items():
                 globals()[dag_id] = dag

