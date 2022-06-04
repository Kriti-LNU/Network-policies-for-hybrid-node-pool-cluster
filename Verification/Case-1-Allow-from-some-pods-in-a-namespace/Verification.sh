
# Setup pods and Np for verification
kubectl create namespace development
kubectl label namespace/development purpose=development
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-1-Allow-from-some-pods-in-a-namespace\Testpods.yaml"
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-1-Allow-from-some-pods-in-a-namespace\Serverpods.yaml"
kubectl get pods -n development --show-labels 

# Apply NP
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-1-Allow-from-some-pods-in-a-namespace\Networkpolicy.yaml"

# Verification After applying NP
# Should be reachable
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing
kubectl exec --namespace development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing

# Should not be reachable
kubectl exec --namespace development lin-apiserver-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-apiserver-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-apiserver-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing
kubectl exec --namespace development win-apiserver-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing

# CleanUp
kubectl delete pod win-apiserver-testpod -n development
kubectl delete pod lin-apiserver-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod win-frontend-testpod -n development
kubectl delete netpol limit-ingress-using-podselector -n development