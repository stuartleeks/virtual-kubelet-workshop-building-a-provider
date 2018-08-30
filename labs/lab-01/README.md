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

## Goal

The goal for this lab is to create an API that the web provider for Virtual Kubelet can connect to.
Feel free to write the API in whatever language/stack you feel most comfortable in.

The API implementation won't actually run pods, instead it should track which pods are running and return the appropriate status information.

## Create an API

What you will have by the end of the lab is shown in this picture:

```diagram
+----------------+         +---------------------------+          +------------------------------+
|                |         |                           |   HTTP   |                              |
|   Kubernetes   | <-----> |   Virtual Kubelet: Web    | <------> |   The API that you write :-) |
|                |         |                           |          |                              |
+----------------+         +---------------------------+          +------------------------------+
```

The API definition can be found in the [web provider docs](https://github.com/virtual-kubelet/virtual-kubelet/tree/master/providers/web).

When the Virtual Kubelet starts up there are some methods that are immediately called, so these make a good starting point:

- /capacity
- /nodeAddresses
- /nodeConditions
- /getPods

Once you have these methods working you can deploy Virtual Kubelet and the Web UI...

## Deploy Virtual Kubelet

For this lab we will create an HTTP API on our local machine. We will deploy Virtual Kubelet and the Web UI into the cluster and configure them to connect to the local API:

```diagram
+-------------------------------------------------------------+      +----------------------------------------+
|                                                             |      |                                        |
| Kubernetes                                                  |      |     Your local machine                 |
|                                                             |      |                                        |
| +------------+    +---------------------------------+       |      |                                        |
| |            |    |                                 |       |      |                                        |
| |  Control   |    |  Kubernetes Pod                 |       |      |                                        |
| |  Plane     |    |                                 |       |      |                                        |
| |            |    |   +------------------------+    |       |      |     +------------------------------+   |
| |            |    |   |                        |    |       |  HTTP|     |                              |   |
| |            +<------>+  Virtual Kubelet: Web  +<-+--------------------->+   The API that you write :+) |   |
| |            |    |   |                        |  | |       |      |     |                              |   |
| |            |    |   +------------------------+  | |       |      |     +------------------------------+   |
| |            |    |                               | |       |      |                                        |
| |            |    |   +------------------------+  | |       |      |                                        |
| |            |    |   |                        |  | |       |      |                                        |
| |            |    |   |  Web UI                +<-+ |       |      |                                        |
| |            |    |   |                        |    |       |      |                                        |
| |            |    |   +------------------------+    |       |      |                                        |
| |            |    |                                 |       |      |                                        |
| +------------+    +---------------------------------+       |      |                                        |
|                                                             |      |                                        |
+-------------------------------------------------------------+      +----------------------------------------+


```

To deploy, run

```bash
helm install chart/ --name vk --set webApiUrl=<your url>
```

You need to replace the URL with a URL for your API that is addressable from inside the cluster.

For example, if running with minikube then you can get the minikube IP Address via `minikube ip` and then lookup the corresponding local address with `ifconfig`.

**TODO what about Docker for Windows/Mac??**

Now you should be able to run `kubectl get nodes` and see your Virtual Kubelet node listed.

You should also be able to follow the instructions output from the `helm install` step above to get the Web UI URL. If you load that in your browser it should connect to the API as specified

## Handle CreatePod

Now that you have the minimal API that is required to start up Virtual Kubelet, the next step is to add the ability to create a pod. I.e. implement the `/createPod` endpoint. Once Kubernetes has started a pod on the Virtual Kubelet node it will also query its status via the `/getPodStatus` endpoint.

To test your implementation, try deploying a pod. There is a `deployment.yaml` file that you can use if you wish: `kubectl apply -f deployment.yaml`.

If everything is working then you should see the pod shown in the web UI, and in `kubectl get pods` output.
