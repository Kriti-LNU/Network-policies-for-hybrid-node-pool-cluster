# Create pods and service 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-12-Limit-egress-using-ports\Pods-and-service.yaml"

# Apply network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-12-Limit-egress-using-ports\Networkpolicy.yaml"

# Test after applying the NP
kubectl run windows-testpod -it --rm --image mcr.microsoft.com/windows/servercore:ltsc2022 --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"windows\"}}}' -n development --labels "app=frontend" --command -- powershell.exe
ping win-service 
ping lin-service

# From linux based pod
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"}}}' -n development --labels "app=frontend"
wget -O- http://win-service
wget -O- http://lin-service

kubectl delete pod windows-pod -n development
kubectl delete pod linux-pod -n development
kubectl delete svc lin-service -n development
kubectl delete svc win-service -n development
kubectl delete netpol allow-from-ports -n development


