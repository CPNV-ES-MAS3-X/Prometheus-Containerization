```bash
minikube start
minikube delete

minikube addons enable ingress

kubectl describe service prometheus
kubectl get pods -n default -l "app=prometheus"

docker build -t prometheus .
minikube image load prometheus
kubectl apply -f prometheus-deployment.yml

kubectl delete deployment  prometheus
kubectl delete service prometheus
kubectl delete ingress prometheus
```
