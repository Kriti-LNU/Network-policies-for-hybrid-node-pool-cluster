RESOURCE_GROUP_NAME="Kriti-Linux-only-NPM"
CLUSTER_NAME="LinCluster"
LOCATION="westus"

# Create a resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create a virtual network and subnet
az network vnet create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name Vnet \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name AKSSubnet \
    --subnet-prefix 10.240.0.0/16

# Get the subnet resource ID for the existing subnet into which the AKS cluster will be joined:
SUBNET_ID=$(az network vnet subnet list \
     --resource-group $RESOURCE_GROUP_NAME \
    --vnet-name Vnet \
    --query "[0].id" --output tsv)

DNS_SERVICE_IP="10.0.10.10"
SERVICE_CIDR="10.0.10.0/24"
az aks create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME \
   --generate-ssh-keys \
    --enable-managed-identity \
    --network-plugin azure \
    --vnet-subnet-id ${SUBNET_ID} \
    --dns-service-ip ${DNS_SERVICE_IP} \
    --service-cidr ${SERVICE_CIDR} \
    --node-count 1
az aks get-credentials --resource-group Kriti-Linux-only-NPM --name LinCluster
    
kubectl apply -f "C:\github\Ndetwork-policies-for-hybrid-node-pool-cluster\Setup files\azure-npm-linux.yaml"