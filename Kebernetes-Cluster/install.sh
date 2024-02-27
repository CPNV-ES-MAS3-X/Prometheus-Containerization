# master node
sudo hostnamectl set-hostname mas-masternode-01
sudo echo '10.20.0.101 mas-workernode-01' | sudo tee -a /etc/hosts

# worker node
sudo hostnamectl set-hostname mas-workernode-01
sudo echo '10.20.0.100 mas-masternode-01' | sudo tee -a /etc/hosts


# each nodes
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
sudo apt update

sudo apt install kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo tee /etc/default/kubelet <<EOF
KUBELET_EXTRA_ARGS="--cgroup-driver=cgroupfs"
EOF
sudo systemctl daemon-reload && sudo systemctl restart kubelet
   
sudo tee /etc/docker/daemon.json <<EOF
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {"max-size": "100m"},
"storage-driver": "overlay2"
}
EOF
sudo systemctl daemon-reload && sudo systemctl restart docker

# master nodes

sudo sed -i  '/\[Service\]/a Environment=\"KUBELET_EXTRA_ARGS=--fail-swap-on=false\"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload && sudo systemctl restart kubelet

#sudo kubeadm init --control-plane-endpoint=mas-masternode-01 --upload-certs --pod-network-cidr=10.244.0.0/16
sudo kubeadm init --control-plane-endpoint=mas-masternode-01 --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


## helm 
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace\
  --set controller.service.loadBalancerIP=10.20.0.101
  
#------------------------------#
#after worker node joined cluser
kubectl label node mas-workernode-01 node-role.kubernetes.io/worker=worker
