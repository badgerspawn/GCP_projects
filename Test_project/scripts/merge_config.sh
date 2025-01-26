#!/bin/bash

# Exit on any error
set -e

# Function to display usage
usage() {
  echo "Usage: $0 <env_name>"
  echo "  env_name: Name of the environment"
  exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  usage
fi

ENV_NAME="$1"

ROOT_DIR=$(pwd)
CONFIG_DIR="$ROOT_DIR/config"
GLOBAL_CONFIG="${CONFIG_DIR}/config.tfvars"
GLOBAL_SECRETS="${CONFIG_DIR}/secrets.tfvars"
GLOBAL_BACKEND="${CONFIG_DIR}/backend.tfvars"
ENV_CONFIG="${CONFIG_DIR}/${ENV_NAME}/config.tfvars"
ENV_SECRETS="${CONFIG_DIR}/${ENV_NAME}/secrets.tfvars"
ENV_BACKEND="${CONFIG_DIR}/${ENV_NAME}/backend.tfvars"
TERRAFORM_DIR="$ROOT_DIR/terraform"
OUTPUT_FILE="$TERRAFORM_DIR/$ENV_NAME.auto.tfvars"
BACKEND_FILE="$TERRAFORM_DIR/${ENV_NAME}_backend.tfvars"

# Ensure required files exist
if [ ! -f "$GLOBAL_CONFIG" ] || [ ! -f "$GLOBAL_SECRETS" ]; then
  echo "Error: Global config.tfvars or secrets.tfvars not found in root directory."
  exit 1
fi

if [ ! -d "${CONFIG_DIR}/${ENV_NAME}" ]; then
  echo "Error: Environment directory ${ENV_NAME} does not exist."
  exit 1
fi

if [ ! -f "$ENV_CONFIG" ] || [ ! -f "$ENV_SECRETS" ]; then
  echo "Error: config.tfvars or secrets.tfvars missing in ${ENV_NAME} directory."
  exit 1
fi

if [ ! -f "$GLOBAL_BACKEND" ] && [ ! -f "$ENV_BACKEND" ]; then
  echo "Error: Global backend.tfvars or environment backend.tfvars must exist."
  exit 1
elif [ -f "$ENV_BACKEND" ]; then
  cp "$ENV_BACKEND" "$BACKEND_FILE"
else
  cp "$GLOBAL_BACKEND" "$BACKEND_FILE"
fi


# Function to merge two tfvars files
merge_tfvars_files() {
  local file1="$1"
  local file2="$2"

  # Use awk to combine files while preserving comments and overriding variables
  awk '
    BEGIN {
      FS="=";
      OFS="=";
    }
    /^[[:space:]]*#/ || /^[[:space:]]*$/ {
      print $0; next;
    }
    {
      gsub(/[[:space:]]+/, "", $1); # Remove spaces around keys
      if (!seen[$1]++) {
        order[++i] = $1;
      }
      vars[$1] = $0; # Store variable with full line
    }
    END {
      for (j=1; j<=i; j++) {
        print vars[order[j]];
      }
    }
  ' "$file1" "$file2"
}


echo "env = \"$ENV_NAME\"" > "$OUTPUT_FILE"

# Step 1: Merge global config and secrets
TEMP_GLOBAL_MERGED=$(mktemp)
merge_tfvars_files "$GLOBAL_CONFIG" "$GLOBAL_SECRETS" > "$TEMP_GLOBAL_MERGED"

# Step 2: Merge env config and secrets
TEMP_ENV_MERGED=$(mktemp)
merge_tfvars_files "$ENV_CONFIG" "$ENV_SECRETS" > "$TEMP_ENV_MERGED"

# Step 3: Merge global merged with env merged
merge_tfvars_files "$TEMP_GLOBAL_MERGED" "$TEMP_ENV_MERGED" >> "$OUTPUT_FILE"

# Clean up temporary files
rm -f "$TEMP_GLOBAL_MERGED" "$TEMP_ENV_MERGED"

echo "Environment '$ENV_NAME' tfvars generated."
echo "Output file: $OUTPUT_FILE"
