# 🌐 OnFinance AI - EKS Full Stack Deployment

### 🚀 Submitted by: Gajapathi Kikkara 
**Role Applied**: DevOps Engineer  
📅 Date: April 6, 2025

---

## 📌 Project Overview

This project demonstrates a full-stack application (frontend + backend) deployed on AWS EKS, with a production-ready infrastructure using Terraform, Kubernetes, centralized logging and monitoring with CloudWatch, and scalable architecture practices. It follows best practices in CI/CD, security, and observability.

---

## 🧱 Project Structure

```bash
onFinanceAI/
├── onfinance-terraform/    # All Terraform Infrastructure-as-Code
├── weather-app/            # Frontend, Backend, and K8s manifests
│   ├── k8s/                # All Kubernetes manifests
│   ├── scripts/            # Shell scripts to build, push, and deploy
│   ├── frontend/           # React app with Vite
│   └── backend/            # Node.js Express API
└── architecture-diagram.png


🛠️ Stage 1: High-Level Architecture

✅ Components:
Amazon EKS for container orchestration
ALB (LoadBalancer) for frontend access
Private subnets for backend and RDS
Amazon RDS (Aurora Serverless) for relational storage
IAM Roles with IRSA for secure resource access
Amazon S3 (optional static/data storage)
CloudWatch + Fluent Bit for centralized logs & metrics
SNS for alerting via CloudWatch alarms


⚙️ Stage 3: Kubernetes Deployment
📁 Directory: weather-app/k8s/
🧱 Deployments
frontend/deployment.yaml

backend/deployment.yaml

🧪 Apply All Resources:
bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -R -f k8s/

🔐 Configuration Management
ConfigMap and Secrets defined under k8s/backend/
Separate HPA, probes, and service configs per app

🌐 Exposed Services:
frontend → LoadBalancer (ALB)
backend → ClusterIP (internal to frontend)

📊 Stage 4: Logging & Monitoring
✔️ Tools Used:
Fluent Bit DaemonSet
CloudWatch Agent
Amazon CloudWatch Logs & Metrics
CloudWatch Container Insights
CloudWatch Alarms with SNS Email Notification

🧪 Steps Done:
Installed CloudWatch CRDs and agents manually
Logs routed from all pods to:
/aws/containerinsights/<cluster-name>/application
Alarms configured on CPU usage for backend using cpu_utilization metric
SNS topic triggers email alert
All manifests are located in: k8s/monitoring/

📦 Scripts
📁 Directory: weather-app/scripts/
bash
./build-push.sh   # Builds Docker images and pushes to ECR


✅ How to Deploy the Full Stack
Provision Infrastructure:
bash
cd onfinance-terraform/dev
terraform apply

Build & Push Docker Images
bash
cd weather-app/scripts
./build-push.sh


✅ CloudWatch Monitoring Example
Navigate to: CloudWatch > Container Insights

Query logs for pods:

sql
fields @timestamp, @message
| filter pod_name like /backend/
| sort @timestamp desc
| limit 20
Metrics available:

cpu_utilization
memory_working_set_bytes
network_rx_bytes