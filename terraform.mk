TF_INIT_FLAGS ?=

# Shared provider plugin cache reused across workspaces and runs. Created here
# so `make install`/`update` benefit even without direnv; Terraform silently
# skips caching if the directory does not already exist.
export TF_PLUGIN_CACHE_DIR ?= $(HOME)/.cache/terraform/plugins

# Platforms to record provider checksums for in .terraform.lock.hcl. Keep in
# sync with the terraform_providers_lock pre-commit hook.
TF_LOCK_PLATFORMS ?= darwin_arm64 linux_amd64

.PHONY: terraform-install
terraform-install: ## install Terraform providers and modules
	mkdir -p "$(TF_PLUGIN_CACHE_DIR)"
	terraform init $(TF_INIT_FLAGS)
install:: terraform-install

.PHONY: terraform-update
terraform-update:: ## update Terraform providers and modules, then lock all platforms
	mkdir -p "$(TF_PLUGIN_CACHE_DIR)"
	terraform init -upgrade
	terraform providers lock $(addprefix -platform=,$(TF_LOCK_PLATFORMS))
update:: terraform-update

.PHONY: terraform-build
terraform-build: ## build Terraform plan for the current configuration
	terraform plan
build:: terraform-build

.PHONY: terraform-clean
terraform-clean: ## remove Terraform providers and modules
	rm -rf $$(find . -name .terraform -type d)
clean:: terraform-clean
