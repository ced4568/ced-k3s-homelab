Ced’s K3s HomeLab

A fully-HA Kubernetes cluster powered by Raspberry Pi hardware.
Includes MetalLB load balancer, NGINX ingress, and kube-prometheus monitoring for Ced’s NOC.

Architecture

3 × Control Plane nodes (etcd HA)

9 × Worker nodes with workload isolation
-Ingress Pool (1-3)
-Data Pool (4-6)
-Monitoring Pool (7-9)

Features

High Availability k3s control plane

MetalLB L2 load balancer

NGINX ingress controller

Prometheus + Grafana stack

Custom NOC dashboards
