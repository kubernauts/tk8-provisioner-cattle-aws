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
   request_spot_instances: false
   spot_price:
   zone: "a"
   cloudwatch_monitoring: false
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
   vpc_cidr_block: # No need to specify CIDR block for existing VPC
   vpc_id: "vpc-1abcdgggga72a691a"
   subnet_id: "subnet-1f98d368767ge1e71"
   security_group_name: "rancher-nodes"
   ami_id: "test123"  
   ssh_user: "ubuntu"
   controlplane_instance_type: "t2.medium"
   worker_instance_type: "t2.large"
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
   request_spot_instances: false
   zone: "a"
   spot_price:
   cloudwatch_monitoring: false
   root_disk_size: 20
   iam_instance_profile_name: "rancher-controlplane-role"
   iam_instance_profile_worker: "rancher-worker-role"
   rancher_cluster_name: "cattle-aws-cluster"
   rancher_api_url: "https://rancher.xyz.com/v3"
   rancher_access_key:
   rancher_secret_key:
   rke_network_plugin: "canal"
   region: "eu-central-1"
   existing_vpc: "true"
   vpc_cidr_block: # No need to specify CIDR block in case of existing VPC
   vpc_id: "vpc-1abcdgggga72a691a"
   subnet_id: "subnet-1f98d368767ge1e71"
   security_group_name: "rancher-nodes"
   ami_id: "test123" 
   ssh_user: "ubuntu"
   controlplane_instance_type: "t2.medium"
   worker_instance_type: "t2.large"
   overlap_cp_etcd_worker: "false"
   overlap_node_pool:
      hostname_prefix:
      quantity:
   master_node_pool:
      hostname_prefix:"cattle-aws-master"
      quantity: 1
   worker_node_pool:
      Hostname_prefix: "cattle-aws-worker"
      quantity: 1
```

Creating a cluster along with Infrastructure (overlapped controlplane, etcd, worker):

Example `config.yaml`:

```bash
cattle-aws:
   request_spot_instances: false
   zone: "a"
   spot_price:
   cloudwatch_monitoring: false
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
   vpc_cidr_block: "10.0.0.0/16" # Specify CIDR block with new VPC
   vpc_id:
   subnet_id:
   security_group_name:
   ami_id: "test123" 
   ssh_user: "ubuntu"
   controlplane_instance_type: "t2.medium"
   worker_instance_type: "t2.large"
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
   request_spot_instances: false
   zone: "a"
   spot_price:
   cloudwatch_monitoring: false
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
   vpc_cidr_block: "10.0.0.0/16" # Specify CIDR block with new VPC
   vpc_id:
   subnet_id:
   security_group_name:
   ami_id: "test123"
   ssh_user: "ubuntu"
   controlplane_instance_type: "t2.medium"
   worker_instance_type: "t2.large"
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

1. Download the latest binary based on your platform from here - https://github.com/kubernauts/tk8/releases
2. Set environment variables.
3. Use a `config.yaml` from the above example.
4. Run `tk8ctl cluster install cattle-aws`.

## Field Reference:
* `request_spot_instances`: If you want to use spot instances for the cluster. Possible values: `true`,`false`. DO NOT keep this empty. Set it to false if spot instances are not required.

* `zone`: (Optional) The zone in which you want to launch your instances. For example, `a`. This means, the instance will be launched in `region``zone` - eu-central-1a. If not specified, Rancher will automatically choose a zone.

* `spot_price`: The spot instance bidding price. For example: "0.75". Specify this along with `request_spot_instances` to use spot instances for the cluster.

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

* `vpc_cidr_block`: (Optional) VPC CIDR block for creating the VPC with the provisioner.

* `subnet_id`: (Optional) Subnet ID. Specify if you want to create the cluster in existing VPC.

* `security_group_name`: (Optional) Security group name. Specify if you want to create the cluster in existing VPC.

* `controlplane_instance_type`: (Mandatory) Instance type for controlplane nodes. The instance type which should be used to provision controlplane nodes via Rancher. Note that in case of overlapped controlplane, etcd and worker, this field will be used. `worker_instance_type` will only be used in case of non-overlapped node pools for separate workers.

* `worker_instance_type`: (Optional) Instance type for worker nodes. This field should be specified when you want separate controlplane and worker node pools.

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

* `cloudwatch_monitoring`: (Mandatory). This is field is required to be set. This field determines if cloudwatch monitoring should be enabled for the instances. The field type is `boolean` and the possible values are `true` and `false`. Please don't keep it empty.

* `ami_id`: (Optional). Set this field if you want to use a specific AMI ID for creating instances in the cluster. It normally makes sense to keep `os` field empty while using this.

## Spot Instance Usage Caveats:
While the use of spot instances is possible, TK8 uses the following conventions on where the spot instances will be used if `request_spot_instances` and `spot_price` are set:

* Spot instances can be used for:
    * For worker nodes
    * For overlapped nodes, i.e. all nodes acting as `controlplane`, `etcd`, and `worker`
* Spot instances cannot be used for:
    * Node templates which will be used for creating a separate master node pool. In simple words, if you have `overlap_cp_etcd_worker` as `false` and are using spot instances, the spot instances will be used only for worker nodes and not master nodes. 

### Reasoning:
In the past we have seen that sometimes when a particular instance type in a particular region is requested to the user, AWS can throw unexpected errors like `capacity-oversubscribed`. In case of such errors, in worst case scenarios, if all the masters go down and AWS was not able to provide at least one spot instance, then we'll have an issue at our hands. That is why we have decided to not allow use of `spot instances` for master-only node pools.

If anyone from the community have a better reasoning to allow usage of spot instances for master-only nodes, please file an issue. We'll discuss the issues and see if we can make a better choice than this.
