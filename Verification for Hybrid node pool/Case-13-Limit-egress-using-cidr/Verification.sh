
# Create testpods 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-13-Limit-egress-using-cidr\Testpods.yaml"

# Before applying the NP file test connectivity
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://172.217.160.228 -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://www.yahoo.com -UseBasicParsing

# From linux based pod
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"}}}' -n development --labels "app=frontend"
wget -O- http://172.217.160.228
wget -O- --timeout=2 http://www.yahoo.com

# Apply network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-13-Limit-egress-using-cidr\Networkpolicy.yaml"

# Test after applying the NP
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://216.58.221.36 -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://www.yahoo.com -UseBasicParsing

# From linux based pod
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"}}}' -n development --labels "app=frontend"
wget -O- http://216.58.221.36
wget -O- --timeout=2 http://www.yahoo.com

kubectl delete pod win-frontend-testpod -n development
kubectl delete netpol allow-from-cidr -n development


