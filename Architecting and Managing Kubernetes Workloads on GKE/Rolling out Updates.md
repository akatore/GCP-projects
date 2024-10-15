# Rolling out Updates

Kubernetes makes it easy to rollout updates to our applications using the builtin rolling update mechanism. Here we will learn how to:

* Modify deployments to tigger rolling updates
* Pause and resume an active rolling update
* Rollback a deployment to a previous revision

## Rollout a new version of the Auth service

```
kubectl rollout history deployment auth
```

Modify the auth deployment image:

```
vim deployments/auth.yaml
```

```
image: "kelseyhightower/auth:2.0.0"
```

```
kubectl apply -f deployments/auth.yaml --record
```

```
kubectl describe deployments auth
```

```
kubectl get replicasets
```

```
kubectl rollout history deployment auth
```

## Pause and Resume an Active Rollout

```
kubectl rollout history deployment hello
```

Modify the hello deployment image:

```
vim deployments/hello.yaml
```

```
image: "kelseyhightower/hello:2.0.0"
```

```
kubectl apply -f deployments/hello.yaml --record
```

```
kubectl describe deployments hello
```

```
kubectl rollout pause deployment hello
```

```
kubectl rollout resume deployment hello
```

## Rollback the Hello service

Use the `kubectl rollout undo` command to rollback to a previous deployment of the Hello service.

## Summary

Here we learned how to rollout updates to our applications by modifying deployment objects to trigger rolling updates. we also learned how to pause and resume an active rolling update and rollback it back using the `kubectl rollout` command.