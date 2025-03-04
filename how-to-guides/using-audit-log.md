---
description: This guide shows you how to use the Omni audit log.
---

# Audit logs

{% hint style="info" %}
Audit logs are enabled by default for customers on our Omni SaaS.
{% endhint %}

{% hint style="info" %}
#### Enabling the audit log for self-hosted Omni

By default, the audit log is disabled. To enable it, you need to specify the `--audit-log-dir <dir>` when starting the Omni server.

For example:

```bash
docker run \
... omitted for brevity ...
  ghcr.io/siderolabs/omni:<tag> \
    --name=onprem-omni \
... omitted for brevity ...
    --audit-log-dir=/tmp/omni/audit-log
```

Starting the server without the `--audit-log-dir` or with empty value will disable the audit log.

The audit log is stored in the directory specified by `--audit-log-dir <dir>` flag. The log files are named `<year>-<month>-<day>.jsonlog`. The retention period is 30 days (including the current day), after which the log files are deleted.
{% endhint %}

#### Getting the Audit log

There are two ways of getting a concatenated audit log using Omni:

1. Using UI. Simply click "Download audit log" in the main menu from the home panel on the lower right.
2. Using `omnictl audit-log` command. This command will stream the audit log from the Omni to the local machine stdout.

The second way is preferable if you have a huge audit log, as it will not consume a lot of memory on the client if you look for something specific.

#### Format of the Audit log

The audit log is stored in JSON format. Each line in the log file is a JSON object representing an audit event.

Below is an example of log entry along with explanations.

```json
{"event_type":"create","resource_type":"Clusters.omni.sidero.dev","event_ts":1723466435280,"event_data":{"cluster":{"id":"talos-default","features":{},"kubernetes_version":"1.30.1","talos_version":"1.7.4"},"session":{"user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36","ip_address":"<snip>","user_id":"fa02ea7c-6eb1-491e-b053-b5db63a4384f","role":"Admin","email":"dmitry.matrenichev@siderolabs.com","fingerprint":"0263efb13f3b5016507ec11ba71a96f5fced3a4d"}}}
```

we can expand it to something readable:

```json
{
  "event_type": "create",
  "resource_type": "Clusters.omni.sidero.dev",
  "event_ts": 1723466435280,
  "event_data": {
    "cluster": {
      "id": "talos-default",
      "features": {},
      "kubernetes_version": "1.30.1",
      "talos_version": "1.7.4"
    },
    "session": {
      "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36",
      "ip_address": "<snip>",
      "user_id": "fa02ea7c-6eb1-491e-b053-b5db63a4384f",
      "role": "Admin",
      "email": "dmitry.matrenichev@siderolabs.com",
      "fingerprint": "0263efb13f3b5016507ec11ba71a96f5fced3a4d"
    }
  }
}
```

And go field by field:

* `"event_type"` is event (resource access, k8s or Talos access). Currently, there are seven `event-type`s:
  * `"create"` — resource was created.
  * `"update"` — resource was updated using Update mechanism.
  * `"update_with_conflicts"` — resource was updated using UpdateWithConflicts mechanism.
  * `"destroy"` — resource was destroyed.
  * `"teardown"` — resource is being torn down. Usually, it means that a resource will be destroyed soon.
  * `"k8s_access"` — k8s access event. Some user accessed Kubernetes cluster.
  * `"talos_access"` — talos access event. Some user accessed talos cluster.
* `"resource_type"` is the type of resource.
* `"event_ts"` is the timestamp of the event in milliseconds.
* `"event_data"` is the data of the event. It is a JSON object with at least one of the following fields:
  * `"session"` is the session data. It describes the session of the user who performed the action. It is a JSON object with the following fields:
    * `"user_agent"` is the user agent. For actions that are performed by Omni itself, the user agent will be "Omni-Internal-Agent" and the rest of the fields will be empty.
    * `"ip_address"` is the IP address. For k8s\_access this will be empty.
    * `"user_id"` is the user ID.
    * `"role"` is the role of the user.
    * `"email"` is the email of the user.
    * `"fingerprint"` is the fingerprint of the user.
  * `"new_user"` describes the newly created/edited or deleted user. It is a JSON object.
  * `"machine"` describes the machine. Currently it logs when a machine is created or destroyed. It is a JSON object.
  * `"machine_labels"` describes the machine labels. It is a JSON object.
  * `"access_policy"` describes the access policy. It is a JSON object.
  * `"cluster"` describes the cluster. It is a JSON object.
  * `"machine_set"` describes the cluster machine set. It is a JSON object.
  * `"machine_set_node"` describes the cluster machine set node. It is a JSON object.
  * `"config_patch"` describes the config patch. It is a JSON object.
  * `"talos_access"` describes the Talos access event. It is a JSON object with those fields:
    * `"full_method_name"` is the full method name that is being called on Talos side.
    * `"cluster_name"` is the name of the cluster.
    * `"machine_ip"` is the IP of the node.
  * `"k8s_access"` describes the Kubernetes access event. It is a JSON object with those fields:
    * `"full_method_name"` is the full HTTP/2 method name that is being called on Kubernetes side.
    * `"command"` is the command that is being called.
    * `"body"` is the body of the request if any.
    * `"kube_session"` is the session of the Kubernetes user.
    * `"cluster_name"` is the name of the cluster.
    * `"cluster_uuid"` is the UUID of the cluster.

**Supported resources.**

Currently, we support the following resources:

* `PublicKeys.omni.sidero.dev` — public keys.
* `Users.omni.sidero.dev` — users.
* `Identities.omni.sidero.dev` — identities.
* `Machines.omni.sidero.dev` — machines.
* `MachineLabels.omni.sidero.dev` — machine labels.
* `AccessPolicies.omni.sidero.dev` — access policies.
* `Clusters.omni.sidero.dev` — clusters.
* `MachineSets.omni.sidero.dev` — machine sets.
* `MachineSetNodes.omni.sidero.dev` — machine set nodes.
* `ConfigPatches.omni.sidero.dev` — config patches.

We also support logging access to k8s cluster using kubectl, and accessing Talos nodes directly.
