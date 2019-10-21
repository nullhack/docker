FROM ubuntu:19.10

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends build-essential -y && apt-get install --no-install-recommends python3 python3-pip python3-setuptools python3-wheel python3-dev -y && apt-get install --no-install-recommends npm -y && apt-get install --no-install-recommends nodejs -y && apt-get install --no-install-recommends openssh-server vim tmux -y && apt-get install --no-install-recommends default-libmysqlclient-dev -y && npm install -g configurable-http-proxy && apt-get install jupyter -y && pip3 install --upgrade jupyterhub && pip3 install apache-airflow[cypto,celery,postgres,jdbc,mysql,ssh] 

RUN \
   pip3 install --upgrade jupyterlab && jupyter labextension install @lckr/jupyterlab_variableinspector && jupyter labextension install @jupyterlab/git && pip3 install --upgrade jupyterlab-git && jupyter serverextension enable --sys-prefix --py jupyterlab_git && jupyter labextension install @jupyterlab/github && jupyter labextension install jupyterlab-drawio && jupyter labextension install @krassowski/jupyterlab_go_to_definition 

RUN \
  pip3 install --no-cache-dir --upgrade numpy pandas matplotlib pandasql ipython jupyter_client ipykernel pyreadline protobuf jedi

WORKDIR /lab

RUN jupyterhub --generate-config

RUN sed -i "s/#c.Spawner.default_url = ''/c.Spawner.default_url = '\/lab'/" jupyterhub_config.py

RUN mkdir /run/sshd

COPY ./entrypoint.sh ./entrypoint.sh

EXPOSE 8000 22

ENTRYPOINT ["bash", "./entrypoint.sh"]

CMD ["jupyterhub"]
