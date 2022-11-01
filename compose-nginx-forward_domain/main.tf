terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
    }
  }
}

provider "authentik" {
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

resource "authentik_provider_proxy" "provider" {
  name               = "test-apps"
  internal_host      = ""
  external_host      = "http://localhost.dev.goauthentik.io"
  cookie_domain      = "localhost.dev.goauthentik.io"
  mode               = "forward_domain"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  token_validity     = "days=30"
}

resource "authentik_application" "app" {
  name              = "test-apps"
  slug              = "test-apps"
  protocol_provider = authentik_provider_proxy.provider.id
}

resource "authentik_outpost" "docker" {
  name = "docker"
  protocol_providers = [
    authentik_provider_proxy.provider.id,
  ]
  config = jsonencode({
    authentik_host                 = "http://local-server-1:9000"
    authentik_host_browser         = ""
    authentik_host_insecure        = false
    container_image                = null
    docker_labels                  = null
    docker_map_ports               = false
    docker_network                 = "local_default"
    kubernetes_disabled_components = []
    kubernetes_image_pull_secrets  = []
    kubernetes_ingress_annotations = {}
    kubernetes_ingress_secret_name = "authentik-outpost-tls"
    kubernetes_namespace           = "default"
    kubernetes_replicas            = 1
    kubernetes_service_type        = "ClusterIP"
    log_level                      = "trace"
    object_naming_template         = "ak-outpost-%(name)s"
  })
}
