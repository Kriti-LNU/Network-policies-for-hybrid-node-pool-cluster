
# Create server pods and testpods 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-9-Allow-egress-to-same-namespace-pods\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-9-Allow-egress-to-same-namespace-pods\Testpods.yaml"
kubectl get pods -n development --show-labels
kubectl get pods --show-labels
# Apply the network policy file 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-9-Allow-egress-to-same-namespace-pods\Networkpolicy.yaml"

# Should be Allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod -n development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-backend-pod -n development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-database-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-database-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-database-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-database-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Shouldn't be allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-default-backend-pod -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-default-backend-pod -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-default-backend-pod -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-default-backend-pod -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Clean up
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod win-frontend-testpod -n development
kubectl delete pod linux-database-pod -n development
kubectl delete pod windows-database-pod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete pod linux-default-backend-pod
kubectl delete pod windows-default-backend-pod
kubectl delete netpol limit-egress-to-same-namespace -n development