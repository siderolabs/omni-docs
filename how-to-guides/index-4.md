---
description: A guide on how to create a config patch for a machine in an Omni cluster.
---

# Create a Patch For Cluster Machines

Omni allows you to create patches and target the patches to all members of a cluster; all control plane nodes; all worker nodes; or specific machines. Upon logging in, click the “Clusters” menu item on the left. Now, select “Config Patches” from the menu under the ellipsis:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-patch-a-machine/1_hu2cbad0a46d42d47a473925d39138f584_834014_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

(You can also navigate to the specific cluster, and then select Config Patches in the right hand menu.)

Next, click “Create Patch”:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-patch-a-machine/2_hu2cbad0a46d42d47a473925d39138f584_791478_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

Pick the specific machine or class of machines from the “Patch Target” dropdown:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-patch-a-machine/3_hu2cbad0a46d42d47a473925d39138f584_895307_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

Type in the desired config patch:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-patch-a-machine/4_hu2cbad0a46d42d47a473925d39138f584_273007_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

Click “Save” to create the config patch:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-patch-a-machine/5_hu2cbad0a46d42d47a473925d39138f584_273644_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

For an example of a patch to enable node-to-node network encryption - the KubeSpan feature of Talos Linux - see [Creating a Hybrid Cluster](index-5.md).
