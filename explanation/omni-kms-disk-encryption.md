# Omni KMS Disk Encryption

Starting from 1.5.0, Talos supports KMS (Key Management Server) disk encryption key types. KMS keys are randomly generated on the Talos node and then sealed using the KMS server. A sealed key is stored in the `luks2` metadata. To decrypt a disk, Talos node needs to communicate with the KMS server and decrypt the sealed key. The KMS server endpoint is defined in the key configuration.

If the `Cluster` resource has `diskencryption` enabled, Omni creates a config patch for each cluster machine and sets key's KMS endpoint to the Omni gRPC API. Each disk encryption key is sealed using an AES256 key managed by Omni:

* Omni generates a random AES256 key for a machine when it is allocated.
* When the machine is wiped the encryption key is deleted.

{% hint style="warning" %}
KMS encryption makes cluster more sensitive to Omni downtime. A node must be able to reach Omni when it is restarted in order to unseal the disk encryption key.
{% endhint %}
