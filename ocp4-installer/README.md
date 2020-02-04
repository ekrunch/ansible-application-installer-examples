# ocp4-installer
Demo for installing Openshift 4.x on VMware (Tested using ESXi 6.5 w/ vCenter 6.5).

** WIP - Functional but needs work **

This process automates some of the User Provisioned Installation (UPI) for VMware documented [here](https://docs.openshift.com/container-platform/4.2/installing/installing_vsphere/installing-vsphere.html#installation-dns-user-infra_installing-vsphere)

Prerequisites:
- Ansible 2.9 - Several of the VMware modules used in this project are new for 2.9.
- Accessible Web Server - The example uses nginx on port 80. Define the web server in the bootstrapwebservers of the inventory
- DNS entries should be set up already (A records and SRV records are required, I recommend A/PTR for all of the worker nodes as well)
  - See the DNS.md for instructions on this process. They are also covered in the documentation.
- Load Balancer should be set up already. Example configurations for HAProxy are available in my openshift_scripts repo [here](https://github.com/ekrunch/openshift_scripts/tree/master/4.1/UPI)
- Static DHCP mappings are used in this example so set those up and then put the MAC Addresses in the inventory file. Note that the boot process for OCP 4 requires DHCP so you'll need it even if you change the IP settings manually later. Also note that in VMware, you can only assign certain MAC Address ranges to VMs. The included sample inventory has a correct range for VMware so change the last 6 digits accordingly or just use the provided ranges.
- Customize the inventory.sample and copy it to custom/inventory. The scripts are keyed to look for this inventory file. If you're familiar with Ansible, you can redirect it to a different inventory file as needed.

Notes:
- Automatic template creation of the RHCOS OVA might not function correctly. There are some known issues with the vmware_deploy_ovf module in Ansible. If it doesn't work, please create the RHCOS template yourself (as per OCP installation instructions). You can set deploy_ova to false in the inventory to skip this step.

The following steps are performed by the Ansible playbooks
- Download and deploy the OCP 4.x client, installer, and RHCOS OVA image. (Client / OVA download are optional and can be disabled. See inventory.sample)
- Extract the installer and execute the installation routine to create the required RHCOS meta files (bootstrap.ign, master.ign, worker.ign)
- Create the append-bootstrap.ign
- Create the bootstrap, master, and worker VMs from the RHCOS OVA and update their metadata with the RHCOS metadata.
- Upload the bootstrap.ign created by the installer to a web server. (**User must provide a functioning web server that is acceisble from the bootstrap server as VMware is unable to accept the require base64 configuration from the bootstrap.ign file due to it's size**)
- Start the nodes if configured.

Post run Steps
- If the Ansible playbook didn't start the nodes for you, start them. 
- Execute the installer to wait for bootstrap complete (_./openshift-install --dir data wait-for bootstrap-complete_)
  - Note that bootstrapping can take 10-20 minutes to complete. To view status, ssh as the "core" user to the bootstrap node and it will tell you the command to watch the bootstrap process. This can also help diagnose bootstrapping errors. If the bootstrap node won't accept the login using the "core" user and the SSH key provided in the installation, it might not have booted correctly. Check the console in VMware for errors, and ensure that it downloaded the bootstrap.ign from the web server.
- After that you'll need to configure the cluster using the OC client. (If the option was enabled, It's downloaded along with the installer) 
- As per the OCP insutrctions, you'll need to configure the image registry and authentication providers.
  - View operator status with the command _oc get clusteroperators_
- Once all of the operators are online, you can execute the installer again with the "_./openshift-install --dir data wait-for install-complete_" option.

** All of the following is on the "maybe one day" list as they are infrastructure specific and probably should be done in different roles. **

- Configure authentication / registry
- Execute the wait for bootstrap / install complete
- Create the relevant load balancer configuration
- Create the relevant DHCP/DNS configuration

Review roles/ocp4.install/defaults/main.yml for variables that can be changed to make this example work in another environment.

To use this, copy the inventory.sample file to custom/inventory (this folder is ignored by git) and customize it to your environment.

After inventory customization is completed, use the following playbooks / scripts
- get_hosts.sh - Use this script to determine if your inventory is working as expected. It will list the hosts in inventory by group
- get_vmware_info.sh - Use this script to gather information about the VMware cluster and test connectivity
- install_ocp_4.sh - This triggers the installation for OCP 4.x via the role

