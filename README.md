# GCP-projects

before starting, it's to be known to these commands.

```shell
gcloud config set compute/region "REGION"  ## Set the default compute region:
gcloud config set compute/zone "ZONE"      ## Set the default compute zone:

gcloud container clusters create --machine-type=e2-medium --zone=ZONE lab-cluster   ## Cluster creation command
gcloud container clusters get-credentials lab-cluster ## Authenticate with the cluster:
```
**Updating kubeconfig**: The third command updates the `kubeconfig` file with the necessary credentials to interact with the specified Kubernetes cluster using `kubectl`.
> 1. Containers and Kubernetes

