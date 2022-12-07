#!/usr/bin/env bash
#
# set -o pipefail  # trace ERR through pipes
# set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
# set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

declare -a roles=("calculatron"
                  "hq" "fdc" "doop" "dama" "bil"
                  "ofro" "uhat" "as"
                  "ttt" "vds"
                  "spne" "rewe" "ts")

# stop logstash services
cd ../services

#for i in "${roles[@]}"
#do
#  sleep 2s && fleetctl destroy "node-exporter@$i.service"
#done

for i in "${roles[@]}"
do
  sleep 2s && fleetctl start "node-exporter@$i.service"
done