#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🗑️  Kubernetes Mini Cluster Cleanup${NC}"
echo -e "${BLUE}====================================${NC}\n"

if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed${NC}"
    exit 1
fi

# Confirm deletion
echo -e "${YELLOW}⚠️  This will DELETE all resources in 'mini-cluster' namespace!${NC}"
echo ""
read -p "Are you sure? (type 'yes' to confirm): " confirmation

if [ "$confirmation" != "yes" ]; then
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
    exit 0
fi

echo -e "\n${YELLOW}🗑️  Deleting namespace 'mini-cluster'...${NC}"

if kubectl delete namespace mini-cluster; then
    echo -e "${GREEN}✓ Namespace deleted successfully${NC}"
    echo ""
    echo -e "${YELLOW}⏳ Waiting for resources to be cleaned up...${NC}"
    sleep 5
    
    # Verify deletion
    if kubectl get namespace mini-cluster &> /dev/null; then
        echo -e "${YELLOW}⚠️  Namespace still exists, waiting...${NC}"
        sleep 10
    else
        echo -e "${GREEN}✓ All resources have been cleaned up${NC}"
    fi
else
    echo -e "${RED}❌ Failed to delete namespace${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Cleanup completed!${NC}\n"
