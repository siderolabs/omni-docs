# Using SAML and ACLs for fine-grained access control

In this tutorial we will use SAML and ACLs to control fine-grained access to Kubernetes clusters.

Let's assume that at our organization:

- We run a Keycloak instance as the SAML identity provider.
- Have our Omni instance already configured to use Keycloak as the SAML identity provider.
- Our Omni instance has 2 types of clusters:
  - Staging clusters with the name prefix `staging-`: `staging-1`, `staging-2`, etc.
  - Production clusters with the name prefix `prod-`: `prod-1`, `prod-2`, etc.
- We want the users with the SAML role `omni-cluster-admin` to have full access to all clusters.
- We want the users with the SAML role `omni-cluster-support` to have full access to staging clusters and read-only access to production clusters.

## Sign in as the initial SAML User

If our Omni instance has no users yet, the initial user who signs in via SAML will be automatically assigned to the Omni `Admin` role.

We sign in as the user `admin@example.org` and get the Omni `Admin` role.

## Configuring the AccessPolicy

We need to configure the ACL to assign the `omni-cluster-support` role to the users with the SAML role `omni-cluster-support` and
the `omni-cluster-admin` role to the users with the SAML role `omni-cluster-admin`.

Create the following YAML file `acl.yaml`:

```yaml
metadata:
  namespace: default
  type: AccessPolicies.omni.sidero.dev
  id: access-policy
spec:
  usergroups:
    support:
      users:
        - labelselectors:
            - saml.omni.sidero.dev/role/omni-cluster-support=
    admin:
      users:
        - labelselectors:
            - saml.omni.sidero.dev/role/omni-cluster-admin=
  clustergroups:
    staging:
      clusters:
        - match: staging-*
    production:
      clusters:
        - match: prod-*
    all:
      clusters:
        - match: "*"
  rules:
    - users:
        - group/support
      clusters:
        - group/staging
      role: Operator
    - users:
        - group/support
      clusters:
        - group/production
      role: Reader
      kubernetes:
        impersonate:
          groups:
            - read-only
    - users:
        - group/admin
      clusters:
        - group/all
      role: Operator
  tests:
    - name: support engineer has Operator access to staging cluster
      user:
        name: support-eng@example.org
        labels:
          saml.omni.sidero.dev/role/omni-cluster-support: ""
      cluster:
        name: staging-1
      expected:
        role: Operator
    - name: support engineer has Reader access to prod cluster and impersonates read-only group
      user:
        name: support-eng@example.org
        labels:
          saml.omni.sidero.dev/role/omni-cluster-support: ""
      cluster:
        name: prod-1
      expected:
        role: Reader
        kubernetes:
          impersonate:
            groups:
              - read-only
    - name: admin has Operator access to staging cluster
      user:
        name: admin-1@example.org
        labels:
          saml.omni.sidero.dev/role/omni-cluster-admin: ""
      cluster:
        name: staging-1
      expected:
        role: Operator
    - name: admin has Operator access to prod cluster
      user:
        name: admin-1@example.org
        labels:
          saml.omni.sidero.dev/role/omni-cluster-admin: ""
      cluster:
        name: prod-1
      expected:
        role: Operator
```

As the admin user `admin@example.org`, apply this ACL using omnictl:

```bash
$ omnictl apply -f acl.yaml
```

## Accessing the Clusters

Now, in an incognito window, log in as a support engineer, `cluster-support-1@example.org`.
Since the user is not assigned to any Omni role yet, they cannot use Omni Web.

Download `omnictl` and `omniconfig` from the UI, and try to list the clusters by using it:
```bash
$ omnictl --omniconfig ./support-omniconfig.yaml get cluster
NAMESPACE   TYPE   ID   VERSION
Error: rpc error: code = PermissionDenied desc = failed to validate: 1 error occurred:
	* rpc error: code = PermissionDenied desc = unauthorized: access denied: insufficient role: "None"
```

You won't be able to list the clusters because the user is not assigned to any Omni role.

Now try to get the cluster `staging-1`:
```bash
$ omnictl --omniconfig ./support-omniconfig.yaml get cluster staging-1
NAMESPACE   TYPE      ID          VERSION
default     Cluster   staging-1   5
```

You can get the cluster `staging-1` because the ACL allows the user to access the cluster.

Finally, try to delete the cluster `staging-1`:
```bash
$ omnictl --omniconfig ./support-omniconfig.yaml delete cluster staging-1
torn down Clusters.omni.sidero.dev staging-1
destroyed Clusters.omni.sidero.dev staging-1
```

The operation will succeed, because the ACL allows `Operator`-level access to the cluster for the user.

Try to do the same operations with the cluster `prod-1`:
```bash
$ omnictl --omniconfig ./support-omniconfig.yaml get cluster prod-1
NAMESPACE   TYPE      ID          VERSION
default     Cluster   prod-1   5

$ omnictl --omniconfig ./support-omniconfig.yaml delete cluster prod-1
Error: rpc error: code = PermissionDenied desc = failed to validate: 1 error occurred:
	* rpc error: code = PermissionDenied desc = unauthorized: access denied: insufficient role: "Reader"
```

The user will be able to get the cluster but not delete it, because the ACL allows only `Reader`-level access to the cluster for the user.

If you do the same operations as the admin user, you'll notice that you are able to both get and delete staging and production clusters.

## Assigning Omni roles to Users

If you want to allow SAML users to use Omni Web, you need to assign them at least the `Reader` role.
As the admin, sign in to Omni Web and assign the role `Reader` to both `cluster-support-1@example.org` and `cluster-admin-1@example.org`.

Now, as the support engineer, you can sign out & sign in again to Omni Web and see the clusters `staging-1` and `prod-1` in the UI.
