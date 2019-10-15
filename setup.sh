#/bin/bash

yum install docker -y

yum install socat -y

systemctl enable docker --now

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

mv ./kubectl /usr/local/bin/kubectl

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube

install minikube /usr/local/bin

minikube start --vm-driver=none


curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

kubectl --namespace kube-system create sa tiller

kubectl create clusterrolebinding tiller     --clusterrole cluster-admin     --serviceaccount=kube-system:tiller

helm init --service-account tiller

helm init --service-account tiller --override spec.selector.matchLabels.'name'='tiller',spec.selector.matchLabels.'app'='helm' --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl apply -f -

helm repo update

kubectl get deploy,svc tiller-deploy -n kube-system

helm install --name my-release --set mongodbRootPassword=redhat,mongodbUsername=my-user,mongodbPassword=redhat,mongodbDatabase=mongo_db stable/mongodb

