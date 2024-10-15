# GCP-projects

<!--For each of the following Projects, you should be in the kubernetes dir:
```
cd GCP-projects
```/!-->
## [Application Deployment and Container Orchestration on GKE](Flask%20App%20with%20GKE%20Deployment/flask-app-with-gke.md)
  * [Project overview](Flask%20App%20with%20GKE%20Deployment/project-summary.md)

## [CI/CD with Terraform and Kubernetes](https://github.com/akatore/GCP-projects/tree/main/ci-cd-with-terraform-kubernetes-on-gcp)

## [Orchestrating the Cloud with Kuberenetes](https://github.com/akatore/GCP-projects/tree/main/Architecting%20and%20Managing%20Kubernetes%20Workloads%20on%20GKE)
  * [Creating and managing pods](Creating%20and%20managing%20pods.md)
  * [Monitoring and health checks](Monitoring%20and%20Health%20Checks.md)
  * [Managing application configurations and secrets](Managing%20application%20configurations%20and%20secrets.md)
  * [Creating and managing services](Creating%20and%20Managing%20Services.md)
  * [Creating and managing deployments](Creating%20and%20Managing%20Deployments.md)
  * [Rolling out updates](Rolling%20out%20Updates.md)
  * [Containers and Kubernetes](Containers%20and%20Kubernetes/README.md)
  * [Deploy Kubernetes Applications](Deploy%20Kubernetes%20Applications%20on%20GKE/Deploy%20Kubernetes%20Applications.md)
  * [Docker on GCP](Docker%20on%20GCP/Docker%20on%20GCP.md)
  * Configuring Google Kubernetes Engine (GKE) Networking (**completed not documented**)
  * Configuring Persistent Storage for Google Kubernetes Engine (**completed not documented**)

## [CICD in GKE](CICD%20in%20GKE/ci-cd-on-gke.md) 
  * Working with Artifact Registry #working with container images #Integrtion with Cloud Code
  * Google Kubernetes Engine Pipeline using Cloud Build (in progress)
  * Continuous Delivery with Google Cloud Deploy (in progress)
  
before starting, it's good to be known to these commands.

```shell
source <(kubectl completion bash)

gcloud config set compute/region "REGION"  ## Set the default compute region:
gcloud config set compute/zone "ZONE"      ## Set the default compute zone:

gcloud container clusters create --machine-type=e2-medium --zone=ZONE lab-cluster   ## Cluster creation command
gcloud container clusters get-credentials CLUSTER_NAME --zone ZONE --project PROJECT_ID ## Authenticates with the cluster:
gcloud services list --enabled  # To list all the enabled googleapis
gcloud services enable artifactregistry.googleapis.com # to enable googleapi for particular resource api

gcloud config list accounts
gcloud config set account YOUR_ACCOUNT_EMAIL

gcloud auth login  ## Authentication, It will prompt you to log in to your Google account and store the credentials locally.

gcloud iam roles add-member --project=your-project-id --role=ROLES/SPECIFIC_ROLE --member=user:your-email@example.com
gcloud iam roles add-member --project=your-project-id --role=roles/owner --member=user:your-email@example.com  ## Authorization
```
**Updating kubeconfig**: The 4rth command updates the `kubeconfig` file with the necessary credentials to interact with the specified Kubernetes cluster using `kubectl`.
