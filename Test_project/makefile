# Makefile

# Terraform directory
TERRAFORM_DIR := terraform

# Config directory
CONFIG_DIR := config

MAKEFLAGS += --no-print-directory

# Make targets
.PHONY: az_login checkenv envs init plan apply clean

az_login:
	@if ! az account show > /dev/null 2>&1; then \
		az login; \
	fi

checkenv:
	@if [ -z "$(ENV)" ]; then \
		echo "Error: ENV parameter is not supplied."; \
		exit 1; \
	else \
		if [ ! -d "$(CONFIG_DIR)/$(ENV)" ]; then \
				echo "Error: ENV parameter \"$(ENV)\" is not a valid environment."; \
				$(MAKE) envs; \
				exit 1; \
		fi; \
	fi

envs:
	@echo "Available environments:"
	@for dir in $(CONFIG_DIR)/*; do \
		if [ -d "$$dir" ]; then \
				echo "  $${dir##*/}"; \
		fi; \
	done

init: checkenv az_login clean
	@echo "Initializing Terraform for environment $(ENV)"
	@echo "Creating tfvars file"
	@bash ./scripts/merge_config.sh $(ENV)
	@export ARM_ACCESS_KEY=$(./scripts/get_access_key.sh) && \
	cd $(TERRAFORM_DIR) && terraform init -backend-config="key=azure_central_deploy_$(ENV).tfstate"

plan: checkenv az_login
	@echo "Running Terraform plan for environment $(ENV)"
	@cd $(TERRAFORM_DIR) && terraform plan 

apply: checkenv az_login
	@echo "Applying Terraform configuration for environment $(ENV)"
	@cd $(TERRAFORM_DIR) && terraform apply 

clean:
	@echo "Cleaning up"
	@rm -f $(TERRAFORM_DIR)/*.auto.tfvars
	@rm -rf $(TERRAFORM_DIR)/.terraform
	@rm -f $(TERRAFORM_DIR)/.terraform.lock.hcl
