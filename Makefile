.PHONY: create-cluster delete-cluster deploy-apisix deploy-httpbin deploy-route test deploy-keycloak

create-cluster:
	kind create cluster --config kind-cluster.yaml

delete-cluster:
	kind delete cluster --name apisix-playground

deploy-apisix:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add apisix https://charts.apiseven.com
	helm repo update
	helm upgrade --install apisix apisix/apisix \
	  --kube-context kind-apisix-playground \
	  --version 2.5.0 \
	  --create-namespace \
	  --namespace ingress-apisix \
	  --set gateway.http.enabled=true \
	  --set gateway.type=NodePort \
	  --set gateway.http.nodePort="30950" \
	  --set ingress-controller.enabled=true \
	  --set ingress-controller.config.apisix.serviceNamespace=ingress-apisix \
	  --set ingress-controller.config.apisix.adminAPIVersion=v3
	# Apisix Helm chart doesn't let us specify the NodePort to use
	kubectl patch service apisix-gateway -n ingress-apisix --type='json' -p='[{"op":"replace","path":"/spec/ports/0/nodePort","value":30950}]'

deploy-httpbin:
	kubectl apply --context kind-apisix-playground -f httpbin.yaml
	kubectl apply --context kind-apisix-playground -f httpbin-service-clusterip.yaml

deploy-route:
	kubectl apply --context kind-apisix-playground -f route.yaml

test:
	curl --location --request GET "http://127.0.0.1/get?foo1=bar1&foo2=bar2" -H "Host: local.httpbin.org"

deploy-keycloak:
	kubectl apply --context kind-apisix-playground -f keycloak.yaml