#!/bin/bash

set -e

# === Config ===
AWS_ACCOUNT_ID="365305373147"
AWS_REGION="us-east-1"
BACKEND_REPO_NAME="onfinance-backend"
FRONTEND_REPO_NAME="onfinance-frontend"
IMAGE_TAG="latest"

ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# === Authenticate to ECR ===
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$ECR_URL"

# === Build and Push Backend ===
echo "Building Backend Image..."
docker build -t $BACKEND_REPO_NAME -f backend/Dockerfile ./backend

echo "Tagging Backend Image..."
docker tag $BACKEND_REPO_NAME:$IMAGE_TAG $ECR_URL/$BACKEND_REPO_NAME:$IMAGE_TAG

echo "Pushing Backend Image to ECR..."
docker push $ECR_URL/$BACKEND_REPO_NAME:$IMAGE_TAG

# === Build and Push Frontend ===
echo "Building Frontend Image..."
docker build -t $FRONTEND_REPO_NAME -f frontend/Dockerfile ./frontend

echo "Tagging Frontend Image..."
docker tag $FRONTEND_REPO_NAME:$IMAGE_TAG $ECR_URL/$FRONTEND_REPO_NAME:$IMAGE_TAG

echo "Pushing Frontend Image to ECR..."
docker push $ECR_URL/$FRONTEND_REPO_NAME:$IMAGE_TAG

echo "✅ Build and push completed successfully!"
