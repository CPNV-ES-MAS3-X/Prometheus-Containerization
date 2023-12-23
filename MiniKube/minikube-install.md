## Install 

```
sudo apt update
sudo apt upgrade -y
sudo apt install curl wget apt-transport-https -y

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo usermod -aG docker $USER
newgrp docker
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin
kubectl version --client -o yaml
minikube start --driver docker

minikube status
kubectl get nodes
kubectl cluster-info
kubectl config view
minikube addons list
minikube addons enable dashboard
minikube dashboard
```

## Test

```
kubectl create deployment app1 --image nginx
kubectl expose deployment app1 --name app1-svc --type NodePort --port 80
kubectl get deployment app1
kubectl get svc app1-svc
minikube service app1-svc --url
```

## Destroy

```
minikube stop
miniube start
minikube restart

minikube stop
minikube delete
```
