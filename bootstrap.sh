#!/usr/bin/env bash
set -euo pipefail

echo "=============================================="
echo " Ced's K3s HomeLab Bootstrap"
echo "=============================================="
echo
echo "This script assumes:"
echo "  - K3s control-plane is already up (k3s-django-1/2/3)"
echo "  - Worker nodes are joined (k3s-node-1..9)"
echo "  - KUBECONFIG is set to point to the cluster"
echo
read -p "Press ENTER to continue or Ctrl+C to abort... " _

echo "[1/6] Labeling nodes into ingress/data/monitoring groups..."
./scripts/03_label_nodes.sh

echo "[2/6] Installing MetalLB (IP pool 10.10.30.251-254)..."
./scripts/10_install_metallb.sh

echo "[3/6] Installing ingress-nginx (LoadBalancer via MetalLB)..."
./scripts/20_install_ingress_nginx.sh

echo "[4/6] Installing Ced's NOC (kube-prometheus-stack)..."
./scripts/30_install_ceds_noc.sh

echo "[5/6] Deploying demo nginx app + ingress..."
kubectl apply -f manifests/demo-app/demo-nginx.yaml

echo "[6/6] Applying ingress for Grafana and Prometheus..."
kubectl apply -f manifests/ingress/grafana-ingress.yaml
kubectl apply -f manifests/ingress/prometheus-ingress.yaml

echo
echo "=============================================="
echo " Done!"
echo " - Demo app:      http://demo.local"
echo " - Grafana:       http://grafana.local"
echo " - Prometheus:    http://prometheus.local"
echo
echo "Remember to add these to your desktop hosts file pointing to the"
echo "MetalLB ingress IP (e.g. 10.10.30.251):"
echo
echo "  10.10.30.251 demo.local grafana.local prometheus.local"
echo
echo "You can now log into Grafana and import dashboards from the"
echo "dashboards/ folder in this repo."
echo "=============================================="
