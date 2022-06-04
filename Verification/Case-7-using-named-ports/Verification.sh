# Create pods and service 
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-8-Using-named-ports\Pods-and-service.yaml"

# Test before applying NP
## From linux based testpod 
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides '{ "spec": {"nodeSelector":{"kubernetes.io/os":"linux"}}}' -n development
curl http://sample-service:8001
curl http://sample-service:5001
## From windows based testpod 
kubectl run windows-testpod -it --rm --image mcr.microsoft.com/windows/servercore:ltsc2022 --overrides '{ "spec": {"nodeSelector":{"kubernetes.io/os":"windows"}}}'  -n development --command -- powershell.exe
Invoke-WebRequest -uri sample-service:5001 -UseBasicParsing
Invoke-WebRequest -uri sample-service:8001 -UseBasicParsing
# Apply the network policy file
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policy in k8s\Case-5-NP-using-named-ports-NP.yaml"

# Test after applying the NP
## From linux based testpod 
kubectl run --rm -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 testpod --overrides '{ "spec": {"nodeSelector":{"kubernetes.io/os":"linux"}}}' -n development --labels "run=curl"
curl http://sample-service:8001
curl http://sample-service:5001
## From windows based testpod 
kubectl run windows-testpod -it --rm --image mcr.microsoft.com/windows/servercore:ltsc2022 --overrides '{ "spec": {"nodeSelector":{"kubernetes.io/os":"windows"}}}'  -n development --labels "run=curl" --command -- powershell.exe
Invoke-WebRequest -uri sample-service:5001 -UseBasicParsing
Invoke-WebRequest -uri sample-service:8001 -UseBasicParsing