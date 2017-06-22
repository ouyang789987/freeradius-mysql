#!/bin/bash

if [[ -h /etc/freeradius/mods-enabled/sql ]]; then
  exit 0
fi

sed -i "s/allow_vulnerable_openssl.*/allow_vulnerable_openssl = yes/" /etc/freeradius/radiusd.conf
sed -i '0,/md5/{s/md5/mschapv2/}' /etc/freeradius/mods-available/eap


bash -c "echo Europe/Amsterdam > /etc/timezone"
dpkg-reconfigure -f noninteractive tzdata