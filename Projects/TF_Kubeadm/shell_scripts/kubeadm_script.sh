#!/bin/bash
sudo su -
yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce >/dev/null 2>&1
systemctl start docker
systemctl enable docker
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i '/swap/d' /etc/fstab
swapoff -a
echo -e "net.bridge.bridge-nf-call-ip6tables = 1 \nnet.bridge.bridge-nf-call-iptables = 1" >>/etc/sysctl.d/kubernetes.conf
echo -e "[kubernetes] \nname=Kubernetes \nbaseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 \nenabled=1 \ngpgcheck=1 \nrepo_gpgcheck=1 \ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg \n    https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" >>/etc/yum.repos.d/kubernetes.repo
yum install -y kubeadm-1.19.1 kubelet-1.19.1 kubectl-1.19.1
systemctl start kubelet
systemctl enable kubelet