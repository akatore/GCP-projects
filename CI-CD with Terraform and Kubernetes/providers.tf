terraform {
  required_version = ">=0.12"
  backend "gcs" {
    
  }
}

# Google provider block
provider "google" {
  project = var.project_id
  region = var.region

}

provider "kubernetes" {
  host = google_container_cluster.default  # we can fine our host google_container_cluster.default because we have created, we need endpoint of our cluster
  token = data.google_client_config.current # we can get token from google_client_config
  client_certificate = base64decode(google_container_cluster.default.master_auth[0].client_certificate)
  client_key = base64decode(google_container_cluster.default.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)

}