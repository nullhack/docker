#!/usr/bin/env bash

if [ ! -z "$ROOT_PASSWORD" ]; then
  echo "Changing root password"
  echo root:${ROOT_PASSWORD} | chpasswd
fi

printenv | grep LOGIN | sed -e 's/[^=]*=\(.*\)/\1/' | while read p; do
if [ ! -z "$p" ]; then
  new_login=$p
  new_user=$(echo $new_login | sed -e 's/\(.*\):.*/\1/')
  echo "Adding user: $new_user"
  useradd --shell /bin/bash --create-home $new_user
  echo $new_login | chpasswd
fi
done

if [ ! -z "$CUSTOM_PACKAGES" ]; then
  echo "Installing custom packages"
  pip3 install $(echo $CUSTOM_PACKAGES | tr -s '(,|\n)' ' ' )
fi

/usr/sbin/sshd -D &

exec "$@"
