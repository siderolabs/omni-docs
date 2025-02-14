---
description: A guide on installing and configuring `omnictl` for Omni.
---

# Install and Configure Omnictl

### Recommended installation

To install `omnictl`and the kubectl `oidc-login`plugin automatically on macOS and Linux you can use the provided Hombrew formula.

```
brew install siderolabs/tap/sidero-tools
```

This will install `talosctl`, `omnictl`, and `kube-oidc_login`and keep them updated.

### Manual installation

Download `omnictl` and `omniconfig` from the Omni dashboard.

{% hint style="info" %}
The downloaded binary will be named according the the selected platform and architecture (e.g. `omnictl-linux-amd64`). It is left as an exercise to the user to move the downloaded binary into your `PATH` and make it executable. This guide assumes the downloaded binary has been renamed `omnictl`.

For example, to do so on a mac:

```bash
mv omnictl-darwin-arm64 omnictl
chmod +x omnictl
mv omnictl /usr/local/bin
```
{% endhint %}

Add the downloaded `omniconfig.yaml` to the default location to use it with `omnictl`:

```bash
cp omniconfig.yaml ~/.config/omni/config
```

If you would like to merge the `omniconfig.yaml` with an existing configuration, use the following command:

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

If the browser window does not open automatically, it can be opened manually by copying and pasting the URL into a web browser:Copy

```bash
BROWSER=echo omnictl get clusters
```
