# ⚡ QUICK START GUIDE

## 🚀 One-Command Startup

```bash
~/Downloads/test1/start-cluster.sh
```

This will:
- ✅ Start all 5 Docker containers
- ✅ Wait for services to stabilize
- ✅ Run health checks
- ✅ Test load balancer
- ✅ Display access URLs
- ✅ Show quick commands

---

## 🧪 Complete Testing Suite

```bash
~/Downloads/test1/test-cluster.sh
```

This tests:
- Container status
- Health checks on all services
- Load balancer round-robin
- Direct worker access
- Network connectivity
- Volume mounting
- Docker resources
- Load testing (if Apache Bench installed)
- Jenkins access
- Log summaries

---

## 📱 Quick Commands Reference

```bash
# Go to project directory
cd ~/Downloads/test1

# Start everything
docker compose up -d

# Check status
docker compose ps

# View logs (live)
docker compose logs -f

# Stop everything
docker compose down

# Test load balancer
curl http://localhost/

# Performance test (100 requests, 10 concurrent)
ab -n 100 -c 10 http://localhost/

# Test round-robin (should alternate)
for i in {1..6}; do curl -s http://localhost | grep Docker; done

# Jenkins dashboard
http://localhost:8080
```

---

## 🔗 Access Points

| Service | URL | Port |
|---------|-----|------|
| Load Balancer | http://localhost | 80 |
| Worker 1 | http://localhost:8081 | 8081 |
| Worker 2 | http://localhost:8082 | 8082 |
| Jenkins | http://localhost:8080 | 8080 |

---

## 🔄 GitHub Automation

### Terminal 1: Start ngrok
```bash
ngrok http 8080
# Copy the HTTPS URL
```

### Terminal 2: Start cluster
```bash
~/Downloads/test1/start-cluster.sh
```

### GitHub Webhook Setup
1. https://github.com/antiquark007/devops_mini_project/settings/hooks
2. **Payload URL:** `https://your-ngrok-url.ngrok-free.dev/github-webhook/`
3. **Events:** ✅ Just push
4. Click **Add webhook**

### Test Automated Build
```bash
cd ~/Downloads/test1
echo "# Update" >> README.md
git add .
git commit -m "Test"
git push origin main

# Watch Jenkins auto-build at http://localhost:8080
```

---

## 📊 Monitoring Commands

```bash
# View all container logs (live)
docker compose logs -f

# View specific service logs
docker compose logs -f loadbalancer
docker compose logs -f worker1

# Monitor resource usage
docker stats

# Network inspection
docker network inspect test1_cluster_network

# Volume status
docker volume ls
```

---

## 🔧 Troubleshooting

```bash
# Check if all containers are healthy
docker compose ps

# Restart a service
docker compose restart jenkins

# Full rebuild (stop + remove + start)
docker compose down && docker compose up -d

# Remove everything including volumes
docker compose down -v

# Check specific service's health
curl http://localhost/health
curl http://localhost:8081/health
curl http://localhost:8082/health
curl http://localhost:8080/health
```

---

## 📖 Full Documentation

See: `SETUP_AND_TEST.md` for complete guide with:
- Detailed setup instructions
- Comprehensive testing procedures
- Troubleshooting tips
- Load testing examples
- Automation setup

---

## 📋 Complete Workflow

```bash
# 1. Open 3 terminals

# Terminal 1: Start ngrok (optional for GitHub webhooks)
ngrok http 8080

# Terminal 2: Start cluster
cd ~/Downloads/test1
./start-cluster.sh

# Terminal 3: Run tests
./test-cluster.sh

# 4. Make code changes and push
git push origin main

# 5. Watch Jenkins auto-build at http://localhost:8080
# 6. Cluster auto-deploys!
```

---

## ✅ Pre-flight Checklist

Before starting, verify:
- [ ] Docker is installed: `docker --version`
- [ ] Docker Compose works: `docker compose version`
- [ ] Project dir exists: `~/Downloads/test1`
- [ ] All files present: `ls -la ~/Downloads/test1/`

---

**Ready to go?** 

```bash
~/Downloads/test1/start-cluster.sh
```

🚀
