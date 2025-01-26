#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Usage function to display help
usage() {
  echo "Usage: $0 -r <repo_path> -d <key_dir> -s <secret_name>"
  exit 1
}

# Parse arguments
while getopts "r:d:s:" opt; do
  case "$opt" in
    r) REPO_PATH="$OPTARG" ;;
    d) KEY_DIR="$OPTARG" ;;
    s) SECRET_NAME="$OPTARG" ;;
    *) usage ;;
  esac
done

# Ensure all required arguments are provided
if [ -z "$REPO_PATH" ] || [ -z "$KEY_DIR" ] || [ -z "$SECRET_NAME" ]; then
  usage
fi

# Step 1: Navigate to the repository
echo "Navigating to repository at $REPO_PATH"
cd "$REPO_PATH" || { echo "Repository path not found!"; exit 1; }

# Step 2: Initialize git-crypt
echo "Initializing git-crypt"
#git-crypt init

# Step 3: Export the key
echo "Exporting git-crypt key to $SECRET_NAME"
git-crypt export-key "$SECRET_NAME"

# Step 4: Save the key to the specified directory
mkdir -p "$KEY_DIR"
mv "$SECRET_NAME" "$KEY_DIR/"
KEY_PATH="$KEY_DIR/$SECRET_NAME"
echo "Key saved to $KEY_PATH"

# Step 5: Upload the base64-encoded key to GCP Secret Manager
echo "Uploading key to GCP Secret Manager"
gcloud secrets create $SECRET_NAME --replication-policy="automatic"
gcloud secrets versions add $SECRET_NAME --data-file=$KEY_PATH

echo "git-crypt repository initialized and key securely uploaded to GCP Secret Manager."