# 🐳 Docker Mini Cluster

A beginner-friendly, single-machine Docker cluster demonstrating load balancing,
shared volumes, and CI/CD with Jenkins — no Kubernetes required.

---

## 📁 Project Structure

```
docker-mini-cluster/
├── master/
│   └── index.html          ← Source HTML (synced to shared volume)
├── worker/
│   └── nginx.conf          ← NGINX config for both worker containers
├── loadbalancer/
│   └── nginx.conf          ← NGINX upstream / round-robin config
├── docker-compose.yml      ← Defines all 5 services
├── Jenkinsfile             ← CI/CD pipeline definition
└── README.md
```

---

## 🏗️ Architecture

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

## 🚀 Quick Start

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

- **Shared Docker volumes** — master writes, workers read
- **NGINX upstream / proxy_pass** — load balancing without hardware
- **Round robin** — default NGINX upstream algorithm
- **Jenkins declarative pipeline** — Checkout → Build → Deploy stages
- **Docker socket mounting** — Jenkins controls Docker from inside a container
- **Single-machine cluster** — all containers on one host, bridged network

---

*Built for a college project demonstration. No Kubernetes, no Ansible, just Docker.*
