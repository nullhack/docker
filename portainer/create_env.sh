#!/bin/sh

environment_password_size=32
environment_base_env_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
environment_file_name=${1:-env.default}

echo "# creating environment ${environment_base_env_path}/${environment_file_name}"

# host configuration
export PORTAINER_HOST_PORT=9000

# portainer configuration
export PORTAINER_IMAGE=portainer/portainer:1.21.0
export PORTAINER_PORT=9000
export PORTAINER_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export PORTAINER_AUTH_BASIC=$(docker run --rm --entrypoint htpasswd registry:2 -Bbn admin ${PORTAINER_PASSWORD} | cut -d ":" -f 2)

# traefik configuration
export TRAEFIK_AUTH_USER=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export TRAEFIK_AUTH_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export TRAEFIK_AUTH_BASIC=$(docker run --rm --entrypoint htpasswd registry:2 -Bbn ${TRAEFIK_AUTH_USER} ${TRAEFIK_AUTH_PASSWORD})
export TRAEFIK_TRAEFIK_DOMAIN=portainer.localhost
export TRAEFIK_ENABLE=true


printenv | sort | sed -e "s/^[^#].*/export &/g" | sed -e "s/.*/&'/g" | sed "s/=/='/" > "${environment_base_env_path}/${environment_file_name}"

