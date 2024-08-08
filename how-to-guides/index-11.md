---
description: A guide on how to create a machine class.
---

# Create a Machine Class

This guide shows you how to create and a machine class.

{% tabs %}
{% tab title="CLI" %}
Create a file called `machine-class.yaml` with the following content:

```yaml
metadata:
  namespace: default
  type: MachineClasses.omni.sidero.dev
  id: test
spec:
  matchlabels:
    # matches machines with amd64 architecture and more than 2 CPUs
    - omni.sidero.dev/arch = amd64, omni.sidero.dev/cpus > 2
```

Create the machine class:

```bash
omnictl apply -f machine-class.yaml
```
{% endtab %}

{% tab title="UI" %}
First, click the “Machine Classes” section button in the sidebar.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/0_hu5c347fbf3eb269726456bc1f3ef9dbb2_251622_900x0_resize_catmullrom_3.png" alt="" height="456" width="900"><figcaption></figcaption></figure>

Next, click the “Create Machine Class” button.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/1_hub73e792c85fabe36c6f59b7079c64a1f_131941_900x0_resize_catmullrom_3.png" alt="" height="456" width="900"><figcaption></figcaption></figure>

Add machine query conditions by typing them manually in the input box.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/2_hu07e493ae100699b060ea20efa35d6036_377565_900x0_resize_catmullrom_3.png" alt="" height="457" width="900"><figcaption></figcaption></figure>

Clicking the label in the machine list will add them to the input box.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/3_hu06ee8aa8e2d6832f191a1c5bc41c4254_377701_900x0_resize_catmullrom_3.png" alt="" height="457" width="900"><figcaption></figcaption></figure>

Clicking on “+” will add blocks to match the machines using boolean `OR` operator.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/4_hu04bfb46b577f0042c2cc3088aabd10eb_387491_900x0_resize_catmullrom_3.png" alt="" height="457" width="900"><figcaption></figcaption></figure>

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/5_hu232b1e1aec8fb97eb0eb9693e92acda6_399815_900x0_resize_catmullrom_3.png" alt="" height="458" width="900"><figcaption></figcaption></figure>

Name the machine class.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/6_hu04b4af328a38beb13e5f05165b9f48ba_399992_900x0_resize_catmullrom_3.png" alt="" height="458" width="900"><figcaption></figcaption></figure>

Click “Create Machine Class”.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/how-to-create-machine-classes/7_huef5773341b3d582f599356fb15b78984_399931_900x0_resize_catmullrom_3.png" alt="" height="458" width="900"><figcaption></figcaption></figure>
{% endtab %}
{% endtabs %}
