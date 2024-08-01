#!/bin/bash

set -e
set -x

./build.sh

CCNET_CONF_DIR=/tmp/ccnet
SEAFILE_CONF_DIR=/tmp/seafile-data
LOG_DIR=/tmp/logs

# -------------------------------------------
# MariaDB
# -------------------------------------------
# https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/
curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version="mariadb-10.6"
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y mariadb-server-10.6
# service mysql start
sudo systemctl start mysql.service

SQLROOTPW=root

sudo mysqladmin -u root password $SQLROOTPW

cat > /tmp/.my.cnf <<EOF
[client]
user=root
password=$SQLROOTPW
EOF

sudo mv /tmp/.my.cnf /root/.my.cnf

# sudo cat > /root/.my.cnf <<EOF
# [client]
# user=root
# password=$SQLROOTPW
# EOF

sudo chmod 600 /root/.my.cnf

sudo mysqladmin -uroot -proot create seafile
sudo mysqladmin -uroot -proot create ccnet

######################
# Initialize ccnet/seafile configuration
######################

mkdir ${CCNET_CONF_DIR}
cd ${CCNET_CONF_DIR} && cat >> ccnet.conf <<EOF
[General]
SERVICE_URL = http://127.0.0.1:8000

[Database]
ENGINE = mysql
HOST = 127.0.0.1
PORT = 3306
USER = root
PASSWD = root
DB = ccnet
CONNECTION_CHARSET = utf8mb4
CREATE_TABLES=true
EOF

mkdir ${SEAFILE_CONF_DIR}
cd ${SEAFILE_CONF_DIR} && cat >> seafile.conf <<EOF
[database]
type = mysql
host = 127.0.0.1
port = 3306
user = root
password = root
db_name = seafile
connection_charset = utf8mb4
create_tables=true

EOF

######################
# Stat ccnet/seafile
######################
mkdir ${LOG_DIR}
seaf-server -c ${CCNET_CONF_DIR} -d ${SEAFILE_CONF_DIR} -D all -f - >${LOG_DIR}/seafile.log 2>&1 &
