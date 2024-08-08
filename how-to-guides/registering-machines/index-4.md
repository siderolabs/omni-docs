---
description: A guide on how to register a Hetzner server with Omni.
---

# Register a Hetzner Server

### Dashboard <a href="#dashboard" id="dashboard"></a>

Upon logging in you will be presented with the Omni dashboard.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-hetzner-server/register-a-hetzner-server-1_hu0be398a1d6bb39386fc95dcd73c16f2d_321797_900x0_resize_catmullrom_3.png" alt="" height="563" width="900"><figcaption></figcaption></figure>

### Download the Hetzner Image <a href="#download-the-hetzner-image" id="download-the-hetzner-image"></a>

First, download the Hetzner image from the Omni portal by clicking on the “Download Installation Media” button. Now, click on the “Options” dropdown menu and search for the “Hetzner” option. Notice there are two options: one for `amd64` and another for `arm64`. Select the appropriate option for the machine you are registering. Now, click the “Download” button.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-hetzner-server/register-a-hetzner-server-2_hub2723a3bce83670dc2756e84b1b5c70c_1213956_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

*

{% tabs %}
{% tab title="Packer" %}
Place the following in the same directory as the downloaded installation media and name the file `hcloud.pkr.hcl`:

Copy

```hcl
packer {
  required_plugins {
    hcloud = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

locals {
  image = "<path to downloaded installation media>"
}

source "hcloud" "talos" {
  rescue       = "linux64"
  image        = "debian-11"
  location     = "hel1"
  server_type  = "cx11"
  ssh_username = "root"

  snapshot_name = "Omni Image"
}

build {
  sources = ["source.hcloud.talos"]

  provisioner "file" {
    source = "${local.image}"
    destination = "/tmp/talos.raw.xz"
  }

  provisioner "shell" {
    inline = [
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
    ]
  }
}
```

Now, run the following:

Copy

```bash
export HCLOUD_TOKEN=${TOKEN}
packer init .
packer build .
```

Take note of the image ID produced by running this command.
{% endtab %}
{% endtabs %}

### Create a Server <a href="#create-a-server" id="create-a-server"></a>

```bash
hcloud context create talos

hcloud server create --name omni-talos-1 \
    --image <image ID> \
    --type cx21 --location <location>
```

**Warning**

{% hint style="warning" %}
Machines must be able to egress to your account’s WireGuard port and port 443.
{% endhint %}

### Conclusion <a href="#conclusion" id="conclusion"></a>

Navigate to the “Machines” menu in the sidebar. You should now see a machine listed.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-hetzner-server/register-a-hetzner-server-3_hub2723a3bce83670dc2756e84b1b5c70c_291403_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

You now have a Hetzner server registered with Omni and ready to provision.
