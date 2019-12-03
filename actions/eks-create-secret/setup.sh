#!/bin/bash

# required parameters in ENV:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# EKS_CLUSTER_NAME
# EKS_SECRET_NAME
# EKS_SECRET_FILE_NAME
# EKS_SECRET_FILE_VALUE

echo 'Fetching EKS credentials'
eksctl utils write-kubeconfig --cluster $EKS_CLUSTER_NAME
    
echo "Creating secret: $EKS_SECRET_NAME"
mkdir -p /tmp/eks
echo $EKS_SECRET_FILE_VALUE > /tmp/eks/$EKS_SECRET_FILE_NAME

kubectl create secret generic $EKS_SECRET_NAME \
  --from-file=/tmp/eks/$EKS_SECRET_FILE_NAME \
  --dry-run -o yaml | kubectl apply -f -
