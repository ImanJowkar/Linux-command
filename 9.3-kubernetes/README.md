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

# service account and role-binding
kubectl create serviceaccount mysvcaccount

kubectl create rolebinding my-binding --role view --serviceaccount default:mysvcaccount --namespace default

kubectl create clusterrolebinding my-binding --clusterrole view --serviceaccount default:mysvcaccount

token=$(kubectl create token mysvcaccount)

curl -X GET https://192.168.96.41:6443/api/v1/namespaces/default/pods -H "Authorization: Bearer $token" -H "Accept: application/json" --insecure

```

