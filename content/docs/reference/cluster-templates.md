---
title: "Cluster Templates"
description: "Reference documentation for cluster templates."
date: 2022-10-29T15:35:30-07:00
draft: false
weight: 10
---

Cluster templates are parsed, validated, and converted to Omni resources, which are then created or updated via the Omni API.
Omni guarantees backward compatibility for cluster templates, so the same template can be used with any future version of Omni.

All referenced files in machine configuration patches should be stored relative to the current working directory.

## Structure

The Cluster Template is a YAML file consisting of multiple documents, with each document having a `kind` field that specifies the type of the document.
Some documents might also have a `name` field that specifies the name (ID) of the document.

```yaml
kind: Cluster
name: example
labels:
  my-label: my-value
kubernetes:
  version: v1.26.0
talos:
  version: v1.3.2
patches:
  - name: kubespan-enabled
    inline:
      machine:
        network:
          kubespan:
            enabled: true
---
kind: ControlPlane
machines:
  - 27c16241-96bf-4f17-9579-ea3a6c4a3ca8
  - 4bd92fba-998d-4ef3-ab43-638b806dd3fe
  - 8fdb574a-a252-4d7d-94f0-5cdea73e140a
---
kind: Workers
machines:
  - b885f565-b64f-4c7a-a1ac-d2c8c2781373
  - a54f21dc-6e48-4fc1-96aa-3d7be5e2612b
---
kind: Workers
name: xlarge
machines:
  - 1f721dee-6dbb-4e71-9832-226d73da3841
---
kind: Machine
name: 27c16241-96bf-4f17-9579-ea3a6c4a3ca8
---
kind: Machine
name: 4bd92fba-998d-4ef3-ab43-638b806dd3fe
install:
  disk: /dev/vda
---
kind: Machine
name: 8fdb574a-a252-4d7d-94f0-5cdea73e140a
install:
  disk: /dev/vda
---
kind: Machine
name: b885f565-b64f-4c7a-a1ac-d2c8c2781373
install:
  disk: /dev/vda
---
kind: Machine
name: a54f21dc-6e48-4fc1-96aa-3d7be5e2612b
locked: true
install:
  disk: /dev/vda
---
kind: Machine
name: 1f721dee-6dbb-4e71-9832-226d73da3841
install:
  disk: /dev/vda
```

Each cluster template should have exactly one document of `kind: Cluster`, `kind: ControlPlane`, and any number of `kind: Workers` with different `name`s.

Every `Machine` document must be referenced by either a `ControlPlane` or `Workers` document.

## Document Types

### `Cluster`

The `Cluster` document specifies the cluster configuration, labels, defines the cluster name and base component versions.

```yaml
kind: Cluster
name: example
labels:
  my-label: my-value
annotations:
  my-annotation: my-value
kubernetes:
  version: v1.26.1
talos:
  version: v1.3.3
patches:
  - file: patches/example-patch.yaml
```

| Field | Type | Description |
|-------|------|-------------|
| `kind` | string | `Cluster` |
| `name` | string | Cluster name: only letters, digits and `-` and `_` are allowed. The cluster name is used as a key by all other documents, so if the cluster name changes, a new cluster will be created. |
| `labels` | map[string]string | Labels to be applied to the cluster. |
| `annotations` | map[string]string | Annotations to be applied to the cluster. |
| `kubernetes.version` | string | Kubernetes version to use, `vA.B.C`. |
| `talos.version` | string | Talos version to use, `vA.B.C`. |
| `patches` | array | List of [patches](#patches) to apply to the cluster. |

### `ControlPlane`

The `ControlPlane` document specifies the control plane configuration, defines the number of control plane nodes, and the list of machines to use.

As control plane machines run an `etcd` cluster, it is recommended to use a number of machines for the control plane that can achieve a stable quorum (i.e. 1, 3, 5, etc.).
Changing the set of machines in the control plane will trigger a rolling scale-up/scale-down of the control plane.

The control plane should have at least a single machine, but it is recommended to use at least 3 machines for the control plane for high-availability.

```yaml
kind: ControlPlane
labels:
  my-label: my-value
annotations:
  my-annotation: my-value
machines:
  - 27c16241-96bf-4f17-9579-ea3a6c4a3ca8
  - 4bd92fba-998d-4ef3-ab43-638b806dd3fe
  - 8fdb574a-a252-4d7d-94f0-5cdea73e140a
patches:
  - file: patches/example-controlplane-patch.yaml
```

| Field | Type | Description |
|-------|------|-------------|
| `kind` | string | `ControlPlane` |
| `labels` | map[string]string | Labels to be applied to the control plane machine set. |
| `annotations` | map[string]string | Annotations to be applied to the control plane machine set. |
| `machines` | array | List of machine IDs to use for control plane nodes (mutually exclusive with `machineClass`). |
| `patches` | array | List of [patches](#patches) to apply to the machine set. |
| `machineClass` | [MachineClass](#machineclass) | Machine Class configuration (mutually exclusive with `machines`). |

### `Workers`

The `Workers` document specifies the worker configuration, defines the number of worker nodes, and the list of machines to use.

```yaml
kind: Workers
name: workers
labels:
  my-label: my-value
annotations:
    my-annotation: my-value
machines:
  - b885f565-b64f-4c7a-a1ac-d2c8c2781373
patches:
  - file: patches/example-workers-patch.yaml
```

| Field | Type | Description |
|-------|------|-------------|
| `kind` | string | `Workers` |
| `name` | string | Worker machine set name: only letters, digits and `-` and `_` are allowed. Defaults to `workers` when omitted. Must be unique and not be `control-planes`. |
| `labels` | map[string]string | Labels to be applied to the worker machine set. |
| `annotations` | map[string]string | Annotations to be applied to the worker machine set. |
| `machines` | array | List of machine IDs to use as worker nodes in the machine set (mutually exclusive with `machineClass`). |
| `patches` | array | List of [patches](#patches) to apply to the machine set. |
| `machineClass` | [MachineClass](#machineclass) | Machine Class configuration (mutually exclusive with `machines`). |

### `MachineClass`

The `MachineClass` section of the [Control Plane](#controlplane) or the [Workers](#workers) defines the rule for picking the machines in the machine set.

```yaml
kind: Workers
name: workers
machineClass:
  name: worker-class
  size: 2
```

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Name of the machine class to use. |
| `size` | number | Number of machines to pick from the matching machine class. |

{{% alert title="Note" %}}
`size` field supports keyword `unlimited|infinity` which makes the machine set pick all available machines from the specified machine class.
{{% /alert %}}

### `Machine`

The `Machine` document specifies the install disk and machine-specific configuration patches.
They are optional, but every `Machine` document must be referenced by either a `ControlPlane` or `Workers` document.

```yaml
kind: Machine
name: 27c16241-96bf-4f17-9579-ea3a6c4a3ca8
labels:
  my-label: my-value
annotations:
  my-annotation: my-value
locked: false
install:
  disk: /dev/vda
patches:
  - file: patches/example-machine-patch.yaml
```

| Field | Type | Description |
|-------|------|-------------|
| `kind` | string | `Machine` |
| `name` | string | Machine ID. |
| `labels` | map[string]string | Labels to be applied to the machine set node. |
| `annotations` | map[string]string | Annotations to be applied to the machine set node. |
| `locked` | string | Whether the machine should be marked as locked. Can be `true` only if the machine is used as a worker. |
| `install.disk` | string | Disk to install Talos on. Matters only for Talos running from ISO or iPXE. |
| `patches` | array | List of [patches](#patches) to apply to the machine. |

{{% alert title="Note" %}}
When Talos is not installed and the install disk is not specified, Omni will try to pick the install disk automatically.
It will find the smallest disk which is larger than 5GB.
{{% /alert %}}

## Common Fields

### `patches`

The `patches` field is a list of [machine configuration patches](https://www.talos.dev/latest/talos-guides/configuration/patching/) to apply to a cluster, a machine set, or an individual machine.
Config patches modify the configuration before it is applied to each machine in the cluster.
Changing configuration patches modifies the machine configuration which gets automatically applied to the machine.

```yaml
patches:
  - file: patches/example-patch.yaml
  - name: kubespan-enabled
    inline:
      machine:
        network:
          kubespan:
            enabled: true
  - idOverride: 950-set-env-vars
    labels:
      my-label: my-value
    annotations:
      my-annotation: my-value
    inline:
      machine:
        env:
          MY_ENV_VAR: my-value
```

| Field | Type | Description |
|-------|------|-------------|
| `file` | string | Path to the patch file. Path is relative to the current working directory when executing `omnictl`. File should contain Talos machine configuration strategic patch. |
| `name` | string | Name of the patch. Required for `inline` patches when `idOverride` is not set, optional for `file` patches (default name will be based on the file path). |
| `idOverride` | string | Override the config patch ID, so it won't be generated from the `name` or `file`. |
| `labels` | map[string]string | Labels to be applied to the config patch. |
| `annotations` | map[string]string | Annotations to be applied to the config patch. |
| `inline` | object | Inline patch containing Talos machine configuration strategic patch.  |

A configuration patch may be either `inline` or `file` based.
Inline patches are useful for small changes, file-based patches are useful for more complex changes, or changes shared across multiple clusters.
