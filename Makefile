.PHONY: help label-nodes install-metallb install-ingress install-noc demo-app grafana-ingress prometheus-ingress all

help:
	@echo "Ced's K3s HomeLab Makefile"
	@echo
	@echo "Targets:"
	@echo "  label-nodes        - Label ingress/data/monitoring nodes"
	@echo "  install-metallb    - Install and configure MetalLB"
	@echo "  install-ingress    - Install ingress-nginx via Helm"
	@echo "  install-noc        - Install Prometheus + Grafana (kube-prometheus-stack)"
	@echo "  demo-app           - Deploy demo nginx app + ingress"
	@echo "  grafana-ingress    - Apply Grafana ingress"
	@echo "  prometheus-ingress - Apply Prometheus ingress"
	@echo "  all                - MetalLB + ingress + NOC + demo app + ingresses"

label-nodes:
	./scripts/03_label_nodes.sh

install-metallb:
	./scripts/10_install_metallb.sh

install-ingress:
	./scripts/20_install_ingress_nginx.sh

install-noc:
	./scripts/30_install_ceds_noc.sh

demo-app:
	kubectl apply -f manifests/demo-app/demo-nginx.yaml

grafana-ingress:
	kubectl apply -f manifests/ingress/grafana-ingress.yaml

prometheus-ingress:
	kubectl apply -f manifests/ingress/prometheus-ingress.yaml

all: label-nodes install-metallb install-ingress install-noc demo-app grafana-ingress prometheus-ingress
