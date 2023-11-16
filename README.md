# k8sgpt-shankar


Install:

Mac:

```
brew tap k8sgpt-ai/k8sgpt
brew install k8sgpt
```

Version:

```
k8sgpt version
```

Without any backend  configured:

```
k8sgpt analyze   

Error: AI provider openai not specified in configuration. Please run k8sgpt auth
Error: AI provider not specified in configuration
```

List of configured providers:

```
k8sgpt auth list                                 
Default: 
> openai
Active: 
Unused: 
> openai
> localai
> azureopenai
> noopai
> cohere
> amazonbedrock
> amazonsagemaker
```

SetUp LocalAI:

```
# Clone LocalAI
git clone https://github.com/go-skynet/LocalAI

cd LocalAI

# (optional) Checkout a specific LocalAI tag
# git checkout -b build <TAG>

# Download luna-ai-llama2 to models/
wget https://huggingface.co/TheBloke/Luna-AI-Llama2-Uncensored-GGUF/resolve/main/luna-ai-llama2-uncensored.Q4_0.gguf -O models/luna-ai-llama2

# Use a template from the examples
cp -rf prompt-templates/getting_started.tmpl models/luna-ai-llama2.tmpl

# (optional) Edit the .env file to set things like context size and threads
# vim .env

# start with docker compose
docker compose up -d --pull always
# or you can build the images with:
# docker compose up -d --build
# Now API is accessible at localhost:8080
curl http://localhost:8080/v1/models
# {"object":"list","data":[{"id":"luna-ai-llama2","object":"model"}]}

curl http://localhost:8080/v1/chat/completions -H "Content-Type: application/json" -d '{
     "model": "luna-ai-llama2",
     "messages": [{"role": "user", "content": "How are you?"}],
     "temperature": 0.9
   }'

# {"model":"luna-ai-llama2","choices":[{"message":{"role":"assistant","content":"I'm doing well, thanks. How about you?"}}]}
```

Issues: The MAC 8core 32GB is struck when trying to run inference



Local AI k8s setup:

1. Helm install (RHEL 8.6)
```
wget https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz
tar -zxvf helm-v3.9.4-linux-amd64.tar.gz 
sudo mv linux-amd64/helm /usr/local/bin/helm

```

2. helm 

```
helm repo add go-skynet https://go-skynet.github.io/helm-charts/
```

values.yaml

```
deployment:
  image: quay.io/go-skynet/local-ai:latest
  env:
    threads: 4
    context_size: 512
  modelsPath: "/models"
  imagePullSecrets:
     - name: docker-registry-secret

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
      enabled: false
      size: 6Gi
      accessModes:
        - ReadWriteOnce

      annotations: {}

      # Optional
      storageClass: nfs-client


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

Install:

```
helm install local-ai go-skynet/local-ai -f values.yaml
```

useful Helm Commands:

```
helm search repo
helm search repo go-skynet/local-ai
helm template my-release go-skynet/local-ai --dry-run --debug > manifests.yaml
```

https://localai.io/basics/getting_started/index.html#fast-setup


To authenticate to a specific backend:

```k8sgpt auth --backend noopai --password sensitive```


Refernces:

https://anaisurl.com/k8sgpt-full-tutorial/

https://itnext.io/k8sgpt-localai-unlock-kubernetes-superpowers-for-free-584790de9b65
