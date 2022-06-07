
# Setup pods
kubectl label namespace/default purpose=default
kubectl create namespace development
kubectl label namespace/development purpose=development
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-4-Allow-ingress-from-a-namespace\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-4-Allow-ingress-from-a-namespace\Testpods.yaml"
kubectl get pods -n development --show-labels 
kubectl get pods --show-labels

# Apply NP
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-4-Allow-ingress-from-a-namespace\Networkpolicy.yaml"

# After applying NP
# Not reachable
kubectl exec --namespace development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80

# Should be reachable
kubectl exec lin-apiserver-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80

# Cleanup
kubectl delete pod lin-apiserver-testpod
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete netpol allow-ingress-from-a-namespace -n development