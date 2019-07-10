#!/bin/sh

environment_password_size=32
environment_base_env_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
environment_file_name=${1:-env.default}

echo "# creating environment ${environment_base_env_path}/${environment_file_name}"

# basic configuration
export TRAEFIK_HOST_PORT_HTTP=80
export TRAEFIK_PORT_HTTP=80
export TRAEFIK_HOST_PORT_HTTPS=443
export TRAEFIK_PORT_HTTPS=443
export TRAEFIK_IMAGE=traefik:1.7
export TRAEFIK_CONFIG_HOST_PATH=./config/traefik.toml
export TRAEFIK_CONFIG_PATH=/etc/traefik/traefik.toml
export TRAEFIK_ACME_HOST_PATH=./config/acme
export TRAEFIK_ACME_PATH=/etc/traefik/acme

# traefik configuration
export TRAEFIK_AUTH_USER=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export TRAEFIK_AUTH_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export TRAEFIK_AUTH_BASIC=$(docker run --rm --entrypoint htpasswd registry:2 -Bbn ${TRAEFIK_AUTH_USER} ${TRAEFIK_AUTH_PASSWORD})
export TRAEFIK_INTERFACE_DOMAIN=traefik.localhost
export TRAEFIK_PORT=8080
export TRAEFIK_ENABLE=true


printenv | sort | sed -e "s/^[^#].*/export &/g" | sed -e "s/.*/&'/g" | sed "s/=/='/" > "${environment_base_env_path}/${environment_file_name}"

