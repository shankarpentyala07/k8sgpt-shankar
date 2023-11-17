# Setting up k8sGPT + LocalAI on K8s cluster:


1. Install Helm:

```
wget https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz
tar -zxvf helm-v3.9.4-linux-amd64.tar.gz 
sudo mv linux-amd64/helm /usr/local/bin/helm
```

## 2. LocalAI setup:

a) Add helm repo

```
helm repo add go-skynet https://go-skynet.github.io/helm-charts/
```

b) create pull secret:

Command:

```
kubectl create secret docker-registry docker-registry-secret --docker-server=docker.io --docker-username=<username> --docker-password=<password>
```

Example:

```
kubectl create secret docker-registry docker-registry-secret --docker-server=docker.io --docker-username=shankarpentyala07 --docker-password=<password>
```

c) create values.yml file for helm :

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

d) Install the chart:

```
helm install local-ai go-skynet/local-ai -f values.yml --version 2.1.2
```

Sample Output:
```
helm install local-ai go-skynet/local-ai -f values.yml --version 2.1.2
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/auth/kubeconfig
I1117 14:59:30.943408  122252 request.go:601] Waited for 1.186391393s due to client-side throttling, not priority and fairness, request: <api>
W1117 14:59:36.907532  122252 warnings.go:70] unknown field "spec.template.spec.containers[0].imagePullSecrets"
W1117 14:59:36.907554  122252 warnings.go:70] unknown field "spec.template.spec.initContainers[0].imagePullSecrets"
NAME: local-ai
LAST DEPLOYED: Fri Nov 17 14:59:34 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

```

### Issue:

Current , bug is imagePullSecrets doesn't get applied to the deployment

Workaround: (Patch Deployment)

```
kubectl patch deployment local-ai  -p '{"spec": {"template": {"spec": {"imagePullSecrets": [{"name": "docker-registry-secret"}]}}}}'
kubectl scale deploy local-ai --replicas=0
kubectl scale deploy local-ai --replicas=1
```
Successful Install logs:

```
 oc logs local-ai-84db9544b6-z586k
Defaulted container "local-ai" out of: local-ai, download-model (init)
@@@@@
Skipping rebuild
@@@@@
If you are experiencing issues with the pre-compiled builds, try setting REBUILD=true
If you are still experiencing issues with the build, try setting CMAKE_ARGS and disable the instructions set as needed:
CMAKE_ARGS="-DLLAMA_F16C=OFF -DLLAMA_AVX512=OFF -DLLAMA_AVX2=OFF -DLLAMA_FMA=OFF"
see the documentation at: https://localai.io/basics/build/index.html
Note: See also https://github.com/go-skynet/LocalAI/issues/288
@@@@@
CPU info:
model name	: AMD EPYC-Milan Processor
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm rep_good nopl cpuid extd_apicid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm cmp_legacy svm cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw topoext perfctr_core ssbd ibrs ibpb stibp vmmcall fsgsbase tsc_adjust bmi1 avx2 smep bmi2 rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves clzero xsaveerptr wbnoinvd arat npt nrip_save umip vaes vpclmulqdq rdpid arch_capabilities
CPU:    AVX    found OK
CPU:    AVX2   found OK
CPU: no AVX512 found
@@@@@
11:18PM INF Starting LocalAI using 4 threads, with models path: /models
11:18PM INF LocalAI version: v1.40.0 (6ef7ea2635ae5371be4e6eef516c2ad4afd9f4a3)

 ┌───────────────────────────────────────────────────┐ 
 │                   Fiber v2.50.0                   │ 
 │               http://127.0.0.1:8080               │ 
 │       (bound on host 0.0.0.0 and port 8080)       │ 
 │                                                   │ 
 │ Handlers ............ 73  Processes ........... 1 │ 
 │ Prefork ....... Disabled  PID ................ 14 │ 
```

## k8sGPT Setup:

a) Add helm repo:

```
helm repo add k8sgpt https://charts.k8sgpt.ai/
```

b) Install the chart

```
helm install release k8sgpt/k8sgpt-operator -n k8sgpt-operator-system --create-namespace --version 0.0.24
```

c) Create k8sgpt cr:

```
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPT
metadata:
  name: k8sgpt-local-ai
  namespace: k8sgpt-operator-system
spec:
  ai:
    enabled: true
    model: ggml-gpt4all-j
    backend: localai
    baseUrl: http://local-ai.default.svc.cluster.local:80/v1
  noCache: false
  version: v0.3.8
```


Useful Helm Commands:

```
helm repo list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/auth/kubeconfig
NAME     	URL                                     
go-skynet	https://go-skynet.github.io/helm-charts/

helm search repo go-skynet --versions
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/auth/kubeconfig
NAME              	CHART VERSION	APP VERSION	DESCRIPTION                                       
go-skynet/local-ai	2.1.2        	1.3        	A Helm chart for deploying LocalAI to a Kuberne...
go-skynet/local-ai	2.1.1        	0.1.0      	A Helm chart for deploying LocalAI to a Kuberne...
go-skynet/local-ai	2.1.0        	0.1.0      	A Helm chart for deploying LocalAI to a Kuberne...
go-skynet/local-ai	2.0.0        	0.1.0      	A Helm chart for deploying LocalAI to a Kuberne...
go-skynet/local-ai	1.0.3        	0.1.0      	A Helm chart for LocalAI                          
go-skynet/local-ai	1.0.2        	0.1.0      	A Helm chart for LocalAI                          
go-skynet/local-ai	1.0.1        	0.1.0      	A Helm chart for LocalAI 

helm repo list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/auth/kubeconfig
NAME     	URL                                     
go-skynet	https://go-skynet.github.io/helm-charts/
k8sgpt   	https://charts.k8sgpt.ai/             


helm search repo k8sgpt --versions
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/auth/kubeconfig
NAME                  	CHART VERSION	APP VERSION	DESCRIPTION                                       
k8sgpt/k8sgpt-operator	0.0.24       	0.0.24     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.23       	0.0.23     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.22       	0.0.22     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.21       	0.0.21     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.20       	0.0.20     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.19       	0.0.19     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.17       	0.0.17     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.16       	0.0.16     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.15       	0.0.15     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.14       	0.0.14     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.13       	0.0.13     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.12       	0.0.12     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.11       	0.0.11     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.10       	0.0.10     	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.9        	0.0.9      	Automatic SRE Superpowers within your Kubernete...
k8sgpt/k8sgpt-operator	0.0.8        	0.1.0      	A Helm chart for Kubernetes                       
k8sgpt/k8sgpt-operator	0.0.6        	0.1.0      	A Helm chart for Kubernetes  
```
