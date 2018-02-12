#!/usr/bin/env sh

USER_ID=${HOST_USER_ID:-9001}
DOCKER_GROUP_ID=${HOST_DOCKER_GROUP_ID:-9001}
COMMAND=${COMMAND:-/usr/local/bin/forge}

delgroup docker

addgroup docker -g ${DOCKER_GROUP_ID}
adduser -s /bin/sh -u ${USER_ID} -D user
addgroup user docker
export HOME=/home/user

ln -s ${HOME}/work/public_keys ${HOME}/.ssh
chown -h user:user ${HOME}/.ssh

exec /usr/local/bin/gosu user ${COMMAND} "$@"
