---
description: A guide to keeping your clusters up to date with Omni.
---

# Upgrading Omni Clusters

### Introduction

Omni makes keeping your cluster up-to-date easy - which is good, as it is important to stay current with Talos Linux and Kubernetes releases, to ensure you are not exposed to already fixed security issues and bugs. Keeping your clusters up-to-date involves updating both the underlying operating system (Talos Linux) and Kubernetes.

### Upgrading the Operating System

In order to update the Talos Linux version of all nodes in a cluster, navigate to the overview of the cluster you wish to update. (For example, click the cluster name in the Clusters panel.) If newer Talos Linux versions are available, there will be an indication in the far right, where the current cluster Talos version is listed. Clicking that icon, or the "Update Talos" button in the lower right, will allow you to select the new version of Talos Linux that should be deployed across all nodes of the cluster.

Select the new version, and then "Upgrade" (or "Downgrade", if you are selecting an older version than currently deployed.) (Omni will ensure that the Kubernetes version running in the cluster is compatible with the selected version of Talos Linux.)

> **Note**: You may upgrade to any Talos version shown. Omni will only allow supported upgrade paths. In some cases this may require an intermediate upgrade before upgrading to the most recent version.

Omni will then cycle through all nodes in the cluster, safely updating them to the selected version of Talos Linux. Omni will update the control plane nodes first. (Omni ensures the etcd cluster is healthy and will remain healthy after the node being updated leaves the etcd cluster, before allowing a control plane node to be upgraded.)

Omni will drain and cordon each node, update the OS, and then un-cordon the node. Omni always updates nodes with the Talos Linux flag `--preserve=true`, keeping ephemeral data.

NOTE: If any of your workloads are sensitive to being shut down ungracefully, be sure to use the lifecycle.preStop Pod spec.

### Kubernetes Upgrades

As with the Talos Linux version, Omni will notify you on the right hand side of the cluster overview if there is a new version of Kubernetes available. You may click either the Upgrade icon next to the Kubernetes version, or the `Update Kubernetes` button on the lower right of the cluster overview. Kubernetes upgrades are done non-disruptively to workloads and are run in several phases:

* Images for new Kubernetes components are pre-pulled to the nodes to minimize downtime and test for image availability.
* New static pod definitions are rendered on the configuration update which is picked up by the kubelet. The command waits for the change to propagate to the API server state.
* The command updates the kube-proxy daemonset with the new image version.
* On every node in the cluster, the kubelet version is updated.

> Note: The upgrade operation never deletes any resources from the cluster: obsolete resources should be deleted manually.

#### Applying changed Kubernetes Manifests

Unlike the Talos Linux command `talosctl upgrade-k8s`, Omni does not automatically apply updates to Kubernetes bootstrap manifests on a Kubernetes upgrade. This is to prevent Omni overwriting changes to the bootstrap manifests that you applied manually. (Talos Linux has a `--dry-run` feature on the upgrade command that shows you changes before the upgrade - Omni shows you the changes _after_ the upgrade, but before they are applied.) Thus after each Kubernetes upgrade, it is recommended to examine the `BootStrap Manifests` of the cluster (as shown in the left hand navigation) and apply the changes, if they are appropriate.

### Locking nodes

Omni allows you to control which nodes are upgraded during Talos or Kubernetes upgrade operations. You can lock nodes, which prevents them from receiving configuration updates, upgrades and downgrades. This allows you to ensure that new versions of Talos Linux or Kubernetes, or new config patches, are rolled out in a safe and controlled manner. If you cannot do a blue/green deployment with different clusters, you can roll out a new Kubernetes or Talos Linux release, or config patch, to just some of the nodes in your cluster. Once you have validated your applications perform correctly on the new versions, you can unlock all the nodes, and allow them to be updated also.

> Note: you cannot lock control plane nodes, as it is not supported to have the Kubernetes version of a worker higher than that of the control plane nodes in a cluster - this may result in API version incompatibility.

To lock a node, simply select the Lock icon to the right of the node on the Cluster Overview screen, or use the `omnictl cluster machine lock` command. Upgrade and config patch operations will apply to all other nodes in the cluster, but locked nodes will retain their configuration at the time of locking. Unlock the nodes to allow pending cluster updates to complete.
