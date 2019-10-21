# ocp42-installer
Demo for installing Openshift 4.2 on VMware (vCenter required).

** WIP - Nothing works here yet **

** Requires Ansible 2.9 - At the time of writing Ansible 2.9 is currently in RC status so things might change with the production version. **

This process automated the User Provisioned Installation (UPI) documented [here](https://docs.openshift.com/container-platform/4.2/installing/installing_vsphere/installing-vsphere.html#installation-dns-user-infra_installing-vsphere)

The following steps are performed (This is all still WIP so some of this might not be complete yet)
- Create a VMware folder and create the RHCOS template in that folder
- Execute the installation routine to create the required RHCOS meta files
- Upload the bootstrap.ign created in the previous step to a web server. (**User must provide a functioning web server that is acceisble from the bootstrap server as VMware is unable to accept the require base64 configuration from the bootstrap.ign file due to it's size**)
- Create the relevant load balancer configuration
- Create the bootstrap VM and relevant DNS configuration
- Create the master VMs, remove the bootstrap VM, then create the worker VMs.

Review roles/DemoLab.ocp42/defaults/main.yml for variables that can be changed to make this example work in another environment.

To use this, copy the inventory.sample file to custom/inventory (this folder is ignored by git) and customize it to your environment.
