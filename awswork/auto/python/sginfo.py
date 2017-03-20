#!/usr/bin/env python
import boto.ec2
import hashlib
import logging
try:
 conn = boto.ec2.connect_to_region ("cn-north-1")
 current_sgs = conn.get_all_security_groups()
except boto.exception.BotoServerError, e:
  logging.error(e.error_message)
conn.close()
for sg in current_sgs:
 print "="*72
 print "id:\t\t", sg.id
 print "name:\t\t", sg.name
 print "vpc:\t\t", sg.vpc_id
 print "instance:\t", sg.instances()
 print "ingress rules:"
 for rule in sg.rules:
  ruledata = sg.id,rule.grants,rule.ip_protocol,rule.from_port,rule.to_port,"ingress"
  rulehash=hashlib.sha256(str(ruledata)).hexdigest()
  print "\thash:",rulehash
  print "\t",rule.grants,"-> [instance]:",rule.from_port,"-",rule.to_port,rule.ip_protocol
 print "egress rules:"
 for rule in sg.rules_egress:
  ruletuple = sg.id,rule.grants,rule.ip_protocol,rule.from_port,rule.to_port,"ingress"
  rulehash=hashlib.sha256(str(ruletuple)).hexdigest()
  print "\thash:",rulehash
  print "\t[instance]->",rule.grants,":",rule.from_port,"-",rule.to_port,rule.ip_protocol
 print "="*72
