# Update aks-preview to the latest version
az extension add --name aks-preview
az extension update --name aks-preview

# Enable Microsoft.ContainerService/AKSWindows2022Preview
az feature register --namespace Microsoft.ContainerService --name AKSWindows2022Preview
az provider register -n Microsoft.ContainerService

# Set variables
myLocation="eastus" # Depends on you
myResourceGroup="Kriti_Test_hybrid_node_pool" # Depends on you
myAKSCluster="HybridCluster" # Depends on you
mySSHKeyFilePath="kriti-ssh-key.pub"
myWindowsUserName="Kriti_lnu" # Recommend azureuser
myWindowsPassword="Y*xiny349fd10H438nSotT" # Complex enough
myK8sVersion="1.23.3" # AKS supports WS2022 when k8s version >= 1.23

# Create resource group 
az group create --name $myResourceGroup --location $myLocation

# Create AKS cluster 
az aks create \
    --resource-group $myResourceGroup \
    --name $myAKSCluster \
    --generate-ssh-keys  \
    --windows-admin-username $myWindowsUserName \
    --windows-admin-password $myWindowsPassword \
    --kubernetes-version $myK8sVersion \
    --network-plugin azure \
    --vm-set-type VirtualMachineScaleSets \
    --node-count 1

# Set variables for Windows 2022 node pool
myWindowsNodePool="win22" # Length <= 6

# Add Windows node pool
az aks nodepool add \
    --resource-group $myResourceGroup \
    --cluster-name $myAKSCluster \
    --name $myWindowsNodePool \
    --os-type Windows \
    --os-sku Windows2022 \
    --node-count 1

# Optional- If you want to add additional Linux node pool
az aks nodepool add \
    --resource-group $myResourceGroup\
    --cluster-name $myAKSCluster \
    --name linuxpool \
    --node-count 1

# Connect to the cluster 
az aks get-credentials -g $myResourceGroup -n $myAKSCluster --overwrite-existing

kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Setup files for Hybrid cluster\azure-npm-linux.yaml"
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Setup files for Hybrid cluster\azure-npm-windows.yaml"



