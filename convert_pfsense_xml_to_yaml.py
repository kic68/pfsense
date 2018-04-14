#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import xmltodict
from ruamel.yaml import YAML
import re
import sys

from pprint import pprint

with open("./apu.config", 'rb') as apu:
    config=xmltodict.parse(apu)

c = {}
c['hosts']={}

netmap = { "lan": "1", "opt15": "155", "opt4": "66", "opt5": "77", "opt14": "33" }

for net in config['pfsense']['dhcpd'].keys():
    if 'staticmap' in config['pfsense']['dhcpd'][net]:
        for host in config['pfsense']['dhcpd'][net]['staticmap']:
            fqdn = host['hostname'] + '.iantor.de'
            c['hosts'][fqdn] = {}
            c['hosts'][fqdn]['hostname'] = host['hostname']
            c['hosts'][fqdn]['ip'] = host['ipaddr']
            c['hosts'][fqdn]['domain'] = 'iantor.de'
            c['hosts'][fqdn]['mac'] = host['mac']
            c['hosts'][fqdn]['vlan'] = netmap[net]
            print (host)

for host in config['pfsense']['unbound']['hosts']:
    fqdn = host['host'] + '.' + host['domain']
    c['hosts'][fqdn] = {}
    c['hosts'][fqdn]['ip'] = host['ip']
    c['hosts'][fqdn]['hostname'] = host['host']
    c['hosts'][fqdn]['domain'] = host['domain']
    
yaml=YAML()
yaml.default_flow_style = False
print(yaml.dump(c, sys.stdout))

print (config['pfsense']['unbound']['hosts'])
