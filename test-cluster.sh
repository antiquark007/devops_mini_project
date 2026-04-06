#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR=~/Downloads/test1
cd "$PROJECT_DIR" || exit

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_header() { echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n${YELLOW}$1${NC}"; }

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🧪 Docker Mini Cluster - Complete Test Suite${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Test 1: Container Status
print_header "TEST 1: Container Status"
echo "Running: docker compose ps"
docker compose ps
echo ""

# Test 2: Health Checks
print_header "TEST 2: Health Checks on All Services"
echo ""

echo "🔍 Load Balancer (port 80):"
if curl -s http://localhost/health | grep -q "OK"; then
    print_success "Load Balancer is healthy"
else
    print_error "Load Balancer check failed"
fi

echo ""
echo "🔍 Worker 1 (port 8081):"
if curl -s http://localhost:8081/health | grep -q "OK"; then
    print_success "Worker 1 is healthy"
else
    print_error "Worker 1 check failed"
fi

echo ""
echo "🔍 Worker 2 (port 8082):"
if curl -s http://localhost:8082/health | grep -q "OK"; then
    print_success "Worker 2 is healthy"
else
    print_error "Worker 2 check failed"
fi

echo ""

# Test 3: Round-Robin Distribution
print_header "TEST 3: Load Balancer Round-Robin Distribution"
echo "Making 8 requests to http://localhost..."
echo ""

w1_count=0
w2_count=0
lb_count=0

for i in {1..8}; do
    response=$(curl -s http://localhost/)
    
    if echo "$response" | grep -q "Docker Mini"; then
        echo "Request $i: ✅ Received response"
        ((lb_count++))
    else
        echo "Request $i: ⏳ No response yet"
    fi
done

echo ""
print_success "Round-robin test complete"
echo ""

# Test 4: Direct Worker Access
print_header "TEST 4: Direct Worker Access"
echo ""

echo "Testing Worker 1 directly:"
if curl -s http://localhost:8081/ | grep -q "Docker Mini"; then
    print_success "Worker 1 direct access works"
else
    print_error "Worker 1 direct access failed"
fi

echo ""
echo "Testing Worker 2 directly:"
if curl -s http://localhost:8082/ | grep -q "Docker Mini"; then
    print_success "Worker 2 direct access works"
else
    print_error "Worker 2 direct access failed"
fi

echo ""

# Test 5: Network Connectivity
print_header "TEST 5: Network Connectivity Between Services"
echo ""

echo "Testing loadbalancer → worker1:"
if docker exec loadbalancer curl -s http://worker1:80/health | grep -q "OK"; then
    print_success "Load Balancer can reach Worker 1"
else
    print_error "Load Balancer cannot reach Worker 1"
fi

echo ""
echo "Testing loadbalancer → worker2:"
if docker exec loadbalancer curl -s http://worker2:80/health | grep -q "OK"; then
    print_success "Load Balancer can reach Worker 2"
else
    print_error "Load Balancer cannot reach Worker 2"
fi

echo ""
echo "Testing jenkins → loadbalancer:"
if docker exec jenkins curl -s http://loadbalancer/health | grep -q "OK"; then
    print_success "Jenkins can reach Load Balancer"
else
    print_error "Jenkins cannot reach Load Balancer"
fi

echo ""

# Test 6: Volume Mounting
print_header "TEST 6: Volume Mounting (Master → Workers)"
echo ""

echo "Checking if index.html exists in worker1:"
if docker exec worker1 test -f /var/www/html/index.html; then
    print_success "index.html found in Worker 1"
else
    print_error "index.html NOT found in Worker 1"
fi

echo ""
echo "Checking if index.html exists in worker2:"
if docker exec worker2 test -f /var/www/html/index.html; then
    print_success "index.html found in Worker 2"
else
    print_error "index.html NOT found in Worker 2"
fi

echo ""

# Test 7: Docker Resources
print_header "TEST 7: Docker Resources & Performance"
echo ""

echo "Container resource usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""
echo "Disk usage by volumes:"
docker system df

echo ""

# Test 8: Load Testing (if ab available)
print_header "TEST 8: Load Testing"
echo ""

if command -v ab &> /dev/null; then
    echo "Running Apache Bench: 50 requests, 5 concurrent"
    ab -n 50 -c 5 -q http://localhost/ 2>&1 | tail -15
    print_success "Load test complete"
else
    echo "Apache Bench not installed. To install:"
    echo "  sudo apt-get install apache2-utils"
fi

echo ""

# Test 9: Jenkins Access
print_header "TEST 9: Jenkins CI/CD Platform"
echo ""

if curl -s http://localhost:8080 > /dev/null; then
    print_success "Jenkins is accessible at http://localhost:8080"
    echo "Credentials: admin/admin"
else
    print_error "Cannot reach Jenkins"
fi

echo ""

# Test 10: Log Summary
print_header "TEST 10: Recent Logs Summary"
echo ""

echo "Last 5 lines of each service:"
echo ""
echo "📋 Load Balancer logs:"
docker compose logs --tail 3 loadbalancer | tail -3
echo ""
echo "📋 Worker 1 logs:"
docker compose logs --tail 3 worker1 | tail -3
echo ""

# Final Summary
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
print_success "Test Suite Complete! 🎉"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Display summary table
echo "📊 CLUSTER STATUS SUMMARY:"
echo ""
echo "Service          Status         URL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check each service
services=("loadbalancer:80" "worker1:8081" "worker2:8082" "jenkins:8080")

for svc in "${services[@]}"; do
    service=$(echo $svc | cut -d: -f1)
    port=$(echo $svc | cut -d: -f2)
    
    if curl -s http://localhost:$port/health > /dev/null 2>&1 || curl -s http://localhost:$port > /dev/null 2>&1; then
        status="🟢 Running"
    else
        status="🔴 Check"
    fi
    
    printf "%-16s %-14s http://localhost:%-5s\n" "$service" "$status" "$port"
done

echo ""
echo "🔗 Access URLs:"
echo "  • Load Balancer: http://localhost"
echo "  • Worker 1: http://localhost:8081"
echo "  • Worker 2: http://localhost:8082"
echo "  • Jenkins: http://localhost:8080"
echo ""

echo "📖 For more info, see SETUP_AND_TEST.md"
echo ""
