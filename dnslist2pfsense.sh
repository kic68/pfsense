#!/bin/bash

# Create a file named alldns.txt filled with 2 columns like these:
# name.domain.com.  192.168.1.1
# name2.domain2.com. 192.168.2.1
# name3.domain2.de. 192.168.2.2

echo "global \$config;"
echo "parse_config(true);"

index=0
cat alldns.txt | while read name ip
do
  hostname=$(echo $name | cut -d '.' -f 1)
  domain=$(echo $name | cut -d '.' -f 2- | sed -e 's/\.$//')

  echo "\$config['unbound']['hosts']['$index']['host']=\"$hostname\";"
  echo "\$config['unbound']['hosts']['$index']['domain']=\"$domain\";"
  echo "\$config['unbound']['hosts']['$index']['ip']=\"$ip\";"
  echo "\$config['unbound']['hosts']['$index']['descr']=\"Automatically migrated\";"

  let index=$index+1
done
echo "write_config();"
echo "exec"
