---
title: "How to Create an Omni Service Account"
description: "A guide on how to create an Omni service account."
date: 2023-07-03T00:00:00Z
draft: false
weight: 40
---

This guide shows you how to create an Omni service account.

You will need `omnictl` installed and configured to follow this guide.
If you haven't done so already, follow the [`omnictl` guide](../how-to-install-and-configure-omnictl).

## Creating the Service Account

To create an Omni service account, use the following command:

```bash
omnictl serviceaccount create <sa-name>
```

The output of this command will print `OMNI_ENDPOINT` and `OMNI_SERVICE_ACCOUNT_KEY`.

{{% alert title="Note" color="warnging" %}}
Store the `OMNI_SERVICE_ACCOUNT_KEY` securely as it will not be displayed again.
{{% /alert %}}

Export these variables with the printed values:

```bash
export OMNI_ENDPOINT=<output from above command>
export OMNI_SERVICE_ACCOUNT_KEY=<output from above command>
```

You can now use `omnictl` with the generated service account.
