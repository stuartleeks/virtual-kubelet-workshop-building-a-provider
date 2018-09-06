# Lab 1 - Creating a web provider

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

NOTE: you need to replace the URL with a URL for your API that is addressable from inside the cluster.

For example, if running with minikube then you can get the minikube IP Address via `minikube ip` and then lookup the corresponding local address with `ifconfig`.

On Docker for Windows, get the IP address for `host.docker.internal` and use that (specifying the appropriate port): e.g. `http://192.168.1.171:3000`

Now that you have deployed Virtual Kubelet, you should be able to run `kubectl get nodes` and see your Virtual Kubelet node listed.

You should also be able to follow the instructions output from the `helm install` step above to get the Web UI URL. If you load that in your browser it should connect to the API as specified

## Handle CreatePod

Now that you have the minimal API that is required to start up Virtual Kubelet, the next step is to add the ability to create a pod. I.e. implement the `/createPod` endpoint. Once Kubernetes has started a pod on the Virtual Kubelet node it will also query its status via the `/getPodStatus` endpoint.

To test your implementation, try deploying a pod. There is a `pod.yaml` file that you can use if you wish: `kubectl apply -f pod.yaml`.

If everything is working then you should see the pod shown in the web UI, and in `kubectl get pods` output.

If your output looks like the output below then you need to set the pod status to let Kubernetes know that you  have received the request and are running the pod.

```bash
NAME               READY     STATUS           RESTARTS   AGE
helloworld-24k66   0/1       ProviderFailed   0          13s
```

If you have reached this state then the simplest way to clean things up is to forcefully delete the pod (`kubectl delete pod helloworld --force --grace-period=0`). Ordinarily this is not a good idea as it can leave orphaned resources, but since we're not actually executing anything that doesn't apply to us.

## Handle UpdatePod and DeletePod

Once you can create a pod it is good to be able to delete it (`/deletePod`). After implementing this method you should be able to delete a deployment/pod via `kubectl` and see it removed from the pod list in `kubectl get pods` output and the Web UI.

As a bonus, if you implement the `/updatePod` endpoint you will be able to mark a pod as failed using the "Stop Pod" button in the Web UI, and see Kubernetes reschedule it (assuming it is in a deployment/replica set). There is a `deployment.yml` in the lab folder that you can deploy to test this (`kubectl apply -f deployment.yml`).

## Container Logs

Since your implementation doesn't actually execute any containers there aren't any real logs to serve, but you can still implement the endpoint and return some generated fake logs.

The goal is to be able to get your generated log output via `kubectl logs <podname>`.

Hint: the logs are retrieved via an internal api-server in Virtual Kubelet, so you will need to ensure that you return the correct node address so that Kubernetes can talk to the api-server.

## Deployment

Currently you have the API running on your local machine. The next step is to package and deploy the API inside the cluster...