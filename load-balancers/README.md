# Load Balancers
We are now going to set up two load balancers that are going to proxy traffic to our kubernetes cluster with HaProxy. If one server goes down, the other one will automatically take over the floating IP with Keepalived.

## Why not have the floating IP directly on the Kubernetes cluster?
The main reason why is that we don't want to overwhelm a single node inside of the cluster. This could disrupt the cluster, and make it unstable.

### HAProxy
The proxy we are going to use is HAPRoxy. It's a very fast and reliable proxy that can handle a lot of traffic. It's also very easy to configure and maintain.

The proxy is not going to to a lot of heavy lifting, it's just going to proxy the traffic to the correct destination based on ports.

All kubectl traffic (6443) is going to be proxied to the Kubernetes Master Nodes. Other ports are going to be proxied to the worker nodes.

### Keepalived
To move the floating IP between the load balancers, we are going to use Keepalived. It's a very simple and reliable tool that can be used to move the floating IP between the load balancers.

### Floating IP Gotchas
Nb: To assign the floating IP to the machines, we can't rely on just putting it directly on to the machine with keepalived virtual ip's. We have to run a script that targets the Hetzner API to assign the floating IP to the machine.

Nb2: You have to also make a [netplan config](https://docs.hetzner.com/cloud/floating-ips/persistent-configuration) that has the IP attached on all the relevant machines. Or else it wont work.

> Both of these is defined in the Ansible playbook, so you don't have to worry in the about this.

## 🚀 Getting started

### Step 1: Reserve a floating IP
First we need to reserve a floating IP in Hetzner Cloud. This is done through the Hetzner Cloud Console. Make sure to reserve it in the same project as your Kubernetes cluster. We are only going to use ipv4 for now.

### Step 2: Update variable files
There are some variable files that you need to update before you can run the playbook. They are:
- `inventory.yaml`
- `group_vars/all.yaml`
- `host_vars/lb1.yaml`
- `host_vars/lb2.yaml`

> Make sure to create a new vault password file, and store the key for safe keeping. You will need it to run the playbook. More information can be found [here](https://docs.ansible.com/ansible/latest/vault_guide/index.html).

### Step 3: Run playbook
To run the playbook, you will have to put your ansible vault password in a file, and change the path in the command below. Then run the following command:

`ansible-playbook -i inventory.yaml playbook.yaml --vault-password-file </path/to/master/key>`

# Checks/Deugging
To debug the load balancers, and see if things are working, then try the following:

## SSH Intro both Load Balancers and run the following commands

### Check if Floating IP is connected
1. run `ip a list` and check if your floating IP is connected to the `eth0` interface on one of the servers

## Check if Keepalived is running
1. run `systemctl status keepalived` on both machines. Check if the service is running on one both of them.

## Check if HAProxy is running
1. run `systemctl status haproxy` on both machines. Check if the service is running on one both of them.

## Check if floating IP automatically moves between the servers
1. run `journalctl -flu keepalived` on both servers, to see the keepalived messages.
2. Open two more panes to the servers, and run `watch -n 5 ip a list` on both of them. Make sure you are not looking at the same machine twise.
3. run `reboot` on the server that has the floating IP connected to it. 
4. Check if the floating IP moves to the other server.
5. Also check if the floating IP is connected in the Hetzner Cloud Interface.
6. Lastly try to access the floating IP through your browser, and check the logs in the terminal. You should see the requests coming in.


