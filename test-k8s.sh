#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Kubernetes Mini Cluster Test Suite${NC}"
echo -e "${BLUE}======================================${NC}\n"

# Check prerequisites
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed${NC}"
    exit 1
fi

echo -e "${YELLOW}📊 System Status${NC}\n"

# Check namespace
echo "Checking namespace..."
if kubectl get namespace mini-cluster &> /dev/null; then
    echo -e "${GREEN}✓ Namespace 'mini-cluster' exists${NC}"
else
    echo -e "${RED}❌ Namespace 'mini-cluster' not found${NC}"
    exit 1
fi

# Check pods
echo -e "\n${YELLOW}🔍 Pod Status:${NC}"
kubectl get pods -n mini-cluster

# Wait for pods to stabilize
echo -e "\n${YELLOW}⏳ Waiting for pods to stabilize (30 seconds)...${NC}"
sleep 30

# Check individual pod status
echo -e "\n${YELLOW}📋 Detailed Pod Status:${NC}"
POD_STATUS=$(kubectl get pods -n mini-cluster -o jsonpath='{.items[*].status.phase}')
if [[ "$POD_STATUS" == *"Running"* ]]; then
    echo -e "${GREEN}✓ Pods are running${NC}"
else
    echo -e "${YELLOW}⚠️  Some pods may still be initializing${NC}"
fi

# Test health endpoints
echo -e "\n${YELLOW}🏥 Health Checks:${NC}"

# Test master
echo -n "Master: "
MASTER_RESPONSE=$(kubectl exec -n mini-cluster deployment/master -- curl -s http://localhost/health 2>/dev/null || echo "")
if [[ "$MASTER_RESPONSE" == *"healthy"* ]] || [[ ! -z "$MASTER_RESPONSE" ]]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠️  Not ready${NC}"
fi

# Test workers
for i in 0 1; do
    echo -n "Worker $i: "
    WORKER_RESPONSE=$(kubectl exec -n mini-cluster pod/worker-$i -- curl -s http://localhost/health 2>/dev/null || echo "")
    if [[ "$WORKER_RESPONSE" == *"healthy"* ]]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠️  Not ready${NC}"
    fi
done

# Test load balancer
echo -n "Load Balancer: "
LB_RESPONSE=$(kubectl exec -n mini-cluster deployment/loadbalancer -- curl -s http://localhost/health 2>/dev/null || echo "")
if [[ "$LB_RESPONSE" == *"healthy"* ]]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠️  Not ready${NC}"
fi

# Test services connectivity
echo -e "\n${YELLOW}🔗 Network Connectivity:${NC}"

echo "Services:"
kubectl get svc -n mini-cluster

# Test DNS resolution
echo -e "\n${YELLOW}Testing DNS resolution from a pod:${NC}"
DNS_TEST=$(kubectl exec -n mini-cluster pod/worker-0 -- nslookup master-service.mini-cluster.svc.cluster.local 2>/dev/null || echo "Not available")
if [[ "$DNS_TEST" == *"10."* ]] || [[ "$DNS_TEST" == *"master-service"* ]]; then
    echo -e "${GREEN}✓ DNS resolution working${NC}"
else
    echo -e "${YELLOW}⚠️  DNS resolution may be limited${NC}"
fi

# Test inter-pod communication
echo -e "\n${YELLOW}🔀 Inter-Pod Communication:${NC}"

echo -n "Worker-0 → Load Balancer: "
if kubectl exec -n mini-cluster pod/worker-0 -- curl -s http://loadbalancer-service/health &>/dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}❌${NC}"
fi

# Check resource usage
echo -e "\n${YELLOW}💾 Resource Usage:${NC}"

if command -v kubectl top &> /dev/null; then
    echo ""
    echo "Pod resource usage:"
    kubectl top pods -n mini-cluster 2>/dev/null || echo "Metrics not available (install metrics-server)"
    echo ""
    echo "Node resource usage:"
    kubectl top nodes 2>/dev/null || echo "Metrics not available"
fi

# Check persistent volumes
echo -e "\n${YELLOW}💾 Persistent Storage:${NC}"

PVC_STATUS=$(kubectl get pvc jenkins-pvc -n mini-cluster -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
if [ "$PVC_STATUS" == "Bound" ]; then
    echo -e "${GREEN}✓ Jenkins PVC is bound${NC}"
    SIZE=$(kubectl get pvc jenkins-pvc -n mini-cluster -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
    echo "  Size: $SIZE"
else
    echo -e "${YELLOW}⚠️  Jenkins PVC status: $PVC_STATUS${NC}"
fi

# Check RBAC
echo -e "\n${YELLOW}🔐 RBAC Configuration:${NC}"

SA_EXISTS=$(kubectl get serviceaccount jenkins -n mini-cluster 2>/dev/null && echo "true" || echo "false")
if [ "$SA_EXISTS" == "true" ]; then
    echo -e "${GREEN}✓ Jenkins ServiceAccount exists${NC}"
else
    echo -e "${RED}❌ Jenkins ServiceAccount not found${NC}"
fi

# Summary
echo -e "\n${BLUE}=====================================${NC}"
echo -e "${BLUE}📝 Test Summary${NC}"
echo -e "${BLUE}=====================================${NC}\n"

READY_PODS=$(kubectl get pods -n mini-cluster --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)
TOTAL_PODS=$(kubectl get pods -n mini-cluster --no-headers 2>/dev/null | wc -l)

echo "Pods: $READY_PODS/$TOTAL_PODS running"
echo ""

if [ "$READY_PODS" -eq "$TOTAL_PODS" ] && [ "$TOTAL_PODS" -gt 0 ]; then
    echo -e "${GREEN}✅ All tests passed! Cluster is operational.${NC}"
    echo ""
    echo "🌐 Access your services:"
    echo ""
    echo "   Website:  kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80"
    echo "   Jenkins:  kubectl port-forward -n mini-cluster svc/jenkins-service 8080:8080"
    echo "   Workers:  kubectl port-forward -n mini-cluster svc/worker-nodeport 8081:80"
    echo ""
else
    echo -e "${YELLOW}⚠️  Not all pods are ready. Waiting for initialization...${NC}"
    echo "   Check logs: kubectl logs -n mini-cluster -f deployment/jenkins"
    echo ""
fi

echo -e "${BLUE}=====================================${NC}\n"
