#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=metallb-system

echo "[MetalLB] Installing CRDs & core components..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml

echo "[MetalLB] Waiting for pods..."
kubectl rollout status -n ${NAMESPACE} deploy/controller --timeout=180s || true

echo "[MetalLB] Applying IPAddressPool and L2Advertisement (10.10.30.251-10.10.30.254)..."
kubectl apply -f manifests/metallb/ipaddresspool.yaml
kubectl apply -f manifests/metallb/l2advertisement.yaml

kubectl get ipaddresspools.metallb.io -n ${NAMESPACE}
kubectl get l2advertisements.metallb.io -n ${NAMESPACE}
