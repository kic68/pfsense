#!/bin/bash

echo "global \$config;"
echo "parse_config(true);"

index=0
grep '^host' /etc/dhcp/dhcpd.conf | while read line
do
  hostname=$(echo $line | cut -d ' ' -f 2)
  mac=$(echo $line | cut -d '{' -f 2 | cut -d ' ' -f 4 | cut -d';' -f 1)
  ip=$(dig +short $hostname.mydomain.com)

if test -n "$ip"
then
  echo "\$config['dhcpd']['lan']['staticmap']['$index']['mac']=\"$mac\";"
  echo "\$config['dhcpd']['lan']['staticmap']['$index']['cid']=\"$hostname\";"
  echo "\$config['dhcpd']['lan']['staticmap']['$index']['ipaddr']=\"$ip\";"
  echo "\$config['dhcpd']['lan']['staticmap']['$index']['hostname']=\"$hostname\";"
  echo "\$config['dhcpd']['lan']['staticmap']['$index']['descr']=\"Automatically migrated\";"
else
  # echo "NO IP KNOWN FOR $hostname"
  echo -n ""
fi

let index=$index+1
done
echo "write_config();"
echo "exec"
