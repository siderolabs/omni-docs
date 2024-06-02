---
title: "Create a Machine Class"
description: "A guide on how to create a machine class."
date: 2023-10-25T17:19:38+04:00
draft: false
weight: 40
---

This guide shows you how to create and a machine class.

{{< tabpane text=true >}}
{{% tab header="UI" %}}

First, click the "Machine Classes" section button in the sidebar.

{{% imgproc 0.png Resize "900x" %}}
{{% /imgproc %}}

Next, click the "Create Machine Class" button.

{{% imgproc 1.png Resize "900x" %}}
{{% /imgproc %}}

Add machine query conditions by typing them manually in the input box.

{{% imgproc 2.png Resize "900x" %}}
{{% /imgproc %}}

Clicking the label in the machine list will add them to the input box.

{{% imgproc 3.png Resize "900x" %}}
{{% /imgproc %}}

Clicking on "+" will add blocks to match the machines using boolean `OR` operator.

{{% imgproc 4.png Resize "900x" %}}
{{% /imgproc %}}

{{% imgproc 5.png Resize "900x" %}}
{{% /imgproc %}}

Name the machine class.

{{% imgproc 6.png Resize "900x" %}}
{{% /imgproc %}}

Click "Create Machine Class".

{{% imgproc 7.png Resize "900x" %}}
{{% /imgproc %}}

{{% /tab %}}

{{% tab header="CLI" %}}

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

{{% /tab %}}

{{< /tabpane >}}
