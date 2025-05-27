#!/bin/bash

# Check if region is passed as an argument
if [ -z "$1" ]; then
  echo "Region not provided. Using default region: us-east-1"
  REGION="us-east-1"  # Default to us-east-1 if no region is provided
else
  REGION=$1
  echo "Using region: $REGION"
fi

# Check if version is passed as an argument
if [ -z "$2" ]; then
  echo "Version not provided. Using default version: v1"
  VERSION="v1"  # Default version is v1 if not provided
else
  VERSION=$2
  echo "Using version: $VERSION"
fi

# Get the absolute path of the script directory to avoid relative path issues
SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "Script directory is: $SCRIPT_DIR"

# Function to execute deploy-to-ecr.sh script in a given directory
run_deploy_script_in_dir() {
  DIR=$1
  echo "Navigating to $DIR directory..."
  
  # Change to the absolute path of the directory (relative to script location)
  TARGET_DIR="$SCRIPT_DIR/$DIR"
  
  # Check if the directory exists before trying to cd into it
  if [ -d "$TARGET_DIR" ]; then
    cd "$TARGET_DIR" || { echo "Failed to change directory to $TARGET_DIR"; exit 1; }
  else
    echo "Directory $TARGET_DIR not found!"
    exit 1
  fi

  # Check if the deploy-to-ecr.sh script exists and is executable
  if [ -f "./deploy-to-ecr.sh" ]; then
    echo "Running deploy-to-ecr.sh in $DIR with region $REGION and version $VERSION..."
    bash deploy-to-ecr.sh $REGION $VERSION
  else
    echo "deploy-to-ecr.sh script not found in $DIR"
    exit 1
  fi
}

# Run the deploy script in ./containers/angular (relative path)
run_deploy_script_in_dir "./containers/angular"

# Run the deploy script in ./containers/spring (relative path)
run_deploy_script_in_dir "./containers/spring"
