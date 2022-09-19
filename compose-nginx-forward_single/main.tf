terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
    }
  }
}

provider "authentik" {
}
