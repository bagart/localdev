#! /bin/bash
sudo minikube delete

rm -rf ~/.minikube/ ~/.kube ~/.localdev ~/.helm

echo nameserver 8.8.8.8 | sudo tee /etc/resolv.conf
echo nameserver 8.8.4.4 | sudo tee --append /etc/resolv.conf
