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


now before we push the image to container registry we need to enable the api
```
gcloud service enable artifactregistry.googleapis.com
```
