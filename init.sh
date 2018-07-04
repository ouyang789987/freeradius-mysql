#!/bin/bash

sed -i -e "/client localhost/i client 0.0.0.0/0{\n\tsecret = $radpass\n}" \
  -e "/client localhost/i client ipv6{\n\tipv6addr = ::\n\tsecret = $radpass\n}" \
  -e "s/testing123/$radpass/" /etc/freeradius/clients.conf
sql_driver='mysql'
sed -i "/driver =.*/ a\ \n\tserver = \"$mysql_server\"\n\tlogin = \"$mysql_login\"\n\tpassword = \"$mysql_passwd\"\n\tradius_db = \"$mysql_database\"" /etc/freeradius/mods-available/sql


radius_certificate=$(redis-cli -h redis.web.svc.cluster.local -p 6379 get radius.pushto.space:latest)
echo "$radius_certificate" | python3 -c "import sys, json; print(json.load(sys.stdin)['fullchain_pem'])" > /home/fullchain.pem
echo "$radius_certificate" | python3 -c "import sys, json; print(json.load(sys.stdin)['privkey_pem'])" > /home/privkey.pem


/usr/sbin/freeradius -f -X
