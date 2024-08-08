---
description: A guide on how to add or remove nodes to a cluster with Omni.
---

# Scale a Cluster Up or Down

#### Scaling Down or removing nodes from a cluster <a href="#scaling-down-or-removing-nodes-from-a-cluster" id="scaling-down-or-removing-nodes-from-a-cluster"></a>

To delete machines in a cluster, click the “Clusters” menu item on the left, then the name of the cluster you wish to delete nodes from. Click the “Nodes” menu item on the left. Now, select “Destroy” from the menu under the elipsis:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-scale-a-cluster/1_hu2cbad0a46d42d47a473925d39138f584_867232_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

The cluster will now scale down.

#### Scaling Up or adding nodes to a cluster <a href="#scaling-up-or-adding-nodes-to-a-cluster" id="scaling-up-or-adding-nodes-to-a-cluster"></a>

To add machines to a cluster, click the “Cluster” menu item on the left, then the name of the cluster you wish to add nodes to. From the “Cluster Overview” tab, click the “Add Machines” button in the sidebar on the right.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-scale-a-cluster/2_hu2cbad0a46d42d47a473925d39138f584_1109440_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

From the list of available machines that is shown, identify the machine or machines you wish to add, and then click “ControlPlane” or “Worker”, to add the machine(s) with that role. You may add multiple machines in one operation. Click “Add Machines” when all machines have been selected to be added.

The cluster will now scale up.
