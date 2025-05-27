#!/bin/bash

# Input arguments with defaults
REGION="${1:-us-east-1}"
VERSION="${2:-latest}"
DEPLOYMENT_COLOR="${3:-blue}"
ENVIRONMENT="${4:-test}"
APP_SELECTION="${5:-both}"

echo "Using region: $REGION"
echo "Using image version: $VERSION"
echo "Deploying $DEPLOYMENT_COLOR version"
echo "Environment: $ENVIRONMENT"
echo "Application selection: $APP_SELECTION"

# Get AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [ -z "$ACCOUNT_ID" ]; then
  echo "Failed to retrieve AWS account ID."
  exit 1
fi
echo "AWS Account ID: $ACCOUNT_ID"

# Script and template paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")
ANGULAR_TEMPLATE="$SCRIPT_DIR/deployment/angular-deployment-template.yaml"
ANGULAR_CONFIG="$SCRIPT_DIR/deployment/angular-deployment.yaml"
SPRING_TEMPLATE="$SCRIPT_DIR/deployment/spring-deployment-template.yaml"
SPRING_CONFIG="$SCRIPT_DIR/deployment/spring-deployment.yaml"

# Function to process template
process_template() {
  local TEMPLATE=$1
  local TARGET=$2
  cp "$TEMPLATE" "$TARGET"
  sed -i "s|{{REGION}}|$REGION|g" "$TARGET"
  sed -i "s|{{AWS_ACCOUNT_ID}}|$ACCOUNT_ID|g" "$TARGET"
  sed -i "s|{{VERSION_TAG}}|$VERSION|g" "$TARGET"
  sed -i "s|{{DEPLOYMENT_COLOR}}|$DEPLOYMENT_COLOR|g" "$TARGET"
  sed -i "s|{{ENVIRONMENT}}|$ENVIRONMENT|g" "$TARGET"
}

# Deploy based on APP_SELECTION
case "$APP_SELECTION" in
  spring)
    echo "Deploying only Spring pod..."
    process_template "$SPRING_TEMPLATE" "$SPRING_CONFIG"
    kubectl apply -f "$SPRING_CONFIG"
    rm "$SPRING_CONFIG"
    ;;
  angular)
    echo "Deploying only Angular pod..."
    process_template "$ANGULAR_TEMPLATE" "$ANGULAR_CONFIG"
    kubectl apply -f "$ANGULAR_CONFIG"
    rm "$ANGULAR_CONFIG"
    ;;
  *)
    echo "Deploying both Angular and Spring pods..."
    process_template "$ANGULAR_TEMPLATE" "$ANGULAR_CONFIG"
    process_template "$SPRING_TEMPLATE" "$SPRING_CONFIG"
    kubectl apply -f "$ANGULAR_CONFIG"
    kubectl apply -f "$SPRING_CONFIG"
    rm "$ANGULAR_CONFIG" "$SPRING_CONFIG"
    ;;
esac

echo "Pod Deployment complete."
