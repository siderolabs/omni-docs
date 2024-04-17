---
title: Getting Started with Omni
weight: 20
description: "A short guide on setting up a Talos Linux cluster with Omni."
---


In this Getting Started guide we will create a high availability Kubernetes cluster in Omni. 
This guide will use UTM/QEMU, but the same process will work with bare metal machines, cloud instances, and edge devices.

## Prerequisites

### Network access
If your machines have outgoing access, you are all set.
At a minimum all machines should have outgoing access to the Wireguard endpoint shown on the Home panel, which lists the IP address and UDP port that machines should be able to reach.
Machines need to be able to reach that address both on the UDP port specified, and on TCP port 443.

### Some virtual or physical machines
The simplest way to experience Omni is to be able to fire up virtual machines.
For this tutorial, we suggest any virtualization platform that can boot off an ISO (UTM, ProxMox, Fusion, etc) although any cloud platform can also be used with minor adjustments.
Bare metal can also be used, of course, but is often slower to boot and not everyone has spare physical servers around.

### `talosctl`

`talosctl` is the command line tool for issuing API calls and operating system commands to machines in an Omni cluster.
It is not required - cluster management is done via the Omni UI or `omnictl`, but `talosctl` can be useful to investigate the state of the nodes and explore functionality.

Download `talosctl`:

```bash
curl -sL https://talos.dev/install | sh
```

You can also download `talosctl` from within Omni, by selecting the "Download talosctl" button on the right hand side of the Home screen, then selecting the version and platform of `talosctl` desired.
You should rename the downloaded file to `talosctl`, make it executable, and copy it to a location on your PATH.


### `kubectl`
The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. 
You use kubectl to deploy applications, inspect and manage cluster resources, view logs, etc. 

Download `kubectl` via one of methods outlined in the [documentation](https://kubernetes.io/docs/tasks/tools/#kubectl).

Omni integrates all operations (for Omni itself, Kubernetes, and Talos Linux) against the authentication configured for Omni (which may be GitHub, Google, enterprise SAML, etc.)
Thus in order to use `kubectl` with Omni, you *need to install the oidc-login plugin* per the [documentation](https://github.com/int128/kubelogin#getting-started).

Note: When using HomeBrew on Macs with M1 chips, there have been reports of issues with the plugin being installed to the wrong path and not being found. 
You may find it simpler to copy the file from GitHub and manually put the kubelogin binary on your path under the name kubectl-oidc_login so that the kubectl plugin mechanism can find it. 

### `omnictl`
`omnictl` is also an optional binary. 
Almost all cluster operations can be done via the Omni Web UI, but `omnictl` is used for advanced operations, to integrate Omni into CI workflows, or simply if you prefer a CLI to a UI.

Download `omnictl` from within Omni: on the Home tab, click the "Download omnictl" button on the right hand side, select the appropriate platform, and the "Download" button.
Then ensure to rename the binary, make it executable, and copy to a location on your path.
For example:
```bash
Downloads % mv omnictl-darwin-arm64 omnictl
Downloads % chmod +x omnictl
Downloads % mv omnictl /usr/local/bin
```

## Download Installation Media
Omni is a BYO Machine platform - the only thing you need to do is boot your machines off an Omni image. 
The Omni image will have the necessary credentials and endpoints built in to it, that you can use to boot all your machines.
To download the installation media, go to the Home screen in Omni, and select "Download Installation Media" from the right hand side.
Select the appropriate media and platform type - e.g. I will select `ISO (arm64)` as I am going to boot a virtual machine within UTM on an apple M1.

Images exist for many platforms, but you will have to follow the specific installation instructions for that platform (which often involve copying the image to S3 type storage, creating a machine image from it, etc.)

## Boot machines off the downloaded image
Create at least 1 virtual machine with 2GB of memory, but 4 are suggested, using your Hypervisor.
Have each virtual machine boot off the ISO image you just downloaded, and start the virtual machines. 

After a few seconds, the machines should show in the Machines panel of Omni, with the `available` tag.
They will also have tags showing their architecture, memory, cores and other information.

## Create Cluster
Click "Clusters" on the left navigation panel, then "Create Cluster" in the top right.
You can give your cluster a name, select the version of Talos Linux to install, and the version of Kubernetes.
You can also specify any Patches that should be applied in creating your cluster, but in most cases these are not needed to get started.
There are other options on this screen - encryption, backups, machine sets, etc - but we will skip those for this tutorial.

In the section headed "Available Machines", select at least one machine to be the control plane, by clicking `CP`.
(Ideally, you will have 3 control plane nodes.)
Select one machine to be a worker, by clicking `W0` next to the machine.

Then click `Create Cluster`.
Your cluster is now being created, and you will be taken to the Cluster Overview page.
From this page you can download the `kubeconfig` and `talosconfig` files for your cluster, by clicking the buttons on the right hand side.

### Access Kubernetes
You can query your Kubernetes cluster using normal kubernetes operations:
```
kubectl --kubeconfig ./talos-default-kubeconfig.yaml get nodes
```
> Note: you will have to change the referenced kubeconfig file depending on the name of the cluster you created.

The first time you use the `kubectl` command to query a cluster, a browser window will open requiring you to authenticate with your identity provider (Google or GitHub most commonly.)
If you get a message `error: unknown command "oidc-login" for "kubectl"
Unable to connect to the server:` then you need to install the oidc-login plugin as noted above.

### Access Talos commands

You can explore Talos API commands.
Again, the first time you access the Talos API, a browser window will start to authenticate your request.
The downloaded `talosconfig` file for the cluster includes the Omni endpoint, so you do not need to specify endpoints, just nodes.

```bash
talosctl --talosconfig ./talos-default-talosconfig.yaml --nodes 10.5.0.2 get members
```
> In the above example you will need to change the name of the `talosconfig` file, if you changed the cluster name from the default, also the `node` IP, using the actual IP or name of the nodes you created (which are shown in Omni.)

### Explore Omni
Now you have a complete cluster, with a high-availability Kubernetes API endpoint running on the Omni infrastructure, where all authentication is tied in to your enterprise identity provider.
It's a good time to explore all that Omni can offer, including other areas of the UI such as:
- etcd backup and restores
- simple cluster upgrades of Kubernetes and Operating System
- proxying of workload HTTP access
- simple scaling up and down of clusters
- the concept of Machine Sets, that let you manage your infrastructure by classes

And if you are wanting to declaratively manage your clusters and infrastructure declaratively, as code, check out [Cluster Templates](../../reference/cluster-templates/).

### Destroy the Cluster

When you are all done, you can remove the cluster by clicking "Destroy Cluster", in the bottom right of the Cluster Overview panel.
This will wipe the machine and return them to the Available state.

## Cluster example

We have a complete example of a managed cluster complete with a monitoring stack and application management.
It can be found in our [community contrib repo](https://github.com/siderolabs/contrib/blob/main/examples/omni).

### Components

The contrib example includes:

- [Cilium](https://cilium.io/get-started/) for cluster networking
- [Hubble](https://docs.cilium.io/en/stable/gettingstarted/hubble_intro/) for network observability
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) for application management
- [Rook/Ceph](https://rook.io/docs/rook/latest-release/Getting-Started/intro/) for persistent storage
- [Prometheus](https://prometheus.io/docs/introduction/overview/) for metrics collection and alerting
- [Grafana](https://grafana.com/docs/grafana/latest/introduction/) for metrics visualization

### Use

You will need to copy the contents of the `omni` directory to a git repository that can be accessed by the cluster you create.
You will need to update the [ArgoCD ApplicationSet](https://github.com/siderolabs/contrib/blob/main/examples/omni/apps/argocd/argocd/bootstrap-app-set.yaml) template to reference your new git repo, and regenerate the ArgoCD bootstrap patch.

```bash
sed -i 's|https://github.com/siderolabs/contrib.git|<your-git-repo>|' apps/argocd/argocd/bootstrap-app-set.yaml
kustomize build apps/argocd/argocd | yq -i 'with(.cluster.inlineManifests.[] | select(.name=="argocd"); .contents=load_str("/dev/stdin"))' infra/patches/argocd.yaml
```

With these changes made you should commit the new values and push them to the git repo.

Next you should register your machines with Omni (see guides for [AWS](../../how-to-guides/how-to-register-an-aws-ec2-instance), [GCP](../../how-to-guides/how-to-register-a-gcp-instance), [Azure](../../how-to-guides/how-to-register-an-azure-instance/), [Hetzner](../../how-to-guides/how-to-register-a-hetzner-server/), and [bare metal](../../how-to-guides/how-to-register-a-bare-metal-machine-iso/)) and create [machine classes](../../how-to-guides/how-to-create-machine-classes/) to match your hardware.
By default, the example [cluster template](../../reference/cluster-templates) is configured to use 3 instances of machine classes named `omni-contrib-controlplane`, and all instances that match a machines class called `omni-contrib-workers`.
You can modify these settings in the [cluster-template.yaml](https://github.com/siderolabs/contrib/blob/main/examples/omni/infra/cluster-template.yaml), but keep in mind that for Rook/Ceph to work you will need to use at least 3 instances with additional block devices for storage.

Once machines are registered you can create the cluster using the cluster template in the `infra` directory.

```bash
omnictl cluster template sync --file cluster-template.yaml
```

This should create the cluster as described, bootstrap ArgoCD, and begin installing applications from your repo.
Depending on your infrastructure, it should take 5-10 mins for the cluster to come fully online with all applications working and healthy.
Monitoring can be viewed directly from Omni using the [workload proxy](../../how-to-guides/how-to-expose-http-service-from-a-cluster/) feature, with links to Grafana and Hubble found on the left-hand side of the Omni UI.
