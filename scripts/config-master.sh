#!/bin/bash

kubeadm config images pull -v3

kubeadm init --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=NumCPU

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml
