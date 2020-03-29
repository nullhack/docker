# AUTHOR: Eric Lopes
# DESCRIPTION: Airflow all in one container
# BUILD: docker build -t airflow:local .

FROM ubuntu:19.10

ARG AIRFLOW_VERSION=1.10.9
ARG AIRFLOW_GPL_UNIDECODE=yes

ENV DEBIAN_FRONTEND=noninteractive
ENV C_FORCE_ROOT=true
ENV SCRIPTS=/scripts
ENV AIRFLOW_HOME=/airflow

COPY ./airflow_requirements.txt ${SCRIPTS}/airflow_requirements.txt
COPY ./python_requirements.txt ${SCRIPTS}/python_requirements.txt

RUN set -ex \
    && apt-get update -y \
    # installing apt dependencies
    && apt-get install -y curl libpq-dev build-essential python3 python3-pip\
    # installing python dependencies
    && pip3 install apache-airflow["$(grep -v '^#' ${SCRIPTS}/airflow_requirements.txt | tr -s "( |\n)" , | head -c -1)"]==${AIRFLOW_VERSION} \    
    # removing unecessary files
    && apt-get clean \
    && rm -vrf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
RUN set -ex \
    && pip3 install -r "${SCRIPTS}/python_requirements.txt"

COPY ./airflow_change_config.py ${SCRIPTS}/airflow_change_config.py
COPY ./airflow_add_user.py ${SCRIPTS}/airflow_add_user.py
COPY ./airflow_add_connection.py ${SCRIPTS}/airflow_add_connection.py
COPY ./airflow_add_variable.py ${SCRIPTS}/airflow_add_variable.py
COPY ./entrypoint.sh ${SCRIPTS}/entrypoint.sh

WORKDIR ${SCRIPTS}

EXPOSE 8080 5555 8793

ENTRYPOINT ./entrypoint.sh

