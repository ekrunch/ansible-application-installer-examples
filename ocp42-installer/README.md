# ocp42-installer
Demo for installing Openshift 4.2 on VMware (vCenter required).

** WIP - Almost nothing works here yet **

** Requires Ansible 2.9 - At the time of writing Ansible 2.9 is currently in RC status so things might change with the production version. **

This process automated the User Provisioned Installation (UPI) documented [here](https://docs.openshift.com/container-platform/4.2/installing/installing_vsphere/installing-vsphere.html#installation-dns-user-infra_installing-vsphere)

Please create the RHCOS template yourself before running these as I'm having some challenges with vmware_deploy_ovf

The following steps are performed (This is all still WIP so some of this might not be complete yet)
- Download the OCP 4.2 installer and RHCOS OVA image
- Extract the installer and execute the installation routine to create the required RHCOS meta files
- Upload the bootstrap.ign created in the previous step to a web server. (**User must provide a functioning web server that is acceisble from the bootstrap server as VMware is unable to accept the require base64 configuration from the bootstrap.ign file due to it's size**)
- Create the bootstrap VM
- Create the master VMs and worker VMs and fire the OCP installer to wait for bootstrap complete
- At this point it's on you to remove the bootstrap VM when told to do so and configure OCP.
  - My recommendations are to configure the authentication provider so you can log in with something other than kubeadmin as well as configure the registry storage.

** All of the following is on the "maybe one day" list as they are very infrastructure specific and probably should be done in different roles. **

- Create the relevant load balancer configuration
- Create the relevant DHCP/DNS configuration

Review roles/DemoLab.ocp42/defaults/main.yml for variables that can be changed to make this example work in another environment.

To use this, copy the inventory.sample file to custom/inventory (this folder is ignored by git) and customize it to your environment.
