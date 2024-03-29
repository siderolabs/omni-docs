---
title: "Use Kubectl With Omni"
date: 2022-11-17T10:14:18-08:00
draft: false
weight: 90
---

This guide shows you how to use `kubectl` with an Omni-managed cluster.

Navigate to the clusters page by clicking on the "Clusters" button in the sidebar.

{{< imgproc 1.png Resize "900x" >}}
{{< /imgproc >}}

Click the three dots in the cluster's item to access the options menu.

{{< imgproc 2.png Resize "900x" >}}
{{< /imgproc >}}

Click "Download kubeconfig".

{{< imgproc 3.png Resize "900x" >}}
{{< /imgproc >}}

Alternatively you can click on the cluster and download the `kubeconfig` from the cluster dashboard.

{{< imgproc 4.png Resize "900x" >}}
{{< /imgproc >}}

Install the `oidc-login` plugin per the official documentation: https://github.com/int128/kubelogin.
