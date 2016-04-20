#!/bin/bash

set -ex

if [ -n "${COLLECTD_HOST}" ]; then
  VAR=$(eval echo \$${COLLECTD_HOST})
  if [ -n "${VAR}" ]; then
    export COLLECTD_HOST="${VAR}"
  fi
fi

export GRAPHITE_PORT=${GRAPHITE_PORT:-2003}
export GRAPHITE_PREFIX=${GRAPHITE_PREFIX:-collectd.}
export COLLECTD_INTERVAL=${COLLECTD_INTERVAL:-10}

# Adding a user if needed to be able to communicate with docker
GROUP=nobody
if [ -e /var/run/docker.sock ]; then
  GROUP=$(ls -l /var/run/docker.sock | awk '{ print $4 }')
fi

if getent group docker; then
  echo "Group already created and added to user"
else
  groupadd -g ${GROUP} docker
  useradd -g docker collectd-docker-collector
fi

# collect does not work when the process is launched by reefer
reefer -t /etc/collectd/collectd.conf.tpl:/tmp/collectd.conf echo "" > /dev/null
exec "$@"
