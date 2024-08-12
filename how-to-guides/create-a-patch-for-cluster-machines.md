---
description: A guide on how to create a config patch for a machine in an Omni cluster.
---

# Create a Patch For Cluster Machines

Omni allows you to create patches and target the patches to all members of a cluster; all control plane nodes; all worker nodes; or specific machines. Upon logging in, click the “Clusters” menu item on the left. Now, select “Config Patches” from the menu under the ellipsis:

<figure><img src="../.gitbook/assets/Screenshot 2024-08-07 at 9.16.51 PM.png" alt=""><figcaption></figcaption></figure>

(You can also navigate to the specific cluster, and then select Config Patches in the right hand menu.)

Next, click “Create Patch”:

<figure><img src="../.gitbook/assets/Screenshot 2024-08-07 at 9.18.58 PM.png" alt=""><figcaption></figcaption></figure>

Pick the specific machine or class of machines from the “Patch Target” dropdown:

<figure><img src="../.gitbook/assets/Screenshot 2024-08-07 at 9.21.57 PM.png" alt=""><figcaption></figcaption></figure>

Type in the desired config patch:

<figure><img src="../.gitbook/assets/Screenshot 2024-08-07 at 9.23.47 PM.png" alt=""><figcaption></figcaption></figure>

Click “Save” to create the config patch.

For an example of a patch to enable node-to-node network encryption - the KubeSpan feature of Talos Linux - see [Creating a Hybrid Cluster](create-a-hybrid-cluster.md).
