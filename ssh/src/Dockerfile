FROM ubuntu:20.04

RUN \
  apt-get update &&\
  apt-get upgrade -y &&\
  apt-get install openssh-server -y

RUN useradd --shell /bin/bash --create-home user

RUN mkdir /run/sshd

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh", "/usr/sbin/sshd", "-D"]
