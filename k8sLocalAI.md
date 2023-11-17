Setting up k8sGPT + LocalAI on K8s cluster:


1. Install Helm:

```
wget https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz
tar -zxvf helm-v3.9.4-linux-amd64.tar.gz 
sudo mv linux-amd64/helm /usr/local/bin/helm
```

2. LocalAI setup:

a) Add helm repo

```
helm repo add go-skynet https://go-skynet.github.io/helm-charts/
```

b) create values.yml file for helm :

```
deployment:
  image: quay.io/go-skynet/local-ai:latest
  env:
    threads: 4
    context_size: 512
  modelsPath: "/models"
  imagePullSecrets:
     - name: <image pull secret to pull busybox images>

# Models to download at runtime
models:
  # Whether to force download models even if they already exist
  forceDownload: false

  # The list of URLs to download models from
  # Note: the name of the file will be the name of the loaded model
  list:
    - url: "https://gpt4all.io/models/ggml-gpt4all-j.bin"
      # basicAuth: base64EncodedCredentials

  # Persistent storage for models and prompt templates.
  # PVC and HostPath are mutually exclusive. If both are enabled,
  # PVC configuration takes precedence. If neither are enabled, ephemeral
  # storage is used.
  persistence:
    pvc:
      enabled: true
      size: 6Gi
      accessModes:
        - ReadWriteOnce

      annotations: {}

      # Optional
      storageClass: <storage-classs>


service:
  type: ClusterIP
  # If deferring to an internal only load balancer
  # externalTrafficPolicy: Local
  port: 80
  annotations: {}
  # If using an AWS load balancer, you'll need to override the default 60s load balancer idle timeout
  # service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "1200"


image:
  pullPolicy: IfNotPresent
```
