# Define variables
TERRAFORM=terraform
ENV ?= dev
TF_DIR=./
TF_VARS_FILE=terraform.${ENV}.tfvars

# Default target
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  init            Initialize the Terraform working directory"
	@echo "  fmt             Format Terraform configuration files"
	@echo "  validate        Validate the configuration files"
	@echo "  plan            Show an execution plan"
	@echo "  apply           Apply the changes required to reach the desired state"
	@echo "  destroy         Destroy Terraform-managed infrastructure"
	@echo "  lint            Check format recursively"
	@echo "  clean           Remove Terraform temporary files"

# Initialize Terraform
.PHONY: init
init:
	@$(TERRAFORM) init $(TF_DIR)

# Format Terraform files
.PHONY: fmt
fmt:
	@$(TERRAFORM) fmt -recursive $(TF_DIR)

# Validate Terraform configuration
.PHONY: validate
validate:
	@$(TERRAFORM) validate $(TF_DIR)

# Generate and show an execution plan
.PHONY: plan
plan:
	@$(TERRAFORM) plan -var-file=$(TF_VARS_FILE) $(TF_DIR)

# Apply the planned changes
.PHONY: apply
apply:
	@$(TERRAFORM) apply -var-file=$(TF_VARS_FILE) $(TF_DIR)

# Destroy Terraform-managed infrastructure
.PHONY: destroy
destroy:
	@$(TERRAFORM) destroy -var-file=$(TF_VARS_FILE) $(TF_DIR)

# Lint all Terraform files (recursive format check)
.PHONY: lint
lint:
	@$(TERRAFORM) fmt -check -recursive $(TF_DIR)

# Clean up temporary files
.PHONY: clean
clean:
	@rm -rf .terraform/ terraform.tfstate* .terraform.lock.hcl


