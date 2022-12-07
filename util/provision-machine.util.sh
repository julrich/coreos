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

# check for second argument, machine ip
if [ "$#" -lt 2 ]; then
  echo "No machine ip given"
  exit 1
fi

# generate certificates
echo '{"CN":"$1","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca="$CFSSL_CONFIG_LOCATION/ca.pem" -ca-key="$CFSSL_CONFIG_LOCATION/ca-key.pem" -config="$CFSSL_CONFIG_LOCATION/ca-config.json" -profile="client-server" -hostname="$2,$1.ruhmesmeile.systems,$1.machines.ruhmesmeile.local,$1.etcd.services.ruhmesmeile.local,$1.local,$1,127.0.0.1" - | cfssljson -bare "$CFSSL_CONFIG_LOCATION/$1"

# upload certificates
scp "$CFSSL_CONFIG_LOCATION/calculonc.pem" "$CFSSL_CONFIG_LOCATION/calculonc-key.pem" "$CFSSL_CONFIG_LOCATION/$1.pem" "$CFSSL_CONFIG_LOCATION/$1-key.pem" "$CFSSL_CONFIG_LOCATION/ca.pem" "$1:/home/$COREOSUSER"

# place certificates on machine, adjust permissions, and regenerate machine certificates
ssh -t "$1" \
  "sudo mkdir -p /etc/ssl/etcd && \
  sudo cp ca.pem /etc/ssl/etcd/ && \
  sudo mv ca.pem /etc/ssl/certs/ && \
  sudo mv ${1}.pem /etc/ssl/etcd/ && \
  sudo mv ${1}-key.pem /etc/ssl/etcd/ && \
  sudo mv calculonc.pem /etc/ssl/etcd/ && \
  sudo mv calculonc-key.pem /etc/ssl/etcd/ && \
  sudo mkdir -p /etc/docker && \
  sudo cp /etc/ssl/etcd/ca.pem /etc/docker/ && \
  sudo cp /etc/ssl/etcd/${1}.pem /etc/docker/ && \
  sudo cp /etc/ssl/etcd/${1}-key.pem /etc/docker/ && \
  sudo chown -R etcd:etcd /etc/ssl/etcd && \
  sudo chmod 600 /etc/ssl/etcd/*-key.pem && \
  sudo chown etcd:fleet /etc/ssl/etcd/calculonc-key.pem && \
  sudo chmod g+r /etc/ssl/etcd/calculonc-key.pem && \
  sudo mkdir -p /var/lib/etcd/ssl/ && \
  sudo cp /etc/ssl/etcd/ca.pem /var/lib/etcd/ssl/ && \
  sudo cp /etc/ssl/etcd/${1}.pem /var/lib/etcd/ssl/ && \
  sudo cp /etc/ssl/etcd/${1}-key.pem /var/lib/etcd/ssl/ && \
  sudo cp /etc/ssl/etcd/calculonc.pem /var/lib/etcd/ssl/ && \
  sudo cp /etc/ssl/etcd/calculonc-key.pem /var/lib/etcd/ssl/ && \
  sudo chown -R etcd:etcd /var/lib/etcd/ssl && \
  sudo chown etcd:fleet /var/lib/etcd/ssl/calculonc-key.pem && \
  sudo update-ca-certificates"

# upload binaries and configs to server, reboot services
scp "$BINARIES_LOCATION/node-exporter/node_exporter" "$1:/home/$COREOSUSER"

ssh -t "$1" \
  "chmod a+x /home/$COREOSUSER/node_exporter && \
  sudo mv /home/$COREOSUSER/node_exporter /opt/bin"

ssh -t "$1" \
  "wget https://github.com/coreos/fleet/releases/download/v0.11.8/fleet-v0.11.8-linux-amd64.tar.gz && \
  tar -zxvf fleet-v0.11.8-linux-amd64.tar.gz && \
  cd fleet-v0.11.8-linux-amd64 && \
  sudo cp fleetctl /opt/bin/ && \
  cd .. && \
  rm -rf fleet-v0.11.8-linux-amd6* && \
  sudo touch /root/.bashrc && \
  sudo echo 'PATH=$PATH:/opt/bin' > /root/.bashrc && \
  sudo echo ETCDCTL_ENDPOINT=https://127.0.0.1:2379/ > /etc/environment"

# reboot machine
ssh -t "$1" \
  "sudo reboot"
