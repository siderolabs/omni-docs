---
title: Create a Machine Class
date: 2023-10-25T13:19:38.000Z
draft: false
weight: 40
description: A guide on how to create a machine class.
---

# Create a Machine Class

This guide shows you how to create and a machine class.

\{{< tabpane text=true >\}} {



}

First, click the "Machine Classes" section button in the sidebar.

{

} {}

Next, click the "Create Machine Class" button.

{

} {}

Add machine query conditions by typing them manually in the input box.

{

} {}

Clicking the label in the machine list will add them to the input box.

{

} {}

Clicking on "+" will add blocks to match the machines using boolean `OR` operator.

{

} {}

{

} {}

Name the machine class.

{

} {}

Click "Create Machine Class".

{

} {}

{

}

{



}

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

{

}

\{{< /tabpane >\}}
