variable "rancher_api_url" {
  description = "Rancher API URL"
  type        = "string"
}

variable "rancher_access_key" {
  description = "Rancher server's access key"
}

variable "rancher_secret_key" {
  description = "Rancher server's secret key"
}

variable "rancher_cluster_name" {
  description = "Rancher cluster name"
  type        = "string"
}

variable "rke_network_plugin" {
  description = "Network plugin for cluster"
  type        = "string"
}

variable "region" {
  description = "AWS region"
  type        = "string"
}

variable "existing_vpc" {
  description = "Use existing VPC for creating clusters"
  type        = "string"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "subnet_id" {
  description = "subnet id"
  type        = "string"
}

variable "security_group_name" {
  description = "security group id"
  type        = "string"
}

variable "os" {
  description = "os name"
  type        = "string"
}

variable "worker_instance_type" {
  description = "Instance type"
  type        = "string"
}

variable "overlap_node_pool_hostname_prefix" {
  description = "Hostname prefix for overlapped node pools"
  type        = "string"
}

variable "no_overlap_nodepool_master_hostname_prefix" {
  description = "Hostname prefix for master node pool"
  type        = "string"
}

variable "no_overlap_nodepool_worker_hostname_prefix" {
  description = "Hostname prefix for worker node pool"
  type        = "string"
}

variable "overlap_cp_etcd_worker" {
  description = "Overlapping planes for node template"
  type        = "string"
}

variable "no_overlap_nodepool_master_quantity" {
  description = "Node pool master quantity for non-overlapped planes"
  type        = "string"
}

variable "no_overlap_nodepool_worker_quantity" {
  description = "Node pool worker quantity for non-overlapped planes"
  type        = "string"
}

variable "overlap_node_pool_quantity" {
  description = "Node pool quantity for overlap planes"
  type        = "string"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret key"
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS default region"
}

variable "aws_rancher_sg_ing_defaults" {
  description = "Inbound rules for rancher security group"
  type        = "list"
  default     = ["80", "6443", "2376", "443"]
}

variable "aws_rancher_sg_ing_self1" {
  description = "Inbound rules for rancher security group"
  type        = "map"

  default = {
    "protocol" = "tcp,tcp,udp,udp,udp"
    "from"     = "30000,8472,30000,4789,10256"
    "to"       = "32767,8472,32767,4789,10256"
  }
}

variable "aws_rancher_sg_ing_nodeport" {
  description = "Inbound rules for nodeport"
  type        = "map"

  default = {
    "protocol" = "tcp,udp"
    "from"     = "30000,30000"
    "to"       = "32767,32767"
  }
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = "string"
}

variable "iam_instance_profile_name_worker" {
  default     = ""
  description = "IAM instance profile name for worker"
  type        = "string"
}

variable "root_disk_size" {
  default     = ""
  description = "Root disk size in GB"
  type        = "string"
}

variable "request_spot_instances" {
  description = "Request spot instances for the node template"
  type        = string
}

variable "spot_price" {
  default     = ""
  description = "Spot instances price for node template"
  type        = string
}

variable "controlplane_instance_type" {
  default     = ""
  description = "Controlplane instance type"
  type        = "string"
}

variable "ami_id" {
  default     = ""
  description = "AMI id for the instance"
  type        = "string"
}

variable "cloudwatch_monitoring" {
  default     = ""
  description = "Enable/Disable cloudwatch monitoring for instances"
  type        = "string"
}

variable "ssh_user" {
  description = "SSH user"
  type        = "string"
}