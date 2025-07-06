SHELL := zsh

export OP_ACCOUNT := my.1password.com

#
#--------------------------------------------------------------------------
##@ Commands
#--------------------------------------------------------------------------
#
.PHONY: init
init: init-tf ## Init the application
	@echo 'Installing pnpm dependencies'
	@pnpm install

.PHONY: init-tf
init-tf: # Initialize the Terraform workspaces
	@echo "cloudflare_api_token = \"$$(op read 'op://Private/cloudflare.com/Tokens/Portfolio')\"" > terraform/cloudflare-pages/provider.auto.tfvars
	@terraform -chdir=terraform/cloudflare-pages init -reconfigure -backend-config access_key="$$(op read 'op://Private/cloudflare.com/Terraform State Keys/S3 Access Key')" -backend-config secret_key="$$(op read 'op://Private/cloudflare.com/Terraform State Keys/S3 Secret Key')"

.PHONY: up
up: ## Start the local Astro dev server
	@pnpm run dev

#
#--------------------------------------------------------------------------
## Help
#--------------------------------------------------------------------------
#
.PHONY: help
.DEFAULT_GOAL := help
help: # Display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } /^##~ [a-zA-Z_-]+:.*/ { printf "  \033[36m%-15s\033[0m %s\n", substr($$1, 5), $$2 }' $(MAKEFILE_LIST)
