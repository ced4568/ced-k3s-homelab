#!/usr/bin/env bash
set -euo pipefail

echo "[Label] Ingress nodes 1-3"
kubectl label node k3s-node-1 ingress-node=true --overwrite
kubectl label node k3s-node-2 ingress-node=true --overwrite
kubectl label node k3s-node-3 ingress-node=true --overwrite

echo "[Label] Data nodes 4-6"
kubectl label node k3s-node-4 data-node=true --overwrite
kubectl label node k3s-node-5 data-node=true --overwrite
kubectl label node k3s-node-6 data-node=true --overwrite

echo "[Label] Monitoring nodes 7-9"
kubectl label node k3s-node-7 monitoring-node=true --overwrite
kubectl label node k3s-node-8 monitoring-node=true --overwrite
kubectl label node k3s-node-9 monitoring-node=true --overwrite

kubectl get nodes -L ingress-node -L data-node -L monitoring-node
