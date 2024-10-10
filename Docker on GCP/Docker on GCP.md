
```shell
gcloud auth list
```
![Authentication List](image.png)

To list the project configuration:
```shell
gcloud config list project
```
![Project Configuration](image-1.png)

If the image is already present, it won't be downloaded from DockerHub Registry.
![Image Present](image-2.png)

To check if the containers are running:
```shell
docker ps
```
![Running Containers](image-3.png)

To check all containers, including those that are not running:
```shell
docker ps -a
```
![All Containers](image-4.png)

## Packaging an App in a Container

First, create a Dockerfile, then build an image from it. Finally, deploy the app in a container using that image.

```Dockerfile
cat > Dockerfile <<EOF
# Use an official Node runtime as the parent image
FROM node:lts

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Make the container's port 80 available to the outside world
EXPOSE 80

# Run app.js using node when the container launches
CMD ["node", "app.js"]
EOF
```

```javascript
cat > app.js << EOF;
const http = require("http");

const hostname = "0.0.0.0";
const port = 80;

const server = http.createServer((req, res) => {
        res.statusCode = 200;
        res.setHeader("Content-Type", "text/plain");
        res.end("Hello World\n");
});

server.listen(port, hostname, () => {
        console.log("Server running at http://%s:%s/", hostname, port);
});

process.on("SIGINT", function () {
        console.log("Caught interrupt signal and will exit");
        process.exit();
});
EOF

```

```shell
 docker build -t node-app:0.1 .
```
![alt text](image-5.png)
```
docker images
```
```
docker run -p 4000:80 --name my-app node-app:0.1
```
```output
fc6fe0ceec46f092d758c6dadc3ec6a359bb354c506d80648f6802cc0bc4a0c1
```
```
docker ps
```
![alt text](image-7.png)

using detached mode
```
docker run -p 4000:80 --name my-app -d node-app:0.1
```
![alt text](image-8.png)

![alt text](image-9.png)
![alt text](image-10.png)

# lets create an Artifact Repository.
```shell
gcloud artifacts repositories create my-repository --repository-format=docker --location=us-east1 --description="Docker repository"
```
![alt text](image-11.png)

Lets push the container to artifact registry

```
cd ~/test
```
to get the full artfactory path copy above path, 

![alt text](image-13.png)
![alt text](image-14.png)
```

docker build -t us-east1-docker.pkg.dev/qwiklabs-gcp-03-72d7cfc36816/my-repository/node-app:0.2 .
```
```
docker images
```
![alt text](image-12.png)

Pushing this image to Artifact Registry.

```bash
docker push us-east1-docker.pkg.dev/qwiklabs-gcp-03-72d7cfc36816/my-repository/node-app:0.2
```
![alt text](image-15.png)

After the push finishes, from the Navigation Menu, under **CI/CD** navigate to **Artifact Registry** > **Repositories**.

Click on my-repository. You should see your node-app Docker container created:
![alt text](image-16.png)

Test the image
To simulate a fresh environment, we can either start a new VM, SSH into it, and install gcloud, or simply remove all containers and images.
![
    
](image-17.png)
Stop and remove all containers:
```shell
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
```
![alt text](image-18.png)
![alt text](image-19.png)

We must remove child images of `node:lts` before removing the `node` image.

![alt text](image-20.png)
![alt text](image-21.png)

Run this command to remove all Docker images:
```shell
docker rmi us-east1-docker.pkg.dev/qwiklabs-gcp-03-72d7cfc36816/my-repository/node-app:0.2
docker rmi node:lts
docker rmi -f $(docker images -aq) # remove remaining images
docker images
```

(Command Output)

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

At this point, you should have a pseudo-fresh environment.

Pull the image and run it:
```shell
docker run -p 4000:80 -d us-east1-docker.pkg.dev/qwiklabs-gcp-03-72d7cfc36816/my-repository/node-app:0.2
```

Run a curl against the running container:
```shell
curl http://localhost:4000
```

(Command Output)

```
Welcome to Cloud
```