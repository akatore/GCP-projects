# Flask App with GKE Deployment

## Flask App with GKE Deployment: A Comprehensive Guide

**Flask** is a lightweight Python web framework that's popular for its simplicity and flexibility. **Google Kubernetes Engine (GKE)** is a managed Kubernetes service on Google Cloud Platform (GCP) that provides a scalable and reliable platform for deploying containerized applications.

**Combining Flask and GKE** offers a powerful solution for building and deploying scalable, cloud-native web applications. Here's a breakdown of the key components and steps involved:

### 1. **Create a Flask Application:**
* Develop your Flask application using Python.
* Ensure your application is packaged and ready to be deployed as a Docker image.
Flask App
```py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def main_page():
    return "<h1>Welcome to the Main Page</h1><p>This is the homepage of our Flask app.</p>"

@app.route('/about')
def about_page():
    return "<h1>About Page</h1><p>This is the about page of our Flask app.</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

```
### 2. **Build a Docker Image:**
* Create a Dockerfile that defines the environment and dependencies for your Flask application.
* Build the Docker image using the `docker build` command.
Dockerfile
```Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable for Flask to run in production mode
ENV FLASK_ENV=production

# Run app.py when the container launches
CMD ["python", "app.py"]

```



`requirements.txt`
```
Flask==2.3.3

```

![image](https://github.com/user-attachments/assets/2cc1646c-ae2e-4bc2-973f-1b3e8cf588a9)

Lets create a Repository in artifactregistry
```
gcloud artifactregistry repositories create my-repository --location asia-south1 --repository-format=docker
```
Opps! seems we haven't enabled the `artifactregistry.googleapis.com`
![image](https://github.com/user-attachments/assets/69c4f493-eae5-4c0a-af82-c172e2b85643)

Lets try again after enabling.
```
gcloud services enable artifactregistry.googleapis.com
```

lets get the project ID, and set `PROJECT_ID=<project-id>`
![image](https://github.com/user-attachments/assets/64273b1b-ec63-4a43-a60a-90000221ce9c)
And set the project ID
![image](https://github.com/user-attachments/assets/be244dc9-920e-444f-b97c-0940dc0aca3e)

```
gcloud artifactregistry repositories create my-repository --location asia-south1 --repository-format=docker
```

now before we push the image to container registry we need to enable the api
```
gcloud service enable artifactregistry.googleapis.com
```
![image](https://github.com/user-attachments/assets/9d1c75d6-9961-42e9-a4cf-d65420c2c49c)

> NOTE its a paid api, and will cost us, ensure to disable after use, by `gcloud services disable artifactregistry.googleapis.com` before that `gcloud artifactregistry repositories delete my-repository --location asia-south1`

![image](https://github.com/user-attachments/assets/356a9cb2-be97-4f6f-bed8-81730ab9dcd0)

We can now have our repo created here,
![image](https://github.com/user-attachments/assets/b56759d6-db13-4497-9941-620458d33d7b)

Lets do this again,
(either of these commands works)
```
gcloud artifactregistry repositories create my-repository --location asia-south1 --repository-format=docker

gcloud artifacts repositories create my-repository --location=asia-south1 --repository-format=docker
```
![image](https://github.com/user-attachments/assets/378efd41-ab9d-4cd7-825c-828e1366efe0)
![image](https://github.com/user-attachments/assets/a027ed54-358a-47f0-b86b-4f45f726c9b1)


<details>
<summary><H3>INFO</H3></summary>
<p>

The string `asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository` represents the full path to your Docker repository within Google Artifact Registry. Here's how it breaks down:

* **asia-south1-docker.pkg.dev:** This is the hostname for the Artifact Registry location (`asia-south1`) and format (`docker`).
* **vertical-tuner-438407-p5:** This is likely your Google Cloud project ID.
* **/my-repository:** This is the specific name you gave to your repository when you created it (or plan to create it).

This complete path allows you to:

* **Push Docker images:** Use the `docker push` command with this path as the destination to upload your Docker images to the repository.
* **Pull Docker images:** Use the `docker pull` command with this path as the source to download images from the repository.
* **Reference the repository in tools:**  Many tools and frameworks can directly reference repositories using this path for building, deploying, or managing Docker images.

Remember, to successfully use this path, you need to have first:

1. **Enabled the Artifact Registry API:** Ensure the API is enabled for your project using `gcloud services enable artifactregistry.googleapis.com`.
2. **Created the repository:** Use `gcloud artifactregistry repositories create my-repository --location asia-south1 --repository-format=docker` (replacing `my-repository` with your desired name) to create the repository.

</p>
</details>

Lets push our image to artifact registry,
```
docker tag flask-app:v1 asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app:v1
```
```
docker push asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app:v1
```

![image](https://github.com/user-attachments/assets/b9e849e4-3cd0-43e4-a8ea-1981f21e0361)

![image](https://github.com/user-attachments/assets/2dedd4c4-3d0c-4c9f-ab9a-1e423caa483a)

<details>
<summary>If facing bellow error</summary>
<p>

```abhijeetkatore101@cloudshell:~/project (vertical-tuner-438407-p5)$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED             SIZE
flask-app    v1        c3e633216874   About an hour ago   136MB

docker push asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app
Using default tag: latest
The push refers to repository [asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app]
An image does not exist locally with the tag: asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app
abhijeetkatore101@cloudshell:~/project (vertical-tuner-438407-p5)$ 
```
        
The error you encountered happens because the image you're trying to push (`asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app`) does not exist locally. You built the image with the tag `flask-app:v1`, but you need to tag it properly for Google Artifact Registry before pushing.

Here’s how to fix this:

### Steps to Tag and Push the Image to Google Artifact Registry

1. **Tag the Image**:
   You need to tag your existing `flask-app:v1` image with the full path to your Artifact Registry repository.

   ```bash
   docker tag flask-app:v1 asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app:v1
   ```

   This command tags your local `flask-app:v1` image to the registry path `asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app:v1`.

2. **Push the Image**:
   Now, push the tagged image to your Artifact Registry repository.

   ```bash
   docker push asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app:v1
   ```

   Since you have now tagged the image correctly, it should push without errors.

### Verify the Push
You can verify that the image is successfully pushed to the registry by listing the images:

```bash
gcloud artifacts docker images list asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository
```

This should display your `flask-app:v1` image in the repository.

Let me know if you run into any more issues!</p>
        
</details>

<br></br>

```
```
Now we to deploy our app on GKE we need to enable the api first
![image](https://github.com/user-attachments/assets/7d7900ac-9dbf-46b8-9a75-4c5143776cb4)

```
gcloud services enable container.googleapis.com
```
![image](https://github.com/user-attachments/assets/7782d01e-00af-437a-8b23-e532aff036e6)
it's enabled now,
![image](https://github.com/user-attachments/assets/19cea4f5-ef94-4e18-8504-ce04c5e89b9e)

![image](https://github.com/user-attachments/assets/b8db523f-c9ef-4d02-bce5-7d472535a900)

Lets create out cluster, 
<!-- ![image](https://github.com/user-attachments/assets/f8deb320-a0f8-4245-9514-56503a4c4658) /!-->

![image](https://github.com/user-attachments/assets/7a4c0b68-4ea8-4ac2-bd7a-54455ffe6258)

```
gcloud beta container --project "vertical-tuner-438407-p5" clusters create "my-first-cluster-1" --zone "us-central1-c" --no-enable-basic-auth --cluster-version "1.31.1-gke.1146000" --release-channel "rapid" --machine-type "g1-small" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "32" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-ip-alias --network "projects/vertical-tuner-438407-p5/global/networks/default" --subnetwork "projects/vertical-tuner-438407-p5/regions/us-central1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --security-posture=standard --workload-vulnerability-scanning=disabled --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --binauthz-evaluation-mode=DISABLED --enable-managed-prometheus --enable-shielded-nodes --node-locations "us-central1-c"
```

![image](https://github.com/user-attachments/assets/1e18b8d8-1be1-4803-81dd-f524c357bb55)


<details>
<summary>Note</summary>
    <p>
        Artifact Registry API: When you enable the Artifact Registry API in your project, it becomes accessible from any region where Google Cloud services are available.
Repository Access: The repository itself is a logical entity, not tied to a specific physical location. You can access it from any region where you have network connectivity to the Google Cloud platform.
Image Pull: When your GKE cluster needs to pull a Docker image from your Artifact Registry repository, it will establish a network connection and retrieve the image. The location of the repository doesn't affect the speed or reliability of this process.

</p>
</details>


It's in creation, might take few minutes.

![image](https://github.com/user-attachments/assets/fd61cbb0-73b3-43b7-994e-8dbdd8860cef)

So our cluster is created, lets connect to the cluster.

![image](https://github.com/user-attachments/assets/a8ab916c-1323-4c60-8489-75fa60071787)

![image](https://github.com/user-attachments/assets/69ec50cc-0f1c-4e19-9d43-99cf8dc141ba)

```
gcloud container clusters get-credentials my-first-cluster-1 --zone us-central1-c --project vertical-tuner-438407-p5
```
![image](https://github.com/user-attachments/assets/07fe672d-c0bf-4779-9ee6-b75ac08ebdfd)

### 4. **Create a Kubernetes Deployment:**

Lets create our deployment.yaml manifest file.
```
kubectl create deployment flaskappdeployment--image=asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app:v1 --dry-run=client -oyaml
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: flaskappdeployment
  name: flaskappdeployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flaskappdeployment
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: flaskappdeployment
    spec:
      containers:
      - image: asia-south1-docker.pkg.dev/vertical-tuner-438407-p5/my-repository/flask-app:v1
        name: flask-app
        resources: {}
status: {}

```
![image](https://github.com/user-attachments/assets/ee350623-f218-472b-9f99-800e3e0b0335)


lets edit the file in editor
![image](https://github.com/user-attachments/assets/1c533713-f80a-4bf2-a8ee-6a2460768bac)
![image](https://github.com/user-attachments/assets/fd8ccd16-e257-4ac4-9bee-9376411f9f14)
we have added the container ports as our applictaion is listening on 8080

![image](https://github.com/user-attachments/assets/cb202ab3-212e-46bb-8f18-5cf87378fd94)

![image](https://github.com/user-attachments/assets/3f03891f-d712-4b62-b15c-74d84faa1421)

### 4. **Exposing the Deployment with a LoadBalancer:**
Now that out pod is in ready state lets expose it using service.

![image](https://github.com/user-attachments/assets/1a70bb81-196a-4ab3-a4bc-00e36d24a55b)

```
k expose deployment flaskappdeployment --type LoadBalancer --dry-run=client -oyaml
```
```
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: flaskappdeployment
  name: flaskappdeployment
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: flaskappdeployment
  type: LoadBalancer
status:
  loadBalancer: {}
```
![image](https://github.com/user-attachments/assets/51a1ee46-70d8-4926-9af4-e890538cb6aa)

we dont need to do any changes, just neet to create the service of type loadbalancer now,

![image](https://github.com/user-attachments/assets/e3f0b217-d52f-4747-994d-902db0066a66)

![image](https://github.com/user-attachments/assets/e7c20583-6296-4059-9f62-514f850203c3)

Lets get the external IP and check the connection to our appliation.
Once you have the external IP, we can access your app in the browser.

![image](https://github.com/user-attachments/assets/cc47c892-afc3-4343-9b0d-21a59e0d886d)

Woala!!
![image](https://github.com/user-attachments/assets/0c58947e-7ac5-4d5d-83ac-689a06ea92a9)

our about page is also working fine.

![image](https://github.com/user-attachments/assets/3c144761-2490-4b78-8d55-457c9b7343a5)

