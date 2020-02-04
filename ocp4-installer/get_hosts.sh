#!/bin/bash
ansible-playbook -i ./custom/inventory get_hosts.yml $1 $2 $3 $4
