#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "Script directory is: $SCRIPT_DIR"

ANGULAR_CONFIG="$SCRIPT_DIR/deployment/angular-autoscale.yaml"
SPRING_CONFIG="$SCRIPT_DIR/deployment/spring-autoscale.yaml"

# Deploy both autoscaler
echo "Deleting Angular and Spring autoscaler..."
kubectl delete -f "$ANGULAR_CONFIG"
kubectl delete -f "$SPRING_CONFIG"

echo "Autoscaling Deletion complete."