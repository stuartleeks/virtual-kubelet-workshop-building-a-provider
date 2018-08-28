# Demo 1 - The web provider in action

## Setup

> **Requirements**
>
> A Kubernetes cluster (e.g. minikube or Docker for Windows/Mac)
>
> Client binaries:
> - kubectl
> - helm
>

## Deploy Virtual Kubelet

For this demo we're going to deploy a pod that runs the following containers

- Virtual Kubelet configured for the web provider
- a mock web api that implements the web provider interface
- a web UI that interacts with the mock api to show which pods are running

To deploy, run

```bash
helm install chart/ --name vk
```

This uses the helm chart to deploy the pod as described above along with a NodePort service. Follow the instructions that `helm install` outputs to determine the URL to use to access the UI.

At this point, executing `k get pods` should give something similar to

``` bash
NAME                                  READY     STATUS    RESTARTS   AGE
vk-demo-01-64cd8fbcb7-457fk           3/3       Running   0          10s
```

Finally, running the commands that the `helm install` step output should give you output like the following

```bash
The web UI is listening on  http://192.168.39.206:30282
The web API is listening on http://192.168.39.206:30282/api/
```

You can use the first link to access the web UI. The helm chart that we deployed configures the web UI container to proxy to the API via the second link to make it easy to inspect the API directly.

## Creating a pod

To create a pod on the Virtual Kubelet node, run

```bash
kubectl apply -f demo-pod.yml
```

This asks Kubernetes to schedule a pod to the Virtual Kubelet node. In our implementation nothing actually runs, the mock provider simply tracks which pods it has been asked to run and returns them in the `/getpods` API endpoint. The web UI polls this endpoint to display a list of pods 'running' on the Virtual Kubelet node.

`kubectl get pods` will show the pods running, including the helloworld pod we just deployed.

```bash
NAME                                  READY     STATUS    RESTARTS   AGE
helloworld                            1/1       Running   0          6s
```

## Creating a deployment

To create a deployment on the Virtual Kubelet node, run

```bash
kubectl apply -f demo-deployment.yml
```

This asks Kubernetes to schedule a deployment to the Virtual Kubelet node. Again, nothing *actually* runs on the Virtual Kubelet node, the web UI polls this endpoint to display a list of pods 'running' on the Virtual Kubelet node.

`kubectl get pods` will show the pods running, including the helloworld2 pod we just deployed.

```bash
NAME                                  READY     STATUS    RESTARTS   AGE
helloworld2-7d559b4979-ckhrh          1/1       Running   0          3s
```

We can scale the deployment with `kubectl scale deployment helloworld2 --replicas=3` and this schedules additional pods that can be seen in the web UI and via `kubectl get pods`:

```bash
NAME                                  READY     STATUS    RESTARTS   AGE
helloworld2-7d559b4979-ckhrh          1/1       Running   0          46s
helloworld2-7d559b4979-j4lwn          1/1       Running   0          2s
helloworld2-7d559b4979-s8zsf          1/1       Running   0          2s
```