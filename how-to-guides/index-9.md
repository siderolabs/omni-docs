---
description: >-
  This guide shows you how to restore a cluster's etcd to an earlier snapshot.
  This is useful when you need to revert a cluster to an earlier state.
---

# Restore Etcd of a Cluster Managed by Cluster Templates

This tutorial has the following requirements:

* The CLI tool `omnictl` must be installed and configured.
* The cluster which you want to restore **must still exist** (not be deleted from Omni) and have past backups available.
* The cluster **must be managed using cluster templates** (not via the UI).

### Finding the Cluster's UUID

To find the cluster's UUID, run the following command, replacing `my-cluster` with the name of your cluster:

```bash
omnictl get clusteruuid my-cluster
```

The output will look like this:

```
NAMESPACE   TYPE          ID              VERSION   UUID
default     ClusterUUID   my-cluster      1         bb874758-ee54-4d3b-bac3-4c8349737298
```

Note the `UUID` column, which contains the cluster's UUID.

### Finding the Snapshot to Restore

List the available snapshots for the cluster:

```bash
omnictl get etcdbackup -l omni.sidero.dev/cluster=my-cluster
```

The output will look like this:

```
NAMESPACE   TYPE         ID                         VERSION     CREATED AT                         SNAPSHOT
external    EtcdBackup   my-cluster-1701184522   undefined   {"nanos":0,"seconds":1701184522}   FFFFFFFF9A99FBF6.snapshot
external    EtcdBackup   my-cluster-1701184515   undefined   {"nanos":0,"seconds":1701184515}   FFFFFFFF9A99FBFD.snapshot
external    EtcdBackup   my-cluster-1701184500   undefined   {"nanos":0,"seconds":1701184500}   FFFFFFFF9A99FC0C.snapshot
```

The `SNAPSHOT` column contains the snapshot name which you will need to restore the cluster. Let's assume you want to restore the cluster to the snapshot `FFFFFFFF9A99FBFD.snapshot`.

### Deleting the Existing Control Plane

To restore the cluster, we need to first delete the existing control plane of the cluster. This will take the cluster into the non-bootstrapped state. Only then we can create the new control plane with the restored etcd.

Use the following command to delete the control plane, replacing `my-cluster` with the name of your cluster:

```bash
omnictl delete machineset my-cluster-control-planes
```

### Creating the Restore Template

Edit your cluster template manifest `template-manifest.yaml`, edit the list of control plane machines for your needs, and add the `bootstrapSpec` section to the control plane, with cluster UUID and the snapshot name we found above:

```yaml
kind: Cluster
name: my-cluster
kubernetes:
  version: v1.28.2
talos:
  version: v1.5.5
---
kind: ControlPlane
machines:
  - 430d882a-51a8-48b3-ae00-90c5b0b5b0b0
  - e865efbc-25a1-4436-bcd9-0a431554e328
  - 820c2b44-568c-461e-91aa-c2fc228c0b2e
bootstrapSpec:
  clusterUUID: bb874758-ee54-4d3b-bac3-4c8349737298 # The cluster UUID we found above
  snapshot: FFFFFFFF9A99FBFD.snapshot # The snapshot name we found above
---
kind: Workers
machines:
  - 18308f52-b833-4376-a7c8-1cb9de2feafd
  - 79f8db4d-3b6b-49a7-8ac4-aa5d2287f706
```

### Syncing the Template

To sync the template, run the following command:

```bash
omnictl cluster template sync -f template-manifest.yaml
omnictl cluster template status -f template-manifest.yaml
```

After the sync, your cluster will be restored to the snapshot you specified.

### Restarting Kubelet on Worker Nodes

To ensure a healthy cluster operation, the kubelet needs to be restarted on all worker nodes.

{% hint style="info" %}
For this step, you need [talosctl](how-to-install-talosctl.md) to be installed and **talosconfig** to be configured for this cluster. You can download talosconfig using the Web UI or by

```
omnictl talosconfig -c my-cluster
```
{% endhint %}

Get the IDs of the worker nodes:

```bash
omnictl get clustermachine -l omni.sidero.dev/role-worker,omni.sidero.dev/cluster=my-cluster
```

The output will look like this:

```
NAMESPACE   TYPE             ID                                     VERSION
default     ClusterMachine   26b87860-38b4-400f-af72-bc8d26ab6cd6   3
default     ClusterMachine   2f6af2ad-bebb-42a5-b6b0-2b9397acafbc   3
default     ClusterMachine   5f93376a-95f6-496c-b4b7-630a0607ac7f   3
default     ClusterMachine   c863ccdf-cdb7-4519-878e-5484a1be119a   3
```

Gather the IDs in this output, and issue a kubelet restart on them using `talosctl`:

```bash
talosctl -n 26b87860-38b4-400f-af72-bc8d26ab6cd6 service kubelet restart
talosctl -n 2f6af2ad-bebb-42a5-b6b0-2b9397acafbc service kubelet restart
talosctl -n 5f93376a-95f6-496c-b4b7-630a0607ac7f service kubelet restart
talosctl -n c863ccdf-cdb7-4519-878e-5484a1be119a service kubelet restart
```
