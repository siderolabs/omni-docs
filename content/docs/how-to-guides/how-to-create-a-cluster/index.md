---
title: "How to Create a Cluster"
description: "A guide on how to create a cluster."
date: 2022-10-30T15:50:38-07:00
draft: false
weight: 60
---

This guide shows you how to create a cluster from registered machines.

{{< tabpane text=true >}}
{{% tab header="UI" %}}

First, click the "Clusters" section button in the sidebar.
Next, click the "Create Cluster" button.

{{< imgproc how-to-create-a-cluster-1.png Resize "900x" >}}
{{< /imgproc >}}

Select the role for each machine you would like to create a cluster from.
Now that each machine has a role, choose the install disk from the dropdown menu for each machine.
Finally, click "Create Cluster"

{{< imgproc how-to-create-a-cluster-2.png Resize "900x" >}}
{{< /imgproc >}}

{{% /tab %}}

{{% tab header="CLI Manual Allocation" %}}

Create a file called `cluster.yaml` with the following content:

```yaml
kind: Cluster
name: example
kubernetes:
  version: v1.26.0
talos:
  version: v1.3.2
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

{{% tab header="CLI Machine Classes" %}}

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

Be sure to create machine classes `control-planes`, `workers` and `secondary-workers` beforehand. See [machine classes how-to](/docs/how-to-guides/how-to-create-machine-classes/).

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
