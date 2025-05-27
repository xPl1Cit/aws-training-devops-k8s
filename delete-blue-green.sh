#!/bin/bash

# Input arguments
REGION="${1:-us-east-1}"  # Default to us-east-1 if not provided
DEPLOYMENT_COLOR="${2:-blue}"  # Default to blue if not provided
VERSION="${3:-latest}"  # Version of the image to deploy

echo "Deleting $DEPLOYMENT_COLOR version with image version $VERSION in region $REGION"

# Call the deployment script with the selected region, color, and version
bash delete-pods.sh "$REGION" "$VERSION" "$DEPLOYMENT_COLOR"

# Call the service deployment script with the selected color and version
bash delete-service.sh "$VERSION" "$DEPLOYMENT_COLOR"

echo "$DEPLOYMENT_COLOR deployment and services successfully deleted!"
