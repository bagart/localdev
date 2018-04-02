#! /bin/bash

if [[ "$1" == "" ]]; then
    kubectl get pods --all-namespaces | grep localdev | grep -v redis
    echo "use cmd/console.sh ext-api";
else
    KUBE_NAME=`kubectl get pods --all-namespaces | grep $1 | grep -v redis | sed 's/^[^\s]\+\s\+//' | sed 's/\s.*//'`
    kubectl -n localdev exec -ti $KUBE_NAME -c phpfpm bash
fi

