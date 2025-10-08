# k3s 
**k3s** is a **lightweight, certified Kubernetes distribution** developed by **Rancher (now part of SUSE)**.
It’s designed to be **easy to install, resource-efficient, and optimized for edge, IoT, and development environments** — essentially a **minimal Kubernetes** that runs on almost any hardware.

---

### 🧩 **What k3s Is**

* **Lightweight Kubernetes:**
  A fully compliant Kubernetes distribution that removes or replaces non-essential components to reduce memory and storage requirements.

* **Single binary installation:**
  Everything (API server, controller manager, scheduler, etc.) runs from a **single ~50 MB binary**, making setup and upgrades simple.

* **Built-in components:**

  * Embedded SQLite (by default) instead of etcd (though etcd or MySQL/PostgreSQL can also be used)
  * Built-in **containerd** (no need for Docker)
  * Simplified **networking (flannel)** and **service load balancing (klipper-lb)**

* **Automatic TLS, Service LoadBalancer, and Ingress controller** — preconfigured for quick setup.

---

### ⚙️ **Typical Use Cases**

#### 1. 🧠 **Edge Computing**

* Run Kubernetes clusters on **low-power or remote edge devices** (like Raspberry Pis or industrial PCs).
* Great for **retail, IoT gateways, or smart factory** scenarios.
* Example: Deploying containers across 100 remote locations, each with a small 2–4 GB RAM device.

#### 2. ☁️ **Development and Testing**

* Ideal for **local Kubernetes development** (faster than Minikube, MicroK8s, or KIND).
* Easy to spin up a full cluster on a laptop or VM to test apps before deploying to production Kubernetes.

#### 3. 🏠 **Home Labs**

* Popular for **homelab enthusiasts** running services like Grafana, Prometheus, Home Assistant, etc.
* Easy to deploy and manage without consuming much hardware.

#### 4. 🧩 **CI/CD Pipelines**

* Used in **continuous integration/testing environments** where you need a short-lived Kubernetes cluster that spins up quickly and tears down cleanly.

#### 5. 🚀 **Small-Scale Production**

* Suitable for **small businesses or startups** that don’t need the full complexity of Kubernetes but want container orchestration, self-healing, and rolling updates.

#### 6. 🌐 **IoT & Smart Devices**

* Deploying workloads directly on distributed IoT networks where devices have limited CPU/RAM and need decentralized management.

---

### ⚖️ **Comparison: k3s vs. Kubernetes (k8s)**

| Feature              | Kubernetes (k8s)             | k3s                                   |
| -------------------- | ---------------------------- | ------------------------------------- |
| Resource Usage       | Heavy                        | Lightweight                           |
| Installation         | Complex (many binaries)      | One-line install                      |
| Database             | etcd                         | SQLite (default), etcd/MySQL optional |
| Target               | Data centers, cloud clusters | Edge, IoT, small setups               |
| Binary Size          | ~1 GB+                       | ~50 MB                                |
| Certified Kubernetes | ✅                            | ✅                                     |

---

### 🧭 ** Installation**
* on master node run: 
```bash
curl -sfL https://get.k3s.io | sh -

sudo k3s kubectl get nodes

```

To check the cluster status:

```bash
```

---

Perfect 👌 — let’s walk through a **real-world example: “Deploying Grafana and Prometheus on k3s for Edge Monitoring.”**

This is a **common use case** where k3s shines — lightweight enough for small servers or Raspberry Pis, yet powerful enough to run monitoring stacks.

---

## 🧭 Scenario Overview

### **Goal**

Monitor a **remote edge site** (like a small branch office or IoT gateway) using **Prometheus + Grafana** deployed on **k3s**.

### **Why k3s?**

* Low resource footprint (can run on 1 vCPU, 1GB RAM).
* Simplified setup — single binary, no need for external etcd.
* Easy to deploy as a single-node or multi-node cluster.
* Ideal for **remote or embedded environments** with limited resources.

---

## ⚙️ Step-by-Step Deployment

### **1️⃣ Install k3s**

On your edge node (e.g., Ubuntu):

```bash
curl -sfL https://get.k3s.io | sh -
```

Check the cluster:

```bash
sudo k3s kubectl get nodes
```

You should see something like:

```
NAME     STATUS   ROLES                  AGE   VERSION
edge01   Ready    control-plane,master   1m    v1.30.0+k3s1
```

---

### **2️⃣ Deploy Prometheus**

Create a file `prometheus-deploy.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:v2.55.0
        ports:
        - containerPort: 9090
        volumeMounts:
        - name: config-volume
          mountPath: /etc/prometheus/
      volumes:
      - name: config-volume
        configMap:
          name: prometheus-config
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 10s
    scrape_configs:
      - job_name: 'node'
        static_configs:
          - targets: ['node-exporter.monitoring.svc.cluster.local:9100']
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitoring
spec:
  selector:
    app: prometheus
  ports:
    - port: 9090
      targetPort: 9090
```

Deploy:

```bash
sudo k3s kubectl apply -f prometheus-deploy.yaml
```

---

### **3️⃣ Deploy Node Exporter**

This collects system metrics from the node.

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      hostPID: true
      containers:
      - name: node-exporter
        image: prom/node-exporter
        ports:
        - containerPort: 9100
---
apiVersion: v1
kind: Service
metadata:
  name: node-exporter
  namespace: monitoring
spec:
  selector:
    app: node-exporter
  ports:
    - port: 9100
      targetPort: 9100
```

Deploy it:

```bash
sudo k3s kubectl apply -f node-exporter.yaml
```

---

### **4️⃣ Deploy Grafana**

Create `grafana.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:11.1.0
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
spec:
  selector:
    app: grafana
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30000
  type: NodePort
```

Deploy:

```bash
sudo k3s kubectl apply -f grafana.yaml
```

---

### **5️⃣ Access Grafana**

Find the node’s IP:

```bash
hostname -I
```

Open Grafana in your browser:

```
http://<node-ip>:30000
```

Default login:

```
user: admin
pass: admin
```

Then add Prometheus as a data source:

* **URL:** `http://prometheus.monitoring.svc.cluster.local:9090`

---

### **6️⃣ (Optional) Remote Centralization**

If you have multiple k3s clusters at different edge sites,
you can **federate Prometheus** or use **Grafana Cloud / Loki / InfluxDB** to centralize metrics.

---

## 🧩 Summary

| Component         | Purpose                             | Resource Usage |
| ----------------- | ----------------------------------- | -------------- |
| **k3s**           | Lightweight Kubernetes orchestrator | ~512 MB RAM    |
| **Prometheus**    | Metric collection and storage       | ~200 MB RAM    |
| **Node Exporter** | System metrics                      | ~30 MB RAM     |
| **Grafana**       | Visualization dashboards            | ~150 MB RAM    |

✅ Total: Works comfortably on a **2 GB RAM device** (e.g., Raspberry Pi 4, small VM).

---
