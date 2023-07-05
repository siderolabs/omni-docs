---
title: "Installing Airgapped Omni"
description: "A tutorial on installing Omni in an airgapped environment."
date: 2022-10-30T15:50:38-07:00
draft: false
weight: 10
---

## Prerequisites

DNS server
NTP server
TLS certificates
Installed on machine running Omni
- genuuid
    - Used to generate a unique account ID for Omni.
- Docker
    - Used for running the suite of applications
- Wireguard
    - Used by Siderolink

## Overview

- [Gathering Dependencies](#gathering-dependencies)
    - [Generate Certificates](#generate-certificates)
    - [Create app.ini file](#create-the-appini-file)
    - [Gathing Images](#gathering-images)
    - [Move Dependencies](#move-dependencies)
- [Gitea](#gitea)
    - [Install Gitea](#install-gitea)
    - [Gitea Setup](#gitea-setup)
    - [Push Images to Gitea](#push-images-to-gitea)
- [Keycloak](#keycloak)
    - [Start Keycloak](#start-keycloak)
    - [Configuring Keycloak](#configuring-keycloak)
- [Omni](#omni)
    - [Install Omni](#install-omni)


## Gathering Dependencies

In this package, we will be installing:
- Gitea
- Keycloak
- Omni

To keep everything organized, I am using the following directory structure to store all the dependencies and I will move them to the airgapped network all at once.

> **NOTE:** The empty directories will be used for the persistent data volumes when we deploy these apps in Docker.

```bash
airgap
├── certs
├── gitea
├── keycloak
├── omni
└── registry
```

### Generate Certificates

#### TLS Certificates

This tutorial will involve configuring all of the applications to be accessed via https with signed `.pem` certificates generated with [certbot](https://certbot.eff.org/).  There are many methods of configuring TLS certificates and this guide will not cover how to generate your own TLS certificates, but there are many resources available online to help with this subject if you do not have certificates already.

#### Omni Certificate

Omni uses etcd to store the data for our installation and we need to give it a private key to use for encryption of the etcd database.

1. First, Generate a GPG key.

```bash
gpg --quick-generate-key "Omni (Used for etcd data encryption) how-to-guide@siderolabs.com" rsa4096 cert never
```

This will generate a new GPG key pair with the specified properties.

What's going on here?
- `quick-gnerate-key` allows us to quickly generate a new GPG key pair.
-`"Omni (Used for etcd data encryption) how-to-guide@siderolabs.com"` is the user ID associated with the key which generally consists of the real name, a comment, and an email address for the user.
- `rsa4096` specifies the algorithm type and key size.
- `cert` means this key can be used to certify other keys.
- `never` specifies that this key will never expire.

2. Add an encryption subkey

We will use the fingerprint of this key to create an encryption subkey.

To find the fingerprint of the key we just created, run:

```bash
gpg --list-secret-keys
```

Next, run the following command to create the encryption subkey, replacing `$FPR` with your own keys fingerprint.

```bash
gpg --quick-add-key $FPR rsa4096 encr never
```

In this command:
- `$FPR` is the fingprint of the key we are adding the subkey to.
- `rsa4096` and `encr` specify that the new subkey will be an RSA encryption key with a size of 4096 bits.
- `never` means this subkey will never expire.

3. Export the secret key

Lastly we'll export this key into an ASCII formatted file so Omni can use it.

```bash
gpg --export-secret-key --armor how-to-guide@siderolabs.com > certs/omni.asc
```

- `--armor` is an option which creates the output in ASCII format.  Without it, the output would be binary.

Save this file to the certs directory in our package.

### Create the app.ini File

Gitea uses a configuration file named **app.ini** which we can use to pre-configure with the necessary information to run Gitea and bypass the intitial startup page.  When we start the container, we will mount this file as a volume using Docker.

Create the **app.ini** file

```bash
vim gitea/app.ini
```

Replace the `DOMAIN`, `SSH_DOMAIN`, and `ROOT_URL` values with your own hostname:

```ini
APP_NAME=Gitea: Git with a cup of tea
RUN_MODE=prod
RUN_USER=git
I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=false

[server]
CERT_FILE=cert.pem
KEY_FILE=key.pem
APP_DATA_PATH=/data/gitea
DOMAIN=${GITEA_HOSTNAME}
SSH_DOMAIN=${GITEA_HOSTNAME}
HTTP_PORT=3000
ROOT_URL=https://${GITEA_HOSTNAME}:3000/
HTTP_ADDR=0.0.0.0
PROTOCOL=https
LOCAL_ROOT_URL=https://localhost:3000/

[database]
PATH=/data/gitea/gitea.db
DB_TYPE=sqlite3
HOST=localhost:3306
NAME=gitea
USER=root
PASSWD=

[security]
INSTALL_LOCK=true # This is the value which tells Gitea not to run the intitial configuration wizard on start up
```

> **NOTE:** If running this in a production environment, you will also want to configure the database settings for a production database.  This configuration will use an internal sqlite database in the container.

### Gathering Images

Next we will gather all the images needed installing Gitea, Keycloak, Omni, **and** the images Omni will need for creating and installing Talos.

I'll be using the following images for the tutorial:

Gitea
- `docker.io/gitea/gitea:1.19.3`
Keycloak
- `quay.io/keycloak/keycloak:21.1.1`
Omni
- `ghcr.io/siderolabs/omni:v0.11.0`
    - [Contact Us](https://www.siderolabs.com/contact/) if you would like the image used to deploy Omni in an airgapped, or on-prem environement.
- `ghcr.io/siderolabs/imager:v1.4.5`
    - pull this image to match the version of Talos you would like to use.
Talos
- `ghcr.io/siderolabs/flannel:v0.21.4`
- `ghcr.io/siderolabs/install-cni:v1.4.0-1-g9b07505`
- `docker.io/coredns/coredns:1.10.1`
- `gcr.io/etcd-development/etcd:v3.5.9`
- `registry.k8s.io/kube-apiserver:v1.27.2`
- `registry.k8s.io/kube-controller-manager:v1.27.2`
- `registry.k8s.io/kube-scheduler:v1.27.2`
- `registry.k8s.io/kube-proxy:v1.27.2`
- `ghcr.io/siderolabs/kubelet:v1.27.2`
- `ghcr.io/siderolabs/installer:v1.4.5`
- `registry.k8s.io/pause:3.6`

> **NOTE**: The Talos images needed may be found using the command `talosctl images`.  If you do not have `talosctl` installed, you may find the instructions on how to install it [here](https://omni.siderolabs.com/docs/how-to-guides/how-to-install-talosctl/).

#### Package the images

1. Pull the images to load them locally into Docker.
- Run the following command for each of the images listed above **except** for the Omni image which will be provided to you as an archive file already.

```bash
sudo docker pull registry/repository/image-name:tag
```

2. Verify all of the images have been downloaded

```bash
sudo docker image ls
```

3. Save all of the images into an archive file.
- All of the images can be saved as a single archive file which can be used to load all at once on our airgapped machine with the following command.

```bash
docker save -o image-tarfile.tar \
  list \
  of \
  images
```

Here is an an example of the command used for the images in this tutuorial:

```bash
docker save -o registry/all_images.tar \
  docker.io/gitea/gitea:1.19.3 \
  quay.io/keycloak/keycloak:21.1.1 \
  ghcr.io/siderolabs/imager:v1.4.5 \
  ghcr.io/siderolabs/flannel:v0.21.4 \
  ghcr.io/siderolabs/install-cni:v1.4.0-1-g9b07505 \
  docker.io/coredns/coredns:1.10.1 \
  gcr.io/etcd-development/etcd:v3.5.9 \
  registry.k8s.io/kube-apiserver:v1.27.2 \
  registry.k8s.io/kube-controller-manager:v1.27.2 \
  registry.k8s.io/kube-scheduler:v1.27.2 \
  registry.k8s.io/kube-proxy:v1.27.2 \
  ghcr.io/siderolabs/kubelet:v1.27.2 \
  ghcr.io/siderolabs/installer:v1.4.5 \
  registry.k8s.io/pause:3.6
```

### Move Dependencies

Now that we have all the packages necessary for the airgapped deployment of Omni, we'll create a compressed archive file and move it to our airgapped network.

The directory structure should look like this now:

```bash
airgap
├── certs
│   ├── fullchain.pem
│   ├── omni.asc
│   └── privkey.pem
├── gitea
│   └── app.ini
├── keycloak
├── omni
└── registry
    ├── omni-image.tar # Provided to you by Sidero Labs
    └── all_images.tar
```

Create a compressed archive file to move to our airgap machine.

```bash
cd ../
tar czvf omni-airgap.tar.gz airgap/
```

Now I will use scp to move this file to my machine which does not have internet access.  Use whatever method you prefer to move this file.

```bash
scp omni-airgap.tar.gz $USERNAME@$AIRGAP_MACHINE:/home/$USERNAME/
```

Lastly, I will log in to my airgapped machine and extract the compressed archive file in the home directory

```bash
cd ~/
tar xzvf omni-airgap.tar.gz
```

## Log in Airgapped Machine

From here on out, the rest of the tutorial will take place from the airgapped machine we will be installing Omni, Keycloak, and Gitea on.

## Gitea

Gitea will be used as a container registry for storing our images, but also many other functionalities including Git, Large File Storage, and the ability to store packages for many different package types.  For more information on what you can use Gitea for, visit their [documentation](https://docs.gitea.com/).

### Install Gitea

Load the images we moved over.  This will load all the images into Docker on the airgapped machine.

```bash
docker load -i registry/omni-image.tar
docker load -i registry/all_images.tar
```

Run Gitea using Docker:
- The **app.ini** file is already configured and mounted below with the `- v` argument.

```bash
sudo docker run -it \
    -v $PWD/certs/privkey.pem:/data/gitea/key.pem \
    -v $PWD/certs/fullchain.pem:/data/gitea/cert.pem \
    -v $PWD/gitea/app.ini:/data/gitea/conf/app.ini \
    -v $PWD/gitea/data/:/data/gitea/ \
    -p 3000:3000 \
    gitea/gitea:1.19.3
```

You may now log in at the `https://${GITEA_HOSTNAME}:3000` to begin configuring Gitea to store all the images needed for Omni and Talos.

### Gitea setup

This is just the bare minimum setup to run Omni.  Gitea has many additional configuration options and security measures to use in accordance with your industry's security standards. More information on the configuration of Gitea can be found (here)[https://docs.gitea.com/].

#### Create a user

Click the **Register** button at the **top right** corner.  The first user created will be created as an admin and permissions which can be adjusted accordingly afterwards if you like.

#### Create organizations

After registering an admin user, the organizations, can be created which will act as the package repositories for storing images.  Create the following organizations:
- `siderolabs`
- `keycloak`
- `coredns`
- `etcd-development`
- `registry-k8s-io-proxy`

> **NOTE:** If you are using self-signed certs and would like to push images to your local Gitea using Docker, you will also need to configure your certs.d directory as described (here)[https://docs.docker.com/engine/security/certificates/].

### Push Images to Gitea

Now that all of our organizations have been created, we can push the images we loaded into our Gitea for deploying Keycloak, Omni, and storing images used by Talos.

For all of the images loaded, we first need to tag them for our Gitea.

```bash
sudo docker tag original-image:tag gitea:3000/new-image:tag
```

For example, if I am tagging the kube-proxy image it will look like this:

> **NOTE:** Don't forget to tag all of the images from **registry.k8s.io** to go to the **registry-k8s-io-proxy** organization created in Gitea.

```bash
docker tag registry.k8s.io/kube-proxy:v1.27.2 ${GITEA_HOSTNAME}:3000/registry-k8s-io-proxy/kube-proxy:v1.27.2
```

Finally, push all the images into Gitea.

```bash
docker push ${GITEA_HOSTNAME}:3000/registry-k8s-io-proxy/kube-proxy:v1.27.2
```

## Keycloak

### Install Keycloak

The image used for keycloak is already loaded into Gitea and there are no files to stage before starting it so I'll run the following command to start it. **Replace KEYCLOAK_HOSTNAME and GITEA_HOSTNAME with your own hostnames**.

```bash
sudo docker run -it \
    -p 8080:8080 \
    -p 8443:8443 \
    -v $PWD/certs/fullchain.pem:/etc/x509/https/tls.crt \
    -v $PWD/certs/privkey.pem:/etc/x509/https/tls.key \
    -v $PWD/keycloak/data:/opt/keycloak/data \
    -e KEYCLOAK_ADMIN=admin \
    -e KEYCLOAK_ADMIN_PASSWORD=admin \
    -e KC_HOSTNAME=${KEYCLOAK_HOSTNAME} \
    -e KC_HTTPS_CERTIFICATE_FILE=/etc/x509/https/tls.crt \
    -e KC_HTTPS_CERTIFICATE_KEY_FILE=/etc/x509/https/tls.key \
    ${GITEA_HOSTNAME}:3000/keycloak/keycloak:21.1.1 \
    start
```

Once Keycloak is installed, you can reach it in your browser at `https://${KEYCLOAK_HOSTNAME}:3000

### Configuring Keycloak

For details on configuring Keycloak as a SAML Identity Provider to be used with Omni, follow this guide: [Configuring Keycloak SAML](https://omni.siderolabs.com/docs/how-to-guides/how-to-configure-keycloak-for-omni/)

## Omni

With Keycloak and Gitea installed and configured, we're ready to start up Omni and start creating and managing clusters.

### Install Omni

To install Omni, first generate a UUID to pass to Omni when we start it.

```bash
export OMNI_ACCOUNT_UUID=$(uuidgen)
```

Next run the following command, replacing hostnames for Omni, Gitea, or Keycloak with your own.

```bash
sudo docker run \
  --net=host \
  --cap-add=NET_ADMIN \
  -v $PWD/etcd:/_out/etcd \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/certs/fullchain.pem:/fullchain.pem \
  -v $PWD/certs/privkey.pem:/privkey.pem \
  -v $PWD/certs/omni.asc:/omni.asc \
  ${GITEA_HOSTNAME}:3000/siderolabs/omni:v0.12.0 \
    --account-id=${OMNI_ACCOUNT_UUID} \
    --name=omni \
    --cert=/fullchain.pem \
    --key=/privkey.pem \
    --siderolink-api-cert=/fullchain.pem \
    --siderolink-api-key=/privkey.pem \
    --private-key-source=file:///omni.asc \
    --event-sink-port=8091 \
    --bind-addr=0.0.0.0:443 \
    --siderolink-api-bind-addr=0.0.0.0:8090 \
    --k8s-proxy-bind-addr=0.0.0.0:8100 \
    --advertised-api-url=https://${OMNI_HOSTNAME}:443/ \
    --siderolink-api-advertised-url=https://${OMNI_HOSTNAME}:8090/ \
    --siderolink-wireguard-advertised-addr=${OMNI_HOSTNAME}:50180 \
    --advertised-kubernetes-proxy-url=https://${OMNI_HOSTNAME}:8100/ \
    --auth-auth0-enabled=false \
    --auth-saml-enabled \
    --talos-installer-registry=${GITEA_HOSTNAME}:3000/siderolabs/installer \
    --talos-imager-image=${GITEA_HOSTNAME}:3000/siderolabs/imager:v1.4.5 \
    --kubernetes-registry=${GITEA_HOSTNAME}:3000/siderolabs/kubelet \
    --auth-saml-url "https://${KEYCLOAK_HOSTNAME}:8443/realms/omni/protocol/saml/descriptor"
```

What's going on here:
- `--auth-auth0-enabled=false` tells Omni not to use Auth0.
- `--auth-saml-enabled` enables SAML authentication.
- `--talos-installer-registry`, `--talos-imager-image` and `--kubernetes-registry` allow you to set the default images used by Omni to point to your local repository.
- `--auth-saml-url` is the URL we saved earlier in the configuration of Keycloak.
    - `--auth-saml-metadata` may also be used if you would like to pass it as a file instead of a URL and can be used if using self-signed certificates for Keycloak.

### Creating a cluster

Guides on creating a cluster on Omni can be found here:
- [Creating an Omni cluster](https://omni.siderolabs.com/docs/how-to-guides/how-to-create-a-cluster/)

Because we're working in an airgapped environment we will need the following values added to our cluster configs so they know where to pull images from.
More information on the Talos MachineConfig.registries can be found [here](https://www.talos.dev/v1.4/talos-guides/discovery/).

> **NOTE:** In this example, cluster discovery is also disabled.
You may also configure cluster discovery on your network.
More information on the Discovery Service can be found [here](https://www.talos.dev/v1.4/talos-guides/discovery/)

```yaml
machine:
  registries:
    mirrors:
    docker.io:
      endpoints:
      - https://${GITEA_HOSTNAME}:3000
    gcr.io:
      endpoints:
      - https://${GITEA_HOSTNAME}:3000
    ghcr.io:
      endpoints:
      - https://${GITEA_HOSTNAME}:3000
    registry.k8s.io:
      endpoints:
      - https://${GITEA_HOSTNAME}:3000/v2/registry-k8s-io-proxy
      overridePath: true
cluster:
  discovery:
    enabled: false
```

Specifics on patching machines can be found here:
- [Create a Patch for Cluster Machines](https://omni.siderolabs.com/docs/how-to-guides/how-to-patch-a-machine/)

## Closure

With Omni, Gitea, and Keycloak set up, you are ready to start managing and installing Talos clusters on your network!  The suite of applications installed in this tutorial is an example of how an airgapped environment can be set up to make the most out of the Kubernetes clusters on your network.  Other container registries or authentication providers may also be used with a similar setup, but this suite was chosen to give you starting point and an example of what your environment could look like.