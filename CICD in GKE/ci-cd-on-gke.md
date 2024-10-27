# CI/CD using GKE cluster
![image](https://github.com/user-attachments/assets/0c86c41a-60c4-420a-a26b-0bf79d7bda77)


## Objectives
* Create Kubernetes Engine clusters
* Create Cloud Source Repositories
* Trigger Cloud Build from Cloud Source Repositories
* Automate tests and publish a deployable container image via Cloud Build
* Manage resources deployed in a Kubernetes Engine cluster via Cloud Build

List the active account name:

```
gcloud auth list
```

list the project ID

```
gcloud config list project
```

### Step 1. Prepare the environment
#### Set up variables
* In Cloud Shell, set your project ID and project number. Save them as PROJECT_ID and PROJECT_NUMBER variables:
```
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
export REGION=us-central1
gcloud config set compute/region $REGION
```

#### Enable Google services
* Run the following to enable necessary Google services:
```
gcloud services enable \
  cloudresourcemanager.googleapis.com \
  container.googleapis.com \
  artifactregistry.googleapis.com \
  containerregistry.googleapis.com \
  containerscanning.googleapis.com  
```

#### Get the source code
The source code for is located in the <> org on GitHub.

* Clone the source code with the command below, then change into the directory.
```
git clone https://github.com/<>/code/
cd ~/code
```
#### Provision the infrastructure used in this lab
In this lab you will deploy code to Kubernetes Engine (GKE).

* Run the setup script below to prepare this infrastructure:
```
gcloud container clusters create container-dev-cluster --zone=us-east1-c
```


### Step 2. Working with container images
#### Create a Docker Repository on Artifact registry
Artifact Registry supports managing container images. Different artifact types require different specifications.

To support the different API specifications, Artifact Registry needs to know what format we need the API responses to follow. To do this lets create a repository and pass in the `--repository-format` flag indicating the type of repository desired.

1. From Cloud Shell run the following command to create a repository for Docker images:
```
gcloud artifacts repositories create container-dev-repo --repository-format=docker \
  --location=$REGION \
  --description="Docker repository for Container Dev Workshop"

```
2. In the Cloud console, go to Artifact Registry > Repositories and notice your newly created Docker repository named container-dev-repo. If you click on it you can see that it's empty at the moment
![image](https://github.com/user-attachments/assets/59b19bfe-4db2-4561-882b-385c32d515b1)

#### Configure Docker Authentication to Artifact Registry
When connecting to Artifact Registry credentials are required in order to provide access. Rather than set up separate credentials, Docker can be configured to use **your gcloud credentials** seamlessly.

1. From Cloud Shell run the following command to configure Docker to use the Google Cloud CLI to authenticate requests to Artifact Registry in the us-central1 region:
```
gcloud auth configure-docker us-central1-docker.pkg.dev
```

2. The command will prompt for a confirmation to change the Cloud Shell docker configuration, click ENTER.

<details>
<summary><H3>INFO</H3> </summary> 

<p>The command `gcloud auth configure-docker us-central1-docker.pkg.dev` serves to configure Docker to use the Google Cloud CLI's credential helper for authentication with Google Artifact Registry. Here's a breakdown of what each part does:

* **gcloud auth:** This part of the command invokes the Google Cloud CLI's authentication features.
* **configure-docker:** This subcommand specifically focuses on configuring Docker for authentication.
* **us-central1-docker.pkg.dev:** This argument specifies the hostname of the Google Artifact Registry you want to authenticate with. In this case, it points to the registry in the `us-central1` region.

**Overall, this command sets up Docker to automatically use your logged-in Google Cloud account's credentials when pulling or pushing images to the specified Artifact Registry.** This eliminates the need to manually provide credentials each time you interact with the registry.

Here's a deeper dive into how it works:

1. **Credential Helper:** The `gcloud auth configure-docker` command configures Docker to use the `gcloud` credential helper. This helper acts as an intermediary between Docker and the Google Cloud authentication system.
2. **Active Account Credentials:** When you use Docker commands that require authentication, the credential helper checks for your active Google Cloud account session. If you're logged in with `gcloud auth login`, it retrieves your credentials from the local storage.
3. **Automatic Authentication:** The credential helper then uses your retrieved credentials to automatically authenticate with the specified Artifact Registry (us-central1-docker.pkg.dev in this case).
4. **Seamless Interaction:** This process allows Docker to seamlessly pull and push images to the registry without requiring separate login commands.

**Benefits of using `gcloud auth configure-docker`:**

- **Convenience:** Saves time by automatically authenticating with the registry.
- **Security:** Leverages existing Google Cloud credentials, reducing the need to manage separate credentials for Docker.
- **Simplicity:** Streamlines the workflow by eliminating manual login steps.

**Important Notes:**

- This command assumes you have already installed and initialized the Google Cloud CLI.
- This method relies on the active user account in your gcloud session. 
- For enhanced security, consider using service accounts with specific IAM permissions for Artifact Registry access instead of user accounts.
</p>
</details>

#### Explore the sample Application
A sample application is provided in the git repository you cloned.

* Change into the java directory and review the application code:
```
cd ~/cloud-code-samples/java/java-hello-world
```
The folder contains an example Java application that renders a simple web page: in addition to various files, it contains the source code, under the src folder, and a Dockerfile that we'will use to build a container image locally.

#### Build the Container Image
Before you can store container images in Artifact Registry you need to create one.

* Run the following command to build the container image and tag it properly:
```
docker build -t us-central1-docker.pkg.dev/[PROJECT_ID]/container-dev-repo/java-hello-world:tag1 .
```
#### Push the Container Image to Artifact Registry
Run the following command to push the container image to the repository you created:
```
docker push us-central1-docker.pkg.dev/[PROJECT_ID]/container-dev-repo/java-hello-world:tag1
```
#### Review the image in Artifact Registry
1. In Artifact Registry > Repositories, click into `container-dev-repo` and check that the `java-hello-world` image is there.

2. Click on the image and note the image tagged `tag1`. You can see that Vulnerability Scanning is running or already completed and the number of vulnerabilities detected is visible.
![image](https://github.com/user-attachments/assets/b7263098-1ed0-418b-adbf-0146cf13d5b6)

### Step 3. Integration with Cloud Code
We'll now use the Artifact Registry Docker image repository with Cloud Code.

### Deploy the Application to GKE Cluster from Cloud Code
1. From the `java-hello-world` folder run the following command to open Cloud Shell Editor and add the application folder to this workspace:
```
cd ~/cloud-code-samples/
cloudshell workspace .
```
  
The Cloud Shell editor will open with the explorer in the application folder.


2. From the left menu, select Cloud Code and then expand the COMPUTE ENGINE option and click on Select a Project and choose the project ID.
![image](https://github.com/user-attachments/assets/3c80de33-4558-453a-b331-6b87c25c1649)

![image](https://github.com/user-attachments/assets/b23e4e40-e638-47cc-b87d-e1fb0cf7cb27)

![image](https://github.com/user-attachments/assets/4538fa78-9571-4ec4-afff-5eae47fb8d7d)

Also, expand the **KUBERNETES** option. You will be able to see the cluster loading.

Wait until you see the cluster listed under **KUBERNETES** as well as under **COMPUTE ENGINE**.

(ignore the region, the SS is for example only)
![image](https://github.com/user-attachments/assets/407e7e26-7ebf-4149-8709-4197fedb5be9)

3. The following steps will require you to enter your Artifact Registry repository location. The format for the location is:
```
(example)
us-east1-docker.pkg.dev/qwiklabs-gcp-02-283f59f9ad7d/container-dev-repo  
```
Click Navigation menu under the Cloud Shell Editornavigation menu icon View > Command Palette... and type Run on Kubernetes and select Cloud Code: Run on Kubernetes.
![image](https://github.com/user-attachments/assets/0b59c110-ca35-472b-a79f-19b05f7667aa)

![image](https://github.com/user-attachments/assets/4e5512fc-4c07-4489-9384-da97fdf9e0ca)

Choose `cloud-code-samples/java/java-hello-world/skaffold.yaml` and then `dockerfile`.

![image](https://github.com/user-attachments/assets/c15de1c2-3983-49db-9e5b-7319677bb688)

![image](https://github.com/user-attachments/assets/c37935c4-56ea-41cc-8f58-e9a33919a635)
![image](https://github.com/user-attachments/assets/7ee1b3ed-8e00-41ef-a2e4-0a4e2cf836dd)

If Prompted for a context, select Yes to use the current context.
![image](https://github.com/user-attachments/assets/2ba6aad3-683f-4e00-b658-ae6ba88b9402)

In the prompt for the image registry select *Enter the address of an image repository* and put the address location you located below and press Enter.
![image](https://github.com/user-attachments/assets/43ed0353-f07e-4ef0-8f17-bfac10df4c9a)

`us-east1-docker.pkg.dev/qwiklabs-gcp-02-283f59f9ad7d/container-dev-repo` (example only) you have to put the repo address of the one you created.
![image](https://github.com/user-attachments/assets/92deebdb-f275-4585-bd5b-85c8f1e6ca95)

![image](https://github.com/user-attachments/assets/2a64e4f0-a4b3-451f-8dba-51af7f0d6283)

![image](https://github.com/user-attachments/assets/0782d1c8-e6a7-40f1-a7c2-c15712b2375a)

![image](https://github.com/user-attachments/assets/87c8e647-a585-46d7-8f22-99fef60a6345)


#### Update application code
Now update the application to see the change implemented immediately in the deployment on the cluster:

1. Open the HelloWorldController.java by clicking on the Navigation menu under the Cloud Shell Editor navigation menu icon View > Command Palette... and then click one backspace and then enter the path src/main/java/cloudcode/helloworld/web and click the option starting with Hello.. .

2. Change the text in row 20 from "It's running!" to "It's updated!". You should see the build and deployment process starting immediately.

3. At the end of the deploy click again on the forwarded url or refresh the browser window with the application to see your change deployed:

![image](https://github.com/user-attachments/assets/823c1077-5058-4013-8c80-ba649dce5d98)
![image](https://github.com/user-attachments/assets/8cd942a6-488b-4783-ba62-58b1ac7410af)


![image](https://github.com/user-attachments/assets/b59aec2c-ed46-48a9-bfb4-8165de9b9020)

![image](https://github.com/user-attachments/assets/8a38c8c8-8020-4883-b6bb-4c2d04b1abbf)

In the Cloud console go to Navigation Menu > Artifact Registry > Repositories and click into container-dev-repo to check that the java-hello-world image and note the new image.

![image](https://github.com/user-attachments/assets/0caaac5e-0acd-4a54-82a3-c0817dd0015d)

<details> <summary>self notes</summary>
<p>
  
```
gcloud auth login --update-adc
```
```
gcloud artifacts print-settings mvn \
    --repository=container-dev-java-repo \
    --location=us-east1
```
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
 <modelVersion>4.0.0</modelVersion>

 <artifactId>hello-world</artifactId>
 <packaging>jar</packaging>
 <name>Cloud Code Hello World</name>
 <description>Getting started with Cloud Code</description>
 <version>1.0.0</version>
<distributionManagement>
   <snapshotRepository>
     <id>artifact-registry</id>
     <url>artifactregistry://us-east1-maven.pkg.dev/qwiklabs-gcp-02-283f59f9ad7d/container-dev-java-repo</url>
   </snapshotRepository>
   <repository>
     <id>artifact-registry</id>
     <url>artifactregistry://us-east1-maven.pkg.dev/qwiklabs-gcp-02-283f59f9ad7d/container-dev-java-repo</url>
   </repository>
 </distributionManagement>

 <repositories>
   <repository>
     <id>artifact-registry</id>
     <url>artifactregistry://us-east1-maven.pkg.dev/qwiklabs-gcp-02-283f59f9ad7d/container-dev-java-repo</url>
     <releases>
       <enabled>true</enabled>
     </releases>
     <snapshots>
       <enabled>true</enabled>
     </snapshots>
   </repository>
 </repositories>

 <parent>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-parent</artifactId>
   <version>2.6.3</version>
 </parent>

 <properties>
   <java.version>1.8</java.version>
   <checkstyle.config.location>./checkstyle.xml</checkstyle.config.location>
 </properties>

 <build>
   <plugins>
     <plugin>
       <groupId>com.google.cloud.tools</groupId>
       <artifactId>jib-maven-plugin</artifactId>
       <version>3.2.0</version>
     </plugin>
     <plugin>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-maven-plugin</artifactId>
     </plugin>
     <plugin>
       <groupId>org.apache.maven.plugins</groupId>
       <artifactId>maven-checkstyle-plugin</artifactId>
       <version>3.1.2</version>
     </plugin>
   </plugins>
   <extensions>
     <extension>
       <groupId>com.google.cloud.artifactregistry</groupId>
       <artifactId>artifactregistry-maven-wagon</artifactId>
       <version>2.1.0</version>
     </extension>
   </extensions>
 </build>

 <!-- The Spring Cloud GCP BOM will manage spring-cloud-gcp version numbers for you. -->
 <dependencyManagement>
   <dependencies>
     <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-gcp-dependencies</artifactId>
       <version>1.2.8.RELEASE</version>
       <type>pom</type>
       <scope>import</scope>
     </dependency>
   </dependencies>
 </dependencyManagement>

 <dependencies>

   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter</artifactId>
   </dependency>

   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-jetty</artifactId>
   </dependency>

   <dependency>
     <groupId>org.springframework</groupId>
     <artifactId>spring-webmvc</artifactId>
   </dependency>

   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-thymeleaf</artifactId>
   </dependency>

   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-test</artifactId>
     <scope>test</scope>
   </dependency>

   <dependency>
     <groupId>org.springframework.cloud</groupId>
     <artifactId>spring-cloud-gcp-starter-logging</artifactId>
   </dependency>

 </dependencies>

</project>

```
![image](https://github.com/user-attachments/assets/ceeaaab5-76ca-4ff8-b062-9ab4b0b774dd)


![image](https://github.com/user-attachments/assets/156683c2-baa1-4a45-88fd-11258a430142)
</p>
</details>
