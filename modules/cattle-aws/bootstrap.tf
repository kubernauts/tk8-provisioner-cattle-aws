# Provider config
# Create a new rancher2 rke Cluster
resource "rancher2_cluster" "rancher-custom" {
  name        = var.rancher_cluster_name
  description = "${var.rancher_cluster_name} Kubernetes cluster"

  rke_config {
    network {
      plugin = var.rke_network_plugin
    }

    cloud_provider {
      name = "aws"
    }
  }
}

# Create a new rancher2 Node Template
resource "rancher2_node_template" "rancher_existing_vpc" {
  count               = var.existing_vpc && ! var.request_spot_instances ? 1 : 0
  name                = "${var.rancher_cluster_name}_node_template"
  description         = "${var.rancher_cluster_name}_node_template node template"
  cloud_credential_id = rancher2_cloud_credential.test.id
  engine_install_url  = "https://releases.rancher.com/install-docker/18.09.sh"

  amazonec2_config {
    ami                  = data.aws_ami.distro.id
    region               = var.region
    security_group       = [var.security_group_name]
    subnet_id            = var.subnet_id
    vpc_id               = var.vpc_id
    zone                 = ""
    iam_instance_profile = var.iam_instance_profile_name
    instance_type        = var.instance_type
    root_size            = var.root_disk_size
  }
}

# Create a new rancher2 Node Template
resource "rancher2_node_template" "rancher_no_existing_vpc" {
  count               = ! var.existing_vpc && ! var.overlap_cp_etcd_worker ? 1 : 0
  name                = "${var.rancher_cluster_name}_node_template"
  description         = "${var.rancher_cluster_name}_node_template node template"
  cloud_credential_id = rancher2_cloud_credential.test.id
  engine_install_url  = "https://releases.rancher.com/install-docker/18.09.sh"

  amazonec2_config {
    ami    = data.aws_ami.distro.id
    region = var.region

    security_group       = [aws_security_group.rancher_security_group[count.index].name]
    subnet_id            = aws_subnet.rancher-subnet[count.index].id
    vpc_id               = aws_vpc.rancher-vpc[count.index].id
    zone                 = ""
    iam_instance_profile = aws_iam_instance_profile.rancher_controlplane_profile[count.index].name
    instance_type        = var.instance_type
    root_size            = var.root_disk_size
  }
}

resource "rancher2_node_template" "rancher_overlap_spot" {
  count               = var.existing_vpc && var.request_spot_instances && var.overlap_cp_etcd_worker ? 1 : 0
  name                = "${var.rancher_cluster_name}_node_template"
  description         = "${var.rancher_cluster_name}_node_template node template"
  cloud_credential_id = rancher2_cloud_credential.test.id
  engine_install_url  = "https://releases.rancher.com/install-docker/18.09.sh"

  amazonec2_config {
    ami                   = data.aws_ami.distro.id
    region                = var.region
    security_group        = [var.security_group_name]
    subnet_id             = var.subnet_id
    vpc_id                = var.vpc_id
    zone                  = ""
    request_spot_instance = var.request_spot_instances
    spot_price            = var.spot_price
    iam_instance_profile  = var.iam_instance_profile_name
    instance_type         = var.instance_type
    root_size             = var.root_disk_size
  }
}

resource "rancher2_node_template" "rancher_no_existing_vpc_spot" {
  count               = ! var.existing_vpc && var.request_spot_instances && var.overlap_cp_etcd_worker ? 1 : 0
  name                = "${var.rancher_cluster_name}_node_template"
  description         = "${var.rancher_cluster_name}_node_template node template"
  cloud_credential_id = rancher2_cloud_credential.test.id
  engine_install_url  = "https://releases.rancher.com/install-docker/18.09.sh"

  amazonec2_config {
    ami    = data.aws_ami.distro.id
    region = var.region

    security_group        = [aws_security_group.rancher_security_group[count.index].name]
    subnet_id             = aws_subnet.rancher-subnet[count.index].id
    vpc_id                = aws_vpc.rancher-vpc[count.index].id
    zone                  = ""
    request_spot_instance = var.request_spot_instances
    spot_price            = var.spot_price
    iam_instance_profile  = aws_iam_instance_profile.rancher_controlplane_profile[count.index].name
    instance_type         = var.instance_type
    root_size             = var.root_disk_size
  }
}

# Create a new rancher2 overlapped Node Pool if overlap_cp_etcd_worker is set
resource "rancher2_node_pool" "rancher_overlap" {
  count           = var.overlap_cp_etcd_worker && var.existing_vpc ? 1 : 0
  cluster_id      = rancher2_cluster.rancher-custom.id
  name            = "${var.rancher_cluster_name}-node-pool"
  hostname_prefix = var.overlap_node_pool_hostname_prefix

  node_template_id = rancher2_node_template.rancher_overlap_spot[count.index]
  quantity         = var.overlap_node_pool_quantity
  control_plane    = true
  etcd             = true
  worker           = true
}

resource "rancher2_node_pool" "rancher_overlap_no_existing_vpc" {
  count           = var.overlap_cp_etcd_worker && ! var.existing_vpc ? 1 : 0
  cluster_id      = rancher2_cluster.rancher-custom.id
  name            = "${var.rancher_cluster_name}-node-pool"
  hostname_prefix = var.overlap_node_pool_hostname_prefix

  node_template_id = rancher2_node_template.rancher_no_existing_vpc_spot[count.index].id
  quantity         = var.overlap_node_pool_quantity
  control_plane    = true
  etcd             = true
  worker           = true
}

resource "rancher2_node_template" "rancher_worker_no_existing_vpc_no_overlap" {
  count               = ! var.overlap_cp_etcd_worker && ! var.existing_vpc ? 1 : 0
  name                = "${var.rancher_cluster_name}_worker_node_template"
  description         = "${var.rancher_cluster_name}_worker_node_template node template"
  cloud_credential_id = rancher2_cloud_credential.test.id
  engine_install_url  = "https://releases.rancher.com/install-docker/18.09.sh"

  amazonec2_config {
    ami                   = data.aws_ami.distro.id
    region                = var.region
    security_group        = [aws_security_group.rancher_security_group[count.index].name]
    subnet_id             = aws_subnet.rancher-subnet[count.index].id
    vpc_id                = aws_vpc.rancher-vpc[count.index].id
    zone                  = ""
    request_spot_instance = var.request_spot_instances
    spot_price            = var.spot_price
    iam_instance_profile  = aws_iam_instance_profile.rancher_worker_profile[count.index].name
    instance_type         = var.instance_type
  }
}

resource "rancher2_node_template" "rancher_worker_existing_vpc_no_overlap" {
  count               = ! var.overlap_cp_etcd_worker && var.existing_vpc ? 1 : 0
  name                = "${var.rancher_cluster_name}_worker_node_template"
  description         = "${var.rancher_cluster_name}_worker_node_template node template"
  cloud_credential_id = rancher2_cloud_credential.test.id
  engine_install_url  = "https://releases.rancher.com/install-docker/18.09.sh"

  amazonec2_config {
    ami                   = data.aws_ami.distro.id
    region                = var.region
    security_group        = [var.security_group_name]
    subnet_id             = var.subnet_id
    vpc_id                = var.instance_type
    zone                  = ""
    request_spot_instance = var.request_spot_instances
    spot_price            = var.spot_price
    iam_instance_profile  = aws_iam_instance_profile.rancher_worker_profile[count.index].name
    instance_type         = var.instance_type
  }
}

# Create a new rancher2 master Node Pool
resource "rancher2_node_pool" "rancher_master_existing_vpc" {
  count            = ! var.overlap_cp_etcd_worker && var.existing_vpc ? 1 : 0
  cluster_id       = rancher2_cluster.rancher-custom.id
  name             = "${var.rancher_cluster_name}-master-node-pool"
  hostname_prefix  = var.no_overlap_nodepool_master_hostname_prefix
  node_template_id = rancher2_node_template.rancher_existing_vpc[count.index].id
  quantity         = var.no_overlap_nodepool_master_quantity
  control_plane    = true
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "rancher_master_no_existing_vpc" {
  count            = ! var.overlap_cp_etcd_worker && ! var.existing_vpc ? 1 : 0
  cluster_id       = rancher2_cluster.rancher-custom.id
  name             = "${var.rancher_cluster_name}-master-node-pool"
  hostname_prefix  = var.no_overlap_nodepool_master_hostname_prefix
  node_template_id = rancher2_node_template.rancher_no_existing_vpc[count.index].id
  quantity         = var.no_overlap_nodepool_master_quantity
  control_plane    = true
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "rancher_worker_no_overlap_existing_vpc" {
  count            = ! var.overlap_cp_etcd_worker && var.existing_vpc ? 1 : 0
  cluster_id       = rancher2_cluster.rancher-custom.id
  name             = "${var.rancher_cluster_name}-worker-node-pool"
  hostname_prefix  = var.no_overlap_nodepool_worker_hostname_prefix
  node_template_id = rancher2_node_template.rancher_worker_existing_vpc_no_overlap[count.index].id
  quantity         = var.no_overlap_nodepool_worker_quantity
  control_plane    = false
  etcd             = false
  worker           = true
}

resource "rancher2_node_pool" "rancher_worker_no_overlap_no_existing_vpc" {
  count            = ! var.overlap_cp_etcd_worker && ! var.existing_vpc ? 1 : 0
  cluster_id       = rancher2_cluster.rancher-custom.id
  name             = "${var.rancher_cluster_name}-worker-node-pool"
  hostname_prefix  = var.no_overlap_nodepool_worker_hostname_prefix
  node_template_id = rancher2_node_template.rancher_worker_no_existing_vpc_no_overlap[count.index].id
  quantity         = var.no_overlap_nodepool_worker_quantity
  control_plane    = false
  etcd             = false
  worker           = true
}
