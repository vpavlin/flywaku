NAME := $(USER)wakunode
CERTBOT_IMAGE := certbot/certbot
NWAKU_IMAGE := "docker.io/statusteam/nim-waku:v0.17.0"
REGION := ams
WSS_ENABLED := 0

FLYCTL := ./flyctl
FLY_TOML_TEMPLATE := fly.toml.tpl

ifeq ($(WSS_ENABLED),1)
	FLY_TOML_TEMPLATE = fly-sockets.toml.tpl
endif


$(FLYCTL):
	curl -LO https://github.com/superfly/flyctl/releases/download/v0.1.20/flyctl_0.1.20_Linux_x86_64.tar.gz &&\
		tar xzf flyctl_*

fly.toml: $(FLY_TOML_TEMPLATE)
	sed 's/@@NAME@@/$(NAME)/g' < $(FLY_TOML_TEMPLATE) > fly.toml

launch: fly.toml $(FLYCTL)
	$(FLYCTL) apps list | grep -q $(NAME) || (\
		$(FLYCTL) launch --copy-config --name $(NAME) -r $(REGION) --now \
	)
	$(MAKE) scale
scale:
	$(FLYCTL) scale count -y 1

deploy: launch 
	$(FLYCTL) deploy

clean:
	rm -f fly.toml

destroy:
	$(FLYCTL) apps destroy $(NAME)

certs: $(FLYCTL)
	sed 's/@@NAME@@/$(NAME)/g' < fly-certs.toml.tpl > fly.toml
	$(MAKE) launch
	$(FLYCTL) volumes list | grep -q $(NAME) || (\
		$(FLYCTL) volumes create -s 1 -r $(REGION) $(NAME) \
	)
	$(FLYCTL) deploy --image $(CERTBOT_IMAGE) -a $(NAME)  -r $(REGION)
	rm -f fly.toml