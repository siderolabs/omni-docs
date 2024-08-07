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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --destroy-disconnected-machines   removes all disconnected machines which are part of the cluster from Omni
  -d, --dry-run                         dry run
  -h, --help                            help for delete
  -v, --verbose                         verbose output (show diff for each resource)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.

## omnictl cluster kubernetes manifest-sync

Sync Kubernetes bootstrap manifests from Talos controlplane nodes to Kubernetes API.

### Synopsis

Sync Kubernetes bootstrap manifests from Talos controlplane nodes to Kubernetes API.
Bootstrap manifests might be updated with Talos version update, Kubernetes upgrade, and config patching.
Talos never updates or deletes Kubernetes manifests, so this command fills the gap to keep manifests up-to-date.

```
omnictl cluster kubernetes manifest-sync cluster-name [flags]
```

### Options

```
      --dry-run   don't actually sync manifests, just print what would be done (default true)
  -h, --help      help for manifest-sync
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster kubernetes](#omnictl-cluster-kubernetes)	 - Cluster Kubernetes management subcommands.

## omnictl cluster kubernetes upgrade-pre-checks

Run Kubernetes upgrade pre-checks for the cluster.

### Synopsis

Verify that upgrading Kubernetes version is available for the cluster: version compatibility, deprecated APIs, etc.

```
omnictl cluster kubernetes upgrade-pre-checks cluster-name [flags]
```

### Options

```
  -h, --help        help for upgrade-pre-checks
      --to string   target Kubernetes version for the planned upgrade
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster kubernetes](#omnictl-cluster-kubernetes)	 - Cluster Kubernetes management subcommands.

## omnictl cluster kubernetes

Cluster Kubernetes management subcommands.

### Synopsis

Commands to render, validate, manage cluster templates.

### Options

```
  -h, --help   help for kubernetes
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.
* [omnictl cluster kubernetes manifest-sync](#omnictl-cluster-kubernetes-manifest-sync)	 - Sync Kubernetes bootstrap manifests from Talos controlplane nodes to Kubernetes API.
* [omnictl cluster kubernetes upgrade-pre-checks](#omnictl-cluster-kubernetes-upgrade-pre-checks)	 - Run Kubernetes upgrade pre-checks for the cluster.

## omnictl cluster machine lock

Lock the machine

### Synopsis

When locked, no config updates, upgrades and downgrades will be performed on the machine.

```
omnictl cluster machine lock machine-id [flags]
```

### Options

```
  -h, --help   help for lock
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster machine](#omnictl-cluster-machine)	 - Machine related commands.

## omnictl cluster machine unlock

Unlock the machine

### Synopsis

Removes locked annotation from the machine.

```
omnictl cluster machine unlock machine-id [flags]
```

### Options

```
  -h, --help   help for unlock
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster machine](#omnictl-cluster-machine)	 - Machine related commands.

## omnictl cluster machine

Machine related commands.

### Synopsis

Commands to manage cluster machines.

### Options

```
  -h, --help   help for machine
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.
* [omnictl cluster machine lock](#omnictl-cluster-machine-lock)	 - Lock the machine
* [omnictl cluster machine unlock](#omnictl-cluster-machine-unlock)	 - Unlock the machine

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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --destroy-disconnected-machines   removes all disconnected machines which are part of the cluster from Omni
  -d, --dry-run                         dry run
  -f, --file string                     path to the cluster template file.
  -h, --help                            help for delete
  -v, --verbose                         verbose output (show diff for each resource)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -f, --file string   path to the cluster template file.
  -h, --help          help for diff
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template export

Export a cluster template from an existing cluster on Omni.

### Synopsis

Export a cluster template from an existing cluster on Omni. This command requires API access.

```
omnictl cluster template export cluster-name [flags]
```

### Options

```
  -c, --cluster string   cluster name
  -f, --force            overwrite output file if it exists
  -h, --help             help for export
  -o, --output string    output file (default: stdout)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -f, --file string   path to the cluster template file.
  -h, --help          help for render
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -f, --file string     path to the cluster template file.
  -h, --help            help for status
  -q, --quiet           suppress output
  -w, --wait duration   wait timeout, if zero, report current status and exit (default 5m0s)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -d, --dry-run       dry run
  -f, --file string   path to the cluster template file.
  -h, --help          help for sync
  -v, --verbose       verbose output (show diff for each resource)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -f, --file string   path to the cluster template file.
  -h, --help          help for validate
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster template](#omnictl-cluster-template)	 - Cluster template management subcommands.

## omnictl cluster template

Cluster template management subcommands.

### Synopsis

Commands to render, validate, manage cluster templates.

### Options

```
  -h, --help   help for template
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.
* [omnictl cluster template delete](#omnictl-cluster-template-delete)	 - Delete all cluster template resources from Omni.
* [omnictl cluster template diff](#omnictl-cluster-template-diff)	 - Show diff in resources if the template is synced.
* [omnictl cluster template export](#omnictl-cluster-template-export)	 - Export a cluster template from an existing cluster on Omni.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.
* [omnictl cluster delete](#omnictl-cluster-delete)	 - Delete all cluster resources.
* [omnictl cluster kubernetes](#omnictl-cluster-kubernetes)	 - Cluster Kubernetes management subcommands.
* [omnictl cluster machine](#omnictl-cluster-machine)	 - Machine related commands.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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

	source <(omnictl completion zsh)

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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -h, --help              help for add
      --identity string   identity to use for authentication
      --url string        URL of the server (default "grpc://127.0.0.1:8080")
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -h, --help              help for new
      --identity string   identity to use for authentication
      --url string        URL of the server (default "grpc://127.0.0.1:8080")
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.
* [omnictl config add](#omnictl-config-add)	 - Add a new context
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
  -l, --selector string    Selector (label query) to filter on, supports '=' and '==' (e.g. -l key1=value1,key2=value2)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl download

Download installer media

### Synopsis

This command downloads installer media from the server

It accepts one argument, which is the name of the image to download. Name can be one of the following:

     * iso - downloads the latest ISO image
     * AWS AMI (amd64), Vultr (arm64), Raspberry Pi 4 Model B - full image name
     * oracle, aws, vmware - platform name
     * rpi_generic, rockpi_4c, rock64 - board name

To get the full list of available images, look at the output of the following command:
    omnictl get installationmedia -o yaml

The download command tries to match the passed string in this order:

    * name
    * profile

By default it will download amd64 image if there are multiple images available for the same name.

For example, to download the latest ISO image for arm64, run:

    omnictl download iso --arch amd64

To download the latest Vultr image, run:

    omnictl download "vultr"

To download the latest Radxa ROCK PI 4 image, run:

    omnictl download "rpi_generic"


```
omnictl download <image name> [flags]
```

### Options

```
      --arch string                     Image architecture to download (amd64, arm64) (default "amd64")
      --extensions stringArray          Generate installation media with extensions pre-installed
      --extra-kernel-args stringArray   Add extra kernel args to the generated installation media
  -h, --help                            help for download
      --initial-labels stringArray      Bake initial labels into the generated installation media
      --output string                   Output file or directory, defaults to current working directory (default ".")
      --pxe                             Print PXE URL and exit
      --secureboot                      Download SecureBoot enabled installation media
      --talos-version string            Talos version to be used in the generated installation media (default "1.7.4")
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -h, --help                     help for get
      --id-match-regexp string   Match resource ID against a regular expression.
  -n, --namespace string         The resource namespace. (default "default")
  -o, --output string            Output format (json, table, yaml, jsonpath). (default "table")
  -l, --selector string          Selector (label query) to filter on, supports '=' and '==' (e.g. -l key1=value1,key2=value2)
  -w, --watch                    Watch the resource state.
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --break-glass                 get kubeconfig that allows accessing nodes bypasing Omni (if enabled for the account)
  -c, --cluster string              cluster to use
  -f, --force                       force overwrite of kubeconfig if already present, force overwrite on kubeconfig merge
      --force-context-name string   force context name for kubeconfig merge
      --grant-type string           Authorization grant type to use. One of (auto|authcode|authcode-keyboard)
      --groups strings              group to be used in the service account token (groups). only used when --service-account is set to true (default [system:masters])
  -h, --help                        help for kubeconfig
  -m, --merge                       merge with existing kubeconfig (default true)
      --service-account             create a service account type kubeconfig instead of a OIDC-authenticated user type
      --ttl duration                ttl for the service account token. only used when --service-account is set to true (default 8760h0m0s)
      --user string                 user to be used in the service account token (sub). required when --service-account is set to true
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
  -h, --help            help for create
  -r, --role string     role of the service account. only used when --use-user-role=false
  -t, --ttl duration    TTL for the service account key (default 8760h0m0s)
  -u, --use-user-role   use the role of the creating user. if true, --role is ignored (default true)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
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
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.
* [omnictl serviceaccount create](#omnictl-serviceaccount-create)	 - Create a service account
* [omnictl serviceaccount destroy](#omnictl-serviceaccount-destroy)	 - Destroy a service account
* [omnictl serviceaccount list](#omnictl-serviceaccount-list)	 - List service accounts
* [omnictl serviceaccount renew](#omnictl-serviceaccount-renew)	 - Renew a service account by registering a new public key to it

## omnictl support

Download the support bundle for a cluster

### Synopsis

The command collects all non-sensitive information for the cluster from the Omni state.

```
omnictl support [local-path] [flags]
```

### Options

```
  -c, --cluster string   cluster to use
  -h, --help             help for support
  -O, --output string    support bundle output (default "support.zip")
  -v, --verbose          verbose output
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

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
      --break-glass      get operator talosconfig that allows bypassing Omni (if enabled for the account)
  -c, --cluster string   cluster to use
  -f, --force            force overwrite of talosconfig if already present
  -h, --help             help for talosconfig
  -m, --merge            merge with existing talosconfig (default true)
```

### Options inherited from parent commands

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl](#omnictl)	 - A CLI for accessing Omni API.

## omnictl

A CLI for accessing Omni API.

### Options

```
      --context string             The context to be used. Defaults to the selected context in the omniconfig file.
  -h, --help                       help for omnictl
      --insecure-skip-tls-verify   Skip TLS verification for the Omni GRPC and HTTP API endpoints.
      --omniconfig string          The path to the omni configuration file. Defaults to 'OMNICONFIG' env variable if set, otherwise the config directory according to the XDG specification.
```

### SEE ALSO

* [omnictl apply](#omnictl-apply)	 - Create or update resource using YAML file as an input
* [omnictl cluster](#omnictl-cluster)	 - Cluster-related subcommands.
* [omnictl completion](#omnictl-completion)	 - Generate the autocompletion script for the specified shell
* [omnictl config](#omnictl-config)	 - Manage the client configuration file (omniconfig)
* [omnictl delete](#omnictl-delete)	 - Delete a specific resource by ID or all resources of the type.
* [omnictl download](#omnictl-download)	 - Download installer media
* [omnictl get](#omnictl-get)	 - Get a specific resource or list of resources.
* [omnictl kubeconfig](#omnictl-kubeconfig)	 - Download the admin kubeconfig of a cluster
* [omnictl machine-logs](#omnictl-machine-logs)	 - Get logs for a machine
* [omnictl serviceaccount](#omnictl-serviceaccount)	 - Manage service accounts
* [omnictl support](#omnictl-support)	 - Download the support bundle for a cluster
* [omnictl talosconfig](#omnictl-talosconfig)	 - Download the admin talosconfig of a cluster

