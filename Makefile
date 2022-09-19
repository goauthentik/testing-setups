.PHONY: local

local:
	echo "PG_PASS=$(openssl rand -base64 32)" >> local/.env
	echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 32)" >> local/.env
	echo "AUTHENTIK_ERROR_REPORTING__ENABLED=true" >> local/.env
	echo "AUTHENTIK_DISABLE_UPDATE_CHECK=true" >> local/.env
	echo "AUTHENTIK_DISABLE_STARTUP_ANALYTICS=true" >> local/.env
	AUTHENTIK_BOOTSTRAP_TOKEN=$(openssl rand -base64 32)
	echo "AUTHENTIK_BOOTSTRAP_TOKEN=${AUTHENTIK_BOOTSTRAP_TOKEN}" >> local/.env
	AUTHENTIK_BOOTSTRAP_PASSWORD=$(openssl rand -base64 32)
	echo "AUTHENTIK_BOOTSTRAP_PASSWORD=${AUTHENTIK_BOOTSTRAP_PASSWORD}" >> local/.env
	echo "AUTHENTIK_IMAGE=goauthentik.io/dev-server" >> local/.env
	echo "AUTHENTIK_TAG=gh-next" >> local/.env
	echo "AUTHENTIK_OUTPOSTS__DOCKER_IMAGE_BASE=goauthentik.io/dev-%(type)s:gh-next" >> local/.env
	export COMPOSE_PROJECT_NAME=authentik
	cd local && docker-compose pull -q
	cd local && docker-compose up -d
	timeout 600 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:9000/api/v3/root/config/)" != "200" ]]; do sleep 5; done' || false
