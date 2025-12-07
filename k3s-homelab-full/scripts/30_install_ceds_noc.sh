#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=monitoring

echo "[NOC] Creating monitoring namespace (if not exists)..."
kubectl create namespace ${NAMESPACE} 2>/dev/null || true

echo "[NOC] Adding prometheus-community Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm repo update

echo "[NOC] Installing kube-prometheus-stack as 'ceds-noc'..."
helm upgrade --install ceds-noc prometheus-community/kube-prometheus-stack   --namespace ${NAMESPACE}   -f kube-prom-values.yaml

kubectl get pods -n ${NAMESPACE}
kubectl get svc -n ${NAMESPACE}
