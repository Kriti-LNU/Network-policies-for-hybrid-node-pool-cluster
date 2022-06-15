

kubectl label namespace/default purpose=default
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-5-Allow-ingress-from-pods-in-a-namespace\Testpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-5-Allow-ingress-from-pods-in-a-namespace\Serverpods.yaml"
kubectl get pods -n development --show-labels
kubectl get pods --show-labels

# Apply Network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-5-Allow-ingress-from-pods-in-a-namespace\Networkpolicy.yaml"

## After applying NP
# Not reachable
kubectl exec --namespace development lin-database-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-database-development-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-database-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec --namespace development win-database-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Should be reachable
kubectl exec lin-database-default-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec lin-database-default-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec win-database-default-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec win-database-default-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Cleanup 
kubectl delete pod lin-database-default-testpod
kubectl delete pod win-database-default-testpod
kubectl delete pod win-database-development-testpod -n development
kubectl delete pod lin-database-development-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete netpol limit-ingress-from-namespace -n development