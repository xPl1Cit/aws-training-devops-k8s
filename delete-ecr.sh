#!/bin/bash

# Check if region is passed as an argument
if [ -z "$1" ]; then
  echo "Region not provided. Using default region: us-east-1"
  REGION="us-east-1"  # Default to us-east-1 if no region is provided
else
  REGION=$1
  echo "Using region: $REGION"
fi

# Function to delete ECR repositories
delete_ecr_repository() {
  REPO_NAME=$1
  echo "Deleting repository $REPO_NAME in region $REGION..."
  
  # Use AWS CLI to delete the repository
  aws ecr delete-repository --repository-name "$REPO_NAME" --region "$REGION" --force
  if [ $? -eq 0 ]; then
    echo "Repository $REPO_NAME deleted successfully."
  else
    echo "Failed to delete repository $REPO_NAME."
  fi
}

# Delete the repositories
delete_ecr_repository "capstone-al-angular"
delete_ecr_repository "capstone-al-spring"