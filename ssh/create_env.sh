#!/bin/sh

environment_docker_image=ssh:19.04
environment_password_size=32
environment_base_env_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
environment_file_name=${1:-env.default}

[ ! -z $(docker images -q ${environment_docker_image}) ] || docker build -t ${environment_docker_image} "${environment_base_env_path}"

echo "# creating environment ${environment_base_env_path}/${environment_file_name}"

# basic configuration
export SSH_IMAGE=${environment_docker_image}
export SSH_HOST_PORT=2222
export SSH_PORT=22

# user configuration
export PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})
export ROOT_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${environment_password_size})


printenv | sort | sed -e "s/^[^#].*/export &/g" | sed -e "s/.*/&'/g" | sed "s/=/='/" > "${environment_base_env_path}/${environment_file_name}"

