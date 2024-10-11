# GCP-projects

For each of the following Projects, you should be in the kubernetes dir:
```
cd orchestrate-with-kubernetes/kubernetes
```

  * [Creating and managing pods](Creating%20and%20managing%20pods.md)
  * [Monitoring and health checks](Monitoring%20and%20Health%20Checks.md)
  * [Managing application configurations and secrets](Managing%20application%20configurations%20and%20secrets.md)
  * [Creating and managing services](Creating%20and%20Managing%20Services.md)
  * [Creating and managing deployments](Creating%20and%20Managing%20Deployments.md)
  * [Rolling out updates](Rolling%20out%20Updates.md)

before starting, it's to be known to these commands.

```shell
gcloud config set compute/region "REGION"  ## Set the default compute region:
gcloud config set compute/zone "ZONE"      ## Set the default compute zone:

gcloud container clusters create --machine-type=e2-medium --zone=ZONE lab-cluster   ## Cluster creation command
gcloud container clusters get-credentials lab-cluster ## Authenticate with the cluster:
```
**Updating kubeconfig**: The third command updates the `kubeconfig` file with the necessary credentials to interact with the specified Kubernetes cluster using `kubectl`.
> 1. Containers and Kubernetes
