
# Create server pods and testpods 
kubectl label namespace/default purpose=default
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-10-Allow-egress-to-a-namespace\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-10-Allow-egress-to-a-namespace\Testpods.yaml"
kubectl get pods -n development --show-labels
kubectl get pods --show-labels

# Apply the network policy file 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-10-Allow-egress-to-a-namespace\Networkpolicy.yaml"


# Shouldn't be allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod -n development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-webserver-pod --namespace development -o 'jsonpath={.status.podIP}') 80

# Should be Allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-default-backend-pod -o 'jsonpath={.status.podIP}') 80

# Clean up
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod linux-webserver-pod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod linux-default-backend-pod
kubectl delete netpol allow-egress-to-a-namespace -n development