---
title: How to Create a Hybrid Cluster
description: "A guide on how to create a hybrid cluster."
date: 2022-10-29T09:33:42-07:00
draft: false
weight: 20
---

This guide shows you how to create and configure a cluster consisting of machines that are any combination of bare metal, cloud virtual machines, on-premise virtual machines, or SBCs.

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
