.PHONEY: start
start:
	kind create cluster --config kind-config.yaml

.PHONEY: stop
stop:
	docker compose down
	kind delete cluter

.PHONEY: install-metallb
install-metallb:
	kubectl get configmap -n kube-system kube-proxy -oyaml | sed -s 's/strictARP: false/strictARP: true/' | kubectl apply -f -
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

.PHONEY: setup
setup:
	cd bird  && ./render.sh

.PHONEY: start-bird
start-bird:
	docker compose up -d
	docker network connect kind bird

.PHONEY: deploy-resources
deploy-resources:
	cd metallb && ./render.sh
	kubectl apply -f metallb/pool.yaml
	kubectl apply -f metallb/peer.yaml
	kubectl apply -f metallb/adversite.yaml
	kubectl apply -f nginx/pod.yaml
	kubectl apply -f nginx/service.yaml

.PHONEY: birdcl
birdcl:
	docker exec -it bird birdcl

.PHONEY: shell-client
shell-client:
	docker exec -it client bash

