# 🛠 Kubernetes Cluster Maintenance Guide

---

## 1. **Backup Everything Regularly**

**Components to backup:**
- **etcd** database (stores all cluster data)
- Cluster configuration files (`/etc/kubernetes`)
- Custom resources (CRDs, ConfigMaps, Secrets)

**Commands:**
```bash
ETCDCTL_API=3 etcdctl snapshot save snapshot.db \
 --endpoints=https://127.0.0.1:2379 \
 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
 --cert=/etc/kubernetes/pki/etcd/server.crt \
 --key=/etc/kubernetes/pki/etcd/server.key
```

**Notes:**
- Automate etcd backups daily.
- Always store backups in a remote, secure location (S3, external NFS, ...).

---

## 2. **Update and Patch the Cluster**

**Steps:**
1. Check current versions:
   ```bash
   kubectl version
   kubeadm version
   ```
2. Plan for minor upgrades (1.x to 1.x+1).
3. Upgrade control plane nodes first:
   ```bash
   kubeadm upgrade plan
   kubeadm upgrade apply vX.Y.Z
   ```
4. Then upgrade kubelet and kubectl on nodes.
5. Upgrade worker nodes:
   ```bash
   kubectl drain <node-name> --ignore-daemonsets
   apt-get upgrade kubelet kubectl
   kubectl uncordon <node-name>
   ```

**Notes:**
- Always read **Kubernetes Release Notes** before upgrading.
- Perform upgrades during maintenance windows.

---

## 3. **Monitor Cluster Health**

**Monitor:**
- Node status: `kubectl get nodes`
- Pod status: `kubectl get pods --all-namespaces`
- API server responsiveness
- etcd health:
  ```bash
  etcdctl endpoint health
  ```


---

## 4. **Manage Node Resources**

**Regular tasks:**
- Clean up unused images:
  ```bash
  docker image prune
  ```
- Restart kubelet if memory leaks are suspected.
- Check node disk, memory, CPU regularly.

**Notes:**
- Nodes should not exceed 80% resource usage.
- Plan for node autoscaling if necessary.

---

## 5. **Clean Up Orphaned Resources**

**Common cleanups:**
- Delete unused namespaces, pods, PVCs.
- Check for stuck terminating pods:
  ```bash
  kubectl get pods --all-namespaces | grep Terminating
  kubectl delete pod <pod-name> --grace-period=0 --force
  ```

**Notes:**
- Regularly prune resources.
- Build automation to detect and clean up "zombie" resources.

---

## 6. **Security Checks**

**Tasks:**
- Rotate certificates (`kubeadm certs renew all`)
- Rotate service account tokens.
- Audit logs for suspicious activity.
- Update container images regularly to fix vulnerabilities.

**Notes:**
- Implement RBAC properly.
- Apply network policies (deny-all by default).
- Use image scanning tools like Trivy or Clair.

---