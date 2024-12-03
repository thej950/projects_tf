# Kubernetes Cluster Setup with kubeadm

This guide outlines the steps to set up a Kubernetes cluster using **kubeadm**, with a **master node** and **worker nodes**.

---

## Prerequisites

1. **Operating System**: Linux-based (Ubuntu, CentOS, etc.)
2. **Tools to Install**:
   - **kubeadm**
   - **kubectl**
   - **kubelet**
   - **docker**
3. **System Requirements**:
   - All nodes should have unique hostnames.
   - Ensure communication between nodes (check firewalls and security groups).

#### Post-Initialization:
1. Configure `kubectl` for the current user:
   ```bash
   mkdir -p $HOME/.kube
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config
   ```
2. Note the `kubeadm join` command output for later use (for worker nodes).


---
### Initialize the Kubernetes Control Plane

#### On Master Node:
Run the following command, replacing `<Master_Private_IP>` with the private IP of your master node:
```bash
sudo kubeadm init --apiserver-advertise-address=<Master_Private_IP> --pod-network-cidr=192.168.0.0/16
```

Example:
```bash
sudo kubeadm init --apiserver-advertise-address=172.31.86.242 --pod-network-cidr=192.168.0.0/16
```

```bash
[root@ip-172-31-86-242 ~]# kubeadm init --apiserver-advertise-address=172.31.86.242  --pod-network-cidr=192.168.0.0/16
I0129 11:22:20.720465   18242 version.go:252] remote version is much newer: v1.29.1; falling back to: stable-1.19
W0129 11:22:20.793856   18242 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
[init] Using Kubernetes version: v1.19.16
[preflight] Running pre-flight checks
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 25.0.1. Latest validated version: 19.03
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [ip-172-31-86-242.ec2.internal kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 172.31.86.242]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [ip-172-31-86-242.ec2.internal localhost] and IPs [172.31.86.242 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [ip-172-31-86-242.ec2.internal localhost] and IPs [172.31.86.242 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 10.503055 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.19" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node ip-172-31-86-242.ec2.internal as control-plane by adding the label "node-role.kubernetes.io/master=''"
[mark-control-plane] Marking the node ip-172-31-86-242.ec2.internal as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: lum8l6.jq8yqw60fvanxeai
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.86.242:6443 --token lum8l6.jq8yqw60fvanxeai \
        --discovery-token-ca-cert-hash sha256:99a3363cce8cbbde4d01e6ffa4afc6cb86266f3f5e86938248cd5c81e15da730
[root@ip-172-31-86-242 ~]#
```
> Above command will also proide token to join worket machines

### Now deploy calico network 
### Step 3: Deploy a Pod Network (Calico)

#### On Master Node:
Install the Calico network plugin to enable communication between pods:
```bash
kubectl apply -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml
```

```bash
[ec2-user@ip-172-31-86-242 ~]$ kubectl apply -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml
configmap/calico-config created
Warning: apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.apps/calico-node created
serviceaccount/calico-node created
deployment.apps/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
[ec2-user@ip-172-31-86-242 ~]$
```
### To generate slave token for join workers 

```bash
kubeadm token create --print-join-command
```
```bash
[ec2-user@ip-172-31-86-242 ~]$ kubeadm token create --print-join-command
W0129 11:28:58.179093   23550 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
kubeadm join 172.31.86.242:6443 --token i8maao.igve7u8nd2gmc0ml     --discovery-token-ca-cert-hash sha256:99a3363cce8cbbde4d01e6ffa4afc6cb86266f3f5e86938248cd5c81e15da730
[ec2-user@ip-172-31-86-242 ~]$
```
---

### ON worker node

Example:
```bash
sudo kubeadm join 172.31.86.242:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```


```bash
kubeadm join 172.31.86.242:6443 --token i8maao.igve7u8nd2gmc0ml     --discovery-token-ca-cert-hash sha256:99a3363cce8cbbde4d01e6ffa4afc6cb86266f3f5e86938248cd5c81e15da730
```
```bash
[root@Worker1 ~]# kubeadm join 172.31.86.242:6443 --token i8maao.igve7u8nd2gmc0ml     --discovery-token-ca-cert-hash sha256:99a3363cce8cbbde4d01e6ffa4afc6cb86266f3f5e86938248cd5c81e15da730
[preflight] Running pre-flight checks
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 25.0.1. Latest validated version: 19.03
        [WARNING Hostname]: hostname "worker1" could not be reached
        [WARNING Hostname]: hostname "worker1": lookup worker1 on 172.31.0.2:53: no such host
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

[root@Worker1 ~]#
```

# Verify On Master Node 
1. Check the status of all nodes:
```bash
kubectl get nodes
```
```bash             
[ec2-user@Master-Node ~]$ kubectl get nodes
NAME                            STATUS   ROLES    AGE     VERSION
ip-172-31-86-242.ec2.internal   Ready    master   11m     v1.19.1
worker1                         Ready    <none>   2m27s   v1.19.1
[ec2-user@Master-Node ~]$
```

2. Check the status of pods:
   ```bash
   kubectl get pods --all-namespaces
   ```

### Troubleshooting Tips
- **Networking Issues**: Ensure that ports 6443 (API server), 10250 (kubelet), and pod network ports are open.
- **Worker Node Not Ready**: Verify `kubelet` logs using:
  ```bash
  journalctl -u kubelet
  ```
- **Docker Compatibility**: Ensure the installed Docker version is compatible with Kubernetes.
