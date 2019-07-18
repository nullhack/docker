FROM ubuntu:19.04

COPY ./python-requirements.txt /opt/python-requirements.txt

RUN echo "Install wget" && \
    apt-get -y update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Install miniconda3" && \
    apt-get -y update && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/conda/bin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN echo "Install java8" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Install tini" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y tini && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Download Zeppelin binary" && \
    wget --quiet  http://archive.apache.org/dist/zeppelin/zeppelin-0.8.1/zeppelin-0.8.1-bin-netinst.tgz -O /tmp/zeppelin.tgz && \
    tar -zxvf /tmp/zeppelin.tgz && \
    rm -rf /tmp/zeppelin.tgz && \
    mv /zeppelin-0.8.1-bin-netinst /zeppelin

RUN echo "Installing zeppelin interpreters" && \
    /zeppelin/bin/install-interpreter.sh -n jdbc  && \
    /zeppelin/bin/install-interpreter.sh -n md

RUN echo "Update python" && \
    apt-get update && \
    apt-get install -y gcc && \
    pip install --no-cache-dir --upgrade numpy pandas matplotlib pandasql ipython jupyter_client ipykernel ggplot grpcio bkzep pyreadline protobuf jedi pyspark && \
    pip install  --no-cache-dir --upgrade -r /opt/python-requirements.txt && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "tini", "--" ]
WORKDIR /zeppelin
CMD ["bin/zeppelin.sh"]
