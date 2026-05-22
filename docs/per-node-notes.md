# Ced's K3s Node Inventory

> **Note:** All IP addresses have been replaced with placeholders for security. Substitute your own values before using this file.

Use this file to track hardware details, OS, and roles for each node in the cluster.

## Control Plane Nodes

| Name          | IP                      | Role                         | Hardware           | OS / Version                 | Storage        | Notes               |
|---------------|-------------------------|------------------------------|--------------------|------------------------------|----------------|---------------------|
| k3s-django-1  | <control-plane-ip-1>    | control-plane,etcd,master    | Raspberry Pi 4B    | Debian 12 (Bookworm, ARM64)  | SD / SSD       | Primary API / etcd  |
| k3s-django-2  | <control-plane-ip-2>    | control-plane,etcd,master    | Raspberry Pi 4B    | Debian 12 (Bookworm, ARM64)  | SD / SSD       |                     |
| k3s-django-3  | <control-plane-ip-3>    | control-plane,etcd,master    | Raspberry Pi 4B    | Debian 12 (Bookworm, ARM64)  | SD / SSD       |                     |

## Worker Nodes – Ingress

| Name       | IP                   | Role    | Hardware        | OS / Version                | Storage | Notes |
|------------|----------------------|---------|-----------------|-----------------------------|---------|-------|
| k3s-node-1 | <ingress-node-ip-1>  | ingress | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         |       |
| k3s-node-2 | <ingress-node-ip-2>  | ingress | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         |       |
| k3s-node-3 | <ingress-node-ip-3>  | ingress | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         |       |

## Worker Nodes – Data

| Name       | IP                | Role | Hardware        | OS / Version                | Storage | Notes          |
|------------|-------------------|------|-----------------|-----------------------------|---------|----------------|
| k3s-node-4 | <data-node-ip-1>  | data | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         | e.g. databases |
| k3s-node-5 | <data-node-ip-2>  | data | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         |                |
| k3s-node-6 | <data-node-ip-3>  | data | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         |                |

## Worker Nodes – Monitoring

| Name       | IP                        | Role       | Hardware        | OS / Version                | Storage | Notes                  |
|------------|---------------------------|------------|-----------------|-----------------------------|---------|------------------------|
| k3s-node-7 | <monitoring-node-ip-1>    | monitoring | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         | Prometheus, Loki, etc. |
| k3s-node-8 | <monitoring-node-ip-2>    | monitoring | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         |                        |
| k3s-node-9 | <monitoring-node-ip-3>    | monitoring | Raspberry Pi 4B | Debian 12 (Bookworm, ARM64) |         |                        |

## Other Notes

- Proxmox VE: `<proxmox-host-ip>`
- MetalLB VIP range: `<metallb-pool-range>`
- Ingress-nginx LB example: `<metallb-vip>`

Use this file to track future changes (upgrading SD to SSD, RAM sizes, Pi models, etc.).