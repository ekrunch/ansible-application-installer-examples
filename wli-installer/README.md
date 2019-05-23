# wli-installer
Demo for installing WLI 12c and Fusion Middleware using Ansible.

This example does several things
- Mounts an NFS share where the JDK and WLI binaries are located and validates that required binaries exist
- Installs JDK
- Creates an oracle user and oinstall group as well as /u01 directory structure
- Installs WLI
- Optional installs Fusion Middleware (see defaults file listed below)

Review roles/DemoLab.WLI/defaults/main.yml for variables that can be changed to make this example work in another environment.

