#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

export AZ_RESOURCE_GROUP="rgSampleK8s"
export AZ_LOCATION="westeu"

export AZ_CLUSTER_NAME="aksSampleK8s"
export AZ_NET_PLUGIN="azure"
export AZ_NET_POLICY="calico"
export KUBECONFIG=~/.KUBE/${AZ_CLUSTER_NAME}.yaml

export AZ_ACR_NAME="acrSampleACR"
export AZ_ACR_LOGIN_SERVER=$(az acr list \
    --resource-group ${AZ_RESOURCE_GROUP} \
    --query "[?name == \`${AZ_ACR_NAME}\`].loginServer | [0]" \
    --output tsv 
    )

