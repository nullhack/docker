FROM python:3.9-slim

# Checkout and install dagster libraries needed to run the gRPC server
# exposing your repository to dagit and dagster-daemon, and to load the DagsterInstance

RUN pip install \
    dagster==0.11.10 \
    dagster-postgres \
    dagster-docker

# Set $DAGSTER_HOME and copy dagster instance there

ENV DAGSTER_HOME=/opt/dagster/dagster_home

RUN mkdir -p $DAGSTER_HOME

COPY dagster.yaml $DAGSTER_HOME

# Add repository code

WORKDIR /opt/dagster/app

COPY dags/ /opt/dagster/app

RUN pip install . && rm -rf /opt/dagster/app/ && mkdir -p /opt/dagster/app/

COPY dags/dags /opt/dagster/app

# Run dagster gRPC server on port 4000

EXPOSE 4000

# CMD allows this to be overridden from run launchers or executors that want
# to run other commands against your repository
CMD ["dagster", "api", "grpc", "-h", "0.0.0.0", "-p", "4000", "-m", "dags"]
