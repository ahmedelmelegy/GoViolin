#!/usr/bin/env make

.PHONY: run_website install_kind install_kubectl create_kind_cluster \
	create_docker_registry connect_registry_to_kind_network \
	connect_registry_to_kind create_kind_cluster_with_registry \
	delete_docker_registry delete_kind_cluster install_app \
	uninstall_app

run_website_docker:
	docker build -t goviolin-multistage . && \
		docker run --name goviolin -p 8080:8080 -d --rm goviolin-multistage
stop_website_docker:
	docker stop goviolin

install_kubectl:
	brew install kubectl || true;

install_kind:
	curl -o ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-darwin-arm64

connect_registry_to_kind_network:
	docker network connect kind local-registry || true;

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f ./kind_configmap.yaml;

create_docker_registry:
	if ! docker ps | grep -q 'local-registry'; \
	then docker run -d -p 5000:5000 --name local-registry --restart=always registry:2; \
	else echo "---> local-registry is already running. There's nothing to do here."; \
	fi

create_kind_cluster: install_kind install_kubectl create_docker_registry
	kind create cluster --image=kindest/node:v1.21.12 --name goviolin.com --config ./kind_config.yaml || true
	kubectl get nodes

create_kind_cluster_with_registry:
	$(MAKE) create_kind_cluster && $(MAKE) connect_registry_to_kind

delete_kind_cluster: delete_docker_registry
	kind delete cluster --name goviolin.com

delete_docker_registry:
	docker stop local-registry && docker rm local-registry

install_app:
	helm upgrade --atomic --install go-violin-website ./chart

uninstall_app:
	helm uninstall go-violin-website
