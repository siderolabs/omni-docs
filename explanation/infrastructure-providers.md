---
description: Information about what infrastructure providers are and how they work.
---

# Infrastructure Providers

Infrastructure providers are a way to connect compute resources to your Omni instance for automatic management. Providers manage the lifecycle of the machines under their management.

This can replace the traditional "manual" management of machines were an engineer is responsible for downloading installation media and booting a machine to connect to Omni.

There are two main types of infrastructure providers. Providers that manage static resources and providers that manage dynamic resources. Static resources are machines you own and are re-used for different clusters. Dynamic resources are VMs that are created and deleted as needed.

Multiple infrastructure providers can be connected to a single Omni instance and securely communicate with Omni over the gRPC API.

The current infrastructure providers are:

* [Bare metal provider](https://github.com/siderolabs/omni-infra-provider-bare-metal)
* [KubeVirt provider](https://github.com/siderolabs/omni-infra-provider-kubevirt)

If you would like to build your own provider or request a provider to be created please [join our community slack workspace](https://slack.dev.talos-systems.io/) or open an [issue on github](https://github.com/siderolabs/omni/issues).

### Architecture

Each infrastructure provider deployment is intended to manage static or dynamic machines (e.g. bare metal, AWS) in a single location (e.g. dc1, us-east-2). Omni is a single instance you can connect multiple providers to. Clusters can be created with a mix of infrastructure from manually provisioned, dynamic, or static machines.

<figure><img src="../.gitbook/assets/infrastructure providers.drawio.png" alt=""><figcaption></figcaption></figure>



For example, if you have multiple data centers you would run one Bare Metal Infrastructure Provider in each data center with network access to the servers it manages. This would also apply if you have multiple network segments in the same data center.

If you want to run multiple providers connected to on-prem VM providers (e.g. VMware, KubeVirt) you would run one provider per VM management API. So even if all providers can reach all platforms they are still segmented per provider credential.

If you want to run machines in multiple regions or accounts in a public cloud provider you would run one provider per region/account and they all can be connected to the same Omni instance. Public cloud providers do not matter where you run them as long as they can reach the public cloud APIs and your Omni instance.

### Static providers

Static resource providers manage existing bare metal servers in an environment. Static providers are unique because they do not create machines, but they manage power management, PXE booting, and OS provisioning.

When a static machine is not actively being used in a cluster it is turned off to reduce power consumption and heat in a data center. For more information please see the documentation on [how to configure a bare metal provider](../tutorials/setting-up-the-bare-metal-infrastructure-provider.md).

### Dynamic providers

Dynamic providers create machines that can be created and deleted as needed. These are created using other VM platforms such as VMware and OpenStack. They can also use other infrastructure management solutions such as [Forman](https://theforeman.org/) or [RackN](http://rackn.com/rebar/) which have their own APIs and can provision machines out of a pool of resources.

Dynamic providers make a request to a resource API and expect machines to be created dynamically and connected to Omni. A [machine class](../how-to-guides/create-a-machine-class.md) is automatically created for the request which keeps the machines organized and automatically provisioned to a cluster.

Dynamic providers delete machines when they are not being used in a cluster instead of returning them to a pool of static resources.
