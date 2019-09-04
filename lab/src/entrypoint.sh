#!/usr/bin/env bash

echo root:${ROOT_PASSWORD:?ROOT_PASSWORD} | chpasswd

printenv | grep LOGIN | sed -e 's/[^=]*=\(.*\)/\1/' | while read p; do
if [ ! -z "$p" ]; then
  new_login=$p
  new_user=$(echo $new_login | sed -e 's/\(.*\):.*/\1/')
  echo "Adding $new_user"
  useradd --shell /bin/bash --create-home $new_user
  echo $new_login | chpasswd
fi
done

/usr/sbin/sshd -D &

exec "$@"
