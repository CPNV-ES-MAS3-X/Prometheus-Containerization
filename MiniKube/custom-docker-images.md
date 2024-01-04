# Nginx

Dockerfile
```Dockerfile
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/* && rm -rf /etc/nginx/conf.d/default.conf && rm -rf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx

```


nginx.conf
```conf
events {
    worker_connections  1024;
}
http {
    upstream prometheus {
        server prometheus:9090;
    }

    server {
        listen 80;


        location / {
            proxy_pass http://prometheus;
        }
    }
}

```
nginx-deployment.yaml
```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "nginx"
spec:
  selector:
    matchLabels:
      app: "nginx"
  template:
    metadata:
      labels:
        app: "nginx"
    spec:
      containers:
        - name: "nginx"
          image: "nginx:latest"
          imagePullPolicy: Never
          ports:
            - name: http
              containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: "nginx"
spec:
  selector:
    app: "nginx"
  type: NodePort
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 31000

```

# Prometheus


*From prod*  
config_files  
 | - prometheus.yml  
 | - rules.yml  
 | - web.yml  

Dockerfile
```Dockerfile
FROM prom/prometheus
ADD config_files/prometheus.yml /etc/prometheus
ADD config_files/rules.yml /etc/prometheus
ADD config_files/web.yml /etc/prometheus
EXPOSE 9090
```

prometheus-deployment.yaml
```yml
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
  type: ClusterIP
  ports:
    - protocol: TCP
      port: 9090
      targetPort: 9090
```

### Copy images and build kubernetes infra 

```bash
docker build -t nginx .
minikube image load nginx
kubectl apply -f nginx-deployment.yaml 

docker build -t prometheus .
minikube image load prometheus
kubectl apply -f prometheus-deployment.yaml 

```
