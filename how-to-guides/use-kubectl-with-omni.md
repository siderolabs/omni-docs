# Use Kubectl With Omni

With an Omni managed cluster, you use `kubectl` as with any other Kubernetes cluster, with the caveat that you must use the `kubeconfig` file that you download from Omni, and have the OIDC plug-in installed for your `kubectl`.

All Kubernetes `kubectl` commands are routed through the API endpoint created by Omni, and Omni validates access through the configured OIDC provider or other user authorization mechanism. This ensures your Kubernetes cluster is safe - unlike other systems, mere possession of a `kubeconfig` grants no access - the user also has be valid in the configured authentication system of Omni.

#### Download the KubeConfig file <a href="#download-the-kubeconfig-file" id="download-the-kubeconfig-file"></a>

Navigate to the clusters page by clicking on the “Clusters” button in the sidebar.

Click on the cluster and then click "Download  kubeconfig" from the cluster dashboard on the right. The downloaded file will reflect the name of the cluster.

#### Install the OIDC plug in <a href="#install-the-oidc-plug-in" id="install-the-oidc-plug-in"></a>

Install the `oidc-login` plugin per the official documentation: [https://github.com/int128/kubelogin#getting-started](https://github.com/int128/kubelogin#getting-started)

#### Access the cluster with kubectl <a href="#access-the-cluster-with-kubectl" id="access-the-cluster-with-kubectl"></a>

```
kubectl --kubeconfig ./talos-default-kubeconfig.yaml get nodes
```

Be sure you use the name of the downloaded kubeconfig file, which will vary with the name of the cluster.

The first time you use the `kubectl` command to query a cluster, a browser window will open requiring you to authenticate with your identity provider.

> If you get a message `error: unknown command "oidc-login" for "kubectl" Unable to connect to the server` then you need to install the oidc-login plugin as noted above, and ensure it is in your $PATH.

{% hint style="info" %}
Authentication for `omnictl`, `talosctl`, and `kubectl`will last for 8 hours. After 8 hours you will need to re-authenticate each tool for your environment.
{% endhint %}



### OIDC authentication over SSH <a href="#oidc-authentication-over-ssh" id="oidc-authentication-over-ssh"></a>

If you need to use `kubectl`, `talosctl`, or `omnictl` on a remote host over SSH you may need a way to forward your local client traffic to the remote host where `kubectl-oidc_login` is installed.

To do that you can tunnel the ports over SSH when you connect to the host. This command will open a tunnel using the default ports `oidc-login` attempts to use.

```
ssh -L 8000:localhost:8000 -L 18000:localhost:18000 $HOST
```

You can run this in a separate terminal temporarily while you authenticate your CLI tools.

If you want to have the port forwarding happen automatically every time you connect to the host you should update your \~/.ssh/config file to contain the following lines for the host.

```
Host myhost
  LocalForward 8000 127.0.0.1:8000
  LocalForward 18000 127.0.0.1:18000
```

You will also need to disable automatic browser opening because it will likely try to open a browser on the SSH host or fail to open if one is not installed. Do that by adding `--skip-open-browser` in your $KUBECONFIG file.

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
