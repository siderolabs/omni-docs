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

### Switching between users when authenticating to the same cluster

If you have multiple contexts in your kubeconfig(s) authenticating to the same cluster (in the same Omni instance), switching between these contexts does not switch the authenticated user. This is a [known limitation](https://github.com/int128/kubelogin/issues/29) of the OIDC-based login we use - it uses the existing logged-in user, as their auth token is the already cached for that cluster.

To work around that, when you want to switch to another user, you need to clear the authentication cache first. To do this, run one of the following:

```bash
kubectl oidc-login clean # OR
rm -rf "${KUBECACHEDIR:-$HOME/.kube/cache}/oidc-login"
```

After doing this, the next `kubectl` command you run should trigger the OIDC login flow again, where you can authenticate as the user you need via `Switch User` option.

### OIDC authentication over SSH <a href="#oidc-authentication-over-ssh" id="oidc-authentication-over-ssh"></a>

If you need to use `kubectl` on a remote host over SSH you have two options.

#### Download `kubeconfig` with `--grant-type=authcode-keyboard`

To get started, you first need to download both **omnictl** and **omniconfig**. Once installed, you can use `omnictl` to download the configuration with the following command:

```
omnictl kubeconfig --cluster <name> --grant-type=authcode-keyboard
```

By default, the configuration will be merged with the file specified in the `KUBECONFIG` environment variable.

When using this configuration, the process will not attempt to open a browser automatically. Instead, it will present you with a URL and prompt you to enter a one-time code:

```
Please visit the following URL in your browser: https://<redacted>
Enter code:
```

Opening the link will take you to the Omni login page. After signing in, you will be provided with a code that you can copy and paste into the terminal.

#### Download the regular `kubeconfig` and do port-forwarding

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
