#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

cd ../binaries/mysqld-exporter/
docker build -t mysqld_exporter-fedora-packaging .
if [ ! -d mysqld_exporter-src ]; then
  git clone git@github.com:percona/mysqld_exporter.git mysqld_exporter-src
fi
cd mysqld_exporter-src
git pull
cd ..
docker run -v ${PWD}/mysqld_exporter-src:/go/src/github.com/percona/mysqld_exporter:rw mysqld_exporter-fedora-packaging
mv ${PWD}/mysqld_exporter-src/mysqld_exporter ${PWD}/