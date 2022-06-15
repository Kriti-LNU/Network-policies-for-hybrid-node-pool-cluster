
# Setup pods 
kubectl create namespace development
kubectl label namespace/development purpose=development
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Demo\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Demo\Testpods.yaml"
kubectl get pods -n development --show-labels 

# Apply NP
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Demo\Networkpolicy.yaml"

# After applying NP
# Should be reachable
kubectl exec --namespace development lin-frontend-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-frontend-development-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-frontend-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec --namespace development win-frontend-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Should not be reachable
kubectl exec --namespace development lin-database-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-database-development-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-database-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec --namespace development win-database-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# CleanUp
kubectl delete pod win-database-development-testpod -n development
kubectl delete pod lin-database-development-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete pod lin-frontend-development-testpod -n development
kubectl delete pod win-frontend-development-testpod -n development
kubectl delete netpol limit-ingress-using-podselector -n development