Add nginx ingress controller : 
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx   --namespace ingress-nginx   --create-namespace   --set controller.service.type=LoadBalancer

Headlamp is hosted with headlamp official helm chart : 
helm install headlamp headlamp/headlamp -n headlamp
