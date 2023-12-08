# Kubernetes Cluster
This part of the documentation is about creating, updating and maintaining the kubernetes cluster with ansible.

We are not going to go into what is going to be installed in the cluster, except networking. 

## Load Balancers
We have two [load balancers](../load-balancers/) that proxy the traffic to our cluster. 

They are gong to proxy control panel traffic to the master nodes, and the rest of the traffic to the worker nodes through our private network.

## Master Nodes
We are going to run a minimum of three Master Nodes. Later we can add more if we need, or scale them up.

Important things to keep in mind:
1. It is very important to keep them in an odd number, so we can have a majority vote when it comes to the cluster state.
2. Treat them very carefully. If we mess them up, the cluster is in real troubble.
3. Make sure to take down a node for maintenance in a proper way. Read more about that [here](https://kubernetes.io/docs/tasks/administer-cluster/highly-available-master/#maintaining-high-availability-of-the-control-plane-nodes).

## Worker Nodes
We are going to use Hetzner Root Servera aka. dedicated servers for our worker nodes. Here we are going to get A LOT more power for our money.

## 🚀 Getting Started

### Adding the first master node
This part is a bit different from the other parts. The first node is going to be the one that sets up the cluster, and the other nodes are going to join it.

1. Upadte the configurations in `./group_vars`, `./host_vars` and `./inventory.yaml` Make sure to change the filename in `./host_vars` to mach the name of the host in `./inventory.yaml`.
2. Run the playbooks in order: `./playbooks/01-kubernetes-common.yaml` and `./playbooks/02-kubernetes-master-init.yaml`

To run kubectl on your local machine, run 
`scp root@master1.<domain>:/etc/kubernetes/admin.conf ~/.kube/config`
> Make sure to update the <domain> with your domain name.

Check the kubernetes status:
1. `kubectl get pods -n kube-system`
2. `kubectl get pods -n kube-flannel`
3. `kubectl get nodes`


## Adding nodes to the cluster
Adding nodes to the cluster is very easy. You just need to run the following command:

`./playbooks/03-kubernetes-join-nodes.yaml --limit "master1.<domain>,worker1.<domain>"`
> Be sure to change the limit to the main master node and the new node you want to add.

After the process is complete, you should see a new node in the kubernetes cluster.

## Removing a node from the cluster
1. `kubectl get nodes`
2. `kubectl drain <node-name> --ignore-daemonsets`
3. `kubectl delete node <node-name>`

> If you want to add the node to this or some other cluster, then you need to run `kubeadm reset` first.


## Troubleshooting

### Join does not work
If you have set limit to hosts, then make sure to not exclude the master node.