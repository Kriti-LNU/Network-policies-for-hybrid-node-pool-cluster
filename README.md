

# Network-policies-for-hybrid-node-pool-cluster

## For debugging –
- kubectl get pods -n kube-system
- kubectl logs -n kube-system [Npm-pod name] | Select-String "error"
- kubectl exec -ti -n kube-system [Npm-pod name]  -- powershell.exe
- Get-Hnsnetwork | convertto-json
- Get-HnsEndpoint 
- kubectl get pods -n kube-system
 

