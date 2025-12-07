# Ced's K3s HomeLab (Raspberry Pi Cluster)

This repo captures the working configuration of your HA K3s cluster:

- 3× control-plane nodes: `k3s-django-1/2/3`
- 9× worker nodes split into:
  - Ingress: `k3s-node-1..3`
  - Data:    `k3s-node-4..6`
  - Monitoring: `k3s-node-7..9`
- MetalLB for LoadBalancer IPs on your HomeLab VLAN
- ingress-nginx as the main ingress controller
- kube-prometheus-stack (Prometheus + Grafana + Alertmanager + exporters)
- Ced's NOC dashboards for Grafana

You can use this as a GitHub repo, import the dashboards into Grafana, and keep long‑term documentation of Ced's HomeLab.

## Quick Start (once K3s cluster is up)

On `k3s-django-1` with `KUBECONFIG` pointing at the cluster:

```bash
git clone <your-repo-or-copy-files>
cd k3s-homelab-full

# 1) Label nodes into groups
./scripts/03_label_nodes.sh

# 2) Install MetalLB
./scripts/10_install_metallb.sh

# 3) Install ingress-nginx
./scripts/20_install_ingress_nginx.sh

# 4) Install Ced's NOC (kube-prometheus-stack)
./scripts/30_install_ceds_noc.sh

# 5) Deploy demo nginx ingress + Grafana/Prometheus ingress rules
kubectl apply -f manifests/demo-app/demo-nginx.yaml
kubectl apply -f manifests/ingress/grafana-ingress.yaml
kubectl apply -f manifests/ingress/prometheus-ingress.yaml
```

Then update your desktop `hosts` file to point:

```text
10.10.30.251 demo.local grafana.local prometheus.local
```

## Structure

- `cluster-setup.md` – step-by-step narrative of the full setup.
- `kube-prom-values.yaml` – values file for `kube-prometheus-stack` (Ced's NOC).
- `dashboards/` – starter Grafana dashboards in JSON.
- `scripts/` – helper scripts to label nodes and install MetalLB, ingress, and NOC.
- `manifests/` – YAML manifests for MetalLB, demo app, and ingresses.
- `docs/per-node-notes.md` – inventory of each node (IP, role, hardware).
- `diagrams/ced-k3s-from-text.txt` – text that can be imported into draw.io ("Arrange → Insert → Advanced → From text").
