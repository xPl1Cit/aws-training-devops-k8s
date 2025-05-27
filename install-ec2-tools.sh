#!/bin/bash

sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.2/2024-11-15/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

export ARCH=amd64
export PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

sudo yum install docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
newgrp docker