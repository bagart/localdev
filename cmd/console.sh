#! /bin/bash
SERVICE_NAMESPACE="localdev"
SERVICE_NAME="$1"
IGNORED_PODS_REGEXP='redis|postgres|beanstalkd|service-bus'

if [[ "$SERVICE_NAME" == "" ]]; then
    kubectl get pods --all-namespaces | grep $SERVICE_NAMESPACE | grep -vP $IGNORED_PODS_REGEXP
    echo usage: 'cmd/console.sh ext-api'
else
    KUBE_LINE=`kubectl get pods --all-namespaces | grep $SERVICE_NAMESPACE | grep $SERVICE_NAME | grep -vP $IGNORED_PODS_REGEXP`
    #echo KUBE_LINE is $KUBE_LINE
    KUBE_NAME=`echo $KUBE_LINE | sed 's/^[^ ]\+ \+//' | sed 's/\s.*//'`
	echo connect to $KUBE_NAME
    kubectl -n $SERVICE_NAMESPACE exec -ti $KUBE_NAME -c phpfpm bash
fi
