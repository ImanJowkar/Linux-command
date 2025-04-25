# Setup prometheus stack on kubernetes
[ref](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

first of all install helm
[install-helm-document](https://helm.sh/docs/intro/install/)


# install prometheus
[ref](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)
```

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm show values prometheus-community/kube-prometheus-stack > values.yaml


helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f values.yaml -n monitoring --create-namespace 





```


## the output is like below

```
root@node1:~/prometheus# helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f values.yaml -n monitoring --create-namespace

Release "prometheus" has been upgraded. Happy Helming!
NAME: prometheus
LAST DEPLOYED: Fri Apr 25 05:56:16 2025
NAMESPACE: monitoring
STATUS: deployed
REVISION: 2
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=prometheus"

Get Grafana 'admin' user password by running:

  kubectl --namespace monitoring get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

Access Grafana local instance:

  export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=prometheus" -oname)
  kubectl --namespace monitoring port-forward $POD_NAME 3000

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.


```