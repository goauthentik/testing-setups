.PHONY: local

local: local/docker-compose.yml
	cd local && docker compose up -d
	./local/wait.sh

local/docker-compose.yml:
	wget https://raw.githubusercontent.com/goauthentik/authentik/main/docker-compose.yml -O ./local/docker-compose.yml
	cd local && docker compose pull -q
