---
description: Reference documentation for ACLs.
---

# Access Policies (ACLs)

ACLs are used to control fine-grained access policies of users to resources; and are validated, stored, and evaluated as an `AccessPolicy` resource in Omni.

At the moment, only Kubernetes cluster access (group impersonation) is supported.

### Structure

#### `AccessPolicy`

The `AccessPolicy` is a single resource containing a set of user groups, a set of cluster groups, a list of matching rules and a list of tests.

```yaml
metadata:
  namespace: default
  type: AccessPolicies.omni.sidero.dev
  id: access-policy
spec:
  usergroups:
    # match level-1 users by fnmatch expression
    level-1:
      users:
        - match: level-1*
    # match level-2 users by label selectors
    level-2:
      users:
        - labelselectors:
            - level=2
    # match level-3 users by explicit list
    level-3:
      users:
        - name: admin1@example.com
        - name: admin2@example.com
  clustergroups:
    dev:
      clusters:
        - match: dev-*
    staging:
      clusters:
        - match: staging-*
        - match: preprod-*
    production:
      clusters:
        - match: prod-*
  rules:
    - users:
        - group/level-1
      clusters:
        - group/dev
      role: Operator
    - users:
        - group/level-1
      clusters:
        - group/staging
      role: Reader
      kubernetes:
        impersonate:
          groups:
            - read-only
    - users:
        - group/level-2
      clusters:
        - group/dev
        - group/staging
      role: Operator
    - users:
        - group/level-2
      clusters:
        - group/production
      role: Reader
      kubernetes:
        impersonate:
          groups:
            - read-only
    - users:
        - group/level-3
      clusters:
        - group/dev
        - group/staging
        - group/production
      role: Admin
    # simple rule - without links to user or cluster groups
    - users:
        - vault-admin@example.com
      clusters:
        - vault
      role: Admin
  tests:
    # level-1 tests
    - name: level-1 engineer has Operator access to dev cluster
      user:
        name: level-1-a@example.com
      cluster:
        name: dev-cluster-1
      expected:
        role: Operator
    - name: level-1 engineer has read-only access to staging cluster
      user:
        name: level-1-b@example.com
      cluster:
        name: staging-cluster-1
      expected:
        role: Reader
        kubernetes:
          impersonate:
            groups:
              - read-only
    - name: level-1 engineer has no access to production cluster
      user:
        name: level-1-c@example.com
      cluster:
        name: production-cluster-1
      expected:
        role: None
        kubernetes:
          impersonate:
            groups: []
    # level-2 tests
    - name: level-2 engineer has Operator access to staging cluster
      user:
        name: something@example.com
        labels:
          level: "2"
      cluster:
        name: preprod-cluster-1
      expected:
        role: Operator
    - name: level-2 engineer has read-only access to prod cluster
      user:
        name: something@example.com
        labels:
          level: "2"
      cluster:
        name: prod-cluster-1
      expected:
        role: Reader
        kubernetes:
          impersonate:
            groups:
              - read-only
    # level-3 tests
    - name: level-3 engineer has admin access to prod cluster
      user:
        name: admin1@example.com
      cluster:
        name: prod-cluster-1
      expected:
        role: Admin
    # vault-admin tests
    - name: vault-admin has admin access to vault
      user:
        name: vault-admin@example.com
      cluster:
        name: vault
      expected:
        role: Admin
```

| Field                | Type                                             | Description                                                                   |
| -------------------- | ------------------------------------------------ | ----------------------------------------------------------------------------- |
| `metadata.namespace` | string                                           | Always set to `default`.                                                      |
| `metadata.type`      | string                                           | `AccessPolicies.omni.sidero.dev`.                                             |
| `metadata.id`        | string                                           | Always set to `access-policy`.                                                |
| `spec.usergroups`    | map\[string][UserGroup](acls.md#usergroup)       | Map of user group names to user group definitions.                            |
| `spec.clustergroups` | map\[string][ClusterGroup](acls.md#clustergroup) | Map of cluster group names to cluster group definitions.                      |
| `spec.rules`         | array                                            | List of [rules](acls.md#rule) to match.                                       |
| `spec.tests`         | array                                            | List of [tests](acls.md#test) to run when the resource is created or updated. |

#### `UserGroup`

A `UserGroup` is a group of users.

```yaml
users:
  - name: user1@example.com
  - name: user2@example.com
```

| Field   | Type  | Description                    |
| ------- | ----- | ------------------------------ |
| `users` | array | List of [User](acls.md#user)s. |

#### `User`

A `User` is a single user.

```yaml
name: user1@example.com
match: user1*
labelselectors:
  - level=1
```

| Field            | Type   | Description                                                                                          |
| ---------------- | ------ | ---------------------------------------------------------------------------------------------------- |
| `name`           | string | User identity used to authenticate to Omni.                                                          |
| `match`          | string | [fnmatch](https://man7.org/linux/man-pages/man3/fnmatch.3.html) expression to match user identities. |
| `labelselectors` | array  | List of label selector strings.                                                                      |

**Note:** `name`, `match` and `labelselectors` are mutually exclusive. Only one of them can be set to a non-zero value.

#### `ClusterGroup`

A `ClusterGroup` is a group of clusters.

```yaml
clusters:
  - name: cluster-1
  - name: cluster-2
```

| Field      | Type  | Description                          |
| ---------- | ----- | ------------------------------------ |
| `clusters` | array | List of [Cluster](acls.md#cluster)s. |

#### `Cluster`

A `Cluster` is a single cluster.

```yaml
name: cluster-1
match: cluster-1*
```

| Field   | Type                                                                                                     | Description        |
| ------- | -------------------------------------------------------------------------------------------------------- | ------------------ |
| `name`  | string                                                                                                   | Cluster name (ID). |
| `match` | [fnmatch](https://man7.org/linux/man-pages/man3/fnmatch.3.html) expression to match cluster names (IDs). |                    |

**Note:** `name` and `match` are mutually exclusive. Only one of them can be set to a non-zero value.

#### `Rule`

A `Rule` is a set of users, clusters and Kubernetes impersonation groups.

The reserved prefix `group/` is used to reference a user group in `users` or a cluster group in `clusters`.

```yaml
users:
  - user1@example.com
  - group/user-group-1
clusters:
  - cluster1
  - group/cluster-group-1
role: Operator
kubernetes:
  impersonate:
    groups:
      - system:masters
      - another-impersonation-group
```

| Field                           | Type  | Description                                                                   |
| ------------------------------- | ----- | ----------------------------------------------------------------------------- |
| `users`                         | array | List of [User](acls.md#user)s or [UserGroup](acls.md#usergroup)s.             |
| `clusters`                      | array | List of [Cluster](acls.md#cluster)s or [ClusterGroup](acls.md#clustergroup)s. |
| `role`                          | enum  | [Role](acls.md#role) to grant to the user.                                    |
| `kubernetes.impersonate.groups` | array | List of `string`s representing Kubernetes impersonation groups.               |

#### `Role`

A `Role` is the role to grant to the user.

Possible values: `None`, `Reader`, `Operator`, `Admin`.

#### `Test`

A `Test` is a single test case.

Test cases are run when the resource is created or updated, and if any of them fail, the operation is rejected.

```yaml
name: support engineer has full access to staging cluster
user:
  name: support1@example.com
cluster:
  name: staging-cluster-1
expected:
  role: Operator
  kubernetes:
    impersonate:
      groups:
        - system:masters
```

| Field      | Type                               | Description                       |
| ---------- | ---------------------------------- | --------------------------------- |
| `name`     | string                             | Human-friendly test case name.    |
| `user`     | [TestUser](acls.md#testuser)       | User identity to use in the test. |
| `cluster`  | [TestCluster](acls.md#testcluster) | Cluster to use in the test.       |
| `expected` | [Expected](acls.md#expected)       | Expected result.                  |

#### `TestUser`

A `TestUser` is the user identity to use in a test case.

```yaml
name: user1@example.com
labels:
  level: "1"
```

| Field    | Type               | Description                         |
| -------- | ------------------ | ----------------------------------- |
| `name`   | string             | User identity to use in the test.   |
| `labels` | map\[string]string | Map of label names to label values. |

#### `TestCluster`

A `TestCluster` is the cluster to use in a test case.

```yaml
name: cluster-1
```

| Field  | Type   | Description        |
| ------ | ------ | ------------------ |
| `name` | string | Cluster name (ID). |

#### `Expected`

An `Expected` is the expected results of a test case.

```yaml
role: Operator
kubernetes:
  impersonate:
    groups:
      - system:masters
      - another-impersonation-group
```

| Field                           | Type  | Description                                                     |
| ------------------------------- | ----- | --------------------------------------------------------------- |
| `role`                          | enum  | [Role](acls.md#role) to grant to the user.                      |
| `kubernetes.impersonate.groups` | array | List of `string`s representing Kubernetes impersonation groups. |
