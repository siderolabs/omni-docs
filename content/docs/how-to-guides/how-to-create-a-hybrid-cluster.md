---
title: How to Create a Hybrid Cluster
description: "A guide on how to create a hybrid cluster."
date: 2022-10-29T09:33:42-07:00
draft: false
weight: 20
---

This guide shows you how to create and configure a cluster consisting of machines that are any combination of bare metal, cloud virtual machines, on-premise virtual machines, or SBCs.

You can refer to the general guide on creating a cluster and when it is time to add a machine ensure each machine has the following patch:

```yaml
machine:
  network:
    kubespan:
      enabled: true
```
