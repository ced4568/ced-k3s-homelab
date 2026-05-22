# Ced's K3s Cluster Setup End to End

Note: All IP addresses and subnet ranges in this document have been replaced with placeholders for security. Substitute your own values where you see <placeholder> before running any commands.

---

## 1. Base Networking

**HomeLab VLAN:** `<homelab-vlan-subnet>`
**Gateway:** UniFi Dream Router
**DHCP:** Configured to exclude the upper range so MetalLB can safely use that range.

- Proxmox VE: `<proxmox-host-ip>`
- MetalLB pool: `<metallb-pool-range>`

Subnets you have overall (for reference):

- Default: `<default-subnet>` (not used)
- Main: `<main-vlan-subnet>`
- IoT: `<iot-vlan-subnet>`
- HomeLab: `<homelab-vlan-subnet>`
- Guest: `<guest-vlan-subnet>`

---

## 2. K3s Control Plane

### Nodes

- `k3s-django-1` – `<control-plane-ip-1>` (control-plane, etcd, master)
- `k3s-django-2` – `<control-plane-ip-2>` (control-plane, etcd, master)
- `k3s-django-3` – `<control-plane-ip-3>` (control-plane, etcd, master)

All three are Debian 12 (Bookworm, ARM64 on Raspberry Pi).

### 2.1 Install K3s on the first control-plane node

On `k3s-django-1`:

```bash
curl -sfL https://get.k3s.io | sh -s - server
```

Then capture the version, token, and kubeconfig:

```bash
k3s --version

sudo cat /var/lib/rancher/k3s/server/node-token

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
```

Update the kubeconfig to point to the node's real IP instead of `127.0.0.1`:

```bash
sed -i 's/https:\/\/127.0.0.1:6443/https:\/\/<control-plane-ip-1>:6443/' ~/.kube/config
export KUBECONFIG=$HOME/.kube/config
```

Check:

```bash
kubectl get nodes -o wide
```

You should see `k3s-django-1` as `Ready control-plane,etcd,master`.

### 2.2 Join additional control-plane nodes

Get the join token from `k3s-django-1`:

```bash
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo "$TOKEN"
```

On `k3s-django-2` and `k3s-django-3`:

```bash
export K3S_URL="https://<control-plane-ip-1>:6443"
export K3S_TOKEN="<PASTE TOKEN FROM k3s-django-1>"

curl -sfL https://get.k3s.io | \
  K3S_URL=$K3S_URL \
  K3S_TOKEN=$K3S_TOKEN \
  sh -s - server
```

Verify from `k3s-django-1`:

```bash
kubectl get nodes -o wide
```

You should now see all three `k3s-django-*` nodes as control plane,etcd,master.

---

## 3. Worker Nodes

You have 9 worker nodes grouped as:

- Ingress: `k3s-node-1`, `k3s-node-2`, `k3s-node-3`
- Data: `k3s-node-4`, `k3s-node-5`, `k3s-node-6`
- Monitoring: `k3s-node-7`, `k3s-node-8`, `k3s-node-9`

### 3.1 Join workers as agents

On each worker node (`k3s-node-N`), use:

```bash
export K3S_URL="https://<control-plane-ip-1>:6443"
export K3S_TOKEN="<same token from k3s-django-1>"

curl -sfL https://get.k3s.io | \
  K3S_URL=$K3S_URL \
  K3S_TOKEN=$K3S_TOKEN \
  sh -s - agent
```

Confirm from `k3s-django-1`:

```bash
kubectl get nodes -o wide
```

All 9 agents should show as `Ready` with no special roles yet.

### 3.2 Label nodes by function

From `k3s-django-1` (or any node with kubeconfig):

```bash
# Ingress group
kubectl label node k3s-node-1 ingress-node=true
kubectl label node k3s-node-2 ingress-node=true
kubectl label node k3s-node-3 ingress-node=true

# Data group
kubectl label node k3s-node-4 data-node=true
kubectl label node k3s-node-5 data-node=true
kubectl label node k3s-node-6 data-node=true

# Monitoring group
kubectl label node k3s-node-7 monitoring-node=true
kubectl label node k3s-node-8 monitoring-node=true
kubectl label node k3s-node-9 monitoring-node=true

kubectl get nodes -L ingress-node -L data-node -L monitoring-node
```

Additionally, you used `kubectl label node ...` to set the `ROLES` field (`ingress`, `data`, `monitoring`) for documentation.

---

## 4. MetalLB

### 4.1 Install MetalLB

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml
```

Wait for pods:

```bash
kubectl get pods -n metallb-system -o wide
```

### 4.2 Configure IPAddressPool and L2Advertisement

MetalLB is configured with an address pool in `manifests/metallb/ipaddresspool.yaml`:

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: ceds-pool
  namespace: metallb-system
spec:
  addresses:
    - <metallb-pool-range>
```

and `manifests/metallb/l2advertisement.yaml`:

```yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: ceds-l2
  namespace: metallb-system
spec:
  ipAddressPools:
    - ceds-pool
```

Apply:

```bash
kubectl apply -f manifests/metallb/ipaddresspool.yaml
kubectl apply -f manifests/metallb/l2advertisement.yaml
```

Check:

```bash
kubectl get ipaddresspools.metallb.io -n metallb-system
kubectl get l2advertisements.metallb.io -n metallb-system
```

---

## 5. Ingress-NGINX

### 5.1 Install Helm & ingress-nginx

On `k3s-django-1`:

```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

Install ingress nginx targeting the ingress node group:

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer \
  --set controller.nodeSelector.ingress-node="true"
```

Check:

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

You should see `EXTERNAL-IP` assigned from MetalLB, e.g. `<metallb-vip>`.

---

## 6. Demo Ingress App

`manifests/demo-app/demo-nginx.yaml` contains:

- A `Deployment` with 3 replicas of `nginx`
- A `ClusterIP` Service
- An Ingress pointing `demo.local` to the service via ingress-nginx

Apply:

```bash
kubectl apply -f manifests/demo-app/demo-nginx.yaml
```

Update your desktop hosts file:

```text
<metallb-vip> demo.local
```

Open `http://demo.local` in a browser and you should see the nginx welcome page, served via:

Desktop → MetalLB VIP (`<metallb-vip>`) → ingress-nginx → demo-nginx Service → Pods.

---

## 7. Ced's NOC (kube-prometheus-stack)

Namespace:

```bash
kubectl create namespace monitoring
```

Helm repo:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Install with your custom values file:

```bash
helm install ceds-noc prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f kube-prom-values.yaml
```

`kube-prom-values.yaml` (included in this repo) pins Prometheus, Alertmanager, and Grafana to the `monitoring-node=true` nodes, configures PVCs for metrics and Grafana data, and exposes Grafana via a LoadBalancer (MetalLB).

Check pods & services:

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

You should see:

- `ceds-noc-grafana` as a `LoadBalancer` with an `EXTERNAL-IP` like `<grafana-external-ip>`
- Prometheus, Alertmanager, kube state metrics, node exporters, etc.

Open Grafana at:

```text
http://<grafana-external-ip>
```

Username: `admin`
Password: either the one in `kube-prom-values.yaml` (if set) or via:

```bash
kubectl --namespace monitoring get secret ceds-noc-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

---

## 8. Grafana Dashboards (Ced's NOC)

Use Grafana → Dashboards → New → Import, and upload:

- `dashboards/ced_cluster_overview.json`
- `dashboards/ced_nodes_detail.json`
- `dashboards/ced_ingress_metallb.json`

Choose the kube-prometheus-stack Prometheus datasource.

You now have a live NOC for:

- Cluster health (nodes, pods, API server)
- Per-node CPU, RAM, disk, pod counts
- Ingress and MetalLB metrics

---

## 9. Future Enhancements

- Add Loki + Promtail for logs
- Add Prometheus alerting rules (node down, high CPU, low disk, etc)
- Add Alertmanager integrations (Discord/Slack/email)
- Use GitOps (FluxCD or ArgoCD) to manage this repo as the source of truth
