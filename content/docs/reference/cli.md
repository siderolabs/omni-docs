---
title: omnictl CLI
description: omnictl CLI tool reference.
---

<!-- markdownlint-disable -->

## omnictl apply

Create or update resource using YAML file as an input

```
omnictl apply [flags]
```

### Options

```
  -d, --dry-run       Dry run, implies verbose
  -f, --file string   Resource file to load and apply
  -h, --help          help for apply
  -v, --verbose       Verbose output
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl cluster delete

Delete all cluster resources.

### Synopsis

Delete all resources related to the cluster. The command waits for the cluster to be fully destroyed.

```
omnictl cluster delete cluster-name [flags]
```

### Options

```
  -d, --dry-run   dry run
  -h, --help      help for delete
  -v, --verbose   verbose output (show diff for each resource)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.

## omnictl cluster status

Show cluster status, wait for the cluster to be ready.

### Synopsis

Shows current cluster status, if the terminal supports it, watch the status as it updates. The command waits for the cluster to be ready by default.

```
omnictl cluster status cluster-name [flags]
```

### Options

```
  -h, --help            help for status
  -q, --quiet           suppress output
  -w, --wait duration   wait timeout, if zero, report current status and exit (default 5m0s)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.

## omnictl cluster template delete

Delete all cluster template resources from Omni.

### Synopsis

Delete all resources related to the cluster template. This command requires API access.

```
omnictl cluster template delete [flags]
```

### Options

```
  -d, --dry-run   dry run
  -h, --help      help for delete
  -v, --verbose   verbose output (show diff for each resource)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
  -f, --file string         path to the cluster template file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template diff

Show diff in resources if the template is synced.

### Synopsis

Query existing resources for the cluster and compare them with the resources generated from the template. This command requires API access.

```
omnictl cluster template diff [flags]
```

### Options

```
  -h, --help   help for diff
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
  -f, --file string         path to the cluster template file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template render

Render a cluster template to a set of resources.

### Synopsis

Validate template contents, convert to resources and output resources to stdout as YAML. This command is offline (doesn't access API).

```
omnictl cluster template render [flags]
```

### Options

```
  -h, --help   help for render
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
  -f, --file string         path to the cluster template file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template status

Show template cluster status, wait for the cluster to be ready.

### Synopsis

Shows current cluster status, if the terminal supports it, watch the status as it updates. The command waits for the cluster to be ready by default.

```
omnictl cluster template status [flags]
```

### Options

```
  -h, --help            help for status
  -q, --quiet           suppress output
  -w, --wait duration   wait timeout, if zero, report current status and exit (default 5m0s)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
  -f, --file string         path to the cluster template file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template sync

Apply template to the Omni.

### Synopsis

Query existing resources for the cluster and compare them with the resources generated from the template, create/update/delete resources as needed. This command requires API access.

```
omnictl cluster template sync [flags]
```

### Options

```
  -d, --dry-run   dry run
  -h, --help      help for sync
  -v, --verbose   verbose output (show diff for each resource)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
  -f, --file string         path to the cluster template file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template validate

Validate a cluster template.

### Synopsis

Validate that template contains valid structures, and there are no other warnings. This command is offline (doesn't access API).

```
omnictl cluster template validate [flags]
```

### Options

```
  -h, --help   help for validate
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
  -f, --file string         path to the cluster template file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template

Cluster template management subcommands.

### Synopsis

Commands to render, validate, manage cluster templates.

### Options

```
  -f, --file string   path to the cluster template file.
  -h, --help          help for template
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.
* [omnictl cluster template delete](#omnictl-cluster-template-delete)	 - Delete all cluster template resources from Omni.
* [omnictl cluster template diff](#omnictl-cluster-template-diff)	 - Show diff in resources if the template is synced.
* [omnictl cluster template render](#omnictl-cluster-template-render)	 - Render a cluster template to a set of resources.
* [omnictl cluster template status](#omnictl-cluster-template-status)	 - Show template cluster status, wait for the cluster to be ready.
* [omnictl cluster template sync](#omnictl-cluster-template-sync)	 - Apply template to the Omni.
* [omnictl cluster template validate](#omnictl-cluster-template-validate)	 - Validate a cluster template.

## omnictl cluster

Cluster-related subcommands.

### Synopsis

Commands to destroy clusters and manage cluster templates.

### Options

```
  -h, --help   help for cluster
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.
* [omnictl cluster delete](#omnictl-cluster-delete)	 - Delete all cluster resources.
* [omnictl cluster status](#omnictl-cluster-status)	 - Show cluster status, wait for the cluster to be ready.
* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl completion bash

Generate the autocompletion script for bash

### Synopsis

Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(omnictl completion bash)

To load completions for every new session, execute once:

#### Linux:

	omnictl completion bash > /etc/bash_completion.d/omnictl

#### macOS:

	omnictl completion bash > $(brew --prefix)/etc/bash_completion.d/omnictl

You will need to start a new shell for this setup to take effect.


```
omnictl completion bash
```

### Options

```
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl completion](#omnictl-completion)	 - Generate the autocompletion script for the specified shell

## omnictl completion fish

Generate the autocompletion script for fish

### Synopsis

Generate the autocompletion script for the fish shell.

To load completions in your current shell session:

	omnictl completion fish | source

To load completions for every new session, execute once:

	omnictl completion fish > ~/.config/fish/completions/omnictl.fish

You will need to start a new shell for this setup to take effect.


```
omnictl completion fish [flags]
```

### Options

```
  -h, --help              help for fish
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl completion](#omnictl-completion)	 - Generate the autocompletion script for the specified shell

## omnictl completion powershell

Generate the autocompletion script for powershell

### Synopsis

Generate the autocompletion script for powershell.

To load completions in your current shell session:

	omnictl completion powershell | Out-String | Invoke-Expression

To load completions for every new session, add the output of the above command
to your powershell profile.


```
omnictl completion powershell [flags]
```

### Options

```
  -h, --help              help for powershell
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl completion](#omnictl-completion)	 - Generate the autocompletion script for the specified shell

## omnictl completion zsh

Generate the autocompletion script for zsh

### Synopsis

Generate the autocompletion script for the zsh shell.

If shell completion is not already enabled in your environment you will need
to enable it.  You can execute the following once:

	echo "autoload -U compinit; compinit" >> ~/.zshrc

To load completions in your current shell session:

	source <(omnictl completion zsh); compdef _omnictl omnictl

To load completions for every new session, execute once:

#### Linux:

	omnictl completion zsh > "${fpath[1]}/_omnictl"

#### macOS:

	omnictl completion zsh > $(brew --prefix)/share/zsh/site-functions/_omnictl

You will need to start a new shell for this setup to take effect.


```
omnictl completion zsh [flags]
```

### Options

```
  -h, --help              help for zsh
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl completion](#omnictl-completion)	 - Generate the autocompletion script for the specified shell

## omnictl completion

Generate the autocompletion script for the specified shell

### Synopsis

Generate the autocompletion script for omnictl for the specified shell.
See each sub-command's help for details on how to use the generated script.


### Options

```
  -h, --help   help for completion
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.
* [omnictl completion bash](#omnictl-completion-bash)	 - Generate the autocompletion script for bash
* [omnictl completion fish](#omnictl-completion-fish)	 - Generate the autocompletion script for fish
* [omnictl completion powershell](#omnictl-completion-powershell)	 - Generate the autocompletion script for powershell
* [omnictl completion zsh](#omnictl-completion-zsh)	 - Generate the autocompletion script for zsh

## omnictl config add

Add a new context

```
omnictl config add <context> [flags]
```

### Options

```
      --basic-auth string   basic auth credentials
  -h, --help                help for add
      --identity string     identity to use for authentication
      --url string          URL of the server (default "grpc://127.0.0.1:8080")
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config basic-auth

Set the basic auth credentials

```
omnictl config basic-auth <username> <password> [flags]
```

### Options

```
  -h, --help   help for basic-auth
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config context

Set the current context

```
omnictl config context <context> [flags]
```

### Options

```
  -h, --help   help for context
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config contexts

List defined contexts

```
omnictl config contexts [flags]
```

### Options

```
  -h, --help   help for contexts
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config identity

Set the auth identity for the current context

```
omnictl config identity <identity> [flags]
```

### Options

```
  -h, --help   help for identity
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config info

Show information about the current context

```
omnictl config info [flags]
```

### Options

```
  -h, --help   help for info
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config merge

Merge additional contexts from another client configuration file

### Synopsis

Contexts with the same name are renamed while merging configs.

```
omnictl config merge <from> [flags]
```

### Options

```
  -h, --help   help for merge
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config new

Generate a new client configuration file

```
omnictl config new [<path>] [flags]
```

### Options

```
      --basic-auth string   basic auth credentials
  -h, --help                help for new
      --identity string     identity to use for authentication
      --url string          URL of the server (default "grpc://127.0.0.1:8080")
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config url

Set the URL for the current context

```
omnictl config url <url> [flags]
```

### Options

```
  -h, --help   help for url
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)

## omnictl config

Manage the client configuration file (omniconfig)

### Options

```
  -h, --help   help for config
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.
* [omnictl config add](#omnictl-config-add)	 - Add a new context
* [omnictl config basic-auth](#omnictl-config-basic-auth)	 - Set the basic auth credentials
* [omnictl config context](#omnictl-config-context)	 - Set the current context
* [omnictl config contexts](#omnictl-config-contexts)	 - List defined contexts
* [omnictl config identity](#omnictl-config-identity)	 - Set the auth identity for the current context
* [omnictl config info](#omnictl-config-info)	 - Show information about the current context
* [omnictl config merge](#omnictl-config-merge)	 - Merge additional contexts from another client configuration file
* [omnictl config new](#omnictl-config-new)	 - Generate a new client configuration file
* [omnictl config url](#omnictl-config-url)	 - Set the URL for the current context

## omnictl delete

Delete a specific resource by ID or all resources of the type.

### Synopsis

Similar to 'kubectl delete', 'omnictl delete' initiates resource deletion and waits for the operation to complete.

```
omnictl delete <type> [<id>] [flags]
```

### Options

```
      --all                Delete all resources of the type.
  -h, --help               help for delete
  -n, --namespace string   The resource namespace. (default "default")
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl get

Get a specific resource or list of resources.

### Synopsis

Similar to 'kubectl get', 'omnictl get' returns a set of resources from the OS.
To get a list of all available resource definitions, issue 'omnictl get rd'

```
omnictl get <type> [<id>] [flags]
```

### Options

```
  -h, --help               help for get
  -n, --namespace string   The resource namespace. (default "default")
  -o, --output string      Output format (json, table, yaml). (default "table")
  -w, --watch              Watch the resource state.
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl kubeconfig

Download the admin kubeconfig of a cluster

### Synopsis

Download the admin kubeconfig of a cluster.
If merge flag is defined, config will be merged with ~/.kube/config or [local-path] if specified.
Otherwise kubeconfig will be written to PWD or [local-path] if specified.

```
omnictl kubeconfig [local-path] [flags]
```

### Options

```
  -c, --cluster string              cluster to use
  -f, --force                       force overwrite of kubeconfig if already present, force overwrite on kubeconfig merge
      --force-context-name string   force context name for kubeconfig merge
  -h, --help                        help for kubeconfig
  -m, --merge                       merge with existing kubeconfig (default true)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl machine-logs

Get logs for a machine

### Synopsis

Get logs for a provided machine id

```
omnictl machine-logs machineID [flags]
```

### Options

```
  -f, --follow              specify if the logs should be streamed
  -h, --help                help for machine-logs
      --log-format string   log format (raw, omni, dmesg) to display (default is to display in raw format) (default "raw")
      --tail int32          lines of log file to display (default is to show from the beginning) (default -1)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl serviceaccount create

Create a service account

```
omnictl serviceaccount create <name> [flags]
```

### Options

```
  -h, --help              help for create
  -s, --scopes strings    scopes of the service account. only used when --use-user-scopes=false
  -t, --ttl duration      TTL for the service account key (default 8760h0m0s)
  -u, --use-user-scopes   use the scopes of the creating user. if true, --scopes is ignored (default true)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl serviceaccount](#omnictl-serviceaccount)	 - Manage service accounts

## omnictl serviceaccount destroy

Destroy a service account

```
omnictl serviceaccount destroy <name> [flags]
```

### Options

```
  -h, --help   help for destroy
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl serviceaccount](#omnictl-serviceaccount)	 - Manage service accounts

## omnictl serviceaccount list

List service accounts

```
omnictl serviceaccount list [flags]
```

### Options

```
  -h, --help   help for list
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl serviceaccount](#omnictl-serviceaccount)	 - Manage service accounts

## omnictl serviceaccount renew

Renew a service account by registering a new public key to it

```
omnictl serviceaccount renew <name> [flags]
```

### Options

```
  -h, --help           help for renew
  -t, --ttl duration   TTL for the service account key (default 8760h0m0s)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl serviceaccount](#omnictl-serviceaccount)	 - Manage service accounts

## omnictl serviceaccount

Manage service accounts

### Options

```
  -h, --help   help for serviceaccount
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.
* [omnictl serviceaccount create](#omnictl-serviceaccount-create)	 - Create a service account
* [omnictl serviceaccount destroy](#omnictl-serviceaccount-destroy)	 - Destroy a service account
* [omnictl serviceaccount list](#omnictl-serviceaccount-list)	 - List service accounts
* [omnictl serviceaccount renew](#omnictl-serviceaccount-renew)	 - Renew a service account by registering a new public key to it

## omnictl talosconfig

Download the admin talosconfig of a cluster

### Synopsis

Download the admin talosconfig of a cluster.
If merge flag is defined, config will be merged with ~/.talos/config or [local-path] if specified.
Otherwise talosconfig will be written to PWD or [local-path] if specified.

```
omnictl talosconfig [local-path] [flags]
```

### Options

```
  -c, --cluster string   cluster to use
  -f, --force            force overwrite of talosconfig if already present
  -h, --help             help for talosconfig
  -m, --merge            merge with existing talosconfig (default true)
```

### Options inherited from parent commands

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl

A CLI for accessing Omni API.

### Options

```
      --context string      The context to be used. Defaults to the selected context in the omniconfig file.
  -h, --help                help for omnictl
      --omniconfig string   The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl apply](#omnictl-apply)	 - Create or update resource using YAML file as an input
* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.
* [omnictl completion](#omnictl-completion)	 - Generate the autocompletion script for the specified shell
* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)
* [omnictl delete](#omnictl-delete)	 - Delete a specific resource by ID or all resources of the type.
* [omnictl get](#omnictl-get)	 - Get a specific resource or list of resources.
* [omnictl kubeconfig](#omnictl-kubeconfig)	 - Download the admin kubeconfig of a cluster
* [omnictl machine-logs](#omnictl-machine-logs)	 - Get logs for a machine
* [omnictl serviceaccount](#omnictl-serviceaccount)	 - Manage service accounts
* [omnictl talosconfig](#omnictl-talosconfig)	 - Download the admin talosconfig of a cluster

