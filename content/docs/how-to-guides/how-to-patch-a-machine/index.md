---
title: "Create a Patch For Cluster Machines"
description: "A guide on how to create a config patch for a machine in a cluster."
draft: false
weight: 60
---

Omni allows you to create patches and target the patches to all members of a cluster; all control plane nodes; all worker nodes; or specific machines.
Upon logging in, click the "Clusters" menu item on the left.
Now, select "Config Patches" from the menu under the ellipsis:

{{< imgproc 1.png Resize "900x" >}}
{{< /imgproc >}}
(Yoou can also navigate to the specific cluster, and then select Config Patches in the right hand menu.)

Next, click "Create Patch":

{{< imgproc 2.png Resize "900x" >}}
{{< /imgproc >}}

Pick the specific machine or class of machines from the "Patch Target" dropdown:

{{< imgproc 3.png Resize "900x" >}}
{{< /imgproc >}}

Type in the desired config patch:

{{< imgproc 4.png Resize "900x" >}}
{{< /imgproc >}}

Click "Save" to create the config patch:

{{< imgproc 5.png Resize "900x" >}}
{{< /imgproc >}}

For an example of a patch to enable node-to-node network encryption - the KubeSpan feature of Talos Linux - see [Creating a Hybrid Cluster](../how-to-create-a-hybrid-cluster/).