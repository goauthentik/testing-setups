<p align="center">
    <img src="https://goauthentik.io/img/icon_top_brand_colour.svg" height="150" alt="authentik logo">
</p>

---

[![](https://img.shields.io/discord/809154715984199690?label=Discord&style=for-the-badge)](https://discord.gg/jg33eMhnj6)

# authentik testing setups

Kubernetes manifests to quickly test different cluster setups with authentik.

## Run

### `make all`:

Apply common resources, in the following order:

- FluxCD: used to deploy helmcharts via CRDs
- authentik: Install authentik with PostgreSQL and Redis
- whoami: A simple application to test with

### `make nginx`:

Common resources + nginx ingress controller

### `make traefik`:

Common resources + traefik ingress controller

### `make remove`:

Remove all resources.
