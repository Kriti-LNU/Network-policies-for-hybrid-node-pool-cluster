
# Create pods
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-16-Limit-egress-using-ports-numbers\Serverpods.yaml"
# create testpods
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-16-Limit-egress-using-ports-numbers\Testpods.yaml"

# Apply the network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-16-Limit-egress-using-ports-numbers\Networkpolicy.yaml"

# After applying Network policy Verification 

# Should be allowed 
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-pod2 -n development  -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-pod2 -n development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development win-frontend-testpod -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-pod2 -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec -n development win-frontend-testpod -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-pod2 -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing

# Shouldn't be allowed
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod windows-pod1 -n development  -o 'jsonpath={.status.podIP}') 8080
kubectl exec -n development lin-frontend-testpod -- nc -vz $(kubectl get pod linux-pod1 -n development -o 'jsonpath={.status.podIP}') 8080
kubectl exec -n development win-frontend-testpod -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-pod1 -n development -o 'jsonpath={.status.podIP}'):8080 -UseBasicParsing
kubectl exec -n development win-frontend-testpod -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-pod1 -n development -o 'jsonpath={.status.podIP}'):8080 -UseBasicParsing

# CleanUp 
kubectl delete pod win-frontend-testpod -n development
kubectl delete pod lin-frontend-testpod -n development
kubectl delete pod linux-pod1 -n development
kubectl delete pod windows-pod1 -n development
kubectl delete pod linux-pod2 -n development
kubectl delete pod windows-pod2 -n development
kubectl delete netpol allow-to-port -n development

