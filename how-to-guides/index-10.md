---
description: A guide on how to create an Omni service account.
---

# Create an Omni Service Account

You will need `omnictl` installed and configured to follow this guide. If you haven't done so already, follow the [`omnictl` guide](index-1.md).

### Creating the Service Account

To create an Omni service account, use the following command:

```bash
omnictl serviceaccount create <sa-name>
```

{% hint style="info" %}
By default, the created service account will have a lifetime of 1 year, and uses the role of the creating user. These options can be adjusted by passing in the `--ttl` and `--role` parameters to the command. [See the command for details](../reference/cli.md#omnictl-serviceaccount-create).
{% endhint %}

The output of this command will print `OMNI_ENDPOINT` and `OMNI_SERVICE_ACCOUNT_KEY`.

{% hint style="warning" %}
Store the `OMNI_SERVICE_ACCOUNT_KEY` securely as it will not be displayed again.
{% endhint %}

Export these variables with the printed values:

```bash
export OMNI_ENDPOINT=<output from above command>
export OMNI_SERVICE_ACCOUNT_KEY=<output from above command>
```

You can now use `omnictl` with the generated service account.
