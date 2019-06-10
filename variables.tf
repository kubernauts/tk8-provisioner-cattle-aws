variable "request_spot_instances" {
  default     = false
  description = "Request spot instances for the node template"
  type        = string
}

variable "spot_price" {
  default     = ""
  description = "Spot instances price for node template"
  type        = string
}

variable "root_disk_size" {
  default     = "20"
  description = "Root disk size for instances in GB"
  type        = string
}

variable "iam_instance_profile_name_worker" {
  default     = ""
  description = "IAM instance profile name for worker"
  type        = string
}

variable "iam_instance_profile_name" {
  default     = ""
  description = "IAM instance profile name"
  type        = string
}

variable "rancher_api_url" {
  default     = "https://rancher.kubernauts.de/v3"
  description = "Rancher API URL"
  type        = string
}

variable "rancher_access_key" {
  description = "Rancher server's access key"
}

variable "rancher_secret_key" {
  description = "Rancher server's secret key"
}

variable "rancher_cluster_name" {
  default     = "cattle-aws-demo"
  description = "Rancher cluster name"
  type        = string
}

variable "rke_network_plugin" {
  default     = "canal"
  description = "Network plugin for cluster"
  type        = string
}

variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
  type        = string
}

variable "existing_vpc" {
  default     = false
  description = "Use existing VPC for creating clusters"
  type        = string
}

variable "vpc_id" {
  default     = ""
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  default     = ""
  description = "subnet id"
  type        = string
}

variable "security_group_name" {
  default     = ""
  description = "security group id"
  type        = string
}

variable "os" {
  default     = "ubuntu"
  description = "ami id - frankfurt"
  type        = string
}

variable "instance_type" {
  default     = "t2.medium"
  description = "Instance type"
  type        = string
}

variable "overlap_cp_etcd_worker" {
  default     = true
  description = "Overlapping planes for node template"
  type        = string
}

variable "overlap_node_pool_hostname_prefix" {
  default     = "cattle-aws-demo"
  description = "Hostname prefix for overlapped node pools"
  type        = string
}

variable "no_overlap_nodepool_master_hostname_prefix" {
  default     = ""
  description = "Hostname prefix for master node pool"
  type        = string
}

variable "no_overlap_nodepool_worker_hostname_prefix" {
  default     = ""
  description = "Hostname prefix for worker node pool"
  type        = string
}

variable "no_overlap_nodepool_master_quantity" {
  default     = ""
  description = "Node pool master quantity for non-overlapped planes"
  type        = string
}

variable "no_overlap_nodepool_worker_quantity" {
  default     = ""
  description = "Node pool worker quantity for non-overlapped planes"
  type        = string
}

variable "overlap_node_pool_quantity" {
  default     = "1"
  description = "Node pool quantity for overlap planes"
  type        = string
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

