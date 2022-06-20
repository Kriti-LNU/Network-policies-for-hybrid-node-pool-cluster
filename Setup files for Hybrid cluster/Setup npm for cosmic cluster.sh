# Steps
# 1. Upgrade the k8s version
# 2. Add Linux and Windows node pool
# 3. Deploy NPM Daemonsets for Linux and Windows nodes 

###----------------------------------------------STEP 1---------------------------------------------------------------
## Setup NPM on COSMIC Clusters 
# Upgrade the k8s version 
# Testing is done on debug cosmic cluster 
# AKS supports Windows server 2022 when k8s version >= 1.23
az aks upgrade --name cosmic-ajayyadav-d01-00-nam-southcentralus-aks -g cosmic-ajayyadav-d01-00-nam-southcentralus --version 1.23.3

###----------------------------------------------STEP 2-----------------------------------------------------------------------
# For adding a Linux node pool with Mariner image
az aks nodepool add --resource-group cosmic-ajayyadav-d01-00-nam-southcentralus --cluster-name cosmic-ajayyadav-d01-00-nam-southcentralus-aks --os-sku CBLMariner --mode System --os-type Linux --node-count 1 --name tempnodepool

## Steps for adding win node pool
# Enable Microsoft.ContainerService/AKSWindows2022Preview
az feature register --namespace Microsoft.ContainerService --name AKSWindows2022Preview
az provider register -n Microsoft.ContainerService
# Add Windows node pool
az aks nodepool add  --resource-group cosmic-ajayyadav-d01-00-nam-southcentralus --cluster-name cosmic-ajayyadav-d01-00-nam-southcentralus-aks --name windowsNodePool --os-type Windows --os-sku Windows2022 --node-count 1

#-------------------------------STEP 3-----------------------------------------------------
# Connect to the cluster 
az aks get-credentials --name cosmic-ajayyadav-d01-00-nam-southcentralus-aks -g cosmic-ajayyadav-d01-00-nam-southcentralus

# Apply Linux NPM file and Windows NPM file
# Make sure for hybrid nodepool, windows NPM daemons set should have a different name than the linux one
# or else they will overwrite each other.
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Setup files for Hybrid cluster\azure-npm-linux.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Setup files for Hybrid cluster\azure-npm-windows.yaml"
