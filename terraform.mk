TF_INIT_FLAGS ?=

.PHONY: terraform-install
terraform-install: ## install OpenTofu providers and modules
	find . -name .terraform.lock.hcl -not -path '*/.terraform/*' | xargs -n1 dirname | xargs -I{} tofu -chdir={} init $(TF_INIT_FLAGS)
install:: terraform-install

.PHONY: terraform-update
terraform-update:: ## update OpenTofu providers and modules
	find . -name .terraform.lock.hcl -not -path '*/.terraform/*' | xargs -n1 dirname | xargs -I{} tofu -chdir={} init -upgrade
update:: terraform-update

.PHONY: terraform-build
terraform-build: ## build OpenTofu plan for the current configuration
	tofu plan
build:: terraform-build

.PHONY: terraform-clean
terraform-clean: ## remove OpenTofu providers and modules
	rm -rf $$(find . -name .terraform -type d)
clean:: terraform-clean
