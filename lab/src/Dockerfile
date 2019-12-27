FROM ubuntu:19.10

USER root

ARG AIRFLOW_VERSION=1.10.7
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update &&\
  apt-get install vim tmux curl openssh-server default-libmysqlclient-dev -y &&\
  apt-get install build-essential -y &&\
  apt-get install python3 python3-pip python3-setuptools python3-wheel python3-dev -y &&\
  apt-get install jupyter -y &&\
  pip3 install jupyterlab &&\
  pip3 install jupyterhub
RUN \
  apt install npm -y &&\
  npm install -g configurable-http-proxy
RUN \
  jupyter labextension install @jupyterlab/git &&\
  pip3 install --upgrade jupyterlab-git &&\
  jupyter serverextension enable --sys-prefix --py jupyterlab_git &&\
  jupyter labextension install @jupyterlab/github
RUN \
  apt-get install git -y &&\
  git clone https://github.com/agoose77/jupyterlab-markup.git &&\
  cd jupyterlab-markup &&\
  npm install &&\
  npm run build &&\
  jupyter labextension link .
RUN \
  pip3 install apache-airflow[cypto,celery,postgres,jdbc,mysql,ssh]==${AIRFLOW_VERSION} &&\
  pip3 install --no-cache-dir --upgrade numpy pandas matplotlib pandasql ipython jupyter_client ipykernel pyreadline protobuf jedi

WORKDIR /lab

RUN jupyterhub --generate-config

RUN sed -i "s/#c.Spawner.default_url = ''/c.Spawner.default_url = '\/lab'/" jupyterhub_config.py

RUN mkdir /run/sshd

COPY ./entrypoint.sh ./entrypoint.sh

EXPOSE 8000 22

ENTRYPOINT ["bash", "./entrypoint.sh"]

CMD ["jupyterhub"]
