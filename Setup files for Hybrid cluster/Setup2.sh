# Update aks-preview to the latest version
az extension add --name aks-preview
az extension update --name aks-preview

# Enable Microsoft.ContainerService/AKSWindows2022Preview
az feature register --namespace Microsoft.ContainerService --name AKSWindows2022Preview
az provider register -n Microsoft.ContainerService

# Set variables
myLocation="westus" # Depends on you
myResourceGroup="Kriti_Cluster" # Depends on you
myAKSCluster="AKSCluster" # Depends on you
mySSHKeyFilePath="kriti-ssh-key.pub"
myWindowsUserName="Kriti_lnu" # Recommend azureuser
myWindowsPassword="Y*xiny349fd10H438nSotT" # Complex enough
myK8sVersion="1.23.3" # AKS supports WS2022 when k8s version >= 1.23

# Create a resource group
az group create --name $myResourceGroup --location $myLocation

# Create a virtual network and subnet
az network vnet create \
    --resource-group $myResourceGroup \
    --name Vnet \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name AKSSubnet \
    --subnet-prefix 10.240.0.0/16

# Get the subnet resource ID for the existing subnet into which the AKS cluster will be joined:
SUBNET_ID=$(az network vnet subnet list \
     --resource-group $myResourceGroup \
    --vnet-name Vnet \
    --query "[0].id" --output tsv)

DNS_SERVICE_IP="10.0.10.10"
SERVICE_CIDR="10.0.10.0/24"

az aks create \
    --resource-group $myResourceGroup \
    --name $myAKSCluster \
    --node-count 1 \
    --generate-ssh-keys \
    --dns-service-ip ${DNS_SERVICE_IP} \
    --service-cidr ${SERVICE_CIDR} \
    --docker-bridge-address 172.17.0.1/16 \
    --vnet-subnet-id $SUBNET_ID \
    --windows-admin-username $myWindowsUserName \
    --windows-admin-password $myWindowsPassword \
    --kubernetes-version $myK8sVersion \
    --vm-set-type VirtualMachineScaleSets \
    --network-plugin azure 

# Set variables for Windows 2022 node pool
myWindowsNodePool="win22" # Length <= 6
az aks nodepool add \
    --resource-group $myResourceGroup \
    --cluster-name $myAKSCluster \
    --name $myWindowsNodePool \
    --os-type Windows \
    --os-sku Windows2022 \
    --node-count 1

az aks get-credentials -g $myResourceGroup -n $myAKSCluster --overwrite-existing
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Setup files\azure-npm-linux.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Setup files\azure-npm-windows.yaml"


