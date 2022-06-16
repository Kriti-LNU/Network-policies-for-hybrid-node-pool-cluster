
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-6-Allow-ingress-from-pods-or-namespace\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-6-Allow-ingress-from-pods-or-namespace\Testpods.yaml"
kubectl get pods --show-labels
kubectl get pods -n development --show-labels

# Apply the NP file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-6-Allow-ingress-from-pods-or-namespace\Networkpolicy.yaml"

## After applying NP
# Should be reachable
kubectl exec --namespace development lin-testapp-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-testapp-development-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-testapp-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec --namespace development win-testapp-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec lin-frontend-default-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec lin-frontend-default-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec win-frontend-default-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec win-frontend-default-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Shouldn't be reachable
kubectl exec --namespace development lin-webserver-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development lin-webserver-development-testpod -- nc -vz $(kubectl get pod windows-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec --namespace development win-webserver-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec --namespace development win-webserver-development-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Cleanup 
kubectl delete pod lin-frontend-default-testpod
kubectl delete pod win-frontend-default-testpod
kubectl delete pod win-testapp-development-testpod -n development
kubectl delete pod lin-testapp-development-testpod -n development
kubectl delete pod win-webserver-development-testpod -n development
kubectl delete pod lin-webserver-development-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod windows-backend-pod -n development
kubectl delete netpol allow-ingress-from-pods-or-namespace -n development