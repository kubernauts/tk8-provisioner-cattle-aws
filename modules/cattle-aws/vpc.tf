resource "random_string" "cluster_id" {
  length           = 16
  special          = true
  override_special = "/@\" "
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "rancher-vpc" {
  count                = var.existing_vpc ? 0 : 1
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = map(
    "Name", "${var.rancher_cluster_name}-rancher-vpc",
    "kubernetes.io/cluster/${random_string.cluster_id.result}", "owned",
  )
}

resource "aws_subnet" "rancher-subnet" {
  count = var.existing_vpc ? 0 : 1

  #count = 1

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.rancher-vpc[count.index].id
  tags = map(
    "Name", "${var.rancher_cluster_name}-rancher",
    "kubernetes.io/cluster/${random_string.cluster_id.result}", "owned",
  )
}

resource "aws_internet_gateway" "rancher-ig" {
  count  = var.existing_vpc ? 0 : 1
  vpc_id = aws_vpc.rancher-vpc[count.index].id

  tags = {
    Name = "${var.rancher_cluster_name}-rancher-igw"
  }
}

resource "aws_route_table" "rancher-rt" {
  count  = var.existing_vpc ? 0 : 1
  vpc_id = aws_vpc.rancher-vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rancher-ig[count.index].id
  }
}

resource "aws_route_table_association" "rancher-rta" {
  count = var.existing_vpc ? 0 : 1

  #count = 1

  subnet_id      = aws_subnet.rancher-subnet.*.id[count.index]
  route_table_id = aws_route_table.rancher-rt[count.index].id
}
