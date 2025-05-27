#!/bin/bash

# Input arguments
REGION="${1:-us-east-1}"  # Default to us-east-1 if not provided
VERSION="${2:-latest}"  # Version of the image to deploy

bash delete-blue-green.sh "$REGION" "blue" "$VERSION"
