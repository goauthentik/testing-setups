terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2022.6.3"
    }
  }
}

provider "authentik" {
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

resource "authentik_service_connection_docker" "local" {
  name  = "Local Docker"
  local = true
}

resource "authentik_provider_proxy" "provider" {
  name               = "whoami"
  internal_host      = ""
  external_host      = "http://whoami.127.0.0.1.nip.io"
  mode               = "forward_single"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  token_validity     = "days=30"
}

resource "authentik_application" "app" {
  name              = "whoami"
  slug              = "whoami"
  protocol_provider = authentik_provider_proxy.provider.id
}

resource "authentik_outpost" "docker" {
  name = "docker"
  protocol_providers = [
    authentik_provider_proxy.provider.id,
  ]
  service_connection = authentik_service_connection_docker.local.id
  config = jsonencode({
    log_level                      = "trace"
    docker_labels                  = null
    authentik_host                 = "http://authentik:9000"
    docker_network                 = "authentik_default"
    container_image                = null
    docker_map_ports               = true
    kubernetes_replicas            = 1
    kubernetes_namespace           = "default"
    authentik_host_browser         = ""
    object_naming_template         = "ak-outpost-%(name)s"
    authentik_host_insecure        = false
    kubernetes_service_type        = "ClusterIP"
    kubernetes_image_pull_secrets  = []
    kubernetes_disabled_components = []
    kubernetes_ingress_annotations = {}
    kubernetes_ingress_secret_name = "authentik-outpost-tls"
  })
}
