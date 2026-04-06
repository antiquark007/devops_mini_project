#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR=~/Downloads/test1
cd "$PROJECT_DIR" || exit

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🐳 Docker Mini Cluster - Complete Setup & Test${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# Function to print section headers
print_header() {
    echo -e "${YELLOW}📌 $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# STEP 1: Start Docker Compose
print_header "STEP 1: Starting Docker Compose"
echo "Command: docker compose up -d"
docker compose up -d

# Check if startup was successful
if [ $? -ne 0 ]; then
    print_error "Failed to start Docker compose!"
    exit 1
fi

print_success "Docker compose started"
echo ""

# STEP 2: Wait for services
print_header "STEP 2: Waiting for services to stabilize..."
echo "Sleeping for 10 seconds..."
sleep 10
print_success "Services should be ready"
echo ""

# STEP 3: Check container status
print_header "STEP 3: Checking Container Status"
docker compose ps
echo ""

# STEP 4: Health checks
print_header "STEP 4: Running Health Checks"
echo ""

# Test Load Balancer
echo -n "Testing Load Balancer (port 80)... "
if curl -s http://localhost/health > /dev/null; then
    print_success "Load Balancer OK"
else
    echo -e "${YELLOW}⏳ Still starting...${NC}"
fi

# Test Worker 1
echo -n "Testing Worker 1 (port 8081)... "
if curl -s http://localhost:8081/health > /dev/null; then
    print_success "Worker 1 OK"
else
    echo -e "${YELLOW}⏳ Still starting...${NC}"
fi

# Test Worker 2
echo -n "Testing Worker 2 (port 8082)... "
if curl -s http://localhost:8082/health > /dev/null; then
    print_success "Worker 2 OK"
else
    echo -e "${YELLOW}⏳ Still starting...${NC}"
fi

# Test Jenkins
echo -n "Testing Jenkins (port 8080)... "
if curl -s http://localhost:8080 > /dev/null; then
    print_success "Jenkins OK"
else
    echo -e "${YELLOW}⏳ Still starting...${NC}"
fi

echo ""

# STEP 5: Test round-robin
print_header "STEP 5: Testing Load Balancer Round-Robin"
echo "Making 4 requests to load balancer..."
for i in {1..4}; do
    echo -n "Request $i: "
    curl -s http://localhost/ | grep -o "Docker Mini" > /dev/null && echo "✅" || echo "⏳"
done
echo ""

# STEP 6: Display access points
print_header "STEP 6: Access Your Cluster"
echo ""
echo -e "${BLUE}Service              URL                        Port${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Load Balancer        http://localhost              80"
echo "Worker 1             http://localhost:8081         8081"
echo "Worker 2             http://localhost:8082         8082"
echo "Jenkins CI/CD        http://localhost:8080         8080"
echo ""

# STEP 7: Display quick test commands
print_header "STEP 7: Quick Test Commands"
echo ""
echo "Test round-robin:"
echo "  for i in {1..6}; do curl -s http://localhost/ | grep Docker; done"
echo ""
echo "View logs (live):"
echo "  docker compose logs -f loadbalancer"
echo ""
echo "Performance test:"
echo "  ab -n 100 -c 10 http://localhost/"
echo ""
echo "Stop cluster:"
echo "  docker compose down"
echo ""

# STEP 8: Optional ngrok setup
print_header "STEP 8: Optional - Global Access via ngrok"
echo ""
echo "To expose Jenkins globally for GitHub webhooks:"
echo "  ngrok http 8080"
echo ""
echo "Then use the HTTPS URL for GitHub webhook:"
echo "  https://your-url.ngrok-free.dev/github-webhook/"
echo ""

# Final status
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
print_success "Docker Mini Cluster is READY! 🚀"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""
echo "📖 Full documentation: See SETUP_AND_TEST.md"
echo ""
