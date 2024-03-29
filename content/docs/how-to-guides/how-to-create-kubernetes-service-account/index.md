---
title: "Create a Service Account Kubeconfig"
description: "A guide on how to create a service account kubeconfig in Omni."
date: 2023-02-24T00:00:00Z
draft: false
weight: 40
---

This guide shows you how to create a service account kubeconfig in Omni.

You need `omnictl` installed and configured to follow this guide.
If you haven't done so already, follow the [`omnictl` guide](../how-to-install-and-configure-omnictl).

You also need to have a cluster created in Omni to follow this guide.

## Creating the Service Account Kubeconfig

To create a service account kubeconfig, run the following command:

```bash
omnictl kubeconfig --service-account -c <cluster> --user <user> <path to kubeconfig>
```

{{% alert title="Note" color="info" %}}
Replace `<path to kubeconfig>` with a path where the kubeconfig file should be written.
Replace `<cluster>` with the name of the cluster in Omni.
Replace `<user>` with any value you would like.
{{% /alert %}}

This command will create a service account token with the given username and obtain a kubeconfig file for the given cluster and username.

You can now use `kubectl` with the generated kubeconfig.
