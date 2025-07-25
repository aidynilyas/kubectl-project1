#!/bin/bash

set -e
echo "MAKE SURE MINIKUBE ADDONS INGRESS DISABLED"
minikube addons disable ingress 

echo "📦 Adding ingress-nginx Helm repo..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "📁 Creating namespace 'ingress-nginx'..."
kubectl create namespace ingress-nginx || echo "Namespace already exists."

echo "🚀 Installing ingress-nginx via Helm..."
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.hostNetwork=true \
  --set controller.dnsPolicy=ClusterFirstWithHostNet \
  --set controller.kind=DaemonSet

echo "⏳ Waiting for ingress-nginx controller to be ready..."
kubectl rollout status deployment ingress-nginx-controller -n ingress-nginx

echo "🌐 Starting minikube tunnel in background (requires sudo)..."
if pgrep -f "minikube tunnel" >/dev/null; then
  echo "Minikube tunnel is already running."
else
  sudo nohup minikube tunnel > /dev/null 2>&1 &
  echo "Started minikube tunnel in background."
fi

echo "🔍 Getting Minikube IP..."
MINIKUBE_IP=$(minikube ip)
echo "Minikube IP is $MINIKUBE_IP"

echo "📝 Adding 'bookstore.local' to /etc/hosts (requires sudo)..."
if grep -q "bookstore.local" /etc/hosts; then
  echo "Entry already exists in /etc/hosts"
else
  echo "$MINIKUBE_IP bookstore.local" | sudo tee -a /etc/hosts
  echo "Added bookstore.local to /etc/hosts"
fi

echo "✅ Ingress NGINX Controller installation complete."
echo "👉 Try: curl http://bookstore.local"
