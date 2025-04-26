# install

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx


helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -f values.yaml -n ingress-nginx --create-namespace


```


# this is the output

```

Release "ingress-nginx" has been upgraded. Happy Helming!
NAME: ingress-nginx
LAST DEPLOYED: Fri Apr 25 04:46:11 2025
NAMESPACE: ingress-nginx
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the load balancer IP to be available.
You can watch the status by running 'kubectl get service --namespace ingress-nginx ingress-nginx-controller --output wide --watch'

An example Ingress that makes use of the controller:
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: example
    namespace: foo
  spec:
    ingressClassName: nginx
    rules:
      - host: www.example.com
        http:
          paths:
            - pathType: Prefix
              backend:
                service:
                  name: exampleService
                  port:
                    number: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
      - hosts:
        - www.example.com
        secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls


```



# Install Nginx ingress on bitnami ingress controller

```
helm repo add bitnami https://charts.bitnami.com/bitnami


helm show values bitnami/nginx-ingress-controller > values.yaml

helm upgrade --install ingress-nginx bitnami/nginx-ingress-controller -f values.yaml -n ingress-nginx



Release "ingress-nginx" has been upgraded. Happy Helming!
NAME: ingress-nginx
LAST DEPLOYED: Fri Apr 25 12:44:47 2025
NAMESPACE: ingress-nginx
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
CHART NAME: nginx-ingress-controller
CHART VERSION: 11.6.14
APP VERSION: 1.12.1

Did you know there are enterprise versions of the Bitnami catalog? For enhanced secu               re software supply chain features, unlimited pulls from Docker, LTS support, or appl               ication customization, see Bitnami Premium or Tanzu Application Catalog. See https:/               /www.arrow.com/globalecs/na/vendors/bitnami for more information.

** Please be patient while the chart is being deployed **

The nginx-ingress controller has been installed.

Get the application URL by running these commands:

 NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        You can watch its status by running 'kubectl get --namespace ingress-nginx s               vc -w ingress-nginx-nginx-ingress-controller'

    export SERVICE_IP=$(kubectl get svc --namespace ingress-nginx ingress-nginx-ngin               x-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "Visit http://${SERVICE_IP} to access your application via HTTP."
    echo "Visit https://${SERVICE_IP} to access your application via HTTPS."

An example Ingress that makes use of the controller:

  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: example
    namespace: ingress-nginx
  spec:
    ingressClassName: nginx
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                service:
                  name: example-service
                  port:
                    number: 80
              path: /
              pathType: Prefix
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must                also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: ingress-nginx
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset               " is not recommended for production. For production installations, please set the fo               llowing values according to your workload needs:
  - defaultBackend.resources
  - resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

```