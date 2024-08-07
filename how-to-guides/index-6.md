---
description: A guide on how to install Talos system extensions.
---

# Install Talos Linux Extensions

{% tabs %}
{% tab title="UI" %}


On the overview page click “Download Installation Media” button on the right.

Select the list of extensions you want to be installed on the machine, Talos version and installation media type:

<figure><img src="../.gitbook/assets/2.jpg" alt=""><figcaption></figcaption></figure>

Click “Download”

Boot the machine with that installation media. It will have all extensions installed.

You can also add, remove or modify the extensions on an existing machine in a cluster by navigating to the Nodes view in a cluster, clicking on a machine, selecting the Extensions panel, then select Update Extensions to add or remove extensions.
{% endtab %}

{% tab title="CLI" %}
Create a file called `cluster.yaml` with the following content:

```yaml
kind: Cluster
name: example
kubernetes:
  version: v1.29.1
talos:
  version: v1.6.7
systemExtensions:
  - siderolabs/hello-world-service
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
---
kind: Machine
name: <worker machine UUID>
install:
  disk: /dev/<disk>
systemExtensions:
  - siderolabs/nvidia-container-toolkit
  - siderolabs/nvidia-fabricmanager
  - siderolabs/nvidia-open-gpu-kernel-modules
  - siderolabs/nonfree-kmod-nvidia
```

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

The cluster will have `hello-world-service` extension installed on the control plane and all nvidia drivers on the worker.
{% endtab %}
{% endtabs %}
