#! /bin/bash

echo nameserver 10.96.0.10 | sudo tee /etc/resolv.conf;echo nameserver 8.8.8.8 | sudo tee --append /etc/resolv.conf
sudo ip r add 10.101.0.0/16 via $(minikube ip)