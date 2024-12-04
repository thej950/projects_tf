#!/bin/bash

LOG_FILE="/var/log/k8s-setup.log"
touch $LOG_FILE
exec > >(tee -a $LOG_FILE) 2>&1

log_and_exit() {
  echo "[ERROR] $1"
  exit 1
}

echo "########## Starting Kubernetes Setup ##########"

# Run commands as root
if [[ $EUID -ne 0 ]]; then
  log_and_exit "This script must be run as root. Use sudo."
fi

echo "########## Installing Prerequisite Packages ##########"
yum install -y -q yum-utils device-mapper-persistent-data lvm2 >/dev/null 2>&1 || \
  log_and_exit "Failed to install prerequisite packages"

echo "########## Adding Docker Repository ##########"
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >/dev/null 2>&1 || \
  log_and_exit "Failed to add Docker repository"

echo "########## Installing Docker ##########"
yum install -y -q docker-ce >/dev/null 2>&1 || log_and_exit "Failed to install Docker"

echo "########## Starting and Enabling Docker ##########"
systemctl start docker || log_and_exit "Failed to start Docker"
systemctl enable docker || log_and_exit "Failed to enable Docker"

echo "########## Disabling SELinux ##########"
setenforce 0 || log_and_exit "Failed to set SELinux to permissive mode"
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux || \
  log_and_exit "Failed to update SELinux configuration"

echo "########## Disabling Swap ##########"
sed -i '/swap/d' /etc/fstab || log_and_exit "Failed to remove swap entry from /etc/fstab"
swapoff -a || log_and_exit "Failed to disable swap"

echo "########## Configuring Sysctl for Kubernetes ##########"
cat <<EOF >/etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1 || log_and_exit "Failed to apply sysctl settings"

echo "########## Adding Kubernetes Repository ##########"
cat <<EOF >/etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "########## Installing Kubernetes Components ##########"
yum install -y kubeadm-1.19.1 kubelet-1.19.1 kubectl-1.19.1 >/dev/null 2>&1 || \
  log_and_exit "Failed to install Kubernetes components"

echo "########## Starting and Enabling Kubelet ##########"
systemctl start kubelet || log_and_exit "Failed to start Kubelet"
systemctl enable kubelet || log_and_exit "Failed to enable Kubelet"

echo "########## Kubernetes Setup Completed Successfully ##########"
