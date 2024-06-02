---
title: Create a Hybrid Cluster
description: "A guide on how to create a hybrid cluster."
date: 2022-10-29T09:33:42-07:00
draft: false
weight: 40
---

This guide shows you how to create a cluster consisting of any combination of bare metal, cloud virtual machines, on-premise virtual machines, or SBCs, using KubeSpan. KubeSpan is a feature of Talos Linux that provides full non-to-node network encryption with WireGuard, and enables Kubernetes to operate securely even when machines in the cluster on different networks.

Refer to the general guide on creating a cluster to get started.
To create a hybid cluster apply the following cluster patch by clicking on "Config Patches" and navigating the the "Cluster" tab:

{{< imgproc how-to-create-a-hybrid-cluster-1.png Resize "900x" >}}
{{< /imgproc >}}

```yaml
machine:
  network:
    kubespan:
      enabled: true
```
