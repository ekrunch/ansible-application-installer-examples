#!/bin/bash
ansible-playbook -i ./custom/inventory install_ocp_4.yml $1 $2 $3 $4
