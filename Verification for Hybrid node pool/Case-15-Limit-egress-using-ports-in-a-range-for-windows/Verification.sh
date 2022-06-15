
# Create 3 pods in development namespace with the label app=backend 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-15-Limit-egress-using-ports-in-a-range-for-windows\Serverpods.yaml"
# Created 3 pods --> windows-backend-pod1 with port number 5782, windows-backend-pod2 80, windows-backend-pod3 6782
# Create testpods
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-15-Limit-egress-using-ports-in-a-range-for-windows\Testpods.yaml"

#Apply the network policy file
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-15-Limit-egress-using-ports-in-a-range-for-windows\Networkpolicy.yaml"

# The NP file will allow egress from pods with the label app=curl only to pods with the label app=backend on port number in the range 5000 to 7000
kubectl exec win-curl-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod1 -n development -o 'jsonpath={.status.podIP}'):5678 -UseBasicParsing
kubectl exec win-curl-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod2 -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec win-curl-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-backend-pod3 -n development -o 'jsonpath={.status.podIP}'):6782 -UseBasicParsing


# CleanUp 
kubectl delete pod win-curl-testpod -n development
kubectl delete pod windows-backend-pod1 -n development
kubectl delete pod windows-backend-pod2 -n development
kubectl delete pod windows-backend-pod3 -n development
kubectl delete netpol allow-from-ports-in-a-range -n development
