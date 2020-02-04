#!/bin/bash

function usage {
  echo "Usage: $0 (on|off)"
  exit 1
} 

#if [ "$#" -ne 1 ]; then
#  usage
#fi

case $1 in
	on) 
		echo "Power on Guests"
		POWERSTATE="powered-on"
		;;
	off)
		echo "Power off Guests"
		POWERSTATE="shutdown-guest"
		;;
	*)
		usage
esac

echo Setting Power State to ${POWERSTATE} for call to vmware_guest_powerstate module
ansible-playbook -i ./custom/inventory cluster_power.yml -e "VM_POWERSTATE=${POWERSTATE}"
