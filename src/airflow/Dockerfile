# AUTHOR: Eric Lopes
# DESCRIPTION: Airflow all in one container
# BUILD: docker build --rm -t airflow .

FROM ubuntu:19.04

ARG AIRFLOW_VERSION=1.10.3
ARG AIRFLOW_GPL_UNIDECODE=yes
ENV DEBIAN_FRONTEND=noninteractive
ENV C_FORCE_ROOT=true
ENV SCRIPTS=/scripts
ENV AIRFLOW_HOME=/data

WORKDIR ${SCRIPTS}

COPY ./airflow_requirements.txt ${SCRIPTS}/airflow_requirements.txt
COPY ./python_requirements.txt ${SCRIPTS}/python_requirements.txt
COPY ./entrypoint.sh ${SCRIPTS}/entrypoint.sh
COPY ./airflow_config.py ${SCRIPTS}/airflow_config.py

RUN set -ex \
    && build_deps=' \
        build-essential \
        default-libmysqlclient-dev \
        apt-utils \
        ' \
    && apt-get update -y \
    && apt-get upgrade -y \
    # installing apt dependencies
    && apt-get install -y --no-install-recommends $build_deps \
    && apt-get install -y --no-install-recommends python3-dev \
    && apt-get install -y --no-install-recommends python3-pip \
    && apt-get install -y --no-install-recommends curl \
    && apt-get install -y --no-install-recommends postgresql-client \
    && apt-get install -y --no-install-recommends redis-tools \
    # installing python dependencies
    && pip3 install -U pip setuptools wheel \
    && pip3 install -r "${SCRIPTS}/python_requirements.txt" \
    && pip3 install apache-airflow["$(grep -v '^#' ${SCRIPTS}/airflow_requirements.txt | tr -s "( |\n)" , | head -c -1)"]==${AIRFLOW_VERSION} \    
    # removing unecessary files
    && apt-get  purge --auto-remove -y ${build_deps} \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -vrf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

EXPOSE 8080 5555 8793

ENTRYPOINT ./entrypoint.sh run
