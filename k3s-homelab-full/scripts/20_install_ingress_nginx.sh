#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=ingress-nginx

echo "[Ingress] Adding Helm repo for ingress-nginx..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null 2>&1 || true
helm repo update

echo "[Ingress] Installing ingress-nginx (LoadBalancer, pinned to ingress-node=true)..."
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx   --namespace ${NAMESPACE}   --create-namespace   --set controller.service.type=LoadBalancer   --set controller.nodeSelector.ingress-node="true"

kubectl get pods -n ${NAMESPACE}
kubectl get svc -n ${NAMESPACE} ingress-nginx-controller
