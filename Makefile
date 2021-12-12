BASE_DOMAIN = "10.120.0.67.nip.io"
PASSWORD = "this-password-is-used-for-testing"

define apply_folder
	find $(1) -name "*.yaml" | sort -n | xargs cat | \
		sed "s/PLACEHOLDER_DOMAIN/${BASE_DOMAIN}/g" | \
		sed "s/PLACEHOLDER_PASSWORD/${PASSWORD}/g" | \
		kubectl apply -f -
	sleep 5
endef

define remove_folder
	find $(1) -name "*.yaml" | sort -nr | xargs cat | \
		kubectl delete -f -
endef

kube-base:
	$(call apply_folder,cluster/system)
	$(call apply_folder,cluster/base)

kube-nginx: kube-base
	$(call apply_folder,ingress-nginx)

kube-traefik: kube-base
	$(call apply_folder,ingress-traefik)

kube-remove:
	$(call remove_folder,.)
