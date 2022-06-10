# Create pods and service 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Limit-ingress-using-named-ports\Pods-and-service.yaml"

# Test before applying the NP
## From linux based testpod 
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"}}}' -n development --labels "run=curl"
curl http://sample-service.development:8001
curl http://sample-service.development:5001
## From windows based testpod 
kubectl run windows-testpod -it --rm --image mcr.microsoft.com/windows/servercore:ltsc2022 --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"windows\"}}}' -n development --labels "run=curl" --command -- powershell.exe
Invoke-WebRequest -uri http://sample-service:5001 -UseBasicParsing
Invoke-WebRequest -uri http://sample-service:8001 -UseBasicParsing

# Apply network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification\Limit-ingress-using-named-ports\Networkpolicy.yaml"

# Test after applying the NP
## From linux based testpod 
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"}}}' -n development --labels "run=curl"
# Should be reachable
curl http://sample-service.development:8001
# Should not be reachable
curl http://sample-service.development:5001
## From windows based testpod 
kubectl run windows-testpod -it --rm --image mcr.microsoft.com/windows/servercore:ltsc2022 --overrides='{ \"spec\": {\"nodeSelector\":{\"kubernetes.io/os\":\"windows\"}}}' -n development --labels "run=curl" --command -- powershell.exe
# Should not be reachable
Invoke-WebRequest -uri http://sample-service:5001 -UseBasicParsing
# Should be reachable
Invoke-WebRequest -uri http://sample-service:8001 -UseBasicParsing

kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete svc sample-service -n development
kubectl delete netpol allow-from-ports -n development



Invoke-WebRequest -uri eks-sample-windows-service/default.html -UseBasicParsing