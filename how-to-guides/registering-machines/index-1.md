---
description: A guide on how to register a bare metal machines with Omni using PXE/iPXE.
---

# Register a Bare Metal Machine (PXE/iPXE)

This guide shows you how to register a bare metal machine with Omni by PXE/iPXE booting.

### Copy the Required Kernel Parameters <a href="#copy-the-required-kernel-parameters" id="copy-the-required-kernel-parameters"></a>

Upon logging in you will be presented with the Omni dashboard. Click the “Copy Kernel Parameters” button on the right hand side, and save the value for later.

### Download the PXE/iPXE Assets <a href="#download-the-pxeipxe-assets" id="download-the-pxeipxe-assets"></a>

The following example assumes the use of Matchbox server.

Download `vmlinuz` and `initramfs.xz` from the [release](https://github.com/siderolabs/talos/releases) of your choice (Talos Linux 1.4 or greater is required), and place them in `/var/lib/matchbox/assets`.

#### Create the Profile <a href="#create-the-profile" id="create-the-profile"></a>

Place the following in `/var/lib/matchbox/profiles/default.json`:

```json
{
  "id": "default",
  "name": "default",
  "boot": {
    "kernel": "/assets/vmlinuz",
    "initrd": ["/assets/initramfs.xz"],
    "args": [
      "initrd=initramfs.xz",
      "init_on_alloc=1",
      "slab_nomerge",
      "pti=on",
      "console=tty0",
      "console=ttyS0",
      "printk.devkmsg=on",
      "talos.platform=metal",
      "siderolink.api=<your siderolink.api value>",
      "talos.events.sink=<your talos.events.sink value>",
      "talos.logging.kernel=<your talos.logging.kernel value>"
    ]
  }
}
```

Update `siderolink.api`, `talos.events.sink`, and `talos.logging.kernel` with the kernel parameters copied from the dashboard.

Place the following in `/var/lib/matchbox/groups/default.json`:

#### Create the Group <a href="#create-the-group" id="create-the-group"></a>

```json
{
  "id": "default",
  "name": "default",
  "profile": "default"
}
```

Once your machine is configured to PXE boot using your tool of choice, power the machine on.

### Conclusion <a href="#conclusion" id="conclusion"></a>

Navigate to the “Machines” menu in the sidebar of Omni. You should now see a machine listed.

You now have a bare metal machine registered with Omni and ready to provision.
