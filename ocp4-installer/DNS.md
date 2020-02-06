### A quick tutorial on OCP 4.x DNS Load Balancer requirements.

This is my interpretation of the documentation for the UPI installation of VMware. Please see that documentation for more detail.

In this tutorial, I'll use the following as a configuration example.

- 3 Masters, 3 Workers, 1 bootstrap.
- 1 Load Balancer
- Cluster Name : ocp4
- Domain Name : demolab.com

**IP Addresses**
- master1.ocp4.demolab.com - 172.16.31.10
- master2.ocp4.demolab.com - 172.16.31.11
- master3.ocp4.demolab.com - 172.16.31.12
- worker1.ocp4.demolab.com - 172.16.31.20
- worker2.ocp4.demolab.com - 172.16.31.21
- worker3.ocp4.demolab.com - 172.16.31.22
- bootstrap.ocp4.demolab.com - 172.16.31.50

**Load Balancer Configuration**
Example configuration [here](https://github.com/ekrunch/openshift_scripts/tree/master/4.1/UPI)

- HAProxy Node running RHEL 8
- IP Address : 172.16.31.100
- Ports
  - TCP 6443  - k8s API - Pointing to bootstrap and master[1-3]
  - TCP 22623 - CoreOS Ignition - Pointing to bootstrap and master[1-3]
  - TCP 80    - Router Ingress (Insecure) - Pointing to master[1-3] and worker[1-3] (It's done this way because the ingress can initially deploy on master nodes)
  - TCP 443   - Router Ingress (Secure) - Pointing to master[1-3] and worker[1-3]

**DNS Records**

_A Records_
- etcd-0.ocp4.demolab.com    - 172.16.31.10
- etcd-1.ocp4.demolab.com    - 172.16.31.11
- etcd-2.ocp4.demolab.com    - 172.16.31.12

- worker1.ocp4.demolab.com   - 172.16.31.20
- worker2.ocp4.demolab.com   - 172.16.31.21
- worker3.ocp4.demolab.com   - 172.16.31.22

_Optional : Helpful for debugging / later connectivity_
- master1.ocp4.demolab.com   - 172.16.31.10
- master2.ocp4.demolab.com   - 172.16.31.11
- master3.ocp4.demolab.com   - 172.16.31.12

- bootstrap.ocp4.demolab.com - 172.16.31.50

- api.ocp4.demolab.com       - 172.16.31.100 - Points to the load balancer for the 6443 service
- api-int.ocp4.demolab.com   - 172.16.31.100 - Points to the load balancer for the 22623 service

_SRV Records_
- _etcd-server-ssl._tcp.ocp4.demolab.com,etcd-0.ocp4.demolab.com,2380,0,10",
- _etcd-server-ssl._tcp.ocp4.demolab.com,etcd-1.ocp4.demolab.com,2380,0,10",
- _etcd-server-ssl._tcp.ocp4.demolab.com,etcd-2.ocp4.demolab.com,2380,0,10"

_PTR Records_
I recommend that all hosts have a PTR record. The documentation doesn't say that it's required but I find that it helps with the names that show up in the console and relevant CLI commands.

_Wildcard Records_
- *.apps.ocp4.demolab.com     - Points to the load balancer IP for the 80/443 services

**DHCP Reservations**
- 172.16.31.50 - bootstrap.internal.demolab.com - MAC address="00:50:56:11:11:11"

[masters]
- 172.16.31.10 - master1.internal.demolab.com - MAC address="00:50:56:11:22:11"
- 172.16.31.11 - master2.internal.demolab.com - MAC address="00:50:56:11:22:22"
- 172.16.31.12 - master3.internal.demolab.com - MAC address="00:50:56:11:22:33"

[workers]
- 172.16.31.20 - worker1.internal.demolab.com - MAC address="00:50:56:11:33:11"
- 172.16.31.21 - worker2.internal.demolab.com - MAC address="00:50:56:11:33:22"
- 172.16.31.22 - worker3.internal.demolab.com - MAC address="00:50:56:11:33:33"
