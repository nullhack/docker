FROM continuumio/anaconda3:2019.03

USER root

ENV PATH=/opt/conda/bin:$PATH

RUN \
  apt-get update &&\
  apt-get upgrade -y &&\
  apt-get install --no-install-recommends build-essential -y &&\
  conda install -c conda-forge nodejs &&\
  apt-get install --no-install-recommends openssh-server vim tmux -y &&\
  apt-get install --no-install-recommends default-libmysqlclient-dev -y &&\
  npm install -g configurable-http-proxy &&\
  pip install --upgrade jupyterhub &&\
  pip install apache-airflow[cypto,celery,postgres,jdbc,mysql,ssh] &&\
  jupyter labextension install @lckr/jupyterlab_variableinspector &&\
  jupyter labextension install @jupyterlab/git &&\
  pip install --upgrade jupyterlab-git &&\
  jupyter serverextension enable --sys-prefix --py jupyterlab_git &&\
  jupyter labextension install @jupyterlab/github &&\
  jupyter labextension install jupyterlab-drawio &&\
  jupyter labextension install @krassowski/jupyterlab_go_to_definition 

RUN pip install werkzeug==0.15.4


WORKDIR /lab

RUN jupyterhub --generate-config
RUN sed -i "s/#c.Spawner.default_url = ''/c.Spawner.default_url = '\/lab'/" jupyterhub_config.py

RUN mkdir /run/sshd
RUN echo 'source /opt/conda/bin/activate' >> /etc/bash.bashrc

COPY ./entrypoint.sh ./entrypoint.sh

EXPOSE 8000 22

ENTRYPOINT ["bash", "./entrypoint.sh"]

CMD ["jupyterhub"]
