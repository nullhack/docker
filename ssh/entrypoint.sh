#!/usr/bin/env bash

echo user:${PASSWORD:?PASSWORD} | chpasswd
echo root:${ROOT_PASSWORD:?ROOT_PASSWORD} | chpasswd

exec "$@"

