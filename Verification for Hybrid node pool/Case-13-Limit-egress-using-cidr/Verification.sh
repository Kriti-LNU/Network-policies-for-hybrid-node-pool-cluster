
# Apply network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-13-Limit-egress-using-cidr\Networkpolicy.yaml"

# Test after applying the NP
kubectl run windows-testpod -it --rm --image mcr.microsoft.com/windows/servercore:ltsc2022 --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"windows\"}}}' -n development --labels "app=frontend" --command -- powershell.exe
Invoke-WebRequest -uri http://172.217.166.4 -UseBasicParsing

# From linux based pod
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"}}}' -n development --labels "app=frontend"
wget -O- http://172.217.166.4


kubectl delete netpol allow-from-cidr -n development


