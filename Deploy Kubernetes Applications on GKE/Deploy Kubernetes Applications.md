## Deploy an application to the cluster 

We'll created kubernetes object to manage the our cluster resourceses.
For the purpose of this deployment will run google-samples/hello-app:1.0 in our cluster.

Below command creates a new Deployment hello-server from the hello-app container image
```shell
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
```
A deployment hello-server will be craeted. here, --image specifies a container image to deploy. 
The command pulls the example image from a Container Registry bucket. `gcr.io/google-samples/hello-app:1.0` indicates the specific image version to pull. 
If a version is not specified, the latest version is used.


Lets expose the deployment objects to external traffic by create a service, that'll take care of this 
```
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
```

Lets now delete the cluster, 

```
gcloud container clusters delete lab-cluster
```
