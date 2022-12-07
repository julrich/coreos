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

# generate certificates
echo '{"CN":"calculonc","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca="$CFSSL_CONFIG_LOCATION/ca.pem" -ca-key="$CFSSL_CONFIG_LOCATION/ca-key.pem" -config="$CFSSL_CONFIG_LOCATION/ca-config.json" -profile="client" - | cfssljson -bare "$CFSSL_CONFIG_LOCATION/calculonc"

