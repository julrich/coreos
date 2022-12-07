#!/bin/bash

# TODO: why do set directions don't work in sourced scripts?
# set -o pipefail  # trace ERR through pipes
# set -o errtrace  # trace ERR through 'time command' and other functions
# set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
# set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

# we take one argument to set tunnelendpoint right 

MACHINE_SUFFIX='fdc'

if [[ "$#" -eq 1 ]]; then
    case "$1" in
    ttt1) 
    echo "Setting TTT1..."
    MACHINE_SUFFIX="ttt1"
    ;;
    ttt2)
    echo "Setting TTT2..."
    MACHINE_SUFFIX="ttt2"
    ;;
    ttt3)
    echo "Setting TTT3..."
    MACHINE_SUFFIX="ttt3"
    ;;
    ttt4)
    echo "Setting TTT4..."
    MACHINE_SUFFIX="ttt4"
    ;;
    fdc)
    echo "Setting FDC..."
    MACHINE_SUFFIX="fdc"
    ;;
    *)
    echo "Taking FDC (as it should be default)"
    MACHINE_SUFFIX="fdc"
    ;;
    esac

    export FLEETCTL_TUNNEL=momcorp${MACHINE_SUFFIX}.ruhmesmeile.systems:2222
    echo "FLEETCTL_TUNNEL = ${FLEETCTL_TUNNEL}" 

else
    # we need to source this script to make the work with env-variable from parent shell!
    echo "Usage: . setft <MachineSuffix>"
    echo "Try again wiht right argument!"
fi
