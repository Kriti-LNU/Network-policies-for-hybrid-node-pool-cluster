
# Setup pods 
kubectl label namespace/default purpose=default
kubectl create namespace development
kubectl label namespace/development purpose=development
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-4-Allow-ingress-from-a-namespace\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-4-Allow-ingress-from-a-namespace\Testpods.yaml"
kubectl get pods -n development --show-labels 
kubectl get pods --show-labels

# Apply NP
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-4-Allow-ingress-from-a-namespace\Networkpolicy.yaml"

# Not reachable
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec --namespace development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Should be reachable
kubectl exec lin-testapp-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec lin-testapp-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec win-testapp-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec win-testapp-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Cleanup
kubectl delete pod lin-testapp-testpod
kubectl delete pod win-testapp-testpod
kubectl delete pod win-frontend-testpod -n development
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete netpol allow-ingress-from-a-namespace -n development