#!/usr/bin/env bash
source config

echo -=-=-=- starting install_kubernetes.sh -=-=-=-
source install_kubernetes.sh

echo -=-=-=- starting helm init -=-=-=-
helm init

echo -=-=-=- sleep 70 -=-=-=-
sleep 70

echo -=-=-=- starting install_services -=-=-=-
source install_services.sh
