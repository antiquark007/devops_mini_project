# 🎯 Getting Started Guide

Choose your path based on your experience level:

---

## 👶 **BEGINNER** - I'm new to DevOps

### Path: Docker Compose First

1. **Read** `QUICK_START.md` (5 min)
2. **Run** `docker compose up -d` (10 sec)
3. **Visit** http://localhost in browser
4. **Explore** with `docker compose ps`
5. **Test** with `./test-cluster.sh`
6. **Stop** with `docker compose down`

**Time**: 30 minutes
**Complexity**: ⭐☆☆☆☆

### Next Steps
After mastering Docker Compose, move to Kubernetes (see INTERMEDIATE path).

---

## 👨‍💼 **INTERMEDIATE** - I know Docker, want to learn Kubernetes

### Path: Docker Compose → Kubernetes

#### Step 1: Docker Compose (Refresher)
```bash
docker compose up -d
# Play around for 10 minutes
docker compose down
```

#### Step 2: Kubernetes Basics
Read `DOCKER_VS_KUBERNETES.md` (understand the concepts)

#### Step 3: Deploy to Kubernetes
```bash
./deploy-k8s.sh
./test-k8s.sh
```

#### Step 4: Explore
- View pods: `kubectl get pods -n mini-cluster`
- View logs: `kubectl logs -n mini-cluster deployment/jenkins -f`
- Scale workers: `kubectl scale statefulset/worker --replicas=3 -n mini-cluster`

#### Step 5: Cleanup
```bash
./cleanup-k8s.sh
```

**Time**: 1-2 hours
**Complexity**: ⭐⭐⭐☆☆

### Next Steps
Read [Kubernetes documentation](https://kubernetes.io/docs/), try advanced features (Helm, Operators, etc.)

---

## 🚀 **ADVANCED** - I want production-ready setup

### Path: Full K8s with Best Practices

1. **Review** `k8s/` folder structure
2. **Understand** each manifest file
3. **Deploy** with `./deploy-k8s.sh`
4. **Enhance**:
   - Add Ingress for external access
   - Add NetworkPolicies for security
   - Add PodDisruptionBudgets for availability
   - Implement Helm charts
   - Add monitoring (Prometheus, Grafana)
   - Add logging (ELK stack)

5. **Deploy to Cloud**:
   - GKE (Google)
   - EKS (Amazon)
   - AKS (Microsoft)

**Time**: 1-2 days
**Complexity**: ⭐⭐⭐⭐⭐

---

## 📖 Recommended Reading Order

### For Docker Compose
1. `QUICK_START.md` - Get it running quickly
2. `docker-compose.yml` - Understand the config
3. `README.md` - Overall architecture
4. `QUICK_REFERENCE.md` - Common commands

### For Kubernetes
1. `DOCKER_VS_KUBERNETES.md` - Learn the differences
2. `k8s/README.md` - K8s specific guide
3. `k8s/01-namespace.yaml` - Start simple
4. `k8s/02-configmap-nginx.yaml` - ConfigMaps concept
5. `k8s/03-master-deployment.yaml` - Deployments
6. `k8s/04-workers-deployment.yaml` - StatefulSets
7. `k8s/06-jenkins-deployment.yaml` - PVC, RBAC, Services
8. `QUICK_REFERENCE.md` - Common commands

---

## 🎓 Learning Objectives

### After Docker Compose Section
- [ ] Understand container basics
- [ ] Know what Docker Compose does
- [ ] Can start/stop services
- [ ] Can view logs and troubleshoot
- [ ] Understand load balancing basics

### After Kubernetes Section
- [ ] Understand Kubernetes architecture
- [ ] Know key concepts (Pods, Services, Deployments)
- [ ] Can deploy and manage applications
- [ ] Can scale applications
- [ ] Can monitor and view logs
- [ ] Ready for cloud deployment

---

## 💻 System Requirements

### Minimum for Docker Compose
- **OS**: Linux, macOS, or Windows
- **RAM**: 4 GB
- **Disk**: 5 GB free
- **Docker**: v20.10+
- **CPU**: 2 cores

### Minimum for Kubernetes
- **OS**: Linux, macOS, or Windows
- **RAM**: 4 GB (recommended 8 GB)
- **Disk**: 20 GB free
- **Kubernetes**: v1.20+ (local: minikube/kind)
- **CPU**: 2+ cores

---

## 🛠️ Installation Guide

### Prerequisites

**On Linux:**
```bash
# Check Docker
docker --version
docker compose version

# For Kubernetes
kubectl version --client
# Or install: https://kubernetes.io/docs/tasks/tools/
```

**On macOS:**
```bash
# Docker Desktop includes docker compose and kubectl
docker --version
docker compose version
kubectl version --client
```

**On Windows:**
```bash
# Use Docker Desktop for Windows
# Or WSL2 with Linux container support
docker --version
docker compose version
kubectl version --client
```

### Set Up Local Kubernetes

**Option 1: minikube (Recommended for learning)**
```bash
# Install: https://minikube.sigs.k8s.io/
minikube start
kubectl cluster-info
```

**Option 2: kind (Lightweight, fast)**
```bash
# Install: https://kind.sigs.k8s.io/
kind create cluster
kubectl cluster-info
```

**Option 3: Docker Desktop**
```bash
# Enable Kubernetes in Docker Desktop preferences
kubectl cluster-info
```

---

## ✅ Setup Checklist

### Before Starting

- [ ] Docker installed and running
  ```bash
  docker --version
  docker compose version
  ```

- [ ] Ports available (80, 8080, 8081, 8082)
  ```bash
  # Check if ports are free
  netstat -tlnp | grep -E ':(80|8080|8081|8082)'
  ```

- [ ] For Kubernetes: Cluster running
  ```bash
  kubectl cluster-info
  kubectl get nodes
  ```

- [ ] Project cloned/downloaded
  ```bash
  cd devops_mini_project
  ls -la
  ```

### First Run

- [ ] Docker Compose
  ```bash
  ./start-cluster.sh
  ```

- [ ] Kubernetes
  ```bash
  ./deploy-k8s.sh
  ```

---

## 🎯 Quick Wins

### Docker Compose (10 minutes)
```bash
# Start
docker compose up -d

# Visit website
# Open http://localhost in browser

# View logs
docker compose logs -f

# Stop
docker compose down
```

### Kubernetes (15 minutes)
```bash
# Deploy
./deploy-k8s.sh

# Check pods
kubectl get pods -n mini-cluster

# Access services
kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80
# Open http://localhost:8000

# Cleanup
./cleanup-k8s.sh
```

---

## 📚 External Resources

### Docker Compose
- [Official Docs](https://docs.docker.com/compose/)
- [Compose Specification](https://github.com/compose-spec/compose-spec)
- [Docker Hub](https://hub.docker.com/)

### Kubernetes
- [Kubernetes.io Docs](https://kubernetes.io/docs/)
- [Kubernetes by Example](https://kubernetesdocs.com/)
- [Interactive Tutorials](https://kubernetes.io/docs/tutorials/)

### Learning Platforms
- [Linux Academy](https://linuxacademy.com/)
- [A Cloud Guru](https://acloudguru.com/)
- [Udemy Courses](https://www.udemy.com/)
- [freeCodeCamp](https://www.freecodecamp.org/)

---

## 🤔 Frequently Asked Questions

**Q: Which should I learn first?**
A: Docker Compose. It's simpler and helps you understand the concepts before Kubernetes complexity.

**Q: Can I run both simultaneously?**
A: Yes, but they may compete for ports. Stop one before starting the other.

**Q: How long does deployment take?**
A: Docker Compose: 10-15 seconds. Kubernetes: 2-3 minutes (includes initialization).

**Q: Is this production-ready?**
A: Docker Compose: No, local only. Kubernetes: Partially (good for learning, needs hardening for prod).

**Q: Can I use this on the cloud?**
A: Docker Compose: Limited (single host). Kubernetes: Yes, fully portable to any K8s cluster.

**Q: How do I update components?**
A: Docker Compose: Edit config and rerun. Kubernetes: Use `kubectl set image` or update manifests.

---

## 📞 Getting Help

### Having Issues?

1. **Check logs**
   - Docker Compose: `docker compose logs <service>`
   - Kubernetes: `kubectl logs -n mini-cluster <pod-name>`

2. **Verify setup**
   - Docker Compose: `docker compose ps`
   - Kubernetes: `kubectl get all -n mini-cluster`

3. **Read docs**
   - See `README.md` for general info
   - See `DOCKER_VS_KUBERNETES.md` for comparison
   - See `QUICK_REFERENCE.md` for commands

4. **Run tests**
   - Docker Compose: `./test-cluster.sh`
   - Kubernetes: `./test-k8s.sh`

---

## 🎉 Next Steps After Completing

### Phase 1: Foundations ✓
- Docker Compose basics
- Container concepts
- Load balancing

### Phase 2: Kubernetes
- Kubernetes deployments
- Service management
- Persistent storage

### Phase 3: Advanced Topics
- CI/CD integration (Jenkins)
- Monitoring (Prometheus)
- Logging (ELK)
- Security (RBAC, NetworkPolicies)

### Phase 4: Production
- Cloud deployment (AWS/GCP/Azure)
- Auto-scaling
- Disaster recovery
- Enterprise security

---

