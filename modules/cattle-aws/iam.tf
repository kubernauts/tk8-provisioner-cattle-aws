resource "random_string" "iam_random_string" {
  upper            = false
  length           = 10
  special          = false
  override_special = "/@\" "
}

# Rancher control plane IAM roles
resource "aws_iam_role" "rancher_controlplane_role" {
  count              = "${! var.existing_vpc ? 1 : 0}"
  name               = "rancher_controlplane_role_${random_string.iam_random_string.result}"
  assume_role_policy = "${file("${path.module}/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "rancher_controlplane_policy" {
  count       = "${! var.existing_vpc ? 1 : 0}"
  name        = "rancher-controlplane-policy-${random_string.iam_random_string.result}"
  description = "Rancher controlplane policy"
  policy      = "${file("${path.module}/rancher-controlplane-policy.json")}"
}

resource "aws_iam_policy_attachment" "rancher-controlplane-attachment" {
  count      = "${! var.existing_vpc ? 1 : 0}"
  name       = "rancher-controlplane-attachment"
  roles      = ["${aws_iam_role.rancher_controlplane_role.name}"]
  policy_arn = "${aws_iam_policy.rancher_controlplane_policy.arn}"
}

resource "aws_iam_instance_profile" "rancher_controlplane_profile" {
  count = "${! var.existing_vpc ? 1 : 0}"
  name  = "rancher_controlplane_profile_${random_string.iam_random_string.result}"
  role  = "${aws_iam_role.rancher_controlplane_role.name}"
}

# Rancher worker iam role
resource "aws_iam_role" "rancher_worker_role" {
  count              = "${! var.existing_vpc ? 1 : 0}"
  name               = "rancher_worker_role_${random_string.iam_random_string.result}"
  assume_role_policy = "${file("${path.module}/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "rancher_worker_policy" {
  count       = "${! var.existing_vpc ? 1 : 0}"
  name        = "rancher-worker-policy-${random_string.iam_random_string.result}"
  description = "Rancher worker policy"
  policy      = "${file("${path.module}/rancher-worker-policy.json")}"
}

resource "aws_iam_policy_attachment" "rancher-worker-attachment" {
  count      = "${! var.existing_vpc ? 1 : 0}"
  name       = "rancher-worker-attachment"
  roles      = ["${aws_iam_role.rancher_worker_role.name}"]
  policy_arn = "${aws_iam_policy.rancher_worker_policy.arn}"
}

resource "aws_iam_instance_profile" "rancher_worker_profile" {
  count = "${! var.existing_vpc ? 1 : 0}"
  name  = "rancher_worker_profile_${random_string.iam_random_string.result}"
  role  = "${aws_iam_role.rancher_worker_role.name}"
}
