---
description: A guide on how to install talosctl.
---

# Install talosctl

This guide shows you how to install `talosctl`.

Run the following:

```
curl -sL https://talos.dev/install | sh
```

You now have `talosctl` installed.

> Please note that because Omni manages the state of the Talos nodes, and protects the security of the Kubernetes and Talos credentials, some `talosctl` commands (such as `talosctl reset`) will return `PermissionDenied` on Omni managed clusters - such operations must be done through the Omni UI or API calls.
