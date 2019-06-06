# TK8 Cattle AWS Provisioner

Using cattle-aws provisioner with TK8

Provisioner repository: https://github.com/kubernauts/tk8-provisioner-cattle-aws

## Introduction:

The TK8’s new cattle-aws provisioner uses the Terraform’s Rancher2 Provider for creating a Kubernetes cluster on AWS via Rancher resources.

## Prerequisites:

The initial release of the provisioner requires the following things to be ready before using cattle-aws provisioner:

* A Rancher server installation.
* Rancher API URL
* Rancher API keys: access_key and secret_key. Create them from the Rancher GUI.
* AWS access key and secret key.
* Terraform 0.12

Setting Environment Variables:

The following environment variables need to be set up:

* TF_VAR_rancher_access_key - Rancher access key
* TF_VAR_rancher_secret_key - Rancher secret key
* TF_VAR_AWS_ACCESS_KEY_ID - AWS access key
* TF_VAR_AWS_SECRET_ACCESS_KEY - AWS secret key
* AWS_DEFAULT_REGION - Required for provisioner

## Getting Started:

This provisioner supports four modes of creating the Kubernetes cluster via Rancher resources.

Creating a cluster in existing VPC (overlapped controlplane, etcd, worker):

Example config.yaml:

```bash
cattle-aws:
   root_disk_size: 20
   iam_instance_profile_name: "rancher-controlplane-role"
   iam_instance_profile_worker: # specify if overlap_cp_etcd_worker is false and existing_vpc is true
   rancher_cluster_name: "cattle-aws-cluster"
   rancher_api_url: "https://rancher.xyz.com/v3"
   rancher_access_key:
   rancher_secret_key:
   rke_network_plugin: "canal"
   region: "eu-central-1"
   existing_vpc: "true"
   vpc_id: "vpc-1abcdgggga72a691a"
   subnet_id: "subnet-1f98d368767ge1e71"
   security_group_name: "rancher-nodes"
   os: "ubuntu"
   instance_type: "t2.medium"
   overlap_cp_etcd_worker: "true"
   overlap_node_pool:
      hostname_prefix: "cattle-aws-cluster"
      quantity: 1
   master_node_pool:
      hostname_prefix:
      quantity:
   worker_node_pool:
      hostname_prefix:
      quantity:
```

Creating a cluster in existing VPC (overlapped controlplane, etcd and separate worker):

Example config.yaml:

```bash
cattle-aws:
   root_disk_size: 20
   iam_instance_profile_name: "rancher-controlplane-role"
   Iam_instance_profile_worker: “rancher-worker-role”        
   rancher_cluster_name: "cattle-aws-cluster"
   rancher_api_url: "https://rancher.xyz.com/v3"
   rancher_access_key:
   rancher_secret_key:
   rke_network_plugin: "canal"
   region: "eu-central-1"
   existing_vpc: "true"
   vpc_id: "vpc-1abcdgggga72a691a"
   subnet_id: "subnet-1f98d368767ge1e71"
   security_group_name: "rancher-nodes"
   os: "ubuntu"
   instance_type: "t2.medium"
   overlap_cp_etcd_worker: "false"
   overlap_node_pool:
      hostname_prefix:
      quantity:
   master_node_pool:
      hostname_prefix:"cattle-aws-master"
      quantity: 1
   worker_node_pool:
      Hostname_prefix: “cattle-aws-worker”
      quantity: 1
```

Creating a cluster along with Infrastructure (overlapped controlplane, etcd, worker): 

Example config.yaml:

```bash
cattle-aws:
   root_disk_size: 20
   iam_instance_profile_name:
   rancher_cluster_name: "cattle-aws-cluster"
   rancher_api_url: "https://rancher.xyz.com/v3"
   rancher_access_key:
   rancher_secret_key:
   rke_network_plugin: "canal"
   region: "eu-central-1"
   existing_vpc: "false"
   vpc_id:
   subnet_id:
   security_group_name:
   os: "ubuntu"
   instance_type: "t2.medium"
   overlap_cp_etcd_worker: "true"
   overlap_node_pool:
      hostname_prefix: "cattle-aws-cluster"
      quantity: 1
   master_node_pool:
      hostname_prefix:
      quantity:
   worker_node_pool:
      hostname_prefix:
      quantity:
```

Create a cluster along with Infrastructure (overlapped controlplane,etcd and separate worker):

Example config.yaml:

```bash
cattle-aws:
   root_disk_size: 20
   iam_instance_profile_name:
   rancher_cluster_name: "cattle-aws-cluster"
   rancher_api_url: "https://rancher.xyz.com/v3"
   rancher_access_key:
   rancher_secret_key:
   rke_network_plugin: "canal"
   region: "eu-central-1"
   existing_vpc: "false"
   vpc_id:
   subnet_id:
   security_group_name:
   os: "ubuntu"
   instance_type: "t2.medium"
   aws_secret_access_key:
   aws_default_region: "eu-central-1"
   overlap_cp_etcd_worker: "false"
   overlap_node_pool:
      hostname_prefix:
      quantity:
   master_node_pool:
      hostname_prefix: "cattle-aws-master"
      quantity: 1
   worker_node_pool:
      hostname_prefix: "cattle-aws-worker"
      quantity: 1
```bash

## Cattle AWS Deplyoment

0. Build the tk8 binary and place it in you path
1. Clone `tk8` repo, switch to `cattle-aws` provisioner.
2. Set ENV vars
3. Use a config.yaml from example above
4. Run `tk8 cluster install cattle-aws`
