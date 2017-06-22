#!/bin/bash


sed -i -e "/client localhost/i client 0.0.0.0/0{\n\tsecret = $radpass\n}" \
  -e "/client localhost/i client ipv6{\n\tipv6addr = ::\n\tsecret = $radpass\n}" \
  -e "s/testing123/$radpass/" /etc/freeradius/clients.conf
sql_driver='mysql'
sed -i "/driver =.*/ a\ \n\tserver = \"$mysql_server\"\n\tlogin = \"$mysql_login\"\n\tpassword = \"$mysql_passwd\"" /etc/freeradius/mods-available/sql

sed -i -e "s/driver =.*/driver = \"rlm_sql_mysql\"/" -e "s/dialect =.*/dialect = \"mysql\"/" /etc/freeradius/mods-available/sql
ln -s /etc/freeradius/mods-available/sql /etc/freeradius/mods-enabled/sql
