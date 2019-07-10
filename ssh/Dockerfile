FROM ubuntu:19.04

RUN \
  apt-get update &&\
  apt-get upgrade -y &&\
  apt-get install openssh-server -y

RUN groupadd -g 999 user && \
    useradd -u 999 --shell /bin/bash -g user user

RUN mkdir /home/user
RUN chown user:user /home/user

RUN mkdir /run/sshd

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh", "/usr/sbin/sshd", "-D"]
