# Flask App with GKE Deployment

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

Lets create a Repository 
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




