locals {
  create_ing_rules = "${var.existing_vpc ? 0 : 1}"
}

resource "aws_security_group" "rancher_security_group" {
  count       = "${var.security_group_name != "" ? 0 : 1}"
  name        = "rancher-sg-1"
  description = "Allow inbound/outbound traffic for rancher"
  vpc_id      = "${aws_vpc.rancher-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "${random_string.cluster_id.result}" = "owned"
  }
}

resource "aws_security_group_rule" "ingress_rule" {
  count     = "${var.security_group_name != "" ? 0 : 1}"
  type      = "ingress"
  protocol  = "tcp"
  from_port = "2379"
  to_port   = "2380"
  self      = true

  #cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.rancher_security_group.id}"
}

resource "aws_security_group_rule" "ingress_rule1" {
  count     = "${var.security_group_name != "" ? 0 : 1}"
  type      = "ingress"
  protocol  = "tcp"
  from_port = "10250"
  to_port   = "10252"
  self      = true

  #cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.rancher_security_group.id}"
}

resource "aws_security_group_rule" "ingress_world" {
  count = "${length(var.aws_rancher_sg_ing_defaults) * local.create_ing_rules}"

  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(var.aws_rancher_sg_ing_defaults, count.index)}"
  to_port     = "${element(var.aws_rancher_sg_ing_defaults, count.index)}"

  security_group_id = "${aws_security_group.rancher_security_group.id}"
}

resource "aws_security_group_rule" "ingress_self" {
  count = "${length(split(",", var.aws_rancher_sg_ing_self1["protocol"])) * local.create_ing_rules}"

  type      = "ingress"
  protocol  = "${element(split(",", var.aws_rancher_sg_ing_self1["protocol"]), count.index)}"
  self      = true
  from_port = "${element(split(",", var.aws_rancher_sg_ing_self1["from"]), count.index)}"
  to_port   = "${element(split(",", var.aws_rancher_sg_ing_self1["to"]), count.index)}"

  security_group_id = "${aws_security_group.rancher_security_group.id}"
}

resource "aws_security_group_rule" "ingress_nodeport_svc" {
  count = "${length(split(",", var.aws_rancher_sg_ing_nodeport["protocol"])) * local.create_ing_rules}"

  type        = "ingress"
  protocol    = "${element(split(",", var.aws_rancher_sg_ing_nodeport["protocol"]), count.index)}"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(split(",", var.aws_rancher_sg_ing_nodeport["from"]), count.index)}"
  to_port     = "${element(split(",", var.aws_rancher_sg_ing_nodeport["to"]), count.index)}"

  security_group_id = "${aws_security_group.rancher_security_group.id}"
}
