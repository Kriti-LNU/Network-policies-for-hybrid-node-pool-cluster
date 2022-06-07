

kubectl label namespace/default purpose=default
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-5-Allow-ingress-from-pods-in-a-namespace\Testpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-5-Allow-ingress-from-pods-in-a-namespace\Serverpods.yaml"
kubectl get pods -n development --show-labels
kubectl get pods --show-labels

# Apply Network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-5-Allow-ingress-from-pods-in-a-namespace\Networkpolicy.yaml"
## After applying NP
# Not reachable
kubectl exec --namespace development lin-apiserver-development-testpod -- nc -vz $(kubectl get pod linux-backend-pod --namespace development -o 'jsonpath={.status.podIP}') 80

# Should be reachable
kubectl exec lin-apiserver-default-testpod -- nc -vz $(kubectl get pod linux-backend-pod  --namespace development -o 'jsonpath={.status.podIP}') 80

# Cleanup 
kubectl delete pod lin-apiserver-default-testpod
kubectl delete pod lin-apiserver-development-testpod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete netpol limit-ingress-from-namespace -n development