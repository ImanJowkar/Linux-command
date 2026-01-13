#  Kubernetes 


+-----------------------------------------------+
|               Control Plane                   |
| (manages and schedules everything)             |
|-----------------------------------------------|
|  API Server | Controller Manager | Scheduler  |
|  etcd (Database)                                |
+-----------------------------------------------+
               |
               | communicates via API
               v
+-----------------------------------------------+
|                Worker Nodes                   |
|-----------------------------------------------|
| Kubelet | Kube Proxy | Container Runtime      |
| Pods (with containers inside)                 |
+-----------------------------------------------+






----------------------------------
                    +---------------------------+
                    |      Control Plane        |
                    |---------------------------|
                    | +-----------------------+ |
                    | | API Server            | |
                    | +-----------------------+ |
                    | | etcd (Cluster State)  | |
                    | +-----------------------+ |
                    | | Scheduler             | |
                    | +-----------------------+ |
                    | | Controller Manager    | |
                    | +-----------------------+ |
                    +------------|--------------+
                                 |
                                 v
          +-----------------------------------------------+
          |                 Worker Nodes                  |
          |-----------------------------------------------|
          | +------------+  +------------+  +------------+ |
          | |  kubelet   |  |  kubelet   |  |  kubelet   | |
          | | kube-proxy |  | kube-proxy |  | kube-proxy | |
          | | containerd |  | containerd |  | containerd | |
          | |  Pods      |  |  Pods      |  |  Pods      | |
          | +------------+  +------------+  +------------+ |
          +-----------------------------------------------+


![name-space and cgroup](img/1.png)

Cordon → block new Pods

Drain → evict existing Pods

Uncordon → allow Pods again

Evict → graceful Pod removal & reschedule


```sh
# maintainace
kubectl cordon node # Stop new Pods from being scheduled, Existing Pods keep running, No eviction

kubectl drain node  # Stop new Pods from being scheduled, Evicts existing Pods (gracefully)

kubectl uncordon node # Allow scheduling again, New Pods can be placed on the node
‍‍‍‍‍‍‍‍‍


# set lable
kubectl label node node3 role=worker
kubectl label node node3 role-
kubectl get node node3 --show-labels




```