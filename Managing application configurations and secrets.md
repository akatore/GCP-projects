# Managing Application Configurations and Secrets

Applications require configuration settings and secrets such as TLS certificates to run in a production environment. We will:

* Create secrets to store sensitive application data
* Create configmaps to store application configuration data
* Expose secrets and configmaps to Pods at runtime

We will create a new Pod named `secure-monolith` based on the `healthy-monolith` Pod. The `secure-monolith` Pod secures access to the `monolith` container using [Nginx](http://nginx.org/en), which will serve as a reverse proxy serving HTTPS.

> The nginx container will be deployed in the same pod as the monolith container because they are tightly coupled.

## Tutorial: Creating Secrets

Before we can use the `nginx` container to serve HTTPS traffic we need some TLS certificates. Here we will store a set of self-signed TLS certificates in Kubernetes as secrets.

Create the `tls-certs` secret from the TLS certificates stored under the tls directory:

```
kubectl create secret generic tls-certs --from-file=tls/
```

Examine the `tls-certs` secret:

```
kubectl describe secrets tls-certs
```

## Creating Configmaps

The nginx container also needs a configuration file to setup the secure reverse proxy. Here we will create a configmap from the `proxy.conf` nginx configuration file.

Create the `nginx-proxy-conf` configmap based on the `proxy.conf` nginx configuration file:

```
kubectl create configmap nginx-proxy-conf --from-file=nginx/proxy.conf
```

Examine the `nginx-proxy-conf` configmap:

```
kubectl describe configmaps nginx-proxy-conf
```


## Use Configmaps and Secrets

Here we will expose the `nginx-proxy-conf` configmap and the `tls-certs` secrets to the `secure-monolith` pod at runtime:

Examine the `secure-monolith` pod configuration file:

```
cat pods/secure-monolith.yaml
```

Create the `secure-monolith` Pod using kubectl:

```
kubectl create -f pods/secure-monolith.yaml
```

#### Testing the HTTPS endpoint

Forward local port 10443 to 443 of the `secure-monolith` Pod:

```
kubectl port-forward secure-monolith 10443:443
```

Use the `curl` command to test the HTTPS endpoint:

```
curl --cacert tls/ca.pem https://127.0.0.1:10443
```

Use the `kubectl logs` command to verify traffic to the `secure-monolith` Pod:

```
kubectl logs -c nginx secure-monolith
```

Secrets and Configmaps allow us to store application secrets and configuration data, then expose them to Pods at runtime. Here we learned how to expose Secrets and Configmaps to Pods using volume mounts. We also learned how to run multiple containers in a single Pod.