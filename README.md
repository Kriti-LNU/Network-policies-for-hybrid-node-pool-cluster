

# Network-policies-for-hybrid-node-pool-cluster

## Case-1-Allow-from-some-pods-in-a-namespace	
- Allow ingress to pods with app=backend in development namespace only from pods with app=frontend in development namespace. Any other ingress connection to pods with app=backend should be blocked.	
- Working as expected for both Linux and windows-based pods.
## Case-2-Deny-all-ingress-to-selected-pods	
- Deny all ingress connections to pods with app=backend in development namespace.	
- Not working as expected for Windows based pods.
## Case-3-Allow-all-ingress-from-same-namespace	
- Denies all ingress connections to pods with app=backend outside the development namespace.
- Not working as expected for Windows based pods.
## Case-4-Allow-ingress-from-a-namespace	
- Allow ingress from all pods in a namespace.	
- Not Working as expected for both Linux and windows-based pods
## Case-5-Allow-ingress-from-pods-in-a-namespace		
- Working as expected.
## Case-6-Allow-ingress-from-pods-or-namespace		
- Working as expected for both Linux and windows-based pods
## Case-7-Using-named-ports		
## Case-8-Allow-egress-from-some-pods-in-the-namespace	
- Allow egress from pods with app=frontend in development namespace only to pods with app=backend in development namespace. Any other egress connection should be blocked.	Not working as expected.

## For debugging –
- kubectl get pods -n kube-system
- kubectl logs -n kube-system azure-npm-windows-cbzqp | Select-String "error"
- kubectl exec -ti -n kube-system azure-npm-windows-cbzqp  -- powershell.exe
- Get-Hnsnetwork | convertto-json
- Get-HnsEndpoint 
- kubectl get pods -n kube-system
 

