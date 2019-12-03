#!/bin/bash

# required parameters in ENV:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# EKS_CLUSTER_NAME
# EKS_NODE_COUNT
# EKS_NODE_TYPE

eksctl get cluster -n $EKS_CLUSTER_NAME > /dev/null
if [ $? != 0 ]; then
    echo "Creating EKS cluster: $EKS_CLUSTER_NAME"
    eksctl create cluster \
      --name=$EKS_CLUSTER_NAME \
      --nodes=$EKS_NODE_COUNT \
      --node-type=$EKS_NODE_TYPE
        
    echo 'Initializing Helm'
    kubectl -n kube-system create serviceaccount tiller
    kubectl -n kube-system create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount kube-system:tiller
    helm init --service-account tiller --wait

    echo 'Deploying etcd for Compose on Kubernetes'
    kubectl create namespace compose
    helm install --name etcd-operator stable/etcd-operator --namespace compose --wait
    kubectl apply -f /compose-etcd.yaml

    echo 'Installing Compose on Kubernetes'
    installer-linux -namespace=compose -etcd-servers=http://compose-etcd-client:2379 -tag="v0.4.23"
else
	echo "EKS cluster exists - exiting"
fi