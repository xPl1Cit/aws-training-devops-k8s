#!/bin/bash

# Check if region is passed as an argument
if [ -z "$1" ]; then
  echo "Region not provided. Using default region: us-east-1"
  REGION="us-east-1"  # Default to us-east-1 if no region is provided
else
  REGION=$1
  echo "Using region: $REGION"
fi

SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "Script directory is: $SCRIPT_DIR"
# Replace the region placeholder in the config template with the actual region
CONFIG_FILE="$SCRIPT_DIR/cluster/cluster-config.yaml"
cp "$SCRIPT_DIR/cluster/cluster-config-template.yaml" "$CONFIG_FILE"
sed -i "s/{{REGION}}/$REGION/g" "$CONFIG_FILE"

# Apply the eksctl configuration
echo "Creating EKS Cluster in region $REGION..."
eksctl create cluster -f "$CONFIG_FILE"

# Clean up the temporary config file
rm "$CONFIG_FILE"
