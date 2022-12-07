#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

# local system locations
CFSSL_CONFIG_LOCATION="/home/julrich/Projects/Entwicklung/code/certificates"
BINARIES_LOCATION="/home/julrich/Projects/Entwicklung/code/coreos/binaries"
CONFIGS_LOCATION="/home/julrich/Projects/Entwicklung/code/coreos/configs"
COREOSUSER="julrich"

# check for first argument, machine name
if [ "$#" -lt 1 ]; then
  echo "No machine name given"
  exit 1
fi

# upload certificates
scp "$CFSSL_CONFIG_LOCATION/calculonc.pem" "$CFSSL_CONFIG_LOCATION/calculonc-key.pem" "$1:/home/$COREOSUSER"

# place certificates on machine, adjust permissions, and regenerate machine certificates
ssh -t "$1" \
  "sudo mkdir -p /etc/ssl/etcd && \
  sudo mv calculonc.pem /etc/ssl/etcd/ && \
  sudo mv calculonc-key.pem /etc/ssl/etcd/ && \
  sudo mkdir -p /etc/docker && \
  sudo chown etcd:fleet /etc/ssl/etcd/calculonc-key.pem && \
  sudo chmod g+r /etc/ssl/etcd/calculonc-key.pem && \
  sudo mkdir -p /var/lib/etcd/ssl/ && \
  sudo cp /etc/ssl/etcd/calculonc.pem /var/lib/etcd/ssl/ && \
  sudo cp /etc/ssl/etcd/calculonc-key.pem /var/lib/etcd/ssl/ && \
  sudo chown -R etcd:etcd /var/lib/etcd/ssl && \
  sudo chown etcd:fleet /var/lib/etcd/ssl/calculonc-key.pem && \
  sudo update-ca-certificates"

ssh -t "$1" \
  "sudo reboot"
