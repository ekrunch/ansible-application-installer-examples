#!/bin/bash
ansible-playbook -i ./custom/inventory get_vmware_info.yml $1 $2 $3 $4
