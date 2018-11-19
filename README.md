# Building a provider for the Virtual Kubelet
The open source Virtual Kubelet project provides an alternative implementation of the kubelet, which adds a virtual node to your Kubernetes cluster. This virtual node can be backed by a variety of providers, including serverless container infrastructure like Azure Container Instances and AWS Fargate. In this workshop, we'll build on the "Introduction to the Virtual Kubelet" workshop. We will walk through what a provider looks like and then build our own

For the workshop it is recommended that you attempt to create the provider implementation yourself, but if you get stuck there are some example implementations:

 * [Go](https://github.com/stuartleeks/virtual-kubelet-web-mock-go)
 * [Node.js](https://github.com/stuartleeks/virtual-kubelet-web-mock-nodejs)
 * [C#](https://github.com/stuartleeks/virtual-kubelet-web-mock-csharp)
 * [Python](https://github.com/stuartleeks/virtual-kubelet-web-mock-python)
