# Lab 1 - Creating a web provider

**TODO Need to flesh this out**

> **Requirements**
>
> A Kubernetes cluster (e.g. minikube or Docker for Windows/Mac)
>
> Client binaries:
> - kubectl
> - helm
> - the toolset of your choice for building an HTTP API
>

## Deploy Virtual Kubelet

For this lab we will create an HTTP API on our local machine. We will deploy Virtual Kubelet and the Web UI into the cluster and configure them to connect to the local API.

To deploy, run

```bash
helm install chart/ --name vk --set webApiUrl=<your url>
```

You need to replace the URL with a URL for your API that is addressable from inside the cluster.

For example, if running with minikube then you can get the minikube IP Address via `minikube ip` and then lookup the corresponding local address with `ifconfig`.

**TODO what about Docker for Windows/Mac??**

## Create an API

**TODO give link to the web provider interface docs, which methods to start with, ...**