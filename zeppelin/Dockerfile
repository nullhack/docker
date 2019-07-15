FROM ubuntu:19.04

COPY --from=apache/zeppelin:0.8.1 /zeppelin /zeppelin
COPY --from=continuumio/miniconda3 /opt/conda /opt/conda
ENV PATH=/opt/conda/bin:$PATH

COPY ./python-requirements.txt /opt/python-requirements.txt

RUN apt-get update && \
    apt-get install -y gcc && \
    pip install --no-cache-dir --upgrade numpy pandas matplotlib pandasql ipython jupyter_client ipykernel ggplot grpcio bkzep pyreadline protobuf jedi pyspark && \
    pip install  --no-cache-dir --upgrade -r /opt/python-requirements.txt && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
    apt-get -y update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

RUN echo "$LOG_TAG Install tini" && \
    apt-get -y update && \
    apt-get install -y tini && \
    rm -rf /var/lib/apt/lists/*

#ENV TINI_VERSION v0.18.0
#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
#RUN chmod +x /tini

#ENTRYPOINT [ "/tini", "--" ]
ENTRYPOINT [ "tini", "--" ]
ENV Z_HOME="/zeppelin"
WORKDIR ${Z_HOME}
CMD ["bin/zeppelin.sh"]
