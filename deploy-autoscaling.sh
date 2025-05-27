#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "Script directory is: $SCRIPT_DIR"

ANGULAR_CONFIG="$SCRIPT_DIR/deployment/angular-autoscale.yaml"
SPRING_CONFIG="$SCRIPT_DIR/deployment/spring-autoscale.yaml"

# Deploy both autoscaler
echo "Deploying Angular and Spring autoscaler..."
kubectl apply -f "$ANGULAR_CONFIG"
kubectl apply -f "$SPRING_CONFIG"

echo "Autoscaling Deployment complete."