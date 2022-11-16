---
title: How to Register a Bare Metal Machine (ISO)
description: "A guide on how to register bare metal machines with Omni using an ISO."
date: 2022-10-29T09:38:16-07:00
draft: false
weight: 10
---

This guide shows you how to register a bare metal machine with Omni by booting from an ISO.

## Dashboard

Upon logging in you will be presented with the Omni dashboard.

{{< imgproc register-a-bare-metal-machine-iso-1.png Resize "900x" >}}
{{< /imgproc >}}

## Download the ISO

First, download the ISO from the Omni portal by clicking on the "Download Installation Media" button.
Now, click on the "Options" dropdown menu and search for the "ISO" option.
Notice there are two options: one for `amd64` and another for `arm64`.
Select the appropriate option for the machine you are registering.
Now that you have selected the ISO option for the appropriate architecture, click the "Download" button.

{{< imgproc register-a-bare-metal-machine-iso-2.png Resize "900x" >}}
{{< /imgproc >}}

## Write the ISO to a USB Stick

First, plug the USB drive into your local machine.
Now, find the device path for your USB drive and write the ISO to the USB drive.

{{< tabpane text=true >}}
{{% tab header="macOS" %}}

```zsh
diskutil list
...
/dev/disk2 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                                                   *31.9 GB    disk2
...
```

In this example `disk2` is the USB drive.

```zsh
dd if=<path to ISO> of=/dev/disk2 conv=fdatasync
```

{{% /tab %}}
{{% tab header="Linux" %}}

```zsh
$ lsblk
...
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdb      8:0    0 39.1G  0 disk
...
```

In this example `sdb` is the USB drive.


```bash
dd if=<path to ISO> of=/dev/sdb conv=fdatasync
```

{{% /tab %}}
{{< /tabpane >}}

## Boot the Machine

Now that we have our bootable USB drive, plug it into the machine you are registering.
Once the machine is booting you will notice logs from Talos Linux on the console stating that it is reachable over an IP address.

{{% alert title="Warning" color="warning" %}}
You must ensure that your machine can egress to your account's WireGuard port and port 443.
{{% /alert %}}

## Conclusion

Navigate to the "Machines" menu in the sidebar.
You should now see a machine listed.

{{< imgproc register-a-bare-metal-machine-iso-3.png Resize "900x" >}}
{{< /imgproc >}}

You now have a bare metal machine registered with Omni and ready to provision.
