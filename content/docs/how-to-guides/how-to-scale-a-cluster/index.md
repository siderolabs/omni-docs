---
title: Scale a Cluster Up or Down
description: "A guide on how to add or remove nodes to a cluster with Omni."
date: 2023-02-22T12:46:28-08:00
draft: false
weight: 40
---
### Scaling Down or removing nodes from a cluster

To delete machines in a cluster, click the "Clusters" menu item on the left, then the name of the cluster you wish to delete nodes from.
Click the "Nodes" menu item on the left.
Now, select "Destroy" from the menu under the elipsis:

{{< imgproc 1.png Resize "900x" >}}
{{< /imgproc >}}

The cluster will now scale down.

### Scaling Up or adding nodes to a cluster

To add machines to a cluster, click the "Cluster" menu item on the left, then the name of the cluster you wish to add nodes to.
From the "Cluster Overview" tab, click the "Add Machines" button in the sidebar on the right.

{{< imgproc 2.png Resize "900x" >}}
{{< /imgproc >}}

From the list of available machines that is shown, identify the machine or machines you wish to add, and then click "ControlPlane" or "Worker", to add the machine(s) with that role.
You may add multiple machines in one operation.
Click "Add Machines" when all machines have been selected to be added.

The cluster will now scale up.