#!/usr/bin/env bash

## Get kubernetes binaries
source config
source apps/get_minikube.sh
source apps/get_kubectl.sh
source apps/get_helm.sh

source deploy.sh