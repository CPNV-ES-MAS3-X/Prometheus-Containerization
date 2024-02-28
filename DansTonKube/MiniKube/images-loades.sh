cd influxdb
docker build -t influxdb .
minikube image load influxdb
cd ../

cd prometheus
docker build -t prometheus .
minikube image load prometheus
cd ../

cd alertmanager
docker build -t alertmanager .
minikube image load alertmanager
cd ../

cd grafana
docker build -t grafana .
minikube image load grafana
cd ../

