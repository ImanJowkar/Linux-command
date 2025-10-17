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


```sh
kubectl api-resources



```
