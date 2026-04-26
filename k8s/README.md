# 🎯 Kubernetes Deployment

This folder contains Kubernetes manifests to deploy the mini cluster on any Kubernetes cluster.

## 📋 Prerequisites

- **Kubernetes cluster** (v1.20+) - local or cloud-based
  - minikube, kind, kubeadm, or managed K8s (EKS, GKE, AKS, etc.)
- **kubectl** configured to access your cluster
- **Optional**: Helm 3+ (for advanced deployments)

### Verify Prerequisites

```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

---

## 🚀 Quick Start (One Command)

### 1. Deploy All Resources

```bash
kubectl apply -f k8s/
```

Expected output:
```
namespace/mini-cluster created
configmap/nginx-worker-config created
configmap/nginx-lb-config created
deployment.apps/master created
service/master-service created
statefulset.apps/worker created
service/worker-service created
service/worker-nodeport created
deployment.apps/loadbalancer created
service/loadbalancer-service created
persistentvolumeclaim/jenkins-pvc created
deployment.apps/jenkins created
service/jenkins-service created
serviceaccount/jenkins created
clusterrole.rbac.authorization.k8s.io/jenkins created
clusterrolebinding.rbac.authorization.k8s.io/jenkins created
```

### 2. Verify Deployment

```bash
kubectl get all -n mini-cluster
```

Wait 30-60 seconds for all pods to be ready.

### 3. Check Pod Status

```bash
kubectl get pods -n mini-cluster -w
```

Expected statuses:
```
NAME                           READY   STATUS    RESTARTS   AGE
master-xxxxx-xxxxx             1/1     Running   0          2m
worker-0                       1/1     Running   0          2m
worker-1                       1/1     Running   0          2m
loadbalancer-xxxxx-xxxxx       1/1     Running   0          2m
jenkins-xxxxx-xxxxx            1/1     Running   0          2m
```

---

## 📡 Access Services

### Get Service URLs

```bash
kubectl get svc -n mini-cluster
```

### Local Access (kubectl port-forward)

```bash
# Website (Load Balancer)
kubectl port-forward -n mini-cluster svc/loadbalancer-service 8000:80
# → http://localhost:8000

# Jenkins
kubectl port-forward -n mini-cluster svc/jenkins-service 8080:8080
# → http://localhost:8080 (admin/admin)

# Direct Worker Access
kubectl port-forward -n mini-cluster svc/worker-nodeport 8081:80
# → http://localhost:8081
```

### Cloud/External Access

If using a managed K8s cluster (EKS, GKE, AKS) with LoadBalancer support:

```bash
kubectl get svc -n mini-cluster
```

Look for external IPs in the output. These are your public URLs.

---

## 📊 View Logs

### Overall Status

```bash
kubectl describe all -n mini-cluster
```

### Specific Pod Logs

```bash
# Master
kubectl logs -n mini-cluster deployment/master

# Workers
kubectl logs -n mini-cluster statefulset/worker

# Load Balancer
kubectl logs -n mini-cluster deployment/loadbalancer

# Jenkins
kubectl logs -n mini-cluster deployment/jenkins -f
```

### Follow Real-Time Logs

```bash
kubectl logs -f -n mini-cluster deployment/jenkins
```

---

## 🛠️ Deployment Details

### Manifests Overview

| File | Purpose |
|------|---------|
| `01-namespace.yaml` | Create isolated namespace |
| `02-configmap-nginx.yaml` | NGINX configurations for workers & LB |
| `03-master-deployment.yaml` | Master container + ClusterIP service |
| `04-workers-deployment.yaml` | Worker StatefulSet (2 replicas) |
| `05-loadbalancer-deployment.yaml` | NGINX Load Balancer deployment |
| `06-jenkins-deployment.yaml` | Jenkins + PVC + RBAC |

### Resource Requests & Limits

Each component is configured with appropriate resource limits to prevent cluster overload:

| Service | CPU Request | Memory Request | CPU Limit | Memory Limit |
|---------|-------------|----------------|-----------|--------------|
| Master | 100m | 128Mi | 500m | 256Mi |
| Worker | 50m | 64Mi | 200m | 128Mi |
| Load Balancer | 50m | 64Mi | 200m | 128Mi |
| Jenkins | 500m | 512Mi | 1000m | 1Gi |

---

## 🔄 Scaling & Updates

### Scale Workers

```bash
kubectl scale statefulset/worker --replicas=3 -n mini-cluster
```

### Update Image

```bash
# Update Jenkins image
kubectl set image deployment/jenkins jenkins=jenkins/jenkins:2.375.1 -n mini-cluster

# Update Master image
kubectl set image deployment/master master=ubuntu:24.04 -n mini-cluster
```

### Rolling Update

```bash
# Trigger rolling update
kubectl rollout restart deployment/loadbalancer -n mini-cluster

# Monitor rollout
kubectl rollout status deployment/loadbalancer -n mini-cluster
```

---

## 🗑️ Cleanup

### Delete Everything

```bash
kubectl delete namespace mini-cluster
```

This removes all resources in the namespace, including:
- Deployments
- StatefulSets
- Services
- ConfigMaps
- PersistentVolumeClaims
- RBAC rules

---

## 🧪 Testing & Validation

### Health Checks

```bash
# Test load balancer
kubectl exec -it -n mini-cluster deployment/loadbalancer -- curl localhost/health

# Test worker connectivity
kubectl exec -it -n mini-cluster statefulset/worker-0 -- curl localhost/health
```

### Network Connectivity

```bash
# From one pod to another
kubectl exec -it -n mini-cluster pod/master-xxxxx -- curl http://worker-0.worker-service
```

### Persistent Storage

```bash
# Check PVC status
kubectl get pvc -n mini-cluster

# Describe PVC
kubectl describe pvc jenkins-pvc -n mini-cluster
```

---

## 📝 Common Troubleshooting

### Pods not starting?

```bash
# Check pod events
kubectl describe pod -n mini-cluster <pod-name>

# Check resource availability
kubectl top nodes
kubectl top pods -n mini-cluster
```

### LoadBalancer stuck in "Pending"?

This is normal in local clusters (minikube, kind). Use `kubectl port-forward` instead.

### Jenkins volume issues?

```bash
# Check storage class
kubectl get storageclass

# View PVC events
kubectl describe pvc jenkins-pvc -n mini-cluster
```

### Need to access container shell?

```bash
kubectl exec -it -n mini-cluster pod/<pod-name> -- /bin/sh
```

---

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [StatefulSet Guide](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [Services & Networking](https://kubernetes.io/docs/concepts/services-networking/)
- [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

---

## ✅ Deployment Checklist

- [ ] Kubernetes cluster is running and accessible
- [ ] `kubectl` is configured
- [ ] All manifests applied: `kubectl apply -f k8s/`
- [ ] All pods are running: `kubectl get pods -n mini-cluster`
- [ ] Services are accessible via port-forward or LoadBalancer IP
- [ ] Jenkins is accessible and initialized
- [ ] Website is serving from workers through load balancer
