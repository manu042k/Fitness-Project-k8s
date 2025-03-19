#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Kubernetes deployment for Fitness Project..."

# Create namespace (uncomment if you need a specific namespace)
# echo "Creating namespace..."
# kubectl create namespace fitness-app --dry-run=client -o yaml | kubectl apply -f -
# kubectl config set-context --current --namespace=fitness-app
echo "Creating configmap from init.sql..."
cd userDB
kubectl create configmap init-sql-config --from-file=init.sql
cd ..
echo "✅ Configmap created successfully"
echo "Applying secrets..."
kubectl apply -f secrets/session_secret.yaml
kubectl apply -f secrets/DB_secret.yaml
kubectl apply -f userManagement_k8s/user_secret.yaml
kubectl apply -f userDB/userDB_config.yaml
echo "✅ Secrets applied successfully"

echo "Applying persistent volume claims..."
kubectl apply -f sessionDB/sessionDB_pvc.yaml
kubectl apply -f userDB/userDB_pvc.yaml
echo "✅ Persistent volume claims applied successfully"

echo "Deploying databases..."
kubectl apply -f sessionDB/sessionDB_deployment.yaml
kubectl apply -f sessionDB/session_db_service.yaml
kubectl apply -f userDB/userDB_deployment.yaml
kubectl apply -f userDB/user_db_service.yaml
echo "✅ Databases deployed successfully"

echo "Waiting for databases to be ready (30s)..."
sleep 5

echo "Deploying profile service..."
kubectl apply -f profile-service_k8s/profile_deployment.yaml
kubectl apply -f profile-service_k8s/profile_service.yaml
echo "✅ Profile service deployed successfully"

# Add additional service deployments here if available in your project structure

echo "Deploying nginx proxy..."
kubectl apply -f nginx_proxy_k8s/nginx_configmap.yaml
kubectl apply -f nginx_proxy_k8s/nginxProxy_deployment.yaml
kubectl apply -f nginx_proxy_k8s/nginxProxy_service.yaml
echo "✅ Nginx proxy deployed successfully"

echo "Creating database secret..."
kubectl apply -f secrets/DB_secret.yaml
echo "✅ Database secret applied successfully"

echo "Deploying Training Session service..."
kubectl apply -f ./trainingSession_k8s/trainingSession_Deployment.yaml
kubectl apply -f ./trainingSession_k8s/trainingSession_service.yaml

echo "Deploying Trainer service..."
kubectl apply -f ./trainer_k8s/trainer_deployment.yaml
kubectl apply -f ./trainer_k8s/trainer_service.yaml

echo "Deploying Trainee service..."
kubectl apply -f ./trainee_k8s/trainee_deployment.yaml
kubectl apply -f ./trainee_k8s/trainee_service.yaml

echo "Deploying User Management service..."
kubectl apply -f ./userManagement_k8s/UserManagement_Deployment.yaml
kubectl apply -f ./userManagement_k8s/userManagement_service.yaml
echo "✅ User Management service deployed successfully"

echo "Deploying Workout Recommendation service..."
kubectl apply -f ./workout_recommendation_k8s/workoutRecommend_deployment.yaml
echo "✅ Workout Recommendation service deployed"

echo "Deploying Shell service..."
kubectl apply -f ./shell_service/shell_deployment.yaml
kubectl apply -f ./shell_service/shell_service.yaml

echo "Waiting for deployments to be ready..."
echo "Checking status of workout recommendation deployment..."
kubectl get deployment workoutrecommendationdeployment
kubectl describe deployment workoutrecommendationdeployment
echo "Checking pods for workout recommendation..."
kubectl get pods -l app=workout-recommendation-service

# Increase timeout for deployments that might take longer
kubectl wait --for=condition=available deployment/trainingsessiondeployment --timeout=180s
kubectl wait --for=condition=available deployment/trainer-deployment --timeout=180s
kubectl wait --for=condition=available deployment/trainee-deployment --timeout=180s
kubectl wait --for=condition=available deployment/usermanagementdeployment --timeout=180s
kubectl wait --for=condition=available deployment/workoutrecommendationdeployment --timeout=300s || true
kubectl wait --for=condition=available deployment/shell-deployment --timeout=180s

# Continue regardless of timeout
echo "Checking deployment status..."
kubectl get pods
kubectl get services

echo "🎉 Deployment complete! The application should be available shortly."
echo "To access the application, use: kubectl get service nginx-proxy-service"

# Display the external IP when available
echo "Waiting for external IP assignment..."
external_ip=""
while [ -z $external_ip ]; do
  echo "Waiting for end point..."
  external_ip=$(kubectl get svc nginx-proxy-service --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$external_ip" ] && sleep 10
done
echo "External IP: $external_ip"
echo "Access your application at: http://$external_ip/"

echo "Deployment completed successfully."
echo "To check service status, run: kubectl get svc"
echo "To check pod status, run: kubectl get pods"

# Make the script executable with: chmod +x deploy.sh
