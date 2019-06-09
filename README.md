# TK8 Cattle AWS Provisioner

Using cattle-aws provisioner with TK8

## Introduction:

The TK8’s new cattle-aws provisioner uses the Terraform’s Rancher2 Provider for creating a Kubernetes cluster on AWS via Rancher resources.

## Prerequisites:

The initial release of the provisioner requires the following things to be ready before using cattle-aws provisioner:

* A Rancher server installation.
* Rancher API URL
* Rancher API keys: `access_key` and `secret_key`. Create them from the Rancher GUI.
* AWS access key and secret key.
* Terraform 0.12

## Setting Environment Variables:

The following environment variables need to be set up:

* `TF_VAR_rancher_access_key` - Rancher access key
* `TF_VAR_rancher_secret_key` - Rancher secret key
* `TF_VAR_AWS_ACCESS_KEY_ID` - AWS access key
* `TF_VAR_AWS_SECRET_ACCESS_KEY` - AWS secret key
* `TF_VAR_AWS_DEFAULT_REGION` - AWS default region
* `AWS_DEFAULT_REGION` - Required for provisioner
* `AWS_ACCESS_KEY_ID` - AWS access key
* `AWS_SECRET_ACCESS_KEY` - AWS secret key

## Getting Started:

This provisioner supports four modes of creating the Kubernetes cluster via Rancher resources.

Creating a cluster in existing VPC (overlapped controlplane, etcd, worker):

Example `config.yaml`:

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

Example `config.yaml`:

```bash
cattle-aws:
   root_disk_size: 20
   iam_instance_profile_name: "rancher-controlplane-role"
   iam_instance_profile_worker: “rancher-worker-role”
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

Example `config.yaml`:

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

Example `config.yaml`:

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
```

## Cattle AWS Deployment

1. Donwload the latest binary based on your platform from here - https://github.com/kubernauts/tk8/releases
2. Set environment variables.
3. Use a `config.yaml` from the above example.
4. Run `tk8 cluster install cattle-aws`.

## Field Reference:

* `root_disk_size`: Root disk size for instances.

* `iam_instance_profile_name`: IAM instance profile name. Specify this only if you want to create a cluster in existing VPC. See - https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/options/cloud-providers/ for details on how to create if it doesn’t exist.

* `iam_instance_profile_worker`: IAM instance profile name for worker. Specify this only if you want to create a cluster in existing VPC and you want to use different node pools for master/etcd and worker. In other words, if you want to have a separate master/etcd and a separate worker, specify this. If this is not yet created, please create it because, with existing_vpc, we expect you to have AWS resources ready (except instances). See - https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/options/cloud-providers/ for details on how to create if it doesn’t exist.

* `rancher_cluster_name`: Kubernetes cluster name which will be created via Rancher.

* `rancher_api_url`: The API URL for rancher server.

* `rancher_access_key`: Rancher access key. DO NOT specify it here. This is mentioned here because the user needs to know that it is required. You are supposed to set this via environment variable `TF_VAR_rancher_access_key`.

* `rancher_secret_key`: Rancher secret key. §This is mentioned here because it is required. You are supposed to set this via environment variable `TF_VAR_rancher_secret_key`.

* `rke_network_plugin`: (Mandatory) The network plugin to be used to create a Kubernetes cluster. See the possible values here - https://rancher.com/docs/rke/latest/en/config-options/add-ons/network-plugins/

* `region`: (Mandatory) The AWS region in which you want to deploy the cluster.

* `existing_vpc`: (Optional) Specify this if you want to create the cluster in existing VPC. Else, keep it blank. The possible values for this field are boolean values: true and false.

* `vpc_id`: (Optional) VPC ID. Specify if you want to create the cluster in existing VPC.

* `subnet_id`: (Optional) Subnet ID. Specify if you want to create the cluster in existing VPC.

* `security_group_name`: (Optional) Security group name. Specify if you want to create the cluster in existing VPC.

* `os`: (Mandatory) Operating System. The operating system you want to use for instances.

* `instance_type`: (Mandatory) Instance type. The instance type which should be used to provision instances via Rancher.

* `overlap_cp_etcd_worker`: (Mandatory) If the cluster going to be an overlapped one. This means all instances will have the roles: Control Plane, Etcd, and Worker. This is similar to checkmark all the options via Rancher GUI while setting up node pools. The possible values for this field are boolean values: `true` and `false`.

* `overlap_node_pool`: (Not required). You are not supposed to set any value for this as this functions as a parent key for the below properties. Set below properties if you want to create an overlapped node pool. That means the instances inside the node pool will have all the roles: `Control Plane`, `Etcd`, `Worker`.

    * `hostname_prefix`: (Required). This field is required to be set if you want to create an overlapped node pool. The hostname prefix’s value can be any `string`.

    * `quantity`: (Required). This field is required to be set if you want to create an overlapped node pool. The possible value for this field is of `numeric` type. 

* `master_node_pool`: (Not required). You are not supposed to set any value for this as this functions as a parent key for the below properties. Set below properties if you want to create a separate node pool for master nodes.

    * `hostname_prefix`: (Required). This field is required to be set if you want to create an overlapped node pool. The hostname prefix’s value can be any string.

    * `quantity`: (Required). This field is required to be set if you want to create an overlapped node pool. The possible value for this field is of numeric type. 

* `worker_node_pool`: (Not required). You are not supposed to set any value for this as this functions as a parent key for the below properties. Set below properties if you want to create a separate node pool for worker nodes.

    * `hostname_prefix`: (Required). This field is required to be set if you want to create an overlapped node pool. The hostname prefix’s value can be any `string`.

    * `quantity`: (Required). This field is required to be set if you want to create an overlapped node pool. The possible value for this field is of `numeric` type. 	
