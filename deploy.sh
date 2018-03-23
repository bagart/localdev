#!/usr/bin/env bash
source config

echo -=-=-=- starting install_kubernetes.sh -=-=-=-
source install_kubernetes.sh

echo -=-=-=- starting helm init -=-=-=-
source get_helm.sh
echo -=-=-=- sleep 100 -=-=-=-
sleep 100
echo -=-=-=- helm init -=-=-=-
helm init

echo -=-=-=- sleep 100 -=-=-=-
sleep 100

echo -=-=-=- starting install_services -=-=-=-
source install_services.sh
