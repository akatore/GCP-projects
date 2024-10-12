# GCP-projects

For each of the following Projects, you should be in the kubernetes dir:
```
cd GCP-projects
```

## Orchestrating the Cloud with Kuberenetes
  * [Creating and managing pods](Creating%20and%20managing%20pods.md)
  * [Monitoring and health checks](Monitoring%20and%20Health%20Checks.md)
  * [Managing application configurations and secrets](Managing%20application%20configurations%20and%20secrets.md)
  * [Creating and managing services](Creating%20and%20Managing%20Services.md)
  * [Creating and managing deployments](Creating%20and%20Managing%20Deployments.md)
  * [Rolling out updates](Rolling%20out%20Updates.md)
  * [Containers and Kubernetes](Containers%20and%20Kubernetes/README.md)
  * [Deploy Kubernetes Applications](Deploy%20Kubernetes%20Applications%20on%20GKE/Deploy%20Kubernetes%20Applications.md)
  * [Docker on GCP](Docker%20on%20GCP/Docker%20on%20GCP.md)
  
## [Flask app on GKE](Flask%20App%20with%20GKE%20Deployment/flask-app-with-gke.md)

<!-- before starting, it's to be known to these commands.

```shell
gcloud config set compute/region "REGION"  ## Set the default compute region:
gcloud config set compute/zone "ZONE"      ## Set the default compute zone:

gcloud container clusters create --machine-type=e2-medium --zone=ZONE lab-cluster   ## Cluster creation command
gcloud container clusters get-credentials lab-cluster ## Authenticate with the cluster:
```
**Updating kubeconfig**: The third command updates the `kubeconfig` file with the necessary credentials to interact with the specified Kubernetes cluster using `kubectl`.
/!-->
