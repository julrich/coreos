#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

cd ../binaries/proxysql-exporter/
docker build -t proxysql_exporter-fedora-packaging .
if [ ! -d proxysql_exporter-src ]; then
  git clone git@github.com:percona/proxysql_exporter.git proxysql_exporter-src
fi
cd proxysql_exporter-src
git pull
cd ..
docker run -v ${PWD}/proxysql_exporter-src:/go/src/github.com/percona/proxysql_exporter:rw proxysql_exporter-fedora-packaging
mv ${PWD}/proxysql_exporter-src/proxysql_exporter ${PWD}/
