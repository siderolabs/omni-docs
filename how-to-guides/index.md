---
description: A guide on how to create a cluster.
---

# Create a Cluster

This guide shows you how to create a cluster from registered machines.

{% tabs %}
{% tab title="UI" %}
First, click the "Clusters" section button in the sidebar. Next, click the "Create Cluster" button.

You may name the cluster, as well as specify the version of Talos Linux and Kubernetes that the cluster should be created with. You may also enable optional cluster features, such as Disk Encryption or [Workload Service Proxying](index-12.md).

{% hint style="info" %}
Note that disk encryption can only be enabled during cluster creation. Enabling this checkbox will configure the cluster to use Omni as a [Key Management Server](../explanation/omni-kms-disk-encryption.md), and local disk access will not the possible unless the machine is connected to Omni.
{% endhint %}





<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-a-cluster/how-to-create-a-cluster-1_hu0be398a1d6bb39386fc95dcd73c16f2d_322061_900x0_resize_catmullrom_3.png" alt="" height="563" width="900"><figcaption></figcaption></figure>

Select the role for each machine you would like to create a cluster from. Now that each machine has a role, choose the install disk from the dropdown menu for each machine. Finally, click “Create Cluster”

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-a-cluster/how-to-create-a-cluster-2_hub2723a3bce83670dc2756e84b1b5c70c_367125_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>
{% endtab %}

{% tab title="CLI with manual machine allocation" %}
Create a file called `cluster.yaml` with the following content:

```yaml
kind: Cluster
name: example
kubernetes:
  version: v1.27.0
talos:
  version: v1.5.2
---
kind: ControlPlane
machines:
  - <control plane machine UUID>
---
kind: Workers
machines:
  - <worker machine UUID>
---
kind: Machine
name: <control plane machine UUID>
install:
  disk: /dev/<disk>
---
kind: Machine
name: <worker machine UUID>
install:
  disk: /dev/<disk>
```

> If enabling optional features such as disk encryption, add them to the Cluster document e.g.:

```yaml
kind: Cluster
name: example
kubernetes:
  version: v1.27.0
talos:
  version: v1.5.2
features:
  diskEncryption: true
```

{% hint style="info" %}
<pre><code><strong>Be sure to update the UUIDs and install disks with the UUIDs and disks of the machines in your account.
</strong></code></pre>
{% endhint %}

Now, validate the document:

```bash
omnictl cluster template validate -f cluster.yaml
```

Create the cluster:

```bash
omnictl cluster template sync -f cluster.yaml --verbose
```

Finally, wait for the cluster to be up:

```bash
omnictl cluster template status -f cluster.yaml
```
{% endtab %}

{% tab title="CLI with Machine Classes" %}
Create a file called `cluster.yaml` with the following content:

```yaml
kind: Cluster
name: example
kubernetes:
  version: v1.28.0
talos:
  version: v1.5.4
---
kind: ControlPlane
machineClass:
  name: control-planes
  size: 1
---
kind: Workers
machineClass:
  name: workers
  size: 1
---
kind: Workers
name: secondary
machineClass:
  name: secondary-workers
  size: unlimited
```

Be sure to create machine classes `control-planes`, `workers` and `secondary-workers` beforehand. See [machine classes how-to](https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/).

Now, validate the document:

```bash
omnictl cluster template validate -f cluster.yaml
```

Create the cluster:

```bash
omnictl cluster template sync -f cluster.yaml --verbose
```

Finally, wait for the cluster to be up:

```bash
omnictl cluster template status -f cluster.yaml
```
{% endtab %}
{% endtabs %}

