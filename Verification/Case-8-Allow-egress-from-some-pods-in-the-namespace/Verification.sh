
# Create server pods and testpods 
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-6-Limit-egress-to-pods\Serverpods.yaml"
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-6-Limit-egress-to-pods\Testpods.yaml"

# Apply the network policy file 
kubectl apply -f "C:\Users\t-kritilnu\OneDrive - Microsoft\Desktop\Network policies for hybrid cluster\Verification\Case-6-Limit-egress-to-pods\Networkpolicy.yaml"
#--------------------------------Verification----------------------------------------------------
# Should be Allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod -n development -o 'jsonpath={.status.podIP}') 
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-backend-pod -n development -o 'jsonpath={.status.podIP}') 
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing

# Shouldn't be allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-webserver-pod --namespace development -o 'jsonpath={.status.podIP}') 
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-webserver-pod --namespace development -o 'jsonpath={.status.podIP}') 
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-webserver-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-webserver-pod -n development -o 'jsonpath={.status.podIP}') -UseBasicParsing

# Clean up
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod win-frontend-testpod -n development
kubectl delete pod linux-webserver-pod -n development
kubectl delete pod windows-webserver-pod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development