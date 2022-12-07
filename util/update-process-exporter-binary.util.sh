#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

cd ../binaries/process-exporter/
docker build -t process_exporter-fedora-packaging .
if [ ! -d process_exporter-src ]; then
  git clone git@github.com:Percona-Lab/prometheus_per_process_exporter.git process_exporter-src
fi
cd process_exporter-src
git pull
cd ..
docker run -v ${PWD}/process_exporter-src:/go/src/github.com/Percona-Lab/prometheus_per_process_exporter:rw process_exporter-fedora-packaging
mv ${PWD}/process_exporter-src/process_exporter ${PWD}/