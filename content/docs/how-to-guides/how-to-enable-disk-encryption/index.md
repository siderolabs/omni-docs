---
title: "How to Enable Disk Encryption"
description: "A guide on how to enable Omni KMS assisted disk encryption for a cluster."
date: 2022-10-30T15:50:38-07:00
draft: false
weight: 60
---

{{< tabpane text=true >}}
{{% tab header="UI" %}}

First, click the "Clusters" section button in the sidebar.
Next, click the "Create Cluster" button.

{{< imgproc how-to-enable-disk-encryption-1.png Resize "900x" >}}
{{< /imgproc >}}

Select Talos version `>=` `1.5.0`.
Click "Enable Encryption" checkbox.

{{% /tab %}}

{{% tab header="CLI" %}}

Create a file called `cluster.yaml` with the following content:

```yaml
kind: Cluster
name: example
kubernetes:
  version: v1.27.3
talos:
  version: v1.5.0
features:
  diskEncryption: true
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

{{% alert title="Note" color="info" %}}
Be sure to update the UUIDs and install disks with the UUIDs and disks of the machines in your account.
{{% /alert %}}

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

{{% /tab %}}

{{< /tabpane >}}
