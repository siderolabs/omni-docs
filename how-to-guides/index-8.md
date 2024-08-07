---
description: A guide on how to create cluster etcd backups using Omni.
---

# Etcd backups

First of all, check the current overall status of the cluster backup subsystem:

```shell
omnictl get etcdbackupoverallstatus
```

If you have freshly created Omni instance, the output will be similar to this:

```shell
NAMESPACE   TYPE                      ID                          VERSION   CONFIGURATION NAME   CONFIGURATION ERROR   LAST BACKUP STATUS   LAST BACKUP ERROR   LAST BACKUP TIME   CONFIGURATION ATTEMPT
ephemeral   EtcdBackupOverallStatus   etcdbackup-overall-status   1         s3                   not initialized
```

The combination of the `CONFIGURATION NAME` and `CONFIGURATION ERROR` fields display the current backup store configuration status. Currently, Omni supports two backup stores: `local` and `s3`. These are configured during Omni initialization. The output above indicates that the backup store is set to use the `s3` store. However, the s3 configuration itself has not yet been added, so the `CONFIGURATION ERROR` field shows `not initialized`. The rest of the fields show as empty because no backups have been created yet.

## S3 configuration

To use S3 as the backup storage, you will first need to configure the S3 credentials for Omni to use. This can be done by creating an `EtcdBackupS3Configs.omni.sidero.dev` resource in Omni. Below is an example for Minio S3:

```yaml
metadata:
  namespace: default
  type: EtcdBackupS3Configs.omni.sidero.dev
  id: etcd-backup-s3-conf
spec:
  bucket: mybucket
  region: us-east-1
  endpoint: http://127.0.0.1:9000
  accesskeyid: access
  secretaccesskey: secret123
  sessiontoken: ""
```

Let's go through the fields:

* `bucket` - the name of the S3 bucket for storing backups. This is the only field required in all cases.
* `region` - the region of the S3 bucket. If not provided, Omni will use the default region.
* `endpoint` - the S3 endpoint. If not provided, Omni will use the default AWS S3 endpoint.
* `accesskeyid` and `secretaccesskey` - the credentials to access the S3 bucket. If not provided, Omni will assume it runs in an EC2 instance with an IAM role that has access to the specified S3 bucket.
* `sessiontoken` - the session token (if any) for accessing the S3 bucket.

Save it as `<file-name>.yaml` and apply using `omnictl apply -f <file-name>.yaml`. During resource creation, Omni will validate the provided credentials by attempting to list the objects in the bucket. It will return an error if the validation fails and will not update the resource.

Let's get our overall status again and check the output:

```shell
NAMESPACE   TYPE                      ID                          VERSION   CONFIGURATION NAME   CONFIGURATION ERROR   LAST BACKUP STATUS   LAST BACKUP ERROR   LAST BACKUP TIME   CONFIGURATION ATTEMPT
ephemeral   EtcdBackupOverallStatus   etcdbackup-overall-status   2         s3
```

Note that the `CONFIGURATION ERROR` field is now empty, indicating that the provided configuration is valid.

## Manual backup

Now, let's create a manual backup. To do that, we need to create a resource:

```yaml
metadata:
  namespace: ephemeral
  type: EtcdManualBackups.omni.sidero.dev
  id: <your-cluster-name>
spec:
  backupat:
    seconds: <unix-timestamp>
    nanos: 0
```

The `<unix-timestamp>` should be no more than one minute in the future or in the past. The easiest way to get the current timestamp is to simply invoke `date +%s` in your shell. The `nanos` field should always be `0`.

After you save the resource as `<file-name>.yaml`, apply it using `omnictl apply -f <file-name>.yaml`. In a few seconds, you can check the status of the backup:

```shell
omnictl get etcdbackupstatus -o yaml
```

This command print per-cluster backup status. The output will be similar to this:

```yaml
metadata:
  namespace: ephemeral
  type: EtcdBackupStatuses.omni.sidero.dev
  id: <cluster-name>
  version: 1
  owner: EtcdBackupController
  phase: running
spec:
  status: 1
  error: ""
  lastbackuptime:
    seconds: 1702166400
    nanos: 985220192
  lastbackupattempt:
    seconds: 1702166400
    nanos: 985220192
```

You can also get the overall status of the backup subsystem:

```yaml
metadata:
  namespace: ephemeral
  type: EtcdBackupOverallStatuses.omni.sidero.dev
  id: etcdbackup-overall-status
  version: 3
  owner: EtcdBackupOverallStatusController
  phase: running
spec:
  configurationname: s3
  configurationerror: ""
  lastbackupstatus:
    status: 1
    error: ""
    lastbackuptime:
      seconds: 1702166400
      nanos: 985220192
    lastbackupattempt:
      seconds: 1702166400
      nanos: 985220192
```

## Automatic backup

Omni also supports automatic backups. You can enable this feature by directly editing the cluster resource `Clusters.omni.sidero.dev` or by using cluster templates. Let's explore how we can do this in both ways.

### Cluster templates

Enabling automatic backups using cluster templates is quite straightforward. First, you'll need a template that resembles the following:

```yaml
kind: Cluster
name: talos-default
kubernetes:
  version: v1.28.2
talos:
  version: v1.5.5
features:
  backupConfiguration:
    interval: 1h
---
kind: ControlPlane
machines:
  - 1dd4397b-37f1-4196-9c37-becef670b64a
---
kind: Workers
machines:
  - 0d1f01c3-0a8a-4560-8745-bb792e3dfaad
  - a0f29661-cd2d-4e25-a6c9-da5ca4c48d58
```

This is the minimal example of a cluster template for a cluster with a single-node control plane and two worker nodes. Your machine UUIDs will be different, and the Kubernetes and Talos versions will probably also differ. You will need both of these, as well as the cluster name, in your cluster template. To obtain these, refer to the `clustermachinestatus` and `cluster` resources.

In this example, we are going to set the backup interval for the cluster to one hour. Save this template as `<file-name>.yaml`. Before applying this change, we want to ensure that no automatic backup is enabled for this cluster. To do that, let's run the following command:

```shell
omnictl cluster template -f <file-name>.yaml diff
```

The Omni response will resemble the following:

```shell
--- Clusters.omni.sidero.dev(default/talos-default)
+++ Clusters.omni.sidero.dev(default/talos-default)
@@ -19,4 +19,7 @@
   features:
     enableworkloadproxy: false
     diskencryption: false
-  backupconfiguration: null
+  backupconfiguration:
+    interval:
+      seconds: 3600
+      nanos: 0
```

Now that we have verified that Omni does not already have an automatic backup enabled, we will apply the change:

```shell
omnictl cluster template -f <file-name>.yaml sync
```

If you didn't have any backups previously, Omni will not wait for an hour and will immediately create a fresh backup. You can verify this by running the following command:

```shell
omnictl get etcdbackup --selector omni.sidero.dev/cluster=talos-default
```

Keep in mind that to obtain the backup status, you will need to use the label selector `omni.sidero.dev/cluster` along with your cluster name. In this example it is `talos-default`.

```shell
NAMESPACE   TYPE         ID                         VERSION     CREATED AT
external    EtcdBackup   talos-default-1702166400   undefined   {"nanos":0,"seconds":1702166400}
```

### Cluster resource

Another way to enable automatic backups is by directly editing the cluster resource. To do this, first, you'll need to retrieve the cluster resource from the Omni:

```shell
omnictl get cluster talos-default -o yaml
```

```yaml
metadata:
  namespace: default
  type: Clusters.omni.sidero.dev
  id: talos-default
  finalizers:
    - KubernetesUpgradeStatusController
    - TalosUpgradeStatusController
    - SecretsController
    - ClusterController
spec:
  installimage: ""
  kubernetesversion: 1.28.2
  talosversion: 1.5.5
  features:
    enableworkloadproxy: false
    diskencryption: false
```

Add fields related to the backup configuration while preserving the existing fields:

```yaml
metadata:
  namespace: default
  type: Clusters.omni.sidero.dev
  id: talos-default
  finalizers:
    - KubernetesUpgradeStatusController
    - TalosUpgradeStatusController
    - SecretsController
    - ClusterController
spec:
  installimage: ""
  kubernetesversion: 1.28.2
  talosversion: 1.5.5
  features:
    enableworkloadproxy: false
    diskencryption: false
  backupconfiguration:
    interval:
      seconds: 3600
      nanos: 0
```

Save it to the file and apply using `omnictl apply -f <file-name>.yaml`. You will get the output similar to the one above for the cluster template.
