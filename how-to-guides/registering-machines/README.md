# Register machines with Omni

The first step to creating and managing Kubernetes clusters in Omni is registering the machines you wish to use. The machines can run anywhere Talos Linux runs. The guides in this section walk you through the specifics of different platforms.

In general, the process to register a machine with Omni consists of downloading the installation media from your Omni account, and booting the machine off that media.

To start the process, from the Home screen, click "Download Installation Media" on the right hand side:

<figure><img src="../../.gitbook/assets/image (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

The Download Installation Media form will open:

<figure><img src="../../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

This allows you to select media specific to various platforms (AWS, Azure, bare metal, etc), and also to specify options, such as:

* the versions of Talos Linux to initially boot with (note that it is recommended to have all machines that will form a cluster be at the same Talos Linux version.)
* optional extensions to be bundled into the image (providing support for additional features, such as GPUs, driver microcode, etc.)
* specific machine labels to be applied to the machines booted off this image (useful for identifying machines by racks, or location, etc)
* optional capabilities such as:
  * &#x20;SecureBoot (which verifies the signatures of the operating system, ensuring only trusted code is executed). For more information see the [Talos Linux SecureBoot](https://www.talos.dev/latest/talos-guides/install/bare-metal-platforms/secureboot/) page.
  * Tunneling Omni management WireGuard traffic over HTTP2, via the SideroLink gRPC connection. Normally Omni  management traffic runs over UDP. In some environments, that may not be possible. Running the Omni management traffic over HTTP (via gRPC) may allow operation in such restricted environments, but at a cost of substantial overhead. See the [Talos Linux SideroLink](https://www.talos.dev/latest/talos-guides/network/siderolink/) page for more information.
* Generating iPXE boot URLs: if your machines can boot via iPXE, you can configure them to boot directly off Omni via the Image Factory integration. Simply click to generate the PXE Boot URL, and pass that in to your systems to boot from.

Note that some platforms have other specific requirements, which can be seen in the articles within this section.
