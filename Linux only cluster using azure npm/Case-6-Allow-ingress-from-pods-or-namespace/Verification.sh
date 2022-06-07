
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-6-Allow-ingress-from-pods-or-namespace\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-6-Allow-ingress-from-pods-or-namespace\Testpods.yaml"
kubectl get pods --show-labels
kubectl get pods -n development --show-labels

# Apply the NP file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-6-Allow-ingress-from-pods-or-namespace\Networkpolicy.yaml"

## After applying NP
# Should be reachable
kubectl exec --namespace development lin-apiserver-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec lin-frontend-default-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80

# Shouldn't be reachable
kubectl exec --namespace development lin-webserver-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80

# Cleanup 
kubectl delete pod lin-frontend-default-testpod
kubectl delete pod lin-apiserver-development-testpod -n development
kubectl delete pod lin-webserver-development-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete netpol allow-ingress-from-pods-or-namespace -n development