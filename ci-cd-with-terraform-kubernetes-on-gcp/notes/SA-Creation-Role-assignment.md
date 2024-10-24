Yes, after creating a Service Account (SA), you can retrieve its details, including its name and email, using the `gcloud` command-line tool. Here are a couple of ways to grab the service account information:

### 1. **List All Service Accounts**

To list all service accounts in a specific project, you can use the following command:

```bash
gcloud iam service-accounts list --project="[PROJECT_ID]"
```

### Replace the placeholder:
- `[PROJECT_ID]`: The ID of your Google Cloud project.

### Example

```bash
gcloud iam service-accounts list --project="my-project"
```

This command will return a list of service accounts, including their names and emails. The output will look something like this:

```
DISPLAY NAME                  EMAIL                                          DISABLED
---------------------------  ---------------------------------------------  ---------
My Service Account           my-service-account@my-project.iam.gserviceaccount.com  False
```

### 2. **Get Details of a Specific Service Account**

If you want to get detailed information about a specific service account you just created, you can use the following command:

```bash
gcloud iam service-accounts describe [SERVICE_ACCOUNT_EMAIL]
```

### Replace the placeholder:
- `[SERVICE_ACCOUNT_EMAIL]`: The email of the service account (e.g., `my-service-account@my-project.iam.gserviceaccount.com`).

### Example

```bash
gcloud iam service-accounts describe my-service-account@my-project.iam.gserviceaccount.com
```

This command will provide detailed information about the specified service account, including its creation date, display name, and more.

### Summary

Using the above commands, you can easily retrieve the name and email of the service accounts you have created in your Google Cloud project.