#!/usr/bin/env bash

## Get kubernetes binaries
source config
source get_minikube.sh
source get_kubectl.sh
source get_helm.sh

## Install kubernetes using minikube
source install_kubernetes.sh

helm init
sleep 70
echo "== Installing defined services =="
source install_services.sh
