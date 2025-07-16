# setup


```

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm show values bitnami/mariadb  > values.yaml



helm upgrade --install mariadb bitnami/mariadb -f values.yaml -n mariadb --create-namespace



```

### This is the output

```
Release "mariadb" does not exist. Installing it now.
NAME: mariadb
LAST DEPLOYED: Wed Jul 16 07:20:06 2025
NAMESPACE: mariadb
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: mariadb
CHART VERSION: 21.0.3
APP VERSION: 11.8.2

Did you know there are enterprise versions of the Bitnami catalog? For enhanced secure software supply chain features, unlimited pulls from Docker, LTS support, or application customization, see Bitnami Premium or Tanzu Application Catalog. See https://www.arrow.com/globalecs/na/vendors/bitnami for more information.

** Please be patient while the chart is being deployed **

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace mariadb -l app.kubernetes.io/instance=mariadb

Services:

  echo Primary: mariadb.mariadb.svc.cluster.local:3306

Administrator credentials:

  Username: root
  Password : $(kubectl get secret --namespace mariadb mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run mariadb-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mariadb:11.8.2-debian-12-r3 --namespace mariadb --command -- bash

  2. To connect to primary service (read/write):

      mysql -h mariadb.mariadb.svc.cluster.local -uroot -p zbx

To upgrade this helm chart:

  1. Obtain the password as described on the 'Administrator credentials' section and set the 'auth.rootPassword' parameter as shown below:

      ROOT_PASSWORD=$(kubectl get secret --namespace mariadb mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
      helm upgrade --namespace mariadb mariadb oci://registry-1.docker.io/bitnamicharts/mariadb --set auth.rootPassword=$ROOT_PASSWORD

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - primary.resources
  - secondary.resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/



```