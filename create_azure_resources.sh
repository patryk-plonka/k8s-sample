#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source azure_env.sh

az group create \
    --resource-group ${AZ_RESOURCE_GROUP} \
    --location ${AZ_LOCATION}

az acr create \
    --resource-group ${AZ_RESOURCE_GROUP} \
    --name ${AZ_ACR_NAME} \
    --sku Basic

export AZ_ACR_LOGIN_SERVER=$(az acr list \
    --resource-group ${AZ_RESOURCE_GROUP} \
    --query "[?name == \`${AZ_ACR_NAME}\`].loginServer | [0]" \
    --output tsv 
    )

az aks create \
    --resource-group ${AZ_RESOURCE_GROUP} \
    --name ${AZ_CLUSTER_NAME} \
    --generate-ssh-keys \
    --vm-set-type VirtualMachineScaleSets \
    --node-vm-size ${AZ_VM_SIZE:-"Standard_DS2_v2"} \
    --load-balancer-sku standard \
    --enable-managed-identity \
    --network-plugin ${AZ_NET_PLUGIN:-"kubenet"} \
    --network-policy ${AZ_NET_POLICY:-""} \
    --attach-acr ${AZ_ACR_NAME} \
    --node-count ${AZ_VM_COUNT:-3} \
    --zones 1 2 3

az aks get-credentials \
    --resource-group ${AZ_RESOURCE_GROUP} \
    --name ${AZ_CLUSTER_NAME} \
    --file ${KUBECONFIG:-"$HOME/.kube/${AZ_CLUSTER_NAME}.yaml"}