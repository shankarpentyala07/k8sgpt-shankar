Setting up k8sGPT + LocalAI on K8s cluster:


1. Install Helm:

```
wget https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz
tar -zxvf helm-v3.9.4-linux-amd64.tar.gz 
sudo mv linux-amd64/helm /usr/local/bin/helm
```

2. LocalAI setup:

Add helm repo

```
helm repo add go-skynet https://go-skynet.github.io/helm-charts/
```
