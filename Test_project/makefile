# Makefile

# Terraform directory
TERRAFORM_DIR := terraform

# Config directory
CONFIG_DIR := config

MAKEFLAGS += --no-print-directory

# Make targets
.PHONY: gcloud_login checkenv envs init plan apply clean destroy

gcloud_login:
	@if ! gcloud auth list > /dev/null 2>&1; then \
		gcloud auth application-default login; \
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

init: checkenv gcloud_login clean
	@echo "Initializing Terraform for environment $(ENV)"
	@echo "Creating tfvars file"
	@bash ./scripts/merge_config.sh $(ENV)
	@cd $(TERRAFORM_DIR) && terraform init \
	-backend-config=$(ENV)_backend.tfvars


plan: checkenv gcloud_login
	@echo "Creating tfvars file"
	@bash ./scripts/merge_config.sh $(ENV)
	@echo "Running Terraform plan for environment $(ENV)"
	@cd $(TERRAFORM_DIR) && terraform plan 

apply: checkenv gcloud_login
	@echo "Creating tfvars file"
	@bash ./scripts/merge_config.sh $(ENV)
	@echo "Applying Terraform configuration for environment $(ENV)"
	@cd $(TERRAFORM_DIR) && terraform apply 

destroy: checkenv gcloud_login
	@echo "Creating tfvars file"
	@bash ./scripts/merge_config.sh $(ENV)
	@echo "Applying Terraform configuration for environment $(ENV)"
	@cd $(TERRAFORM_DIR) && terraform destroy 

clean:
	@echo "Cleaning up"
	@rm -f $(TERRAFORM_DIR)/*.auto.tfvars
	@rm -f $(TERRAFORM_DIR)/*_backend.tfvars
	@rm -rf $(TERRAFORM_DIR)/.terraform
	@rm -f $(TERRAFORM_DIR)/.terraform.lock.hcl
