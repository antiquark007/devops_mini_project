# 🚀 Deployment Scenarios & Use Cases

Real-world scenarios and how to use this project.

---

## 🎓 Scenario 1: Learning DevOps (Week 1)

**Goal:** Understand basic DevOps concepts

**Steps:**

1. **Day 1: Docker Basics**
   ```bash
   # Read QUICK_START.md
   docker compose up -d
   docker compose ps
   # Explore http://localhost
   ```

2. **Day 2: Container Inspection**
   ```bash
   docker compose exec master bash
   docker compose exec worker1 nginx -v
   docker compose logs -f loadbalancer
   ```

3. **Day 3: Load Balancing**
   ```bash
   # Test round-robin
   for i in {1..10}; do curl -s http://localhost | grep worker; done
   ```

4. **Day 4: CI/CD Setup**
   ```bash
   # Access Jenkins
   # Create a pipeline job
   # Connect to GitHub repo
   # Run first build
   ```

5. **Day 5: Review & Experiment**
   ```bash
   # Modify nginx.conf
   # Edit index.html
   # Rebuild and redeploy
   ```

**Time:** 5 days, 1-2 hours/day  
**Skills Gained:** Docker, Docker Compose, NGINX, Jenkins basics

---

## 🏢 Scenario 2: Preparing for Kubernetes (Week 2-3)

**Goal:** Understand Kubernetes before production

**Steps:**

1. **Setup Local Kubernetes**
   ```bash
   # Install minikube or kind
   minikube start
   # or
   kind create cluster
   ```

2. **Deploy Docker Compose Version First**
   ```bash
   docker compose up -d
   ./test-cluster.sh
   docker compose down
   ```

3. **Study Kubernetes Manifests**
   - Read `k8s/01-namespace.yaml`
   - Read `k8s/02-configmap-nginx.yaml`
   - Read `k8s/03-master-deployment.yaml`
   - Understand each YAML file

4. **Deploy to Kubernetes**
   ```bash
   ./deploy-k8s.sh
   kubectl get all -n mini-cluster
   ```

5. **Experiment with K8s**
   ```bash
   # Scale workers
   kubectl scale statefulset/worker --replicas=3 -n mini-cluster
   
   # View logs
   kubectl logs -f -n mini-cluster deployment/jenkins
   
   # Update image
   kubectl set image deployment/jenkins jenkins=jenkins/jenkins:2.375.1 -n mini-cluster
   ```

6. **Practice Cleanup & Redeployment**
   ```bash
   ./cleanup-k8s.sh
   ./deploy-k8s.sh
   ```

**Time:** 2-3 weeks, 1-2 hours/day  
**Skills Gained:** Kubernetes basics, kubectl, deployments, services, RBAC

---

## ☁️ Scenario 3: Deploying to Cloud (EKS/GKE/AKS)

**Goal:** Deploy to production Kubernetes cluster

**Prerequisites:**
- Cloud account (AWS, GCP, or Azure)
- Kubernetes cluster created
- kubectl configured

**Steps:**

1. **Connect to Cloud Cluster**
   ```bash
   # AWS EKS
   aws eks update-kubeconfig --name my-cluster --region us-east-1
   
   # Google GKE
   gcloud container clusters get-credentials my-cluster --zone us-central1-a
   
   # Azure AKS
   az aks get-credentials --resource-group mygroup --name my-cluster
   ```

2. **Verify Connection**
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

3. **Deploy Project**
   ```bash
   ./deploy-k8s.sh
   ```

4. **Access Services**
   ```bash
   # Get external IPs
   kubectl get svc -n mini-cluster
   
   # Access via cloud load balancer
   # Website: http://<EXTERNAL-IP>:80
   # Jenkins: http://<EXTERNAL-IP>:8080
   ```

5. **Enable HTTPS (Optional)**
   ```bash
   # Install cert-manager
   # Create TLS certificates
   # Update ingress configuration
   ```

**Time:** 1-2 hours  
**Skills Gained:** Cloud deployment, load balancers, DNS, TLS

---

## 🔐 Scenario 4: Production Hardening

**Goal:** Make it production-ready

**Steps:**

1. **Add Ingress for Networking**
   ```yaml
   # Add to k8s/07-ingress.yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: mini-cluster-ingress
     namespace: mini-cluster
   spec:
     rules:
     - host: example.com
       http:
         paths:
         - path: /
           backend:
             serviceName: loadbalancer-service
             servicePort: 80
   ```

2. **Add Network Policies**
   ```bash
   # Restrict inter-pod communication
   kubectl apply -f k8s/network-policies.yaml
   ```

3. **Add Pod Disruption Budgets**
   ```yaml
   apiVersion: policy/v1
   kind: PodDisruptionBudget
   metadata:
     name: worker-pdb
     namespace: mini-cluster
   spec:
     minAvailable: 1
     selector:
       matchLabels:
         app: worker
   ```

4. **Add Resource Quotas**
   ```yaml
   apiVersion: v1
   kind: ResourceQuota
   metadata:
     name: mini-cluster-quota
     namespace: mini-cluster
   spec:
     hard:
       requests.cpu: "10"
       requests.memory: "10Gi"
       limits.cpu: "20"
       limits.memory: "20Gi"
   ```

5. **Enable Monitoring**
   ```bash
   # Install Prometheus
   # Add ServiceMonitor CRDs
   # Configure Grafana dashboards
   ```

6. **Enable Logging**
   ```bash
   # Install ELK stack or Loki
   # Configure log forwarding
   ```

**Time:** 2-3 days  
**Skills Gained:** Advanced K8s, security, monitoring, observability

---

## 🧪 Scenario 5: Multi-Environment Setup

**Goal:** Manage dev, staging, and production

**Directory Structure:**
```
devops_mini_project/
├── k8s/
│   ├── base/                 # Base configurations
│   │   ├── 01-namespace.yaml
│   │   ├── 02-configmap-nginx.yaml
│   │   └── ...
│   │
│   ├── overlays/             # Environment-specific
│   │   ├── dev/
│   │   │   ├── kustomization.yaml
│   │   │   └── patches/
│   │   ├── staging/
│   │   │   ├── kustomization.yaml
│   │   │   └── patches/
│   │   └── prod/
│   │       ├── kustomization.yaml
│   │       └── patches/
```

**Steps:**

1. **Use Kustomize**
   ```bash
   # Deploy to dev
   kubectl apply -k k8s/overlays/dev
   
   # Deploy to staging
   kubectl apply -k k8s/overlays/staging
   
   # Deploy to prod
   kubectl apply -k k8s/overlays/prod
   ```

2. **Use Helm**
   ```bash
   helm create mini-cluster-helm
   helm install mini-cluster ./mini-cluster-helm -n mini-cluster
   ```

3. **GitOps with ArgoCD**
   ```bash
   # Install ArgoCD
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   
   # Create app
   argocd app create mini-cluster \
     --repo https://github.com/user/repo \
     --path k8s/overlays/prod
   ```

**Time:** 3-5 days  
**Skills Gained:** Kustomize, Helm, GitOps, ArgoCD

---

## 🤖 Scenario 6: Continuous Deployment Pipeline

**Goal:** Full automated CI/CD

**Setup:**

1. **GitHub Actions**
   ```yaml
   name: Deploy to K8s
   on: [push]
   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v2
       - run: |
           kubectl apply -f k8s/
           kubectl rollout status deployment/loadbalancer -n mini-cluster
   ```

2. **Jenkins Pipeline**
   ```groovy
   pipeline {
       stages {
           stage('Checkout') {
               steps {
                   git 'https://github.com/user/repo'
               }
           }
           stage('Deploy') {
               steps {
                   sh './deploy-k8s.sh'
               }
           }
           stage('Test') {
               steps {
                   sh './test-k8s.sh'
               }
           }
       }
   }
   ```

3. **GitLab CI**
   ```yaml
   deploy:
     stage: deploy
     script:
       - ./deploy-k8s.sh
       - ./test-k8s.sh
   ```

**Time:** 2-3 days  
**Skills Gained:** CI/CD automation, GitHub Actions, GitOps

---

## 🎯 Scenario 7: Performance Tuning

**Goal:** Optimize for high traffic

**Tasks:**

1. **Horizontal Pod Autoscaling**
   ```bash
   kubectl autoscale statefulset worker --min=2 --max=10 -n mini-cluster
   ```

2. **Vertical Pod Autoscaling**
   ```yaml
   apiVersion: autoscaling.k8s.io/v1
   kind: VerticalPodAutoscaler
   metadata:
     name: worker-vpa
     namespace: mini-cluster
   spec:
     targetRef:
       apiVersion: apps/v1
       kind: StatefulSet
       name: worker
   ```

3. **Load Testing**
   ```bash
   # Install Apache Bench or k6
   ab -n 10000 -c 100 http://localhost
   ```

4. **Resource Monitoring**
   ```bash
   kubectl top pods -n mini-cluster
   kubectl top nodes
   ```

5. **Optimize NGINX**
   - Increase worker processes
   - Tune buffer sizes
   - Enable compression
   - Cache optimization

**Time:** 2-3 days  
**Skills Gained:** Performance tuning, HPA/VPA, load testing

---

## 📊 Scenario 8: Team Collaboration

**Goal:** Set up for team environment

**Steps:**

1. **RBAC Setup**
   ```bash
   # Create developer role
   kubectl create role developer --verb=get,list,watch --resource=pods -n mini-cluster
   
   # Bind to user
   kubectl create rolebinding developer-binding --clusterrole=developer --user=dev@example.com -n mini-cluster
   ```

2. **Namespace Isolation**
   ```bash
   kubectl create namespace dev
   kubectl create namespace staging
   kubectl create namespace prod
   ```

3. **Resource Quotas**
   ```bash
   kubectl create quota dev-quota --hard=requests.cpu=5,requests.memory=10Gi -n dev
   ```

4. **Network Policies**
   ```bash
   # Restrict traffic between namespaces
   ```

5. **Audit Logging**
   ```bash
   # Enable API audit logging
   # Log all kubectl commands
   ```

**Time:** 2-3 days  
**Skills Gained:** RBAC, multi-tenancy, governance

---

## 🆘 Scenario 9: Disaster Recovery

**Goal:** Backup and restore procedures

**Steps:**

1. **Backup Configuration**
   ```bash
   # Backup all manifests
   kubectl get all -n mini-cluster -o yaml > backup.yaml
   
   # Backup persistent data
   kubectl get pvc -n mini-cluster -o yaml > pvc-backup.yaml
   ```

2. **Backup Jenkins Data**
   ```bash
   kubectl exec -it jenkins pod -- tar czf - /var/jenkins_home | gzip > jenkins-backup.tar.gz
   ```

3. **Restore from Backup**
   ```bash
   kubectl apply -f backup.yaml
   ```

4. **Test Restore**
   ```bash
   # Simulate disaster
   kubectl delete namespace mini-cluster
   
   # Restore
   kubectl create namespace mini-cluster
   kubectl apply -f backup.yaml
   ```

**Time:** 1-2 days  
**Skills Gained:** Backup, recovery, disaster preparedness

---

## 🎬 Scenario 10: Live Demo Setup

**Goal:** Demonstrate to stakeholders

**10-Minute Demo Script:**

```bash
# 1. Show current cluster (20 sec)
kubectl get nodes
kubectl get all -n mini-cluster

# 2. Show website (30 sec)
kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80
# Open browser: http://localhost:8000

# 3. Show load balancing (1 min)
# Refresh multiple times, show round-robin

# 4. Show Jenkins (1 min)
kubectl port-forward -n mini-cluster svc/jenkins-service 8080:8080
# Open browser: http://localhost:8080

# 5. Scale workers (1 min)
kubectl scale statefulset/worker --replicas=5 -n mini-cluster
kubectl get pods -n mini-cluster -w

# 6. Show logs (1 min)
kubectl logs -f -n mini-cluster deployment/loadbalancer

# 7. Update image (1 min)
kubectl set image deployment/jenkins jenkins=jenkins/jenkins:2.375.1 -n mini-cluster
kubectl rollout status deployment/jenkins -n mini-cluster

# 8. Show monitoring (1 min)
kubectl top pods -n mini-cluster
kubectl top nodes

# 9. Cleanup (1 min)
./cleanup-k8s.sh
```

**Demo Time:** 10 minutes  
**Q&A Time:** 10 minutes  
**Total:** 20 minutes

---

## 📈 Progression Path

```
Week 1: Docker Compose Basics
   ↓
Week 2-3: Kubernetes Fundamentals  
   ↓
Week 4: Cloud Deployment
   ↓
Week 5-6: Advanced K8s & Production Hardening
   ↓
Week 7-8: CI/CD & Automation
   ↓
Ongoing: Performance, Security, Monitoring
```

---

## 🎓 Next Steps

After completing these scenarios:

1. **Explore Advanced Topics**
   - Service Mesh (Istio, Linkerd)
   - Operator Framework
   - Helm package manager
   - Knative for serverless

2. **Certifications**
   - CKA (Kubernetes Admin)
   - CKAD (Kubernetes Application Developer)
   - CKS (Kubernetes Security)

3. **Community**
   - Join Kubernetes community
   - Contribute to projects
   - Attend meetups/conferences

---

