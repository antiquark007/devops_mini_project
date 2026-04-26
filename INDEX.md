# 📚 Project Documentation Index

Complete guide to all files and their purposes.

---

## 🎯 **START HERE**

### New to this project?
1. Read **[GETTING_STARTED.md](GETTING_STARTED.md)** - Choose your learning path
2. Run one of the options:
   - **Docker Compose:** `docker compose up -d`
   - **Kubernetes:** `./deploy-k8s.sh`
3. Explore and experiment!

---

## 📖 Documentation Files

### Main Documentation

| File | Purpose | For Whom |
|------|---------|----------|
| [README.md](README.md) | **Project overview & architecture** | Everyone |
| [GETTING_STARTED.md](GETTING_STARTED.md) | **Choose your learning path** | Beginners |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | **Common commands & quick fixes** | Everyone |
| [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md) | **Detailed comparison table** | Decision makers |
| [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) | **Real-world use cases** | Advanced users |

### Technology-Specific

| File | Purpose | For Whom |
|------|---------|----------|
| [QUICK_START.md](QUICK_START.md) | **Docker Compose quick start** | Docker users |
| [SETUP_AND_TEST.md](SETUP_AND_TEST.md) | **Advanced Docker Compose setup** | Advanced Docker users |
| [k8s/README.md](k8s/README.md) | **Kubernetes deployment guide** | Kubernetes users |

### Reference

| File | Purpose |
|------|---------|
| [COMMANDS_REFERENCE.txt](COMMANDS_REFERENCE.txt) | Quick command reference |
| [Jenkinsfile](Jenkinsfile) | CI/CD pipeline definition |
| [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) | 10 real-world scenarios |

---

## 🚀 Executable Scripts

### Docker Compose Scripts

```bash
./start-cluster.sh        # Start Docker Compose cluster with health checks
./test-cluster.sh         # Run complete test suite for Docker Compose
```

### Kubernetes Scripts

```bash
./deploy-k8s.sh          # Deploy everything to Kubernetes (one command!)
./test-k8s.sh            # Run complete test suite for Kubernetes
./cleanup-k8s.sh         # Delete all Kubernetes resources
```

**Example:**
```bash
# Kubernetes in 3 steps
./deploy-k8s.sh          # Deploy
./test-k8s.sh            # Test
./cleanup-k8s.sh         # Clean
```

---

## 🗂️ Configuration Files

### Docker Compose

```
docker-compose.yml       ← Main Docker Compose configuration
├─ master               ← Ubuntu container
├─ worker1              ← NGINX container
├─ worker2              ← NGINX container
├─ loadbalancer         ← NGINX load balancer
└─ jenkins              ← Jenkins CI/CD
```

### Kubernetes Manifests (`k8s/` folder)

```
k8s/
├─ 01-namespace.yaml              ← Create 'mini-cluster' namespace
├─ 02-configmap-nginx.yaml        ← NGINX configurations
├─ 03-master-deployment.yaml      ← Master pod + service
├─ 04-workers-deployment.yaml     ← Worker StatefulSet
├─ 05-loadbalancer-deployment.yaml ← Load balancer deployment
├─ 06-jenkins-deployment.yaml     ← Jenkins + storage + RBAC
└─ README.md                      ← Kubernetes-specific guide
```

### Application Configuration

```
master/
└─ index.html            ← Website content

worker/
└─ nginx.conf            ← Worker NGINX config

loadbalancer/
└─ nginx.conf            ← Load balancer NGINX config

Jenkinsfile             ← CI/CD pipeline stages
```

---

## 📖 Reading Guide by Role

### 👶 Beginners (New to DevOps)

**Day 1:**
1. [GETTING_STARTED.md](GETTING_STARTED.md) - 20 min read
2. [README.md](README.md) - Overview - 15 min read
3. Run: `docker compose up -d` - 10 sec
4. Visit: http://localhost - 5 min explore

**Day 2:**
1. [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md) - Comparison - 20 min read
2. [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Commands - 15 min read
3. Try: `docker compose ps` - View status
4. Try: `docker compose logs jenkins` - View logs

**Day 3:**
1. Run: `./test-cluster.sh` - Full test suite
2. Read: [SETUP_AND_TEST.md](SETUP_AND_TEST.md) - Advanced topics
3. Explore: Modify `master/index.html`
4. Redeploy: `docker compose restart`

### 👨‍💼 Intermediate (Some Docker experience)

**Week 1: Docker Compose Deep Dive**
1. [QUICK_START.md](QUICK_START.md) - Refresh basics
2. [SETUP_AND_TEST.md](SETUP_AND_TEST.md) - Advanced Docker
3. Run complete test suite
4. Modify configurations

**Week 2: Introduction to Kubernetes**
1. [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md) - Understand differences
2. [GETTING_STARTED.md](GETTING_STARTED.md) - Learn concepts
3. [k8s/README.md](k8s/README.md) - Kubernetes guide
4. Run: `./deploy-k8s.sh`

**Week 3: Experiment with Kubernetes**
1. Scale: `kubectl scale statefulset/worker --replicas=5 -n mini-cluster`
2. Update: `kubectl set image deployment/jenkins ...`
3. Monitor: `kubectl get pods -n mini-cluster -w`
4. Cleanup: `./cleanup-k8s.sh`

### 🚀 Advanced (Kubernetes experienced)

**Immediate:**
1. Review `k8s/` manifests
2. Understand the architecture
3. Run: `./deploy-k8s.sh`
4. Read: [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md)

**Next Steps:**
1. Add Ingress configuration
2. Implement auto-scaling
3. Add monitoring (Prometheus)
4. Add logging (ELK)
5. Deploy to cloud (EKS/GKE/AKS)

### 👨‍🏫 Instructors/Trainers

**Course Setup:**
1. [GETTING_STARTED.md](GETTING_STARTED.md) - Know all paths
2. [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md) - Teach comparison
3. [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) - Real examples

**Teaching Materials:**
- Use [QUICK_REFERENCE.md](QUICK_REFERENCE.md) as handout
- [README.md](README.md) as syllabus
- [GETTING_STARTED.md](GETTING_STARTED.md) as roadmap

**Assignments:**
- See [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) for projects

---

## 🔍 Quick Lookup by Topic

### **Getting Started**
- 🆕 Completely new: [GETTING_STARTED.md](GETTING_STARTED.md)
- ⚡ Quick start: [QUICK_START.md](QUICK_START.md)
- 📖 Main overview: [README.md](README.md)

### **Docker Compose**
- 🚀 Quick run: `docker compose up -d`
- 📚 Full guide: [QUICK_START.md](QUICK_START.md)
- 🧪 Testing: `./test-cluster.sh`
- 🔧 Advanced: [SETUP_AND_TEST.md](SETUP_AND_TEST.md)

### **Kubernetes**
- 🚀 Quick run: `./deploy-k8s.sh`
- 📚 Full guide: [k8s/README.md](k8s/README.md)
- 🧪 Testing: `./test-k8s.sh`
- 📋 Cleanup: `./cleanup-k8s.sh`

### **Comparison**
- 🔄 Which to choose: [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md)
- 📊 Feature table: [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md)
- 🎯 Use cases: [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md)

### **Commands**
- 📚 Command reference: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- 🐳 Docker commands: [QUICK_START.md](QUICK_START.md)
- ☸️ Kubectl commands: [k8s/README.md](k8s/README.md)

### **CI/CD**
- 🔧 Pipeline config: [Jenkinsfile](Jenkinsfile)
- 📚 Setup guide: [README.md](README.md) - Jenkins section
- 🎯 Automation: [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) - Scenario 6

### **Troubleshooting**
- 🆘 Common issues: [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md)
- 🔍 Docker debugging: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- ☸️ Kubernetes debugging: [k8s/README.md](k8s/README.md)

### **Scenarios**
- 🎓 Learning DevOps: [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) - Scenario 1
- 🏢 Production setup: [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) - Scenario 4
- ☁️ Cloud deploy: [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) - Scenario 3
- 🤖 CI/CD pipeline: [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md) - Scenario 6

---

## 📊 File Dependency Map

```
README.md (Start here)
├─ GETTING_STARTED.md (Choose path)
│  ├─ QUICK_START.md (Docker path)
│  │  ├─ docker-compose.yml
│  │  ├─ start-cluster.sh
│  │  └─ test-cluster.sh
│  │
│  └─ k8s/README.md (Kubernetes path)
│     ├─ k8s/01-namespace.yaml
│     ├─ k8s/02-configmap-nginx.yaml
│     ├─ ... (other K8s manifests)
│     ├─ deploy-k8s.sh
│     ├─ test-k8s.sh
│     └─ cleanup-k8s.sh
│
├─ DOCKER_VS_KUBERNETES.md (Compare)
├─ QUICK_REFERENCE.md (Commands)
├─ DEPLOYMENT_SCENARIOS.md (Projects)
└─ SETUP_AND_TEST.md (Advanced)

Jenkinsfile (CI/CD)
master/index.html (Website)
worker/nginx.conf (Config)
loadbalancer/nginx.conf (Config)
```

---

## ✅ Verification Checklist

### Docker Compose Setup
- [ ] Docker installed: `docker --version`
- [ ] Docker Compose installed: `docker compose version`
- [ ] Project cloned
- [ ] Read [GETTING_STARTED.md](GETTING_STARTED.md)
- [ ] Run: `docker compose up -d`
- [ ] Visit: http://localhost
- [ ] Run: `./test-cluster.sh`

### Kubernetes Setup
- [ ] Docker installed: `docker --version`
- [ ] Kubernetes cluster running: `kubectl cluster-info`
- [ ] kubectl configured
- [ ] Project cloned
- [ ] Read [k8s/README.md](k8s/README.md)
- [ ] Run: `./deploy-k8s.sh`
- [ ] Run: `./test-k8s.sh`

---

## 🆘 Quick Troubleshooting

**Can't find a command?** → [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

**Not sure which to use?** → [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md)

**Want to learn?** → [GETTING_STARTED.md](GETTING_STARTED.md)

**Need real examples?** → [DEPLOYMENT_SCENARIOS.md](DEPLOYMENT_SCENARIOS.md)

**Docker issue?** → [SETUP_AND_TEST.md](SETUP_AND_TEST.md)

**Kubernetes issue?** → [k8s/README.md](k8s/README.md)

---

## 📞 Support Resources

### In This Project
- Documentation: All `.md` files in root
- Kubernetes: All files in `k8s/` folder
- Configuration: `docker-compose.yml`, `Jenkinsfile`
- Scripts: `*.sh` files

### External Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Kubernetes Official Docs](https://kubernetes.io/docs/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)

---

## 🎓 Learning Paths Summary

```
BEGINNER              INTERMEDIATE            ADVANCED
├─ Day 1-3            ├─ Week 1                ├─ Production
│  Read & explore     │  Docker mastery        │  Hardening
├─ QUICK_START.md     ├─ SETUP_AND_TEST.md     ├─ DEPLOYMENT_
├─ Docker Compose     ├─ DOCKER_VS_            │  SCENARIOS.md
└─ ./test-cluster.sh  │  KUBERNETES.md         ├─ Cloud (EKS/GKE)
                      ├─ Week 2-3              └─ Monitoring
                      │  Kubernetes basics     │  Logging
                      ├─ k8s/README.md         │  Security
                      ├─ ./deploy-k8s.sh       │  Auto-scaling
                      └─ ./test-k8s.sh
```

---

## 📈 Progress Tracking

### Docker Compose Milestones
- [ ] Containers start successfully
- [ ] Website accessible
- [ ] Load balancing working
- [ ] Jenkins pipeline running
- [ ] Custom changes deployed

### Kubernetes Milestones
- [ ] Cluster connection verified
- [ ] Manifests applied successfully
- [ ] All pods running
- [ ] Services accessible
- [ ] Auto-scaling tested
- [ ] Rolling updates working

---

## 🎉 Next Steps

1. ✅ Choose your path (Docker Compose or Kubernetes)
2. ✅ Follow the getting started guide
3. ✅ Complete milestone checklist
4. ✅ Explore real-world scenarios
5. ✅ Share your learnings!

**Happy learning!** 🚀

---

