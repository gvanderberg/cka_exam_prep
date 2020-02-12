#!/bin/bash

apt-get update

echo
echo 1\) Install Docker
echo

# curl -sSL https://get.docker.com | bash
apt-get install -y docker.io
cat <<EOF >/etc/docker/daemon.json
{
    "bip": "10.0.60.1/24",
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
systemctl restart docker
systemctl enable docker
usermod $USER -aG docker

echo
echo 2\) Disable Swap
echo

swapoff -a