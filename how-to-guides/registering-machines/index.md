---
description: A guide on how to register bare metal machines with Omni using an ISO.
---

# Register a Bare Metal Machine (ISO)

### Dashboard <a href="#dashboard" id="dashboard"></a>

Upon logging in you will be presented with the Omni dashboard.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-bare-metal-machine-iso/register-a-bare-metal-machine-iso-1_hu0be398a1d6bb39386fc95dcd73c16f2d_321797_900x0_resize_catmullrom_3.png" alt="" height="563" width="900"><figcaption></figcaption></figure>

### Download the ISO <a href="#download-the-iso" id="download-the-iso"></a>

First, download the ISO from the Omni portal by clicking on the “Download Installation Media” button. Now, click on the “Options” dropdown menu and search for the “ISO” option. Notice there are two options: one for `amd64` and another for `arm64`. Select the appropriate option for the machine you are registering. Now that you have selected the ISO option for the appropriate architecture, click the “Download” button.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-bare-metal-machine-iso/register-a-bare-metal-machine-iso-2_hu0be398a1d6bb39386fc95dcd73c16f2d_363086_900x0_resize_catmullrom_3.png" alt="" height="563" width="900"><figcaption></figcaption></figure>

### Write the ISO to a USB Stick <a href="#write-the-iso-to-a-usb-stick" id="write-the-iso-to-a-usb-stick"></a>

First, plug the USB drive into your local machine. Now, find the device path for your USB drive and write the ISO to the USB drive.

* [macOS](https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-bare-metal-machine-iso/#tabs-02-00)
* [Linux](https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-bare-metal-machine-iso/#tabs-02-01)

Copy

```zsh
diskutil list
...
/dev/disk2 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                                                   *31.9 GB    disk2
...
```

In this example `disk2` is the USB drive.

Copy

```zsh
dd if=<path to ISO> of=/dev/disk2 conv=fdatasync
```

### Boot the Machine <a href="#boot-the-machine" id="boot-the-machine"></a>

Now that we have our bootable USB drive, plug it into the machine you are registering. Once the machine is booting you will notice logs from Talos Linux on the console stating that it is reachable over an IP address.

{% hint style="warning" %}
Machines must be able to egress to your account’s WireGuard port and TCP port 443.
{% endhint %}

### Conclusion <a href="#conclusion" id="conclusion"></a>

Navigate to the “Machines” menu in the sidebar. You should now see a machine listed.

<figure><img src="https://omni.siderolabs.com/docs/how-to-guides/registering-machines/how-to-register-a-bare-metal-machine-iso/register-a-bare-metal-machine-iso-3_hub2723a3bce83670dc2756e84b1b5c70c_291403_900x0_resize_catmullrom_3.png" alt="" height="582" width="900"><figcaption></figcaption></figure>

You now have a bare metal machine registered with Omni and ready to provision.
