# Deploy Omni On-prem

This guide shows you how to deploy Omni on-prem. This guide assumes that Omni will be deployed on an Ubuntu machine. Small differences should be expected when using a different OS.

For SAML integration sections, this guide assumes Azure AD will be the provider for SAML.

<mark style="color:red;">Omni is available via a</mark> [<mark style="color:red;">Business Source License</mark>](https://github.com/siderolabs/omni/blob/main/LICENSE) <mark style="color:red;">which allows free installations in non-production environments. If you would like to deploy Omni for production use please contact</mark> [<mark style="color:red;">Sidero sales</mark>](mailto:sales@siderolabs.com?subject=Omni%20license%20inquiry\&body=Hello,%20I%20would%20like%20to%20purchase%20an%20on-prem%20license%20for%20Omni.)<mark style="color:red;">. If you would like to subscribe to the hosted version of Omni please see the</mark> [<mark style="color:red;">SaaS pricing</mark>](https://www.siderolabs.com/pricing/)<mark style="color:red;">.</mark>&#x20;

### Prereqs

There are several prerequisites for deploying Omni on-prem.

#### Install Docker

Install Docker according to the Ubuntu installation guide [here](https://docs.docker.com/engine/install/ubuntu/).

#### Generate Certs

On-prem Omni will require valid SSL certific



ates. This means that self-signed certs _will not_ work as of the time of this writing. Generating certificates is left as an exercise to the user, but here is a rough example that was tested using [DigitalOcean's DNS integration](https://certbot-dns-digitalocean.readthedocs.io/en/stable/) with certbot to generate certificates. The process should be very similar for other providers like Route53.

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

### Configure Authentication

#### Auth0

First, you will need an Auth0 account.

On the account level, configure "Authentication - Social" to allow GitHub and Google login.

Create an Auth0 application of the type "single page web application".

Configure the Auth0 application with the following:

* Allowed callback URLs: `https://<domain name for onprem omni>`
* Allowed web origins: `https://<domain name for onprem omni>`
* Allowed logout URLs: `https://<domain name for onprem omni>`

Disable username/password auth on "Authentication - Database - Applications" tab.

Enable GitHub and Google login on the "Authentication - Social" tab.

Enable email access in the GitHub settings.

Take note of the following information from the Auth0 application:

* Domain
* Client ID

#### SAML Identity Providers

* [EntraID/Azure AD](../using-saml-with-omni/how-to-configure-entraid-for-omni.md)
* [Keycloak](\_index.md)
* [Okta](../using-saml-with-omni/configure-okta-for-omni.md)
* [Workspace ONE Access](../using-saml-with-omni/configure-workspace-one-access-for-omni.md)
* [Unifi Identity Enterprise](../using-saml-with-omni/configure-unifi-identity-enterprise-for-omni.md)

### Create Etcd Encryption Key

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

**Note:** Do not add passphrases to keys during creation.

### Generate UUID

It is important to generate a unique ID for this Omni deployment. It will also be necessary to use this same UUID each time you "docker run" your Omni instance.

Generate a UUID with:

```bash
export OMNI_ACCOUNT_UUID=$(uuidgen)
```

### Deploy Omni

There are two easy ways to run Omni: docker-compose and a simple `docker run`. We recommend using docker-compose, but both are detailed in separate tabs below.

{% tabs %}
{% tab title="Docker Compose" %}
#### Download Assets

To pull down the Omni deployment assets for Docker Compose, simply grab them with curl as follows. Substitute the Omni version as desired.

{% code fullWidth="true" %}
```
export OMNI_VERSION=0.41.0

curl https://raw.githubusercontent.com/siderolabs/omni/v${OMNI_VERSION}/deploy/env.template -o env.template

curl https://raw.githubusercontent.com/siderolabs/omni/v${OMNI_VERSION}/deploy/compose.yaml -o compose.yaml
```
{% endcode %}

#### Customize Template

Open `env.template` for editing and update any fields that are formatted like `<xyz>`. These fields should include things like the desired Omni version, your generated UUID, paths to certs, and etcd information.

Also of important note, you should edit the `Authentication` section to either update the default Auth0 information, or comment it out and uncomment the SAML auth block to use the SAML integration.

#### Run It!

With your environment file in hand, it's now time to run Omni. This can be done with a simple docker-compose command:

```
docker compose --env-file env.template up -d
```
{% endtab %}

{% tab title="Docker Run" %}
Deploying with a `docker run` is quite straight forward, with only some slight differences depending on the auth mechanism in use.

#### Auth0

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

**Note:** The `siderolink-wireguard-advertised-addr` **must** point to an IP, not the domain name.

**Note:** you can omit the `--cert`, `--key`, `--siderolink-api-cert`, and `--siderolink-api-key` flags to run Omni insecurely.

Configuration options are available in the help menu (`--help`).

#### SAML

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

**Note**

In a default setup, the first user that logs in via SAML will be the “admin”. All subsequent users will receive a read-only role and may need to be granted additional access by the admin user from the “Users” tab in Omni.

**Note**

The `siderolink-wireguard-advertised-addr` **must** point to an IP, not the domain name.

**Note**

Note that you can omit the `--cert`, `--key`, `--siderolink-api-cert`, and `--siderolink-api-key` flags to run Omni insecurely.

Configuration options are available in the help menu (`--help`).


{% endtab %}
{% endtabs %}
