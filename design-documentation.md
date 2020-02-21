# Implementation Details for RKE templates with Cattle-AWS-Provisioner

This document describes the outlined plan for integrating rke templates with Tk8's `cattle-aws` provisioner.

## What are RKE templates?

See - https://rancher.com/docs/rancher/v2.x/en/admin-settings/rke-templates/

Terraform Resource - https://www.terraform.io/docs/providers/rancher2/r/clusterTemplate.html


## Example `config.yaml` with RKE template integration:

```bash
cattle-aws-rke-template:
   create_rke_template: true
   rke_template_name: test
   rke_template_config:
      description: "Test cluster config template"
      members:
         access_type: "owner"
 	 user_principal_id: "local://user-XXXXX"
      template_revisions:
         name: "v1"
	 enable_template_revision: true
      cluster_config:
	 enable_cluster_alerting:
	 enable_cluster_monitoring:
	 enable_network_policy:
      rke_config:


```

Please note that this is not the complete set of options which will be available for configuration.

For example, `rke_template_config` can include more options for configurations.

## How can I use RKE templates to create new clusters?

See - https://www.terraform.io/docs/providers/rancher2/r/cluster.html

The relevant part is:

```bash
resource "rancher2_cluster_template" "foo" {
  name = "foo"
  members {
    access_type = "owner"
    user_principal_id = "local://user-XXXXX"
  }
  template_revisions {
    name = "V1"
    cluster_config {
      rke_config {
        network {
          plugin = "canal"
        }
        services {
          etcd {
            creation = "6h"
            retention = "24h"
          }
        }
      }
    }
    default = true
  }
  description = "Test cluster template v2"
}
# Create a new rancher2 RKE Cluster from template
resource "rancher2_cluster" "foo" {
  name = "foo"
  cluster_template_id = "${rancher2_cluster_template.foo.id}"
  cluster_template_revision_id = "${rancher2_cluster_template.foo.template_revisions.0.id}"
}
```

The plan is to create an additional `rancher2_cluster_template` resource with additional configuration options which can be specified alongside node templates.

## Why RKE templates?

Currently, in `cattle-aws` provisioner, we are specifying only a handful of customization options:

```bash
  rke_config {
    network {
      plugin = var.rke_network_plugin
    }

    cloud_provider {
      name = "aws"
    }
  }
```  

For better granular control on the cluster configuration options, we create RKE templates with required configuration.

The benefit of this is that, you will need to create an RKE template only once. After that, the same RKE template can be used to configure the same set of options for creating `n` number of new clusters.

There is, however, another way to achieve this. We can specify the same set of options everytime we create a new cluster which is not great since Rancher already have provided a feature for avoiding the repetition.
 
## Why to integrate RKE templates only with `cattle-aws` provisioner and not others?

At the moment, we can only reuse RKE templates for the below Rancher provisioners:
* Amazon EC2 provisioner
* Azure provisioner
* DigitalOcean provisioner
* vSphere provisioner

In short, we can only reuse RKE templates when the cluster is created and owned by Rancher itself. We cannot use RKE templates to create clusters via managed services, for example, Rancher's Amazon EKS provisioner.

Besides, at the moment, Tk8 only has integration with Rancher's `Amazon EC2 provisioner` via `cattle-aws`. If any new provisioners are added to rancher for the remaining options, I'd highly recommend to integrate RKE templates with them as well.

## Why a different configuration block for RKE templates?

There are a few reasons for this:
* Simplicity. We don't want users to get confused when they see a loooong list of options they need to configure to create the clusters.
* For those who don't need this customization, they can continue with `cattle-aws` provisioner since it works just fine.
* Reducing clutter. Mixing two different configuration options only increases clutter in the `config.yaml`.
* Configuring options in terraform module gets difficult and complicated. Adding a new set of options in the already complicated Terraform module is not a great idea. I'd suggest to create a new terraform module for this and conditionally use any one module based on user input. See https://github.com/kubernauts/tk8-provisioner-cattle-eks for a working example.

## Disclaimer

The code in this repository is not complete. Work needs to be done in creating a different terraform module and integrate it with the go code (the traditional Tk8 way).

## Any questions/issues/help needed

I'd be happy to answer any questions, resolve any issues or help in implementation.

 