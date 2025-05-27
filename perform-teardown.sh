#!/bin/bash

# Input arguments
REGION="${1:-us-east-1}"

bash delete-cluster.sh $REGION
bash delete-ecr.sh $REGION