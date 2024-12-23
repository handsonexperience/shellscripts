swapoff -a

sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab

apt-get update -y


apt-get install ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


apt-get update -y


apt-get install containerd.io -y


containerd config default > /etc/containerd/config.toml


sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

systemctl restart containerd

systemctl enable containerd

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

sysctl --system

apt-get update -y


apt-get install -y apt-transport-https ca-certificates curl gpg


curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/Kubernetes.list


apt-get update

apt-get install -y kubelet kubeadm kubectl


apt-mark hold kubelet kubeadm kubectl


systemctl daemon-reload

systemctl start kubelet

systemctl enable kubelet.service

### after the shell script run the below command and the output which is obtained from the command is token, copy somewhere and paste them in the worker nodes and press enter to get connect to the master.


#kubeadm init


###after the above command exit from root user and switch to ubuntu or normal user and execute the following commands


#mkdir -p $HOME/.kube

#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

#sudo chown $(id -u):$(id -g) $HOME/.kube/config

#kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

