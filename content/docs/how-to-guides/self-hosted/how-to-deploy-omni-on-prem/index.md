---
title: "Deploy Omni On-prem"
date: 2022-11-17T13:06:13-08:00
draft: false
weight: 200
aliases:
  - ../how-to-deploy-omni-on-prem/
---

This guide shows you how to deploy Omni on-prem.
This guide assumes that Omni will be deployed on an Ubuntu machine.
Small differences should be expected when using a different OS.

For SAML integration sections, this guide assumes Azure AD will be the provider for SAML.

{{% alert title="Note" color="info" %}}
Omni is available via a [Business Source License](https://github.com/siderolabs/omni/blob/main/LICENSE) which allows free installations in non-production environments.
If you would like to deploy Omni for production use please contact [Sidero sales](mailto:sales@siderolabs.com?subject=Omni%20license%20inquiry&body=Hello,%20I%20would%20like%20to%20purchase%20an%20on-prem%20license%20for%20Omni.).
If you would like to subscribe to the hosted version of Omni please see the [SaaS pricing](https://www.siderolabs.com/pricing/).
{{% /alert %}}

## Prereqs

There are several prerequisites for deploying Omni on-prem.

### Install Docker

Install Docker according to the Ubuntu installation guide [here](https://docs.docker.com/engine/install/ubuntu/).

### Generate Certs

On-prem Omni will require valid SSL certificates.
This means that self-signed certs _will not_ work as of the time of this writing.
Generating certificates is left as an exercise to the user, but here is a rough example that was tested using [DigitalOcean's DNS integration](https://certbot-dns-digitalocean.readthedocs.io/en/stable/) with certbot to generate certificates.
The process should be very similar for other providers like Route53.

```bash
# Install certbot
$ sudo snap install --classic certbot

# Allow for root access
$ sudo snap set certbot trust-plugin-with-root=ok

# Install DNS provider
$ snap install certbot-dns-<provider>

# Create creds file with API tokens
$ echo '<creds example' > creds.ini

# Create certs for desired domain
$ certbot certonly --dns-<provider> -d <domain name for onprem omni>
```

## Configure Authentication

### Auth0

First, you will need an Auth0 account.

On the account level, configure "Authentication - Social" to allow GitHub and Google login.

Create an Auth0 application of the type "single page web application".

Configure the Auth0 application with the following:

- Allowed callback URLs: `https://<domain name for onprem omni>`
- Allowed web origins: `https://<domain name for onprem omni>`
- Allowed logout URLs: `https://<domain name for onprem omni>`

Disable username/password auth on "Authentication - Database - Applications" tab.

Enable GitHub and Google login on the "Authentication - Social" tab.

Enable email access in the GitHub settings.

Take note of the following information from the Auth0 application:

- Domain
- Client ID

### SAML Identity Providers

- [EntraID/Azure AD](../how-to-configure-entraid-for-omni)
- [Keycloak](../how-to-configure-keycloak-for-omni)
- [Okta](../how-to-configure-okta-for-omni)
- [Workspace ONE Access](../../saml-and-omni/how-to-configure-wsoa-for-omni)

## Create Etcd Encryption Key

Generate a GPG key:

```bash
gpg --quick-generate-key "Omni (Used for etcd data encryption) how-to-guide@siderolabs.com" rsa4096 cert never
```

Find the fingerprint of the generated key:

```bash
gpg --list-secret-keys
```

Using the fingerprint, add an encryption subkey and export:

```bash
gpg --quick-add-key <fingerprint> rsa4096 encr never
gpg --export-secret-key --armor how-to-guide@siderolabs.com > omni.asc
```

{{% alert title="Note" color="info" %}}
Do not add passphrases to keys during creation.
{{% /alert %}}

## Generate UUID

It is important to generate a unique ID for this Omni deployment.
It will also be necessary to use this same UUID each time you "docker run" your Omni instance.

Generate a UUID with:

```bash
export OMNI_ACCOUNT_UUID=$(uuidgen)
```

## Deploy Omni

Running Omni is a simple `docker run`, with some slight differences in flags for Auth0 vs. SAML authentication.

### Auth0

```bash
docker run \
  --net=host \
  --cap-add=NET_ADMIN \
  -v $PWD/etcd:/_out/etcd \
  -v <path to TLS certificate>:/tls.crt \
  -v <path to TLS key>:/tls.key \
  -v $PWD/omni.asc:/omni.asc \
  ghcr.io/siderolabs/omni:<tag> \
    --account-id=${OMNI_ACCOUNT_UUID} \
    --name=onprem-omni \
    --cert=/tls.crt \
    --key=/tls.key \
    --siderolink-api-cert=/tls.crt \
    --siderolink-api-key=/tls.key \
    --private-key-source=file:///omni.asc \
    --event-sink-port=8091 \
    --bind-addr=0.0.0.0:443 \
    --siderolink-api-bind-addr=0.0.0.0:8090 \
    --k8s-proxy-bind-addr=0.0.0.0:8100 \
    --advertised-api-url=https://<domain name for onprem omni>/ \
    --siderolink-api-advertised-url=https://<domain name for onprem omni>:8090/ \
    --siderolink-wireguard-advertised-addr=<ip address of the host running Omni>:50180 \
    --advertised-kubernetes-proxy-url=https://<domain name for onprem omni>:8100/ \
    --auth-auth0-enabled=true \
    --auth-auth0-domain=<Auth0 domain> \
    --auth-auth0-client-id=<Auth0 client ID> \
    --initial-users=<email address>
```

{{% alert title="Note" color="info" %}}
The `siderolink-wireguard-advertised-addr` **must** point to an IP, not the domain name.
{{% /alert %}}

{{% alert title="Note" color="info" %}}
Note that you can omit the `--cert`, `--key`, `--siderolink-api-cert`, and `--siderolink-api-key` flags to run Omni insecurely.
{{% /alert %}}

Configuration options are available in the help menu (`--help`).

### SAML

```bash
docker run \
  --net=host \
  --cap-add=NET_ADMIN \
  -v $PWD/etcd:/_out/etcd \
  -v <path to full chain TLS certificate>:/tls.crt \
  -v <path to TLS key>:/tls.key \
  -v $PWD/omni.asc:/omni.asc \
  ghcr.io/siderolabs/omni:<tag> \
    --account-id=${OMNI_ACCOUNT_UUID} \
    --name=onprem-omni \
    --cert=/tls.crt \
    --key=/tls.key \
    --siderolink-api-cert=/tls.crt \
    --siderolink-api-key=/tls.key \
    --private-key-source=file:///omni.asc \
    --event-sink-port=8091 \
    --bind-addr=0.0.0.0:443 \
    --siderolink-api-bind-addr=0.0.0.0:8090 \
    --k8s-proxy-bind-addr=0.0.0.0:8100 \
    --advertised-api-url=https://<domain name for onprem omni>/ \
    --siderolink-api-advertised-url=https://<domain name for onprem omni>:8090/ \
    --siderolink-wireguard-advertised-addr=<ip address of the host running Omni>:50180 \
    --advertised-kubernetes-proxy-url=https://<domain name for onprem omni>:8100/ \
    --auth-saml-enabled=true \
    --auth-saml-url=<app federation metadata url copied during Azure AD setup>
```

{{% alert title="Note" color="info" %}}
In a default setup, the first user that logs in via SAML will be the "admin".
All subsequent users will receive a read-only role and may need to be granted additional access by the admin user from the "Users" tab in Omni.
{{% /alert %}}

{{% alert title="Note" color="info" %}}
The `siderolink-wireguard-advertised-addr` **must** point to an IP, not the domain name.
{{% /alert %}}

{{% alert title="Note" color="info" %}}
Note that you can omit the `--cert`, `--key`, `--siderolink-api-cert`, and `--siderolink-api-key` flags to run Omni insecurely.
{{% /alert %}}

Configuration options are available in the help menu (`--help`).
