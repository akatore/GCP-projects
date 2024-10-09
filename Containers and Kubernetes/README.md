## Containers and Kubernetes



Step1. Confirming the needed APIs are enabled.

```

```

Step2. Build containers with Dockerfile and Cloud Build

```shell
vi quickstart.sh
```

add following lines in `quickstart.sh`
```shell
#!/bin/sh

echo "Hello there! the time is $(date)."

```
Create `Dockerfile` file    
```
vi Dockerfile
```

```Dockerfile
FROM alpine      #This instructs the build to use the Alpine Linux base image.
COPY quickstart.sh #This instructs the build to use the Alpine Linux base image.
CMD ["/quickstart.sh"]  ## This adds the quickstart.sh script to the / directory in the image.

```

```shell
chmod +x quickstart.sh   ## making the quickstart.sh script executable
```

Create a new Docker repository named quickstart-docker-repo in the location us-east4 with the description "Docker repository"

```shell
gcloud artifacts repositories create quickstart-docker-repo --repository-format=docker \
    --location=us-east4 --description="Docker repository"
```

Building the Docker container image in Cloud Build, using Cloud Shell

```shell
gcloud builds submit --tag us-east4-docker.pkg.dev/${DEVSHELL_PROJECT_ID}/quickstart-docker-repo/quickstart-image:tag1
```

![alt text](image.png)