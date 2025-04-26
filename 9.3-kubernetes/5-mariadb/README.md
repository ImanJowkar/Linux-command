# setup


```

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm show values bitnami/mariadb  > values.yaml



helm install mariadb bitnami/mariadb -f values.yaml -n mariadb --create-namespace



```