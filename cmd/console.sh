#! /bin/bash
SERVICE_NAMESPACE="localdev"
if [[ "$1" == "" ]]; then
    kubectl get pods --all-namespaces | grep $SERVICE_NAMESPACE | grep -v redis | grep -v postgres
    echo "use cmd/console.sh infra";
else
	    #echo "kubectl get pods --all-namespaces | grep $SERVICE_NAMESPACE | grep $1 | grep -v redis | grep -v postgres | sed 's/^[^ ]\+ \+//' | sed 's/\s.*//'";
    KUBE_NAME=`kubectl get pods --all-namespaces | grep $SERVICE_NAMESPACE | grep $1 | grep -v redis | grep -v postgres | sed 's/^[^ ]\+ \+//' | sed 's/\s.*//'`
	echo connect to $KUBE_NAME
    kubectl -n $SERVICE_NAMESPACE exec -ti $KUBE_NAME -c phpfpm bash
fi
