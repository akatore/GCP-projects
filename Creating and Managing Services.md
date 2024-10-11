# Creating and Managing Services

Services provide stable endpoints for Pods based on a set of labels.

We will create the `monolith` service and "expose" the `secure-monolith` Pod externally. we will learn how to:

* Create a service
* Use label selectors to expose a limited set of Pods externally

## Create a Service

Explore the monolith service configuration file:

```
cat services/monolith.yaml 
```

Create the monolith service using kubectl:

```
kubectl create -f services/monolith.yaml
```

Use the `gcloud compute firewall-rules` command to allow traffic to the `monolith` service:

```
gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000
```

##  Interact with the Monolith Service Remotely

```
gcloud compute instances list
```

```
curl -k https://<EXTERNAL_IP>:31000
```

```
kubectl get services monolith
```

```
kubectl describe services monolith
```

## Add Labels to Pods

Currently the `monolith` service does not have any endpoints. One way to troubleshoot an issue like this is to use the `kubectl get pods` command with a label query.

```
kubectl get pods -l "app=monolith"
```

```
kubectl get pods -l "app=monolith,secure=enabled"
```

> Notice this label query does not print any results

Use the `kubectl label` command to add the missing `secure=enabled` label to the `secure-monolith` Pod.

```
kubectl label pods secure-monolith 'secure=enabled'
```

View the list of endpoints on the `monolith` service:

```
kubectl describe services monolith
```

##  Interact with the Monolith Service Remotely

```
gcloud compute instances list
```

```
curl -k https://<EXTERNAL_IP>:31000
```

## Remove Labels from Pods

In this exercise we will observe what happens when a required label is removed from a Pod.

Use the `kubectl label` command to remove the `secure` label from the `secure-monolith` Pod.

```
kubectl label pods secure-monolith secure-
```

View the list of endpoints on the `monolith` service:

```
kubectl describe services monolith
```
