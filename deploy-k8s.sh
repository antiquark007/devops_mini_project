#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Kubernetes Mini Cluster Deployment${NC}"
echo -e "${BLUE}=====================================${NC}\n"

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed${NC}"
    echo "Install from: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}❌ Kubernetes cluster is not accessible${NC}"
    echo "Make sure your cluster is running and kubectl is configured"
    exit 1
fi

echo -e "${GREEN}✓ kubectl is installed${NC}"
echo -e "${GREEN}✓ Kubernetes cluster is accessible${NC}\n"

# Show cluster info
echo -e "${BLUE}📊 Cluster Information:${NC}"
CLUSTER_NAME=$(kubectl config current-context)
echo "Context: $CLUSTER_NAME"
echo ""

# Deploy manifests
echo -e "${YELLOW}📦 Deploying Kubernetes resources...${NC}\n"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
K8S_DIR="$SCRIPT_DIR/k8s"

if [ ! -d "$K8S_DIR" ]; then
    echo -e "${RED}❌ k8s directory not found at $K8S_DIR${NC}"
    exit 1
fi

kubectl apply -f "$K8S_DIR/"

echo -e "\n${BLUE}⏳ Waiting for resources to be created...${NC}\n"
sleep 3

# Check deployment status
echo -e "${YELLOW}🔍 Checking pod status...${NC}"
kubectl get pods -n mini-cluster

echo -e "\n${YELLOW}⏳ Waiting for all pods to be ready (this may take 2-3 minutes)...${NC}"
sleep 5

# Wait for deployments to be ready
for deployment in master loadbalancer jenkins; do
    echo "Waiting for $deployment..."
    kubectl rollout status deployment/$deployment -n mini-cluster --timeout=5m || true
done

# Wait for statefulset
echo "Waiting for workers..."
kubectl rollout status statefulset/worker -n mini-cluster --timeout=5m || true

echo -e "\n${GREEN}✅ Deployment completed!${NC}\n"

# Show final status
echo -e "${BLUE}📊 Final Status:${NC}"
echo ""
kubectl get all -n mini-cluster
echo ""

# Show access information
echo -e "${BLUE}🌐 Access Information:${NC}"
echo ""

echo -e "${YELLOW}Option 1: Using kubectl port-forward (Local access)${NC}"
echo ""
echo "📄 Website (Load Balancer):"
echo "   kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80"
echo "   → http://localhost:8000"
echo ""
echo "🔧 Jenkins:"
echo "   kubectl port-forward -n mini-cluster svc/jenkins-service 8080:8080"
echo "   → http://localhost:8080"
echo "   Username: admin | Password: admin"
echo ""
echo "🖥️  Worker Nodes:"
echo "   kubectl port-forward -n mini-cluster svc/worker-nodeport 8081:80"
echo "   → http://localhost:8081"
echo ""

# Check if LoadBalancer has external IP
echo -e "${YELLOW}Option 2: Using LoadBalancer (if available)${NC}"
EXTERNAL_IPS=$(kubectl get svc -n mini-cluster loadbalancer-service -o jsonpath='{.status.loadBalancer.ingress[*].ip}' 2>/dev/null)
if [ -z "$EXTERNAL_IPS" ]; then
    echo "⚠️  LoadBalancer external IP not available (normal for local clusters)"
    echo "   Use port-forward instead"
else
    echo "✓ Website: http://$EXTERNAL_IPS"
fi
echo ""

# Useful commands
echo -e "${BLUE}📚 Useful Commands:${NC}"
echo ""
echo "# View all resources"
echo "kubectl get all -n mini-cluster"
echo ""
echo "# Watch pods"
echo "kubectl get pods -n mini-cluster -w"
echo ""
echo "# View logs"
echo "kubectl logs -n mini-cluster deployment/jenkins -f"
echo ""
echo "# Scale workers"
echo "kubectl scale statefulset/worker --replicas=3 -n mini-cluster"
echo ""
echo "# Delete everything"
echo "kubectl delete namespace mini-cluster"
echo ""

echo -e "${GREEN}🎉 Happy deploying!${NC}\n"
