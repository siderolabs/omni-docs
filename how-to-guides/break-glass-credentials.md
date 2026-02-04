---
description: Break-Glass Credentials
---

# Usage of Break-Glass (Emergency) Credentials

> [!WARNING]  
> **NOT RECOMMENDED — THIS ACTION BYPASSES ALL SECURITY CONTROLS IMPLEMENTED BY OMNI**

This guide explains how to use *break-glass* credentials to directly access the **Talos API** and **Kubernetes API Server** without Omni.
These credentials should only be used in emergency situations where normal access paths are unavailable (e.g. authentication provider failure, Omni outage, network outage).

---

## Considerations

When break-glass credentials are enabled, both the Talos API and Kubernetes API are exposed directly on Talos machines.
Generated credentials are **certificate-based** and **cannot be revoked** without performing a **CA rotation** of the entire cluster.

Use break-glass credentials only as a last resort.

---

## Prerequisites

To enable break-glass credentials, Omni must be explicitly configured with the `--enable-break-glass-configs` flag.

- For **self-managed deployments**, this flag must be set on the Omni instance itself.
- For **SaaS customers**, contact **SideroLabs Support** to request break-glass credentials.

---

## Usage

Break-glass configurations for both **Kubernetes** and **Talos** can be created by using the `--break-glass` flag on the `omnictl` command:

```bash
# Retrieve privileged kubeconfig
$ omnictl kubeconfig --break-glass --cluster <id>

# Retrieve privileged talosconfig
$ omnictl talosconfig --break-glass --cluster <id>
```

For successfully connecting to the cluster with break-glass credentials , **network connectivity to Talos machines is required** on port `50000/tcp` for the Talos API and port `6443/tcp` for the Kubernetes API.
