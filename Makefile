BASE_DOMAIN = "10.120.0.67.nip.io"
PASSWORD = "this-password-is-used-for-testing"

define apply_folder
	find -s $(1) -type f -exec cat {} \; | \
		sed "s/PLACEHOLDER_DOMAIN/${BASE_DOMAIN}/g" | \
		sed "s/PLACEHOLDER_PASSWORD/${PASSWORD}/g" | \
		kubectl apply -f -
endef

all:
	$(call apply_folder,base)

traefik: all
	$(call apply_folder,ingress-traefik)
