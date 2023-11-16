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

k8sgpt auth --backend noopai --password sensitive
