#!/bin/bash

set -e
set -x

./build.sh

CCNET_CONF_DIR=/tmp/ccnet
SEAFILE_CONF_DIR=/tmp/seafile-data
LOG_DIR=/tmp/logs

######################
# Initialize ccnet/seafile configuration
######################

mkdir ${CCNET_CONF_DIR}
cd ${CCNET_CONF_DIR} && cat >> ccnet.conf <<EOF
[Database]
CREATE_TABLES=true
EOF

mkdir ${SEAFILE_CONF_DIR}
cd ${SEAFILE_CONF_DIR} && cat >> seafile.conf <<EOF
[database]
create_tables=true
EOF

######################
# Stat ccnet/seafile
######################
mkdir ${LOG_DIR}
seaf-server -c ${CCNET_CONF_DIR} -d ${SEAFILE_CONF_DIR} -D all -f - >${LOG_DIR}/seafile.log 2>&1 &
