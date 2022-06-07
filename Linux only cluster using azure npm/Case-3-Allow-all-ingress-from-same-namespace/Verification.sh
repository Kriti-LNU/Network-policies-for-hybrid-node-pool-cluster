
# Setup pods 
kubectl create namespace development
kubectl label namespace/development purpose=development
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-3-Allow-all-ingress-from-same-namespace\Testpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-3-Allow-all-ingress-from-same-namespace\Serverpods.yaml"
kubectl get pods -n development --show-labels 
kubectl get pods --show-labels

# Apply NP
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-3-Allow-all-ingress-from-same-namespace\Networkpolicy.yaml"

# After applying NP

## After applying NP
# Should be reachable
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80

# Should not be reachable
kubectl exec lin-apiserver-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec lin-frontend-default-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80

# Cleanup
kubectl delete pod lin-apiserver-testpod 
kubectl delete pod lin-frontend-default-testpod 
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete netpol allow-ingress-only-from-same-namespace -n development