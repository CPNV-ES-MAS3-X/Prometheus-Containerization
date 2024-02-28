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

```bash
sudo bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo bash -c "iptables -t nat -A PREROUTING -p tcp --dport 81 -j DNAT --to-destination 192.168.49.2:80"
sudo bash -c "iptables -A FORWARD -p tcp -d 192.168.49.2 --dport 80 -j ACCEPT"
```
