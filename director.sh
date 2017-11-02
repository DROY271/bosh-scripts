#!/bin/bash

# Store the current working directory as W.
W=`pwd`

# Location where the bosh deployment is
BOSH_DEPLOYMENT="$W/workspace/bosh-deployment"

source utils.sh
source cli.sh
source install_boshcli_v2.sh
source bosh.sh

#Dispatch the invocation.
dispatch $@
