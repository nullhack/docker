[ -n "$(sudo docker images -q ca:local)" ] || sudo docker build -t ca:local .
