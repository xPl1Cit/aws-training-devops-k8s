#!/bin/bash

# Input arguments
VERSION="${1:-latest}"
DEPLOYMENT_COLOR="${2:-blue}"

echo "Using image version: $VERSION"
echo "Deploying to $DEPLOYMENT_COLOR version"

# Script and template paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SERVICE_TEMPLATE="$SCRIPT_DIR/deployment/spring-service-template.yaml"
SERVICE_CONFIG="$SCRIPT_DIR/deployment/spring-service.yaml"
LB_TEMPLATE="$SCRIPT_DIR/deployment/angular-lb-template.yaml"
LB_CONFIG="$SCRIPT_DIR/deployment/angular-lb.yaml"

# Replace placeholders in deployment templates
for TEMPLATE in "$SERVICE_TEMPLATE" "$LB_TEMPLATE"; do
  TARGET_FILE="${TEMPLATE/-template/}"
  cp "$TEMPLATE" "$TARGET_FILE"
  sed -i "s|{{VERSION_TAG}}|$VERSION|g" "$TARGET_FILE"
  sed -i "s|{{DEPLOYMENT_COLOR}}|$DEPLOYMENT_COLOR|g" "$TARGET_FILE"
done

# Deploy service
echo "Deploying Services..."
kubectl apply -f "$SERVICE_CONFIG"
kubectl apply -f "$LB_CONFIG"

# Clean up deployment config
rm "$SERVICE_CONFIG" "$LB_CONFIG"

echo "Service Deployment complete."
