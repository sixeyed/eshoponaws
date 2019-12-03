#!/bin/bash

# required parameters in ENV:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# EKS_CLUSTER_NAME
# DOCKER_COMPOSE_PATH
# DOCKER_STACK_NAME

echo 'Fetching EKS credentials'
eksctl utils write-kubeconfig --cluster $EKS_CLUSTER_NAME
    
echo 'Deploying stack'
docker stack deploy --orchestrator=kubernetes -c $DOCKER_COMPOSE_PATH $DOCKER_STACK_NAME

echo 'Service details...'
kubectl get service eshopwebmvc-published
