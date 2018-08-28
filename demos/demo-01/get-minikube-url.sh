uiPort=$(kubectl get service vk-demo-01 -o jsonpath={.spec.ports[0].nodePort}) && \
minikubeIp=$(minikube ip) && \
echo "The web UI is listening on  http://$minikubeIp:${uiPort}"
echo "The web API is listening on http://$minikubeIp:${uiPort}/api/"
