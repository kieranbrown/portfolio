DASHLANE_TFSTATE_ID := 246CBCB3-BA34-4369-8BD4-D43DCD8F57BC

#
#--------------------------------------------------------------------------
##@ Help
#--------------------------------------------------------------------------
#
.PHONY: help
help: ## Print this help with list of available commands/targets and their purpose
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } /^##~ [a-zA-Z_-]+:.*/ { printf "  \033[36m%-15s\033[0m %s\n", substr($$1, 5), $$2 }' $(MAKEFILE_LIST)

#
#--------------------------------------------------------------------------
##@ Commands
#--------------------------------------------------------------------------
#
.PHONY: bootstrap
bootstrap: initialize-terraform ## Bootstrap the application
	@echo 'Installing pnpm dependencies'
	@pnpm install

.PHONY: initialize-terraform
initialize-terraform: ## Initialize the Terraform workspaces
	@echo 'Initializing Terraform Workspaces'
	@dcli sync
	@echo "cloudflare_api_token = \"$$(dcli read dl://cloudflare_api_token/content)\"" > terraform/cloudflare-pages/provider.auto.tfvars
	@terraform -chdir=terraform/cloudflare-pages init -reconfigure -backend-config access_key="$$(dcli read dl://$(DASHLANE_TFSTATE_ID)/content?json=cloudflare_s3_access_key)" -backend-config secret_key="$$(dcli read dl://$(DASHLANE_TFSTATE_ID)/content?json=cloudflare_s3_secret_key)"

.PHONY: up
up: ## Start the local Astro dev server
	@pnpm run dev
