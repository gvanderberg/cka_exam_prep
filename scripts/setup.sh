#!/bin/bash

AZ_REPO=$(lsb_release -cs)

echo
echo 1\) Install Docker
echo

apt-get update && \
    apt-get install -y docker.io
rm -rf /var/lib/apt/lists/*

cat <<EOF >/etc/docker/daemon.json
{
    "bip": "10.0.60.1/24",
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl restart docker
systemctl enable docker

usermod azuresupport -aG docker

echo
echo 2\) Disable Swap
echo

swapoff -a

echo
echo 3\) Install dependencies
echo

apt-get update && \
    apt-get install -y apt-transport-https openssh-server
rm -rf /var/lib/apt/lists/*

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt-get update && \
    apt-get install -y kubeadm #kubelet kubectl
rm -rf /var/lib/apt/lists/*
rm -rf /etc/apt/sources.list.d/*

apt-mark hold kubeadm #kubelet kubectl