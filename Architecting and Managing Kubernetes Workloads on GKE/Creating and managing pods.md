# Creating and managing pods

At the core of Kubernetes is the Pod. Pods represent a logical application and hold a collection of one or more containers and volumes. We will:

* Write a Pod configuration file
* Create and inspect Pods 
* Interact with Pods remotely using kubectl

We will create a Pod named `monolith` and interact with it using the kubectl command line tool.

## Creating Pods

Explore the `monolith` pod configuration file:

```
cat pods/monolith.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: monolith
  labels:
    app: monolith
spec:
  containers:
    - name: monolith
      image: kelseyhightower/monolith:1.0.0
      args:
        - "-http=0.0.0.0:80"
        - "-health=0.0.0.0:81"
        - "-secret=secret"
      ports:
        - name: http
          containerPort: 80
        - name: health
          containerPort: 81
      resources:
        limits:
          cpu: 0.2
          memory: "10Mi"

```

Create the `monolith` pod using kubectl:

```
kubectl create -f pods/monolith.yaml
```

## View Pod details

Use the `kubectl get` and `kubect describe` commands to view details for the `monolith` Pod:



```
kubectl get pods
```

```
kubectl describe pods <pod-name>
```

## Interact with a Pod remotely

Pods are allocated a private IP address by default and cannot be reached outside of the cluster. Use the `kubectl port-forward` command to map a local port to a port inside the `monolith` pod. 



Use two terminals. One to run the `kubectl port-forward` command, and the other to issue `curl` commands.

```
kubectl port-forward monolith 10080:80
```

```
curl http://127.0.0.1:10080
```

```
curl http://127.0.0.1:10080/secure
```

```
curl -u user http://127.0.0.1:10080/login
```

> Type "password" at the prompt.

```
curl -H "Authorization: Bearer <token>" http://127.0.0.1:10080/secure
```

> Use the JWT token from the previous login.

## View the logs of a Pod

Use the `kubectl logs` command to view the logs for the `monolith` Pod:

```
kubectl logs monolith
```

> Use the -f flag and observe what happens.

## Run an interactive shell inside a Pod

Use the `kubectl exec` command to run an interactive shell inside the `monolith` Pod:

```
kubectl exec monolith --stdin --tty -c monolith /bin/sh
```