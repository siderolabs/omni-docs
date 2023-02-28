---
title: How to Install and Configure Omnictl
description: "A guide on installing and configuring `omnictl` for Omni."
date: 2023-01-30T00:00:00Z
draft: false
weight: 125
---

This guide shows you how to install and configure `omnictl`.

Download `omnictl` and `omniconfig` from the Omni dashboard.

{{< imgproc 1.png Resize "900x" >}}
{{< /imgproc >}}

{{% alert title="Note" color="info" %}}
The downloaded binary will be named according the the selected platform and architecture (e.g. `omnictl-linux-amd64`).
It is left as an exercise to the user to move the downloaded binary into your `PATH` and make it executable.
This guide assumes the downloaded binary is named `omnictl`.
{{% /alert %}}

Add the downloaded `omniconfig.yaml` to the default location to use it with `omnictl`:

```bash
omnictl config merge ./omniconfig.yaml
```

List the contexts to verify that the `omniconfig` was added:

```bash
$ omnictl config contexts
CURRENT   NAME         URL
          ...
          example      https://example.omni.siderolabs.io/
          ...
```

Run `omnictl` for the first time to perform initial authentication using a web browser:

```bash
omnictl get clusters
```

If the browser window does not open automatically, it can be opened manually by copying and pasting the URL into a web browser:

```bash
BROWSER=echo omnictl get clusters
```
