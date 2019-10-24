# Terraform Provider Rancher2 module

module "cattle-aws" {
  source                                     = "./modules/cattle-aws"
  rancher_api_url                            = var.rancher_api_url
  rancher_access_key                         = var.rancher_access_key
  rancher_secret_key                         = var.rancher_secret_key
  rancher_cluster_name                       = var.rancher_cluster_name
  rke_network_plugin                         = var.rke_network_plugin
  region                                     = var.region
  existing_vpc                               = var.existing_vpc
  vpc_id                                     = var.vpc_id
  subnet_id                                  = var.subnet_id
  security_group_name                        = var.security_group_name
  controlplane_instance_type                 = var.controlplane_instance_type
  worker_instance_type                       = var.worker_instance_type
  overlap_cp_etcd_worker                     = var.overlap_cp_etcd_worker
  no_overlap_nodepool_master_quantity        = var.no_overlap_nodepool_master_quantity
  no_overlap_nodepool_worker_quantity        = var.no_overlap_nodepool_worker_quantity
  overlap_node_pool_quantity                 = var.overlap_node_pool_quantity
  overlap_node_pool_hostname_prefix          = var.overlap_node_pool_hostname_prefix
  no_overlap_nodepool_master_hostname_prefix = var.no_overlap_nodepool_master_hostname_prefix
  no_overlap_nodepool_worker_hostname_prefix = var.no_overlap_nodepool_worker_hostname_prefix
  AWS_ACCESS_KEY_ID                          = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY                      = var.AWS_SECRET_ACCESS_KEY
  AWS_DEFAULT_REGION                         = var.AWS_DEFAULT_REGION
  iam_instance_profile_name                  = var.iam_instance_profile_name
  iam_instance_profile_name_worker           = var.iam_instance_profile_name_worker
  root_disk_size                             = var.root_disk_size
  request_spot_instances                     = var.request_spot_instances
  spot_price                                 = var.spot_price
  ami_id                                     = var.ami_id
  cloudwatch_monitoring                      = var.cloudwatch_monitoring
  ssh_user                                   = var.ssh_user
  zone                                       = var.zone
  vpc_cidr_block                             = var.vpc_cidr_block
}

