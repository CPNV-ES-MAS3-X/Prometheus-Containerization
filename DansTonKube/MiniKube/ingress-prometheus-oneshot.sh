#minikube start
#minikube addons enable ingress

mkdir ingress
mkdir prometheus

cat > ingress/ingress-prometheus.yml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prometheus
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - host: mydomain.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus
                port:
                  number: 9090
EOF


cat > prometheus/Dockerfile <<EOF
FROM prom/prometheus
EXPOSE 9090
EOF

cat > prometheus/prometheus-deployment.yml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "prometheus"
spec:
  selector:
    matchLabels:
      app: "prometheus"
  template:
    metadata:
      labels:
        app: "prometheus"
    spec:
      containers:
        - name: "prometheus"
          image: "prometheus:latest"
          imagePullPolicy: Never
          ports:
            - name: http
              containerPort: 9090
---
apiVersion: v1
kind: Service
metadata:
  name: "prometheus"
spec:
  selector:
    app: "prometheus"
  type: NodePort
  ports:
    - protocol: TCP
      port: 9090
      targetPort: 9090
      nodePort: 31001
EOF

cd prometheus
docker build -t prometheus .
minikube image load prometheus
kubectl apply -f prometheus-deployment.yml 
cd ../

cd ingress
kubectl apply -f ingress-prometheus.yml
cd ../

sudo bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo bash -c "iptables -t nat -A PREROUTING -p tcp --dport 81 -j DNAT --to-destination 192.168.49.2:80"
sudo bash -c "iptables -A FORWARD -p tcp -d 192.168.49.2 --dport 80 -j ACCEPT"
