---
description: A guide on how to install Talos system extensions.
---

# Install Talos System Extensions

{% tabs %}
{% tab title="UI" %}


On the overview page click “Download Installation Media” button:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-install-talos-system-extensions/1_hu8cd91d96fbe1337d206c057b94486f4c_787685_900x0_resize_q75_catmullrom.jpg" alt="" height="527" width="900"><figcaption></figcaption></figure>

Select the list of extensions you want to be installed on the machine, Talos version and installation media type:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-install-talos-system-extensions/2_hu8cd91d96fbe1337d206c057b94486f4c_911357_900x0_resize_q75_catmullrom.jpg" alt="" height="527" width="900"><figcaption></figcaption></figure>

Click “Download”:

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-install-talos-system-extensions/3_hu8cd91d96fbe1337d206c057b94486f4c_872286_900x0_resize_q75_catmullrom.jpg" alt="" height="527" width="900"><figcaption></figcaption></figure>

Boot the machine with that installation media. It will have all extensions installed.

{% hint style="info" %}
{% code overflow="wrap" %}
```
Updating extensions after the cluster is created is possible only when using CLI.
```
{% endcode %}
{% endhint %}
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
