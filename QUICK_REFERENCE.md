# ⚡ Quick Reference Guide

## 🚀 One-Minute Quick Start

### Docker Compose
```bash
docker compose up -d
docker compose ps
# Website: http://localhost
```

### Kubernetes
```bash
./deploy-k8s.sh
kubectl get pods -n mini-cluster
# Then port-forward to access
```

---

## 📋 Most Common Commands

### Docker Compose

| Task | Command |
|------|---------|
| Start all services | `docker compose up -d` |
| Stop all services | `docker compose down` |
| Check status | `docker compose ps` |
| View logs | `docker compose logs -f <service>` |
| Rebuild | `docker compose up -d --build` |
| Remove volumes | `docker compose down -v` |
| Exec in container | `docker compose exec <service> bash` |

### Kubernetes

| Task | Command |
|------|---------|
| Deploy all | `./deploy-k8s.sh` or `kubectl apply -f k8s/` |
| Check pods | `kubectl get pods -n mini-cluster` |
| Watch pods | `kubectl get pods -n mini-cluster -w` |
| View logs | `kubectl logs -n mini-cluster deployment/jenkins -f` |
| Port forward | `kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80` |
| Describe pod | `kubectl describe pod <pod-name> -n mini-cluster` |
| Exec in pod | `kubectl exec -it -n mini-cluster pod/<pod-name> -- bash` |
| Scale | `kubectl scale statefulset/worker --replicas=3 -n mini-cluster` |
| Cleanup | `./cleanup-k8s.sh` |

---

## 🌐 Service URLs

### Docker Compose (Direct Access)
- **Website** → http://localhost
- **Jenkins** → http://localhost:8080
- **Worker 1** → http://localhost:8081
- **Worker 2** → http://localhost:8082

### Kubernetes (Port Forward)
```bash
# Website
kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80
→ http://localhost:8000

# Jenkins
kubectl port-forward -n mini-cluster svc/jenkins-service 8080:8080
→ http://localhost:8080

# Workers
kubectl port-forward -n mini-cluster svc/worker-nodeport 8081:80
→ http://localhost:8081
```

---

## 📚 File Structure

```
devops_mini_project/
├── docker-compose.yml          # Docker Compose setup
├── Jenkinsfile                 # CI/CD pipeline
├── QUICK_START.md             # Quick start guide
├── README.md                   # Main documentation
├── DOCKER_VS_KUBERNETES.md    # Comparison guide
├── QUICK_REFERENCE.md         # This file
├── start-cluster.sh           # Docker Compose startup script
├── test-cluster.sh            # Docker Compose test script
├── deploy-k8s.sh              # Kubernetes deployment script
├── test-k8s.sh                # Kubernetes test script
├── cleanup-k8s.sh             # Kubernetes cleanup script
├── k8s/                        # Kubernetes manifests
│   ├── 01-namespace.yaml
│   ├── 02-configmap-nginx.yaml
│   ├── 03-master-deployment.yaml
│   ├── 04-workers-deployment.yaml
│   ├── 05-loadbalancer-deployment.yaml
│   ├── 06-jenkins-deployment.yaml
│   └── README.md
├── master/
│   └── index.html             # Website content
├── worker/
│   └── nginx.conf             # Worker NGINX config
└── loadbalancer/
    └── nginx.conf             # Load balancer NGINX config
```

---

## 🆘 Troubleshooting Quick Fixes

### Docker Compose Issues

**Containers not starting?**
```bash
docker compose logs <service>
```

**Port already in use?**
```bash
docker compose down
# Then fix the port or kill the conflicting process
```

**Reset everything?**
```bash
docker compose down -v
docker compose up -d
```

### Kubernetes Issues

**Pods not ready?**
```bash
kubectl describe pod <pod-name> -n mini-cluster
kubectl logs <pod-name> -n mini-cluster
```

**Can't access services?**
```bash
kubectl get svc -n mini-cluster
# Make sure to use port-forward
```

**Need a fresh start?**
```bash
./cleanup-k8s.sh
./deploy-k8s.sh
```

---

## 🔍 Health Checks

### Docker Compose
```bash
# All running?
docker compose ps

# Check specific service
docker compose exec <service> curl http://localhost/health
```

### Kubernetes
```bash
# All pods ready?
kubectl get pods -n mini-cluster

# Describe a pod to see status
kubectl describe pod <pod-name> -n mini-cluster

# Check service endpoints
kubectl get endpoints -n mini-cluster
```

---

## 📊 View Logs

### Docker Compose
```bash
# All services
docker compose logs

# Specific service
docker compose logs jenkins

# Follow (real-time)
docker compose logs -f <service>

# Last 100 lines
docker compose logs --tail 100
```

### Kubernetes
```bash
# Specific deployment
kubectl logs -n mini-cluster deployment/jenkins

# Follow (real-time)
kubectl logs -f -n mini-cluster deployment/jenkins

# Previous logs (if crashed)
kubectl logs -p -n mini-cluster pod/<pod-name>

# All pods in namespace
kubectl logs -l app=worker -n mini-cluster
```

---

## 🎛️ Scaling & Updates

### Docker Compose
```bash
# Edit docker-compose.yml to change replicas
# Then redeploy
docker compose down
docker compose up -d
```

### Kubernetes
```bash
# Scale workers to 3
kubectl scale statefulset/worker --replicas=3 -n mini-cluster

# Update image
kubectl set image deployment/jenkins jenkins=jenkins/jenkins:2.375.1 -n mini-cluster

# Monitor rolling update
kubectl rollout status deployment/jenkins -n mini-cluster

# Rollback if needed
kubectl rollout undo deployment/jenkins -n mini-cluster
```

---

## 💾 Persistent Data

### Docker Compose
```bash
# Volumes are stored in Docker
docker volume ls
docker volume inspect <volume-name>
```

### Kubernetes
```bash
# PersistentVolumes
kubectl get pv -n mini-cluster
kubectl get pvc -n mini-cluster

# Describe PVC
kubectl describe pvc jenkins-pvc -n mini-cluster
```

---

## 🔐 Jenkins Access

### Default Credentials
- **Username**: `admin`
- **Password**: `admin`

### Reset Jenkins Password
```bash
# Docker Compose
docker compose exec jenkins bash
# Follow Jenkins password reset guide

# Kubernetes
kubectl exec -it -n mini-cluster deployment/jenkins -- bash
# Follow Jenkins password reset guide
```

---

## 📱 SSH/Shell Access

### Docker Compose
```bash
docker compose exec <service> bash
docker compose exec master bash
docker compose exec jenkins bash
```

### Kubernetes
```bash
kubectl exec -it -n mini-cluster pod/<pod-name> -- bash
kubectl exec -it -n mini-cluster deployment/master -- bash
kubectl exec -it -n mini-cluster pod/worker-0 -- bash
```

---

## 🆚 Testing Both Setups

```bash
# Try Docker Compose first
docker compose up -d
./test-cluster.sh
docker compose down

# Then try Kubernetes
./deploy-k8s.sh
./test-k8s.sh
./cleanup-k8s.sh
```

---

## 📞 Need Help?

### Docker Compose
- Check `docker compose --help`
- View official docs: https://docs.docker.com/compose/

### Kubernetes
- Check `kubectl --help`
- View official docs: https://kubernetes.io/docs/

### This Project
- See `README.md` for overview
- See `DOCKER_VS_KUBERNETES.md` for comparison
- See `k8s/README.md` for Kubernetes-specific guide
- See `QUICK_START.md` for quick commands

---

