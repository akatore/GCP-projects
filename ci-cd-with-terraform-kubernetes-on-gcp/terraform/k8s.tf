# here we'll create k8s resource for terraform

resource "kubernetes_deployment" "name" {
  metadata {
    name = "flaskappdeployment"
    labels = {
      "app" = "flaskappdeployment"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "flaskappdeployment"
      }
    }

    template {
      metadata {
        labels = {
          "app" = "flaskappdeployment"
        }
    }
      spec {
          container {
            name = "flask-app"
            image = var.container_image
            port {
                container_port = 8080
            }
          }
       }
    }
  }    
}

resource "google_compute_address" "appservice" {
    name = "ip-for-service"
    region = var.region
  
}

resource "kubernetes_service" "name" {
  metadata {
    labels = {
      "app" = "flaskappdeployment"
    }
  }
  spec {
    type = "LoadBalancer"
    load_balancer_ip = google_compute_address.default.address
    port {
      port = 8080
      target_port = 8080
    }
    selector = {
        "app" = "flaskappdeployment"
    }
  }
}