#! /bin/bash

KUBE_NAME=`kubectl get pods --all-namespaces | grep $1 | grep -v redis | sed 's/^[^\s]\+\s\+//' | sed 's/\s.*//'`
kubectl -n localdev exec -ti $KUBE_NAME -c phpfpm bash