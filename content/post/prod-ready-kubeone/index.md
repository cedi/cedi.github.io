---
title: 'Bootstrapping a production ready Kubernetes on Hetzner Cloud'
subtitle: '6 tips for creating a production ready Kubernetes cluster using KubeOne with Canal CNI on Hetzner Cloud'
summary: Bootstrapping a production ready Kubernetes cluster using Terraform and KubeOne on Hetzner Cloud running Canal CNI
authors:
- cedi
tags:
- kubernetes
- kubeone
- hetzner
- cloud
- terraform
- bash
categories:
- kubernetes
date: "2022-03-21T00:00:00Z"
lastmod: "2023-01-06T12:06:00Z"
featured: true
draft: false
merge_request: https://github.com/cedi/cedi.github.io/pull/8

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal point options: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight
image:
  caption: 
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects:
- kubeone

# Set captions for image gallery.
gallery_item: []
---

## Introduction

Hi and welcome to my first blog post on my new website.

I know what you are thinking right now "Oh no! Not another blogpost about setting up a Kubernetes Cluster!".
And yeah, I get it! There are a lot of blog-posts, tutorials, and articles already written about this topic.
For example [shibumi][1] wrote an amazing blog-post about [Kubernetes on Hetzner in 2021][2], and there is a even a [Hetzner example terraform][3] in the [KubeOne GitHub][4].

But here is the deal: while those posts and examples give you an _easy_ quick-start, they don't cover the aspects of bootstrapping a KubeOne cluster that is supposed to run in production some day.

To scope this blog-post a bit down, I have to make a few assumptions:

- You already have KubeOne installed on your local machine
- You have a project on Hetzner Cloud
- You have already created a Hetzner API Token for your Project with read+write permissions, or you are able to do so
- You want to use **Canal** as your CNI of choice and not Cilium which was recently added in [KubeOne 1.4][5].
- You are familiar with [terraform][6]

## Preface and Acknowledgements

This is not a "definitive guide" nor should you take everything you read too serious. I might be wrong or too opinionated about stuff.

Actually running Kubernetes in production is way harder than just reading this article. I intentionally leave out **many** details of how to actually run Kubernetes in production.

Specifically, in this post I will not talk about:

- Security
- GitOps
- Disaster recovery
- Monitoring here

I might dedicate future blog-posts to those topics (and hopefully remember to link them back here).

Therefore, the scope of this blog post is narrowed down to bootstrapping a Kubernetes Cluster using KubeOne - with somewhat sane defaults and measures taken - that will get you started on your journey to a production ready Kubernetes Cluster.

## Reliability Tip 1: Use an odd number of API servers

To get started we need to have some virtual servers running on Hetzner Cloud to install the Kubernetes API Server, etcd database and the cluster's control-plane on.
You should stick to odd numbers of your API servers because etcd needs a majority of nodes to agree on updates to the cluster state.


This majority (quorum) required for etcd is `(n/2)+1` [^1].

[^1]: [Diego Ongaro and John Ousterhout, In Search of an Understandable Consensus Algorithm (Extended Version), Stanford University][7]

The [etcd FAQ][8] page describes it:

> For any odd-sized cluster, adding one node will always increase the number of nodes necessary for quorum. Although adding a node to an odd-sized cluster appears better since there are more machines, the fault tolerance is worse since exactly the same number of nodes may fail without losing quorum but there are more nodes that can fail. If the cluster is in a state where it can’t tolerate any more failures, adding a node before removing nodes is dangerous because if the new node fails to register with the cluster (e.g., the address is misconfigured), quorum will be permanently lost.

## Reliability Tip 2: Don't use the `count` meta-argument of terraform

Fortunate for us, KubeOne comes with a great set of [examples][9] for using terraform to set up your infrastructure. We will use the [hetzner example][3] as a base and customize it a bit.
It comes with mostly sane defaults and best practices out of the box, including a firewall and a [placement group][10] for our control-plane nodes to ensure higher reliability.

But there is a problem with this example: The usage of the [`count` meta-argument][11] for the [hcloud_server][12] definition.

At first this seems absolutely valid and an easy fix for avoiding duplicate code. But the devil lies within the details as you're about to find out.

Let's say we want to change the location of our servers, update the base images of our servers, or add/remove an SSH key.
All those changes got something in common:
They will absolutely destroy and re-create the server.

But because we are using the `count` meta-argument, we cannot update (re-create) only one server at a time. We can only replace all servers simultanously.

KubeOne deploys the [etcd][13] database on the API servers, which means if we loose all three API server nodes at the same time, we will loose all three etcd database replicas as well. And if we loose etcd, we loose our entire cluster.

Therefore, we need to replace everything with a `count` meta-argument with an explicit object.
Yes, this causes code duplication.
But it allows us to upgrade one server at a time. And after every server update, we can re-run `kubeone` to repair (or _reconcile_) our cluster. By doing so, we perform a _rolling update_ of our control plane without loosing any data.

Now, lets get to it. We have to change the code blocks in lines [95-99][14], lines [110-126][15], and lines [144-154][16].

{{% expand "main.tf before" %}}

```
resource "hcloud_server_network" "control_plane" {
  count     = var.control_plane_replicas
  server_id = element(hcloud_server.control_plane.*.id, count.index)
  subnet_id = hcloud_network_subnet.kubeone.id
}

resource "hcloud_server" "control_plane" {
  count              = var.control_plane_replicas
  name               = "${var.cluster_name}-control-plane-${count.index + 1}"
  server_type        = var.control_plane_type
  image              = var.image
  location           = var.datacenter
  placement_group_id = hcloud_placement_group.control_plane.id


  ssh_keys = [
    hcloud_ssh_key.kubeone.id,
  ]


  labels = {
    "kubeone_cluster_name" = var.cluster_name
    "role"                 = "api"
  }
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  count            = var.control_plane_replicas
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = element(hcloud_server.control_plane.*.id, count.index)
  use_private_ip   = true
  depends_on = [
    hcloud_server_network.control_plane,
    hcloud_load_balancer_network.load_balancer
  ]
}
```

{{% /expand %}}
<br/>

We have to remove the `count` meta-argument, get rid of the `element(..., count.index)` syntax and replace everything with actual references to explicit objects, so it looks like this:

{{% expand "main.tf after" %}}

```
resource "hcloud_server" "control_plane_1" {
  name               = "api-1"
  server_type        = "cx21"
  image              = "ubuntu-20.04"
  location           = "nbg1"
  placement_group_id = hcloud_placement_group.control_plane_placement.id

  ssh_keys = [
    hcloud_ssh_key.cedi_mae.name
  ]

  labels = {
    "cluster" = "k1"
    "role"    = "api"
  }
}

resource "hcloud_server_network" "control_plane_1" {
  server_id = hcloud_server.control_plane_1.id
  subnet_id = hcloud_network_subnet.kubeone.id
}

resource "hcloud_load_balancer_target" "load_balancer_target_cp1" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.control_plane_1.id
  use_private_ip   = true
  depends_on = [
    hcloud_server_network.control_plane_1,
    hcloud_load_balancer_network.load_balancer,
    hcloud_server.control_plane_1
  ]
}

resource "hcloud_server" "control_plane_2" {
  name               = "api-2"
  server_type        = "cx21"
  image              = "ubuntu-20.04"
  location           = "nbg1"
  placement_group_id = hcloud_placement_group.control_plane_placement.id

  ssh_keys = [
    hcloud_ssh_key.cedi_mae.name
  ]

  labels = {
    "cluster" = "k1"
    "role"    = "api"
  }
}

resource "hcloud_server_network" "control_plane_2" {
  server_id = hcloud_server.control_plane_2.id
  subnet_id = hcloud_network_subnet.kubeone.id
}

resource "hcloud_load_balancer_target" "load_balancer_target_cp2" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.control_plane_2.id
  use_private_ip   = true
  depends_on = [
    hcloud_server_network.control_plane_2,
    hcloud_load_balancer_network.load_balancer,
    hcloud_server.control_plane_2
  ]
}

resource "hcloud_server" "control_plane_3" {
  name               = "api-3"
  server_type        = "cx21"
  image              = "ubuntu-20.04"
  location           = "nbg1"
  placement_group_id = hcloud_placement_group.control_plane_placement.id

  ssh_keys = [
    hcloud_ssh_key.cedi_mae.name
  ]

  labels = {
    "cluster" = "k1"
    "role"    = "api"
  }
}

resource "hcloud_server_network" "control_plane_3" {
  server_id = hcloud_server.control_plane_3.id
  subnet_id = hcloud_network_subnet.kubeone.id
}

resource "hcloud_load_balancer_target" "load_balancer_target_cp3" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.control_plane_3.id
  use_private_ip   = true
  depends_on = [
    hcloud_server_network.control_plane_3,
    hcloud_load_balancer_network.load_balancer,
    hcloud_server.control_plane_3
  ]
}
```

{{% /expand %}}
<br/>

As pointed out by [EarthlingDavey](https://github.com/EarthlingDavey) in [#20](https://github.com/cedi/cedi.github.io/issues/20) this also has some implications for the output.tf, requiring us to remove the `count` meta-argument there as well.

We must up first fix the `ssh_command` ressource from lines [26-28](https://github.com/kubermatic/kubeone/blob/56f84d7c6c98760042a37aea2614fac3c783812c/examples/terraform/hetzner/output.tf#L26-L28) and also the `kubeone_hosts` from line [38-47](https://github.com/kubermatic/kubeone/blob/56f84d7c6c98760042a37aea2614fac3c783812c/examples/terraform/hetzner/output.tf#L30-L47)

{{% expand "output.tf before" %}}
output "ssh_commands" {
  value = formatlist("ssh ${var.ssh_username}@%s", hcloud_server.control_plane.*.ipv4_address)
}

output "kubeone_hosts" {
  description = "Control plane endpoints to SSH to"

  value = {
    control_plane = {
      hostnames            = hcloud_server.control_plane.*.name
      cluster_name         = var.cluster_name
      cloud_provider       = "hetzner"
      private_address      = hcloud_server_network.control_plane.*.ip
      public_address       = hcloud_server.control_plane.*.ipv4_address
      network_id           = hcloud_network.net.id
      ssh_agent_socket     = var.ssh_agent_socket
      ssh_port             = var.ssh_port
      ssh_private_key_file = var.ssh_private_key_file
      ssh_user             = var.ssh_username
    }
  }
}
{{% /expand %}}

{{% expand "output.tf after" %}}
output "ssh_commands" {
  value = [
    "ssh ${var.ssh_username}@hcloud_server.control_plane_1.ipv4_address",
    "ssh ${var.ssh_username}@hcloud_server.control_plane_2.ipv4_address",
    "ssh ${var.ssh_username}@hcloud_server.control_plane_3.ipv4_address"
  ]
}

output "kubeone_hosts" {
  description = "Control plane endpoints to SSH to"

  value = {
    control_plane = {
      cluster_name         = var.cluster_name
      cloud_provider       = "hetzner"
      network_id           = hcloud_network.net.id
      ssh_agent_socket     = var.ssh_agent_socket
      ssh_port             = var.ssh_port
      ssh_private_key_file = var.ssh_private_key_file
      ssh_user             = var.ssh_username
      hostnames = [
        hcloud_server.control_plane_1.name,
        hcloud_server.control_plane_2.name,
        hcloud_server.control_plane_3.name
      ]
      private_address = [
        hcloud_server_network.control_plane_1.ip,
        hcloud_server_network.control_plane_2.ip,
        hcloud_server_network.control_plane_3.ip
      ]
      public_address = [
        hcloud_server.control_plane_1.ipv4_address,
        hcloud_server.control_plane_2.ipv4_address,
        hcloud_server.control_plane_3.ipv4_address
      ]
    }
  }
}
{{% /expand %}}


## Reliability Tip 3: Use terraform remote backends


I'm almost certain, every single one of you ran `terraform apply` at least once on their local machine. I mean, after all, that is how terraform is supposed to be used, right?

And the sad truth is, I've seen a lot of production environments that where built exactly like that: Someone ran `terraform apply` on their local machine. And hey, now we can advertise our infrastructure as "infrastructure as code". _Technically_ this migt be correct but it is certainly not what you would expect.

To us "DevOps" or "SRE" folks it is obvious to run terraform from a CI/CD pipeline.

GitLab released [GitLab managed Terraform state][17] a while back [^2], adding a feature allowing you to securely store your [tfstate][18] within GitLab.
[^2]: [GitLab 13.0 released with Gitaly Clusters, Epic Hierarchy on Roadmaps, and Auto Deploy to ECS][19]

But there is still a problem with this approach: Many don't use GitLab. I use GitHub for the overwhelming majority of my work.
And if the pipeline executes terraform for me, I can't easily run `terraform plan` on my local machine to validate changes before pushing them. Or at least not without manually downloading the tfstate first.

But there is a solution that works from any CI/CD platform as well as the CLI, regardless of platform level integrations that allows for safe storage of the tfstate.

And that's where the terraform [remote backend][20] comes in to play.

[Backends][21] in terraform defines where the [state][18] snapshots are stored.

This particular backend uses [the terraform cloud][22] to actually run terraform for you.

Remote backends give you the greatest level of flexibility and ease as it's possible to use terraform from any (or even multiple) CI/CD pipeline platform(s) and even your local machines without worrying about keeping tfstates, and variables in sync. All Variables (and for that matter secrets as well) are stored on the terraform cloud.

You can find a tutorial on how to set up the remote backend [here][23].


## Reliability Tip 4: Configure your KubeOne.yaml correctly

If you're just starting with KubeOne, you might find a KubeOne.yaml that looks like this:

{{% expand "a basic kubeone.yaml" %}}

```
apiVersion: kubeone.io/v1beta1
kind: KubeOneCluster

versions:
  kubernetes: '1.19.3'

cloudProvider:
  hetzner: {}
  external: true
```

{{% /expand %}}
<br/>

But unfortunately - on the KubeOne documentation website - there isn't a great deal of information available on how to configure your KubeOne cluster in more depth.

But thankfully, the kubeone-cli comes with a nifty command: 

```bash
kubeone config print --full
```

This will show you all available config options with the defaults used.
KubeOne does a good job with those defaults and not much configuration is needed.


I want to deploy the "cluster-autoscaler" addon which comes right out of the box with KubeOne and is particularly useful for production-ready clusters.

I also ensure I set the MTU for canal correctly, as things tend to get a bit icky if the MTU is wrong.

{{% expand "final kubeone.yaml" %}}

```
apiVersion: kubeone.io/v1beta1
kind: KubeOneCluster

versions:
  kubernetes: '1.23.1'

clusterNetwork:
  cni:
    canal:
      mtu: 1400 # Hetzner specific 1450 bytes - 50 VXLAN bytes

cloudProvider:
  hetzner: {}
  external: true

addons:
  enable: true
  path: "./addons"
  addons:
    - name: cluster-autoscaler
```

{{% /expand %}}

## Reliability Tip 5: Configure Canal to not listen on the public network interface

Well, technically not `canal` itself but `flanel` which is a part of `canal`. Remember: `canal` is just a combination of `calico` and `flanel` [^3]
[^3]: [Comparing Kubernetes CNI Providers: Flannel, Calico, Canal, and Weave, Rancher Blog, Suse][24]

The flanel backend which is shipped as part of your canal CNI installation is by default binding on your internet facing `eth0` port[^4]. This is absolutely not what you want!
[^4]: [flanel configuration, flanel documentation, GitHub][25]

I was made aware of the problem by this GitHub issue: [hetznercloud/csi-driver#204][26]

> Is it possible that your Kubernetes nodes use their public IPs (and interfaces) instead of a private network for communication between the nodes?
> -- _[Max Rosin (@ekeih)][27]_

and a solution for the problem was pointed out in [this comment][28]:

> In my setup I use -iface-regex=10\.0\.*\.* in flannel daemonset
> -- _[Evgeniy Gurinovich (@jekakm)][29]_

The fix can be applied relatively easy via `kubectl patch`:

```bash
$ kubectl patch daemonset --namespace kube-system canal --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/1/command/-", "value": "-iface-regex=10\\.0\\.*\\.*"}]'
daemonset.apps/canal patched
```

(It is totally possible to add a step to your CI/CD pipeline that applies the mitigation for you, after you created (or reconciled) your KubeOne cluster)

## Reliability Tip 6: Deploy your worker nodes programatically

KubeOne comes with a [machine-controller][30] that can programmatically deploy worker-nodes to hetzner online using the cluster-api[^5].

[^5]: [Kubernetes Cluster API][31]

KubeOne automagically creates a default [machine-deployment][32] for you.

It's a good start, but we can do better.
Honestly, I just wouldn't bother modifying the existing machine deployment and just get rid of it:

```bash
$ kubectl --namespace kube-system delete machinedeployment prod-ready-pool1
machinedeployments.cluster.k8s.io/prod-ready-pool1 deleted
```

Better create a new machinedeployment.yaml which you should add to your Git-Repo to keep your config in sync.

When we create our worker-nodes, we want to ensure:

- To set annotations for cluster-autoscaler correctly to dynamically scale our worker-nodes
- Deploy our SSH keys to the worker-nodes, allowing easier troubleshooting
- Our worker-nodes are placed in our virtual network
- Labels are added to our worker-nodes, so the hetzner firewall can filter traffic to the worker-nodes as well

In order for the machinedeployment to work correctly, we therefore need to know a few variables:

- The min and max count of worker-nodes
- The cluster-name which is added as a label
- The network-id to place the worker-nodes in the correct virtual network
- The cluster-version as defined in our kubeone.yaml
- The datacenter location (ideally the same as the API servers)


Luckily terraform already provides us all information and we can obtain the terraform output in JSON format.

```bash
$ terraform output -json > output.json
```

And now we can determine most of the variables by using a little `jq` magic:

```bash
export AUTOSCALER_MIN=1
export AUTOSCALER_MAX=3
export NETWORK_ID=`jq -r '.kubeone_hosts.value.control_plane.network_id' output.json`
export CLUSTER_NAME=`jq -r '.kubeone_hosts.value.control_plane.cluster_name' output.json`
export CLUSTER_VERSION=`yq e -j < kubeone.yaml | jq -r '.versions.kubernetes'`
export DATACENTER_LOCATION=`jq -r '.control_plane_info.value.location' output.json`
```

Finally, we can use a template of our machinedeployment and make use of `envsubst` to render our template[^7]:

[^7]: [Invoking the envsubst program][33]

{{% expand "machinedeployment.yaml.tpl" %}}

```
apiVersion: "cluster.k8s.io/v1alpha1"
kind: MachineDeployment
metadata:
  name: "${CLUSTER_NAME}-node-pool"
  namespace: "kube-system"
  annotations:
    cluster.k8s.io/cluster-api-autoscaler-node-group-min-size: "${AUTOSCALER_MIN}"
    cluster.k8s.io/cluster-api-autoscaler-node-group-max-size: "${AUTOSCALER_MAX}"
spec:
  paused: false
  replicas: ${AUTOSCALER_MIN}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 20%
      maxUnavailable: 10%
  minReadySeconds: 60
  selector:
    matchLabels:
      node: "${CLUSTER_NAME}"
  template:
    metadata:
      labels:
        node: "${CLUSTER_NAME}"
    spec:
      providerSpec:
        value:
          cloudProvider: "hetzner"
          cloudProviderSpec:
            token:
              secretKeyRef:
                namespace: kube-system
                name: cloud-provider-credentials
                key: HZ_TOKEN
            labels:
              role: worker
              cluster: "${CLUSTER_NAME}"
            serverType: "cpx31"
            location: "${DATACENTER_LOCATION}"
            image: "ubuntu-20.04"
            networks:
              - "${NETWORK_ID}"
          operatingSystem: "ubuntu"
          operatingSystemSpec:
            distUpgradeOnBoot: false
          sshPublicKeys:
            - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOO9DMiwRjCCWvMA9TKYxRApgQx3g+owxkq9jy1YyjGN cedi@mae
      versions:
        kubelet: "${CLUSTER_VERSION}"
```

{{% /expand %}}
<br/>

```bash
envsubst < ./machinedeployment.yaml.tpl > ./machinedeployment.yaml
```

## Further Reads / Additional links and ressources

- [terraform.io/language/meta-arguments/count][11]
- [tomharrisonjr.com - Terraform count is a Miserable Hack][34]
- [GitHub.com - \[hashicorp/terraform#3885\] Changing count of instances destroys all of them][26]
- [The Definitive Guide to Kubernetes in Production][35]
- [Understanding Distributed Consensus with Raft][7]

[1]: https://shibumi.dev
[2]: https://shibumi.dev/posts/kubernetes-on-hetzner-in-2021
[3]: https://github.com/kubermatic/kubeone/tree/master/examples/terraform/hetzner
[4]: https://github.com/kubermatic/kubeone
[5]: https://github.com/kubermatic/kubeone/releases/tag/v1.4.0
[6]: https://www.terraform.io
[7]: https://kasunindrasiri.medium.com/understanding-raft-distributed-consensus-242ec1d2f521
[8]: https://etcd.io/docs/v3.3/faq/#why-an-odd-number-of-cluster-members
[9]: https://github.com/kubermatic/kubeone/tree/master/examples/terraform/
[10]: https://docs.hetzner.com/cloud/placement-groups/overview
[11]: https://www.terraform.io/language/meta-arguments/count
[12]: https://github.com/kubermatic/kubeone/blob/bbdceaff5ab1d3360f7455ab5f81dbfde73bf161/examples/terraform/hetzner/main.tf#L111
[13]: https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/
[14]: https://github.com/kubermatic/kubeone/blob/56f84d7c6c98760042a37aea2614fac3c783812c/examples/terraform/hetzner/main.tf#L95-L99
[15]: https://github.com/kubermatic/kubeone/blob/56f84d7c6c98760042a37aea2614fac3c783812c/examples/terraform/hetzner/main.tf#L110-L126
[16]: https://github.com/kubermatic/kubeone/blob/56f84d7c6c98760042a37aea2614fac3c783812c/examples/terraform/hetzner/main.tf#L144-L154
[17]: https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html
[18]: https://www.terraform.io/language/state
[19]: https://about.gitlab.com/releases/2020/05/22/gitlab-13-0-released/
[20]: https://www.terraform.io/language/settings/backends/remote
[21]: https://www.terraform.io/language/settings/backends
[22]: https://app.terraform.io
[23]: https://learn.hashicorp.com/tutorials/terraform/github-actions
[24]: https://www.suse.com/c/rancher_blog/comparing-kubernetes-cni-providers-flannel-calico-canal-and-weave/
[25]: https://github.com/flannel-io/flannel/blob/master/Documentation/configuration.md#key-command-line-options
[26]: https://github.com/hetznercloud/csi-driver/issues/204#issuecomment-849429229
[27]: https://github.com/ekeih
[28]: https://github.com/hetznercloud/csi-driver/issues/204#issuecomment-849567869
[29]: https://github.com/jekakm
[30]: https://github.com/kubermatic/machine-controller
[31]: https://cluster-api.sigs.k8s.io
[32]: https://cluster-api.sigs.k8s.io/developer/architecture/controllers/machine-deployment.html
[33]: https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html
[34]: https://tomharrisonjr.com/terraform-count-is-a-miserable-hack-d58a6ffbf422
[35]: https://www.weave.works/blog/the-definitive-guide-to-kubernetes-in-production
