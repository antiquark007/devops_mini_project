# 🐳 DevOps Mini Cluster

A beginner-friendly cluster demonstrating load balancing, CI/CD with Jenkins, and containerization.

**Now with Kubernetes support!** Choose Docker Compose for learning or Kubernetes for production.

---

## 🎯 Quick Navigation

- **🚀 First time?** → Read [GETTING_STARTED.md](GETTING_STARTED.md)
- **🐳 Docker Compose?** → See [Quick Start](#-quick-start-docker-compose)
- **☸️ Kubernetes?** → Run `./deploy-k8s.sh` or see [k8s/README.md](k8s/README.md)
- **🔄 Compare?** → See [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md)
- **📚 Commands?** → See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

---

## 📁 Project Structure

```
devops_mini_project/
├── 🐳 DOCKER COMPOSE (Local Learning)
│   ├── docker-compose.yml       ← Service definitions
│   ├── QUICK_START.md           ← Quick guide
│   ├── start-cluster.sh         ← Easy startup
│   └── test-cluster.sh          ← Test suite
│
├── ☸️ KUBERNETES (Production)
│   ├── k8s/                     ← All manifests
│   │   ├── 01-namespace.yaml
│   │   ├── 02-configmap-nginx.yaml
│   │   ├── 03-master-deployment.yaml
│   │   ├── 04-workers-deployment.yaml
│   │   ├── 05-loadbalancer-deployment.yaml
│   │   ├── 06-jenkins-deployment.yaml
│   │   └── README.md            ← Kubernetes guide
│   ├── deploy-k8s.sh            ← One-command deploy
│   ├── test-k8s.sh              ← K8s test suite
│   └── cleanup-k8s.sh           ← Clean everything
│
├── 📚 DOCUMENTATION
│   ├── README.md                ← You are here
│   ├── GETTING_STARTED.md       ← Choose your path
│   ├── DOCKER_VS_KUBERNETES.md  ← Detailed comparison
│   ├── QUICK_REFERENCE.md       ← Common commands
│   └── SETUP_AND_TEST.md        ← Advanced setup
│
├── 🔧 CONFIGURATION
│   ├── Jenkinsfile              ← CI/CD pipeline
│   ├── master/
│   │   └── index.html           ← Website content
│   ├── worker/
│   │   └── nginx.conf           ← Worker NGINX config
│   └── loadbalancer/
│       └── nginx.conf           ← LB NGINX config
│
└── 📋 REFERENCE
    ├── COMMANDS_REFERENCE.txt
    ├── start-cluster.sh
    └── test-cluster.sh
```

---

## 🏗️ Architecture

```
DEPLOYMENT OPTIONS:

1️⃣ DOCKER COMPOSE (Single Machine)
   Browser → Load Balancer (Port 80)
            ├→ Worker 1 (Port 8081)
            └→ Worker 2 (Port 8082)
            ↓ shared volume
   Master (Ubuntu)
   Jenkins (Port 8080)

2️⃣ KUBERNETES (Multi-Machine Ready)
   Browser → Load Balancer Service (LoadBalancer)
            ├→ Worker Pod 0
            └→ Worker Pod 1
            ↓ ConfigMaps
   Master Pod
   Jenkins Pod (with PersistentVolume)
   All with RBAC & Health Checks
```

---

## 🚀 Quick Start - CHOOSE YOUR PATH

### 🟦 Option 1: Docker Compose (Recommended for beginners)

**Best for:** Learning, local development, testing

```bash
# Start everything with one command
docker compose up -d

# Check status
docker compose ps

# Open in browser
# Website: http://localhost
# Jenkins: http://localhost:8080

# Stop
docker compose down
```

**Time to start:** ⚡ 10 seconds  
**Complexity:** ⭐ Easy  
**Documentation:** See [QUICK_START.md](QUICK_START.md)

---

### 🔶 Option 2: Kubernetes (Recommended for production)

**Best for:** Production, cloud deployment, scaling

```bash
# Deploy to Kubernetes cluster
./deploy-k8s.sh

# Check status
kubectl get pods -n mini-cluster

# Access services
kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80
# Website: http://localhost:8000

# Jenkins
kubectl port-forward -n mini-cluster svc/jenkins-service 8080:8080
# Website: http://localhost:8080

# Cleanup
./cleanup-k8s.sh
```

**Time to start:** 🔧 2-3 minutes  
**Complexity:** ⭐⭐⭐ Advanced  
**Prerequisites:** Kubernetes cluster (minikube, kind, or cloud)  
**Documentation:** See [k8s/README.md](k8s/README.md)

---

## 📊 Comparison at a Glance

| Feature | Docker Compose | Kubernetes |
|---------|---|---|
| **Setup Time** | 10 seconds | 2-3 minutes |
| **Complexity** | Easy | Intermediate |
| **Best Use Case** | Learning, local dev | Production, cloud |
| **Scaling** | Limited | Unlimited |
| **Auto-restart** | ✓ Yes | ✓ Yes |
| **Self-healing** | Manual | Automatic |
| **Cloud Ready** | No | Yes |
| **Resource Limits** | Basic | Advanced |

**→ See [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md) for detailed comparison**

---

## 🎯 Getting Started

**Not sure where to start?** → Read [GETTING_STARTED.md](GETTING_STARTED.md) for a guided path

---

## 🏗️ Architecture Details

```
Browser
   │
   ▼
┌──────────────────┐
│  Load Balancer   │  :80  (NGINX round-robin)
└──────┬─────┬─────┘
       │     │
  ┌────▼─┐ ┌─▼────┐
  │ W-1  │ │ W-2  │   :8081 / :8082  (NGINX workers)
  └──┬───┘ └───┬──┘
     │         │
     └────┬────┘
          │  shared Docker volume
     ┌────▼────┐
     │ Master  │  (Ubuntu — holds index.html)
     └─────────┘

Jenkins  :8080  (CI/CD — pulls GitHub, redeploys via docker-compose)
```

---

## 🚀 Docker Compose Quick Start

### Prerequisites

- Docker Desktop or Docker Engine installed
- `docker compose` (v2) available  
  Verify: `docker compose version`

### 1. Clone / download this project

```bash
git clone https://github.com/YOUR_USERNAME/docker-mini-cluster.git
cd docker-mini-cluster
```

### 2. Start the cluster

```bash
docker compose up -d
```

Wait ~10 seconds for all containers to initialise.

### 3. Verify everything is running

```bash
docker compose ps
```

Expected output — all containers should show `running` / `Up`:

```
NAME            STATUS
master          Up
worker1         Up
loadbalancer    Up
worker2         Up
jenkins         Up
```

### 4. Open in browser

| Service        | URL                      |
|----------------|--------------------------|
| Website (LB)   | http://localhost         |
| Worker 1       | http://localhost:8081    |
| Worker 2       | http://localhost:8082    |
| Jenkins UI     | http://localhost:8080    |

---

## ⚡ Docker Compose - Common Operations

### Quick Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View status
docker compose ps

# View logs
docker compose logs -f <service>

# Execute command
docker compose exec <service> bash
```

### Useful Commands

```bash
# Remove everything (including volumes)
docker compose down -v

# Rebuild images
docker compose build --no-cache

# Scale services
# Edit docker-compose.yml and change replicas, then:
docker compose up -d

# View resource usage
docker stats
```

---

## ☸️ Kubernetes Quick Start

### Prerequisites

- Kubernetes cluster (v1.20+)
- `kubectl` configured
- For local: minikube, kind, or Docker Desktop with K8s enabled

### 1. Verify Kubernetes is running

```bash
kubectl cluster-info
kubectl get nodes
```

### 2. Deploy to Kubernetes

```bash
./deploy-k8s.sh
```

This will:
- ✅ Create `mini-cluster` namespace
- ✅ Deploy all services
- ✅ Wait for pods to be ready
- ✅ Show access instructions

### 3. Check status

```bash
kubectl get pods -n mini-cluster -w
```

### 4. Access services (port-forward)

```bash
# Website (in new terminal)
kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80
# → http://localhost:8000

# Jenkins (in new terminal)
kubectl port-forward -n mini-cluster svc/jenkins-service 8080:8080
# → http://localhost:8080
```

### 5. Cleanup

```bash
./cleanup-k8s.sh
```

---

## 📚 Documentation Index

- **[QUICK_START.md](QUICK_START.md)** - Quick commands for Docker Compose
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Guided learning paths by experience level
- **[DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md)** - Detailed comparison
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command reference for both
- **[k8s/README.md](k8s/README.md)** - Kubernetes-specific documentation
- **[SETUP_AND_TEST.md](SETUP_AND_TEST.md)** - Advanced setup and testing

---

## 🔄 Load Balancer Test (Round Robin)

Refresh http://localhost a few times, or run this loop:

```bash
for i in {1..6}; do
  curl -s http://localhost | grep -o "worker[0-9]*" || echo "response $i"
done
```

Each request will alternate between worker1 and worker2.

---

## ⚙️ Jenkins CI/CD Setup

### First-time Jenkins setup

1. Go to **http://localhost:8080**
2. Get the initial admin password:
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. Paste it in the browser and click **Continue**
4. Choose **"Install suggested plugins"** and wait
5. Create your admin user

### Install Docker in Jenkins container

Jenkins needs Docker CLI to run `docker compose` commands:

```bash
docker exec -it jenkins bash -c "
  apt-get update -q &&
  apt-get install -y docker.io docker-compose-plugin &&
  exit
"
```

### Create a Pipeline job

1. Click **"New Item"** → name it `mini-cluster` → select **Pipeline** → OK
2. Scroll to **Pipeline** section
3. Set **Definition** to `Pipeline script from SCM`
4. **SCM** → `Git`
5. **Repository URL** → your GitHub repo URL
6. **Branch** → `*/main`
7. **Script Path** → `Jenkinsfile`
8. Click **Save**

### Update Jenkinsfile

Edit `Jenkinsfile` line 17 and replace the placeholder:

```groovy
url: 'https://github.com/YOUR_USERNAME/docker-mini-cluster.git'
```

### Run the pipeline

Click **"Build Now"** on the job page.  
The pipeline will: checkout → validate → teardown → pull → deploy → verify.

---

## 📝 Updating the Website

1. Edit `master/index.html`
2. Push to GitHub
3. Trigger the Jenkins pipeline (or click Build Now)

Jenkins will pull the new code and recreate the containers.

---

## 🛑 Stopping the Cluster

```bash
docker compose down
```

To also delete stored volumes (Jenkins data, web content):

```bash
docker compose down -v
```

---

## 🐛 Troubleshooting

| Problem | Fix |
|---|---|
| Port 80 already in use | Stop local web server: `sudo systemctl stop nginx` or `sudo systemctl stop apache2` |
| Jenkins can't run docker | Re-run the Docker install step inside Jenkins container |
| Workers show old content | `docker compose restart worker1 worker2` |
| Volume not syncing | `docker compose restart master` |

---

## 🧠 Concepts Demonstrated

### Docker Compose
- **Shared Docker volumes** — master writes, workers read
- **NGINX upstream / proxy_pass** — load balancing without hardware
- **Round robin** — default NGINX upstream algorithm
- **Container networking** — Inter-container communication via Docker network
- **Health checks** — Automatic container health monitoring
- **Service dependencies** — Managing startup order

### Kubernetes
- **Namespaces** — Isolation and resource organization
- **Deployments & StatefulSets** — Managing containerized applications
- **Services** — Exposing applications (ClusterIP, NodePort, LoadBalancer)
- **ConfigMaps** — Configuration management for NGINX
- **Persistent Volumes** — Storage for Jenkins data
- **RBAC** — Role-based access control
- **Health Probes** — Liveness and readiness checks
- **Auto-scaling** — Horizontal pod autoscaling (manual demo)

### CI/CD with Jenkins
- **Jenkins declarative pipeline** — Checkout → Build → Deploy stages
- **Docker socket mounting** — Jenkins controls Docker from inside a container
- **GitHub integration** — Automatic deployment on push
- **Multi-stage pipeline** — Validation, deployment, verification

---

## 🎓 Learning Outcomes

After working with this project, you'll understand:

- ✅ Container orchestration basics
- ✅ Load balancing and round-robin scheduling
- ✅ Shared volumes and persistent storage
- ✅ CI/CD pipelines and automation
- ✅ NGINX configuration and proxying
- ✅ Docker Compose for local development
- ✅ Kubernetes for production deployment
- ✅ Service mesh and networking concepts
- ✅ When to use each technology

---

## 🤝 Contributing

Have improvements? Submit a pull request!

Possible enhancements:
- Add Ingress for K8s
- Add Prometheus monitoring
- Add ELK stack logging
- Add network policies
- Add horizontal pod autoscaling
- Docker Compose version with networks/volumes optimization

---

## 📜 License

Educational project - feel free to use and modify!

---

## 🎉 Summary

**Start here:**
- **New to DevOps?** → [GETTING_STARTED.md](GETTING_STARTED.md)
- **Quick Docker Compose?** → [QUICK_START.md](QUICK_START.md)
- **Deploy to Kubernetes?** → `./deploy-k8s.sh`
- **Compare options?** → [DOCKER_VS_KUBERNETES.md](DOCKER_VS_KUBERNETES.md)
- **Common commands?** → [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

---

*🐳 Docker Compose + ☸️ Kubernetes + 🔧 Jenkins — Complete DevOps learning platform.*
