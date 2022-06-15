
# Create 3 pods in development namespace with the label app=backend 
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-17-Using-ports-in-a-range\Serverpods.yaml"
# Creates following server pods 
# windows-pod-port-5678
# windows-pod-port-80
# windows-pod-port-6782
# linux-pod-port-6739
# linux-pod-port-8080

# Create testpods with the label app=monitor
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-17-Using-ports-in-a-range\Testpods.yaml"

# Apply the network policy file
# NP will allow egress from pods with the label app=monitor in development namespace only to pods with the label app=backend
# on port number in the range 4900 to 8000
kubectl apply -f "C:\github\Network-policies-for-hybrid-node-pool-cluster\Verification for Hybrid node pool\Case-17-Using-ports-in-a-range\Networkpolicy.yaml"

# Shouldn't be allowed 
kubectl exec win-monitor-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-pod-port-80 -n development -o 'jsonpath={.status.podIP}'):80 -UseBasicParsing
kubectl exec win-monitor-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-pod-port-8080 -n development -o 'jsonpath={.status.podIP}'):8080 -UseBasicParsing
kubectl exec -n development lin-monitor-testpod -- nc -vz $(kubectl get pod windows-pod-port-80 -n development -o 'jsonpath={.status.podIP}') 80
kubectl exec -n development lin-monitor-testpod -- nc -vz $(kubectl get pod linux-pod-port-8080 -n development -o 'jsonpath={.status.podIP}') 8080

# Should be allowed
kubectl exec win-monitor-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-pod-port-5678 -n development -o 'jsonpath={.status.podIP}'):5678 -UseBasicParsing
kubectl exec win-monitor-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po windows-pod-port-6782 -n development -o 'jsonpath={.status.podIP}'):6782 -UseBasicParsing
kubectl exec win-monitor-testpod -n development -- powershell Invoke-WebRequest -Uri http://$(kubectl get po linux-pod-port-6739 -n development -o 'jsonpath={.status.podIP}'):6739 -UseBasicParsing
kubectl exec -n development lin-monitor-testpod -- nc -vz $(kubectl get pod windows-pod-port-5678 -n development -o 'jsonpath={.status.podIP}') 5678
kubectl exec -n development lin-monitor-testpod -- nc -vz $(kubectl get pod windows-pod-port-6782 -n development -o 'jsonpath={.status.podIP}') 6782
kubectl exec -n development lin-monitor-testpod -- nc -vz $(kubectl get pod linux-pod-port-6739 -n development -o 'jsonpath={.status.podIP}') 6739


# CleanUp 
kubectl delete pod win-monitor-testpod -n development
kubectl delete pod lin-monitor-testpod -n development
kubectl delete pod windows-pod-port-5678 -n development
kubectl delete pod windows-pod-port-6782 -n development
kubectl delete pod windows-pod-port-80 -n development
kubectl delete pod linux-pod-port-6739 -n development
kubectl delete pod linux-pod-port-8080 -n development
kubectl delete netpol allow-from-ports-in-a-range -n development
