resource "random_string" "rancher_cloud_cred_random" {
  upper            = false
  length           = 8
  special          = false
  override_special = "/@\" "
}

# Provider config
provider "rancher2" {
  api_url    = var.rancher_api_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

resource "rancher2_cloud_credential" "test" {
  name = "test-${random_string.rancher_cloud_cred_random.result}"

  amazonec2_credential_config {
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
  }
}
