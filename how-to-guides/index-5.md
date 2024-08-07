---
description: A guide on how to create a hybrid cluster.
---

# Create a Hybrid Cluster

This guide shows you how to create a cluster consisting of any combination of bare metal, cloud virtual machines, on-premise virtual machines, or SBCs, using KubeSpan. KubeSpan is a feature of Talos Linux that provides full node-to-node network encryption with WireGuard, and enables Kubernetes to operate securely even when machines in the cluster are on different networks.

Refer to the general guide on creating a cluster to get started. To create a hybrid cluster, navigate to the cluster, then apply the following cluster patch by clicking on "Config Patches", and create a new patch with the target of "Cluster":

<figure><img src="../.gitbook/assets/Screenshot 2024-08-07 at 9.28.24 PM.png" alt=""><figcaption></figcaption></figure>

```yaml
machine:
  network:
    kubespan:
      enabled: true
```

All machines in this cluster will have this patch applied to them, and use WireGuard encryption for all node-to-node traffic.
