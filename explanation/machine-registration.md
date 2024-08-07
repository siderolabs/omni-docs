# Machine Registration

Machine registration is built on top of the extremely fast WireGuard® technology built in to Linux. A technology dubbed SideroLink builds upon WireGuard in order to provide a fully automated way of setting up and maintaining a WireGuard tunnel between Omni and each registered machine. Once the secure tunnel is established between a machine it is possible to manage a machine from nearly anywhere in the world.

The SideroLink network is an overlay network used within the data and management planes within Omni. The sole requirements are that your machine has egress to port 443 and the WireGuard port assigned to your account.

{% hint style="warning" %}
There are some NAT configurations that are not compatible with WireGuard.&#x20;
{% endhint %}
