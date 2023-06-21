.PHONY: terraform-install
terraform-install: ## install Terraform providers and modules
	terraform init
install:: terraform-install

.PHONY: terraform-update
terraform-update:: ## update Terraform providers and modules
	@for f in $$(find . -name terraform.tf -type f); do \
		pushd "$$(dirname "$${f}")"; \
		terraform init -upgrade; \
		terraform providers lock -platform={darwin,linux}_{amd64,arm64}; \
		popd; \
	done
update:: terraform-update

.PHONY: terraform-build
terraform-build: ## build Terraform plan for the current configuration
	terraform plan
build:: terraform-build

.PHONY: terraform-clean
terraform-clean: ## remove Terraform providers and modules
	rm -rf $$(find . -name .terraform -type d)
clean:: terraform-clean
