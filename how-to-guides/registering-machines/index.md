---
description: A guide on how to register bare metal machines with Omni using an ISO.
---

# Register a Bare Metal Machine (ISO)

### Dashboard <a href="#dashboard" id="dashboard"></a>

Upon logging in you will be presented with the Omni dashboard.

### Download the ISO <a href="#download-the-iso" id="download-the-iso"></a>

First, download the ISO from the Omni portal by clicking on the “Download Installation Media” button on the right.

Select the version of Talos for the cluster, then click on the “Options” dropdown menu and search for, or scroll down to, the “ISO” option.&#x20;

<figure><img src="../../.gitbook/assets/Screenshot 2024-08-07 at 8.32.07 PM.png" alt=""><figcaption></figcaption></figure>

Notice there are two options: one for `amd64` and another for `arm64`. Select the appropriate architecture for the machine you are registering. Now that you have selected the ISO option for the appropriate architecture, click the “Download” button.

### Write the ISO to a USB Stick <a href="#write-the-iso-to-a-usb-stick" id="write-the-iso-to-a-usb-stick"></a>

First, plug the USB drive into your local machine. Now, find the device path for your USB drive and write the ISO to the USB drive.

{% tabs %}
{% tab title="MacOS" %}
```
diskutil list
...
/dev/disk2 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                                                   *31.9 GB    disk2
...
```

In this example `disk2` is the USB drive.

```
dd if=<path to ISO> of=/dev/disk2 conv=fdatasync
```
{% endtab %}

{% tab title="Linux" %}
```
$ lsblk
...
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdb      8:0    0 39.1G  0 disk
...
```

In this example `sdb` is the USB drive.

```
dd if=<path to ISO> of=/dev/sdb conv=fdatasync
```
{% endtab %}
{% endtabs %}

### Boot the Machine <a href="#boot-the-machine" id="boot-the-machine"></a>

Now that we have our bootable USB drive, plug it into the machine you are registering. Once the machine is booting you will notice logs from Talos Linux on the console stating that it is reachable over an IP address.

{% hint style="warning" %}
Machines must be able to egress to your account’s WireGuard port and TCP port 443.
{% endhint %}

### Conclusion <a href="#conclusion" id="conclusion"></a>

Navigate to the “Machines” menu in the sidebar of Omni. You should now see a machine listed.

You now have a bare metal machine registered with Omni and ready to provision.
