terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2022.6.3"
    }
  }
}

provider "authentik" {
}
