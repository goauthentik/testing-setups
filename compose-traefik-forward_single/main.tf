terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
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
    authentik_host                 = "http://local-server-1:9000"
    authentik_host_browser         = ""
    authentik_host_insecure        = false
    container_image                = null
    docker_labels                  = {
      "traefik.http.middlewares.authentik.forwardauth.address": "http://ak-outpost-docker:9000/outpost.goauthentik.io/auth/traefik"
      "traefik.http.middlewares.authentik.forwardauth.trustForwardHeader": "true"
      "traefik.http.middlewares.authentik.forwardauth.authResponseHeaders": "X-authentik-username,X-authentik-groups,X-authentik-email,X-authentik-name,X-authentik-uid,X-authentik-jwt,X-authentik-meta-jwks,X-authentik-meta-outpost,X-authentik-meta-provider,X-authentik-meta-app,X-authentik-meta-version"
    }
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
