# Example Makefile

# Phony targets are tasks that are not actual files
.PHONY: create-cluster delete-cluster deploy-apisix deploy-httpbin deploy-route test

create-cluster:
	kind create cluster --config kind-cluster.yaml

delete-cluster:
	kind delete cluster --name apisix-playground

deploy-httpbin:
	kubectl create namespace ingress-apisix
	kubectl apply -f httpbin.yaml
	kubectl apply -f httpbin-service-clusterip.yaml

deploy-apisix:
	helm install apisix apisix/apisix \
	  --set service.type=NodePort \
      --set service.port=30950 \
	  --set ingress-controller.enabled=true \
	  --create-namespace \
	  --namespace ingress-apisix \
	  --set ingress-controller.config.apisix.serviceNamespace=ingress-apisix \
	  --set ingress-controller.config.apisix.adminAPIVersion=v3

deploy-route:
	kubectl apply -f route.yaml

test:
	curl --location --request GET "http://127.0.0.1/get?foo1=bar1&foo2=bar2" -H "Host: local.httpbin.org"