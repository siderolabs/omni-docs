---
title: "Use Kubectl With Omni"
date: 2022-11-17T10:14:18-08:00
draft: false
weight: 90
---

This guide shows you how to use `kubectl` with an Omni-managed cluster.

Navigate to the clusters page by clicking on the "Clusters" button in the sidebar.

{{< imgproc 1.png Resize "900x" >}}
{{< /imgproc >}}

Click the three dots in the cluster's item to access the options menu.

{{< imgproc 2.png Resize "900x" >}}
{{< /imgproc >}}

Click "Download kubeconfig".

{{< imgproc 3.png Resize "900x" >}}
{{< /imgproc >}}

Alternatively you can click on the cluster and download the `kubeconfig` from the cluster dashboard.

{{< imgproc 4.png Resize "900x" >}}
{{< /imgproc >}}

Install the `oidc-login` plugin per the official documentation: https://github.com/int128/kubelogin.

## OIDC authentication over SSH
If you need to use `kubectl`, `talosctl`, or `omnictl` on a remote host over SSH you may need a way to forward your local client traffic to the remote host where `kubectl-oidc_login` is installed.

To do that you can tunnel the ports over SSH when you connect to the host.
This command will open a tunnel using the default ports `oidc-login` attempts to use.

```
ssh -L 8000:localhost:8000 -L 18000:localhost:18000 $HOST
```
You can run this in a separate terminal temporarily while you authenticate your CLI tools.

If you want to have the port forwarding happen automatically every time you connect to the host you should update your ~/.ssh/config file to contain the following lines for the host.

```
Host myhost
  LocalForward 8000 127.0.0.1:8000
  LocalForward 18000 127.0.0.1:18000
```
You will also need to disable automatic browser opening because it will likely try to open a browser on the SSH host or fail to open if one is not installed.
Do that by adding `--skip-open-browser` in your $KUBECONFIG file.

```
      args:
        - oidc-login
        - get-token
        - --oidc-issuer-url=https://$YOUR_ENDPOINT.omni.siderolabs.io/oidc
        - --oidc-client-id=native
        - --oidc-extra-scope=cluster:not-eks
        - --skip-open-browser
      command: kubectl
      env: null
```
