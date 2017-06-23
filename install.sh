#!/bin/bash

if [[ -h /etc/freeradius/mods-enabled/sql ]]; then
  exit 0
fi

sed -i "s/allow_vulnerable_openssl.*/allow_vulnerable_openssl = yes/" /etc/freeradius/radiusd.conf
sed -i "s/radius_db.*/#radius_db = \"radius\"/" /etc/freeradius/mods-available/sql
sed -i '0,/md5/{s/md5/mschapv2/}' /etc/freeradius/mods-available/eap

sed -i -e "s/driver =.*/driver = \"rlm_sql_mysql\"/" -e "s/dialect =.*/dialect = \"mysql\"/" /etc/freeradius/mods-available/sql
ln -s /etc/freeradius/mods-available/sql /etc/freeradius/mods-enabled/sql

bash -c "echo Europe/Amsterdam > /etc/timezone"
dpkg-reconfigure -f noninteractive tzdata