# Ced's K3s Node Inventory

Use this file to track hardware details, OS, and roles for each node in the cluster.

## Control Plane Nodes

| Name          | IP           | Role                         | Hardware           | OS / Version                 | Storage        | Notes               |
|---------------|-------------|------------------------------|--------------------|------------------------------|----------------|---------------------|
| k3s-django-1  | 10.10.30.72 | control-plane,etcd,master    | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64)  | SD / SSD       | Primary API / etcd  |
| k3s-django-2  | 10.10.30.245| control-plane,etcd,master    | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64)  | SD / SSD       |                      |
| k3s-django-3  | 10.10.30.128| control-plane,etcd,master    | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64)  | SD / SSD       |                      |

## Worker Nodes – Ingress

| Name       | IP            | Role    | Hardware           | OS / Version                | Storage | Notes               |
|------------|--------------|---------|--------------------|-----------------------------|---------|---------------------|
| k3s-node-1 | 10.10.30.219 | ingress | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         |                     |
| k3s-node-2 | 10.10.30.134 | ingress | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         |                     |
| k3s-node-3 | 10.10.30.222 | ingress | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         |                     |

## Worker Nodes – Data

| Name       | IP            | Role | Hardware           | OS / Version                | Storage | Notes               |
|------------|--------------|------|--------------------|-----------------------------|---------|---------------------|
| k3s-node-4 | 10.10.30.126 | data | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         | e.g. databases      |
| k3s-node-5 | 10.10.30.239 | data | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         |                     |
| k3s-node-6 | 10.10.30.208 | data | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         |                     |

## Worker Nodes – Monitoring

| Name       | IP           | Role        | Hardware           | OS / Version                | Storage | Notes                   |
|------------|-------------|-------------|--------------------|-----------------------------|---------|-------------------------|
| k3s-node-7 | 10.10.30.198| monitoring  | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         | Prometheus, Loki, etc. |
| k3s-node-8 | 10.10.30.216| monitoring  | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         |                         |
| k3s-node-9 | 10.10.30.29 | monitoring  | Raspberry Pi 4B ?  | Debian 12 (Bookworm, ARM64) |         |                         |

## Other Notes

- Proxmox VE: 10.10.30.250
- MetalLB VIP range: 10.10.30.251–10.10.30.254
- Ingress-nginx LB example: 10.10.30.251

Use this file to track future changes (upgrading SD → SSD, RAM sizes, Pi models, etc.).
