---
description: A guide on how to export a cluster template from a cluster created in the UI.
---

# Export a Cluster Template from a Cluster Created in the UI

This guide shows you how to export a cluster template from a cluster created in the UI. This is useful when you want to switch a cluster from being manually managed to being managed by cluster templates (i.e. via the CLI, to be used in CI automation).

### Exporting the Cluster Template

To export a cluster, run the following command:

```bash
omnictl cluster template export -c my-cluster -o my-cluster-exported-template.yaml
```

It will export the template for the cluster with name `my-cluster` into the file `my-cluster-exported-template.yaml`.

If you inspect the exported template, you will see an output like the following:

```yaml
kind: Cluster
name: my-cluster
labels:
  my-label: my-value
kubernetes:
  version: v1.27.8
talos:
  version: v1.5.5
---
kind: ControlPlane
machines:
  - 1e3133f4-fb7a-4b62-bd4f-b792e2df24e2
  - 5439f561-f09e-4259-8788-9ab835bb9922
  - 63564547-c9cb-4a30-a54a-8f95a29d66a5
---
kind: Workers
machines:
  - 4b46f512-55d0-482c-ac48-cd916b62b74e
patches:
  - idOverride: 500-04e39280-4b36-435e-bedc-75c4ab340a80
    annotations:
      description: Enable verbose logging for kubelet
      name: kubelet-verbose-log
    inline:
      machine:
        kubelet:
          extraArgs:
            v: "4"
---
kind: Machine
name: 1e3133f4-fb7a-4b62-bd4f-b792e2df24e2
install:
  disk: /dev/vda
---
kind: Machine
name: 4b46f512-55d0-482c-ac48-cd916b62b74e
---
kind: Machine
name: 5439f561-f09e-4259-8788-9ab835bb9922
---
kind: Machine
name: 63564547-c9cb-4a30-a54a-8f95a29d66a5
```

### Using the Exported Cluster Template to Manage the Cluster

You can now use this template to manage the cluster - edit the template as needed and sync it using the CLI:

```bash
omnictl cluster template sync -f my-cluster-exported-template.yaml
```

Check the sync status:

```bash
omnictl cluster template status -f my-cluster-exported-template.yaml
```
