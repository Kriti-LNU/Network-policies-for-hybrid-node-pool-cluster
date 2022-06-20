
# Create pods 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-14-Limit-egress-using-private-ip\Testpods.yaml"

# Test  before applying the NP
# From windows based pod
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
# From Linux based pod
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-pod --namespace development -o 'jsonpath={.status.podIP}') 80

# Add ip address of one of the pods - linux-pod or windows-pod to the network policy file and test connectivity
# Apply NP file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-14-Limit-egress-using-private-ip\Networkpolicy.yaml"

# Test after applying the NP
# From windows based pod
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec -n development win-frontend-testpod  -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-pod -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
# From Linux based pod
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-pod --namespace development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-pod --namespace development -o 'jsonpath={.status.podIP}') 80

kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod win-frontend-testpod -n development
kubectl delete pod linux-pod -n development
kubectl delete pod windows-pod -n development
kubectl delete netpol allow-from-cidr -n development


