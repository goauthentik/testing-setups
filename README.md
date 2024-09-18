<p align="center">
    <img src="https://goauthentik.io/img/icon_top_brand_colour.svg" height="150" alt="authentik logo">
</p>

---

[![](https://img.shields.io/discord/809154715984199690?label=Discord&style=for-the-badge)](https://discord.gg/jg33eMhnj6)

> [!WARNING]  
> These test files are now part of the authentik e2e tests, see https://github.com/goauthentik/authentik/pull/11374

# authentik testing setups

authentik docker-compose and kubernetes setups for forward auth in various configurations

## Required local tools

- docker-compose (v2 preferred, see https://docs.docker.com/compose/install/)
- Terraform (1.0+, see https://developer.hashicorp.com/terraform/downloads)

## Run (docker-compose)

`make compose-local` will setup a local docker-compose authentik install. Afterwards, check the `README.md` in one of the following directories:

- `compose-nginx-forward_domain`: Nginx, forward auth (Domain) [here](./compose-nginx-forward_domain/README.md)
- `compose-nginx-forward_single`: Nginx, forward auth (Single app) [here](./compose-nginx-forward_single/README.md)
- `compose-traefik-forward_single`: Traefik, forward auth (Single app) [here](./compose-traefik-forward_single/README.md)
