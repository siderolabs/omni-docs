---
title: "How Deploy Omni On-prem"
date: 2022-11-17T13:06:13-08:00
draft: false
---

This guide shows you how to deploy Omni on-prem.

First, you will need an Auth0 account.
On the account level, configure "Authentication - Social" to allow GitHub and Google login.
Create an Auth0 application of the type "single page web application".
Configure the Auth0 application with the following:

  - Allowed callback URLs: https://localhost:8080/
  - Allowed web origins: https://localhost:8080/
  - Allowed logout URLs: https://localhost:8080/

Disable username/password auth on "Authentication - Database - Applications" tab.
Enable GitHub and Google login on the "Authentication - Social" tab.
Enable email access in the GitHub settings.
Take note of the following information from the Auth0 application:
  - Domain
  - Client ID

Generate a GPG key:

```bash
gpg --quick-generate-key "Omni (Used for etcd data encryption) how-to-guide@siderolabs.com" rsa4096 cert never
```

Find the fingerprint of the generated key:

```bash
gpg --list-secret-keys
```

```bash
gpg --quick-add-key $FPR rsa4096 encr never
gpg --export-secret-key --armor how-to-guide@siderolabs.com > omni.asc
```

Generate a TLS certificate:

A valid TLS certificate is required by Omni.
This is an excercise left up to the user.

Generate a UUID:

```bash
export OMNI_ACCOUNT_UUID=$(uuidgen)
```

Ensure that `docker` is installed on the same machine as `omni`.

Finally, run `omni`:

```bash
docker run \
  --net=host \
  --cap-add=NET_ADMIN \
  --sysctl net.ipv6.conf.all.disable_ipv6=0 \
  -v $PWD/etcd:_out/etcd \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v <path to TLS certificate>:/tls.crt \
  -v <path to TLS key>/tls.key:/tls.key \
  -v $PWD/omni.asc:/omni.asc \
  ghcr.io/siderolabs/omni:<tag> \
    --account-id=${OMNI_ACCOUNT_UUID} \
    --name=how-to-guide \
    --cert=/tls.crt \
    --key=/tls.key \
    --siderolink-api-cert=/tls.crt \
    --siderolink-api-key=/tls.key \
    --private-key-source=file:///omni.asc \
    --event-sink-port=8091 \
    --bind-addr=0.0.0.0:8080 \
    --siderolink-api-bind-addr=0.0.0.0:8090 \
    --k8s-proxy-bind-addr=0.0.0.0:8100 \
    --advertised-api-url=https://<ip address of the host running Omni>:8080/ \
    --siderolink-api-advertised-url=https://<ip address of the host running Omni>:8090/ \
    --siderolink-wireguard-advertised-addr=<ip address of the host running Omni>:50180 \
    --advertised-kubernetes-proxy-url=https://<ip address of the host running Omni>:8100/ \
    --auth-auth0-enabled=true \
    --auth-auth0-domain=<Auth0 domain> \
    --auth-auth0-client-id=<Auth0 client ID> \
    --initial-users=<email address>
```

Configuration options are available in the help menu (`--help`).

{{% alert title="Note" color="info" %}}
Note that you can omit the `--cert`, `--key`, `--siderolink-api-cert`, and `--siderolink-api-key` flags to run Omni insecurely.
{{% /alert %}}
