---
title: "Back Up On-prem Omni Database"
date: 2022-12-28T10:00:00+01:00
draft: false
weight: 210
---

This guide shows you how to back up the database of an on-prem Omni instance.

Omni uses etcd as its database.

There are 2 operating modes for etcd: embedded and external.

When Omni is run with `--etcd-embedded=true` flag, it will configure the embedded etcd server to
listen the addresses specified by the `--etcd-endpoints` flag (`http://localhost:2379` by default).

In the same host where Omni is running (in Docker, `--network=host` needs to be used), you can use
the [etcdctl](https://github.com/etcd-io/etcd/tree/main/etcdctl) command to back up the database:

```bash
etcdctl --endpoints http://localhost:2379 snapshot save snapshot.db
```

The command will save the snapshot of the database to the `snapshot.db` file.

It is recommended to periodically (e.g. with a cron job) take snapshots and store them in a safe location, like an S3
bucket.

{{% alert title="Note" %}}
When `--etcd-embedded` is set to `false`, the database is external and not managed by Omni.

It still needs to be regularly backed up. For more info,
see [etcd disaster recovery](https://etcd.io/docs/v3.3/op-guide/recovery/).
{{% /alert %}}
