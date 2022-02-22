[ -n "$(sudo docker image ls -q -f reference=ca:local)" ] || sudo docker build -t ca:local .
