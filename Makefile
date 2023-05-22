NAME := $(USER)-wakunode
REGION := ams

FLYCTL := ./flyctl


$(FLYCTL):
	curl -LO https://github.com/superfly/flyctl/releases/download/v0.1.8/flyctl_0.1.8_Linux_x86_64.tar.gz &&\
		tar xzf flyctl_*

fly.toml: fly.toml.tpl
	sed 's/@@NAME@@/$(NAME)/g' < fly.toml.tpl > fly.toml

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
