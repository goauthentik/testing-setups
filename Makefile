BASE_DOMAIN = "10.120.0.67.nip.io"
PASSWORD = "this-password-is-used-for-testing"

define apply_folder
	find $(1) -name "*.yaml" | sort -n | xargs cat | \
		sed "s/PLACEHOLDER_DOMAIN/${BASE_DOMAIN}/g" | \
		sed "s/PLACEHOLDER_PASSWORD/${PASSWORD}/g" | \
		kubectl apply -f -
endef

define remove_folder
	find $(1) -name "*.yaml" | sort -nr | xargs cat | \
		kubectl delete -f -
endef

all:
	$(call apply_folder,base)

nginx: all
	$(call apply_folder,ingress-nginx)

traefik: all
	$(call apply_folder,ingress-traefik)

remove:
	$(call remove_folder,.)
