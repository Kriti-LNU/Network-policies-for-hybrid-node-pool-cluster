
# Setup pods and Np for verification
kubectl create namespace development
kubectl label namespace/development purpose=development
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-3-Allow-all-ingress-from-same-namespace\Testpods.yaml"
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-3-Allow-all-ingress-from-same-namespace\Serverpods.yaml"
kubectl get pods -n development --show-labels 
kubectl get pods --show-labels

# Apply NP
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-3-Allow-all-ingress-from-same-namespace\Networkpolicy.yaml"

# Verification After applying NP

## After applying NP
# Should be reachable
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing
kubectl exec --namespace development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing

# Should not be reachable
kubectl exec lin-apiserver-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec lin-apiserver-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec win-apiserver-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing
kubectl exec win-apiserver-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing

# Cleanup
kubectl delete pod win-apiserver-testpod 
kubectl delete pod lin-apiserver-testpod 
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod win-frontend-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete netpol allow-ingress-only-from-same-namespace -n development