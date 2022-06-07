
# Create server pods and testpods 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-7-Allow-egress-to-some-pods-in-same-namespace\Serverpods.yaml"
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-7-Allow-egress-to-some-pods-in-same-namespace\Testpods.yaml"
kubectl get pods -n development --show-labels
kubectl get pods --show-labels
# Apply the network policy file 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Linux only cluster using azure npm\Case-7-Allow-egress-to-some-pods-in-same-namespace\Networkpolicy.yaml"

# Should be Allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-backend-pod -n development -o 'jsonpath={.status.podIP}') 80

# Shouldn't be allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-webserver-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-default-backend-pod -o 'jsonpath={.status.podIP}') 80

# Clean up
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod linux-webserver-pod -n development
kubectl delete pod linux-backend-pod -n development
kubectl delete pod linux-default-backend-pod
kubectl delete netpol limit-egress-from-pod -n development