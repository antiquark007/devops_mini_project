# 🚀 Docker Mini Cluster - Complete Setup & Testing Guide

## 📋 Executive Summary

This guide covers everything needed to:
- Start the cluster from scratch
- Verify all services are running
- Test load balancing across multiple servers
- Monitor and debug the deployment

---

## 🔧 QUICK START (5 minutes)

### **1. Start Everything**

```bash
cd ~/Downloads/test1

# Start all docker containers
docker compose up -d

# Verify all containers are running
docker compose ps
```

**Expected Output:**
```
NAME           IMAGE                 STATUS
master         ubuntu:22.04          Up 30 seconds (healthy)
worker1        nginx:latest          Up 30 seconds (healthy)
worker2        nginx:latest          Up 30 seconds (healthy)
loadbalancer   nginx:latest          Up 30 seconds (healthy)
jenkins        jenkins/jenkins:lts   Up 30 seconds
```

---

## 🌐 ACCESS SERVICES

Once running, access your cluster:

| Service | URL | Port | Purpose |
|---------|-----|------|---------|
| **Load Balancer** | http://localhost | 80 | Main entry point (round-robin) |
| **Worker 1** | http://localhost:8081 | 8081 | Direct access to worker 1 |
| **Worker 2** | http://localhost:8082 | 8082 | Direct access to worker 2 |
| **Jenkins CI/CD** | http://localhost:8080 | 8080 | Pipeline automation & deployment |
| **ngrok Public** | See ngrok terminal | HTTPS | Global access (if running ngrok) |

---

## 🧪 TESTING LOAD BALANCER

### **Test 1: Round-Robin Distribution**

```bash
# Test load balancer multiple times
for i in {1..6}; do
  echo "Request $i:"
  curl -s http://localhost/ | grep -o "Load Balancer\|Docker Mini"
  echo ""
done
```

**Expected:** Alternates between worker1 and worker2

---

### **Test 2: Direct Worker Access**

```bash
# Test Worker 1 directly
curl -s http://localhost:8081/ | grep "Docker Mini Cluster"

# Test Worker 2 directly
curl -s http://localhost:8082/ | grep "Docker Mini Cluster"

# Test Load Balancer (port 80)
curl -s http://localhost/ | grep "Docker Mini Cluster"
```

---

### **Test 3: Health Checks**

```bash
# Check load balancer health
curl http://localhost/health

# Check worker 1 health
curl http://localhost:8081/health

# Check worker 2 health
curl http://localhost:8082/health
```

**Expected Output:**
```
OK
```

---

### **Test 4: Container Status**

```bash
# Full container status
docker compose ps

# Detailed logs
docker compose logs

# Specific service logs
docker compose logs loadbalancer
docker compose logs worker1
docker compose logs worker2
```

---

## 🔄 JENKINS CI/CD AUTOMATION

### **Setup ngrok for GitHub Webhook**

```bash
# Terminal 1: Keep ngrok running
ngrok http 8080
# Copy the HTTPS URL shown (e.g., https://xxxxx.ngrok-free.dev)
```

### **Access Jenkins**

```bash
# Web Interface
http://localhost:8080

# OR via ngrok (globally)
https://your-ngrok-url.ngrok-free.dev

# Default Credentials
Username: admin
Password: admin
```

---

### **Configure GitHub Webhook**

1. Go to: https://github.com/antiquark007/devops_mini_project/settings/hooks
2. Click **"Add webhook"**
3. **Payload URL:** `https://your-ngrok-url.ngrok-free.dev/github-webhook/`
4. **Content type:** `application/json`
5. **Events:** ✅ Just the push event
6. Click **"Add webhook"**

---

### **Test Automated Build**

```bash
# Make a change to your repo
cd ~/Downloads/test1
echo "# Test" >> README.md

# Commit and push
git add README.md
git commit -m "Test automated build"
git push origin main

# Watch Jenkins auto-build at:
# http://localhost:8080/job/devops-mini-cluster/
```

---

## 📊 MONITORING & DEBUGGING

### **Check All Services**

```bash
# Full cluster status
docker compose ps -a

# Network connectivity
docker network ls
docker network inspect test1_cluster_network

# Volume status
docker volume ls
```

---

### **View Logs**

```bash
# All logs
docker compose logs -f

# Specific service (follow logs live)
docker compose logs -f loadbalancer
docker compose logs -f worker1
docker compose logs -f jenkins

# Last 50 lines
docker compose logs --tail 50 loadbalancer
```

---

### **Test Connectivity Between Services**

```bash
# From Jenkins container
docker exec jenkins curl http://loadbalancer/health

# From worker1 to master volume
docker exec worker1 ls -la /var/www/html/

# From loadbalancer to workers
docker exec loadbalancer curl http://worker1:80/
docker exec loadbalancer curl http://worker2:80/
```

---

## 🔧 RESTART & CLEANUP

### **Restart Single Service**

```bash
# Restart a specific container
docker compose restart worker1
docker compose restart loadbalancer
docker compose restart jenkins

# Restart all
docker compose restart

# Full restart (stop + start)
docker compose down
docker compose up -d
```

---

### **Clean Everything**

```bash
# Stop all containers (keep data)
docker compose down

# Stop and remove volumes (delete everything)
docker compose down -v

# Remove all containers, networks, volumes
docker compose down -v --remove-orphans
```

---

## 🔍 TESTING ON MULTIPLE SERVERS

### **Test from different machines on network**

```bash
# Find your machine IP
hostname -I
# Example: 192.168.1.5

# From another computer on network, replace IP:
curl http://192.168.1.5/
curl http://192.168.1.5:8081/
curl http://192.168.1.5:8082/
curl http://192.168.1.5:8080/
```

---

### **Load Testing (simulate multiple users)**

```bash
# Install Apache Bench if needed
sudo apt-get install apache2-utils

# Test 100 requests with 10 concurrent
ab -n 100 -c 10 http://localhost/

# Test and watch round-robin distribution
for i in {1..10}; do
  ab -n 10 -c 5 http://localhost/ &
done
wait
echo "✅ Load test complete"
```

---

### **Docker Container Testing**

```bash
# Enter a container and test from inside
docker exec -it loadbalancer bash

# Inside container - test upstreams
curl http://worker1:80/
curl http://worker2:80/

# Check network
ping worker1
ping worker2

exit
```

---

## 📈 PERFORMANCE MONITORING

### **Real-time Stats**

```bash
# Watch Docker stats
docker stats

# Watch container resource usage
docker compose ps --format "table {{.Names}}\t{{.Status}}"
```

---

### **NGINX Stats**

```bash
# View nginx access logs
docker compose logs loadbalancer | grep "GET /"

# Count requests per worker
docker compose logs loadbalancer | grep "worker1" | wc -l
docker compose logs loadbalancer | grep "worker2" | wc -l
```

---

## ⚙️ SYSTEM STARTUP AUTOMATION

### **Create Startup Script**

```bash
# Create file: ~/start-cluster.sh
cat > ~/start-cluster.sh << 'EOF'
#!/bin/bash
cd ~/Downloads/test1

echo "🚀 Starting Docker Mini Cluster..."
docker compose up -d

echo "⏳ Waiting for services to be healthy..."
sleep 10

echo "✅ Cluster Status:"
docker compose ps

echo "🌐 Access points:"
echo "  Load Balancer: http://localhost"
echo "  Worker 1: http://localhost:8081"
echo "  Worker 2: http://localhost:8082"
echo "  Jenkins: http://localhost:8080"

# Optional: Start ngrok
# ngrok http 8080
EOF

chmod +x ~/start-cluster.sh

# Run it anytime:
~/start-cluster.sh
```

---

### **Auto-start on System Boot**

```bash
# Add to crontab
crontab -e

# Add this line:
@reboot cd ~/Downloads/test1 && docker compose up -d
```

---

## 🆘 TROUBLESHOOTING

### **Issue: Port Already in Use**

```bash
# Check what's using port 80
sudo lsof -i :80

# Kill process
sudo kill -9 <PID>

# Or use different port in docker-compose.yml
# Change ports section for loadbalancer
```

---

### **Issue: Jenkins Can't Connect to Docker**

```bash
# Verify docker socket is accessible
docker exec jenkins docker ps

# Fix if needed
docker exec -u root jenkins usermod -aG docker jenkins
docker compose restart jenkins
```

---

### **Issue: Containers Keep Restarting**

```bash
# Check logs
docker compose logs --tail 20 <service-name>

# Remove and recreate
docker compose down
docker compose up -d
```

---

### **Issue: Health Checks Failing**

```bash
# Check container health
docker inspect <container-name> | grep -A 5 "State"

# Manually test
docker exec <container-name> curl http://localhost/health

# Check disk space
df -h
```

---

## 📱 TESTING COMMANDS CHEATSHEET

```bash
# Quick health check all services
for service in loadbalancer worker1 worker2 jenkins; do
  echo "Testing $service..."
  docker exec $service curl -s http://localhost/health 2>/dev/null && echo "✅ OK" || echo "❌ FAIL"
done

# Quick performance test
ab -n 100 -c 10 http://localhost/

# View all connections
docker compose logs -f --tail 0

# Restart and test
docker compose restart && sleep 5 && docker compose ps
```

---

## 🎯 COMPLETE WORKFLOW

```bash
# 1. Start cluster
docker compose up -d

# 2. Wait for health
sleep 10

# 3. Verify status
docker compose ps

# 4. Test load balancer
curl http://localhost/

# 5. Run load tests
ab -n 50 -c 5 http://localhost/

# 6. View logs
docker compose logs -f

# 7. Stop when done
docker compose down
```

---

## 📞 QUICK COMMANDS REFERENCE

```bash
# Start everything
docker compose up -d

# Check status
docker compose ps

# View logs (all)
docker compose logs

# View logs (specific service, follow)
docker compose logs -f loadbalancer

# Stop everything
docker compose stop

# Stop and remove
docker compose down

# Stop and remove including volumes
docker compose down -v

# Restart specific service
docker compose restart jenkins

# Execute command in container
docker exec jenkins curl http://localhost:8080

# Enter container shell
docker exec -it loadbalancer bash

# Test connectivity
curl http://localhost/
curl http://localhost:8081/
curl http://localhost:8082/

# Performance test
ab -n 100 -c 10 http://localhost/

# Check resource usage
docker stats
```

---

## ✅ Final Checklist

- [ ] Docker compose up -d runs successfully
- [ ] All 5 containers show "healthy" or "up"
- [ ] Load balancer responds on port 80
- [ ] Workers respond on ports 8081 & 8082
- [ ] Jenkins dashboard loads on port 8080
- [ ] ngrok is running (if needed)
- [ ] GitHub webhook is configured
- [ ] Can push code and trigger builds
- [ ] Load balancer round-robin works
- [ ] All health checks pass ✅

---

**Ready to deploy? Run:** `docker compose up -d` 🚀
