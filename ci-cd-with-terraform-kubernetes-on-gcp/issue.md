![image](https://github.com/user-attachments/assets/a779ba42-4656-4886-846f-a0b65ba6b82f)
(service account wasn't activated, i did by adding a josn key, then using below command)

```
gcloud auth activate-service-account gke-wsa@$PROJECT_ID.iam.gserviceaccount.com --key-file=gke-project-439604-55210b49e482.json
```

Great to hear that the issue was resolved by using the `gcloud auth activate-service-account` command! Here’s an explanation of how and why that command fixed the problem.

### Understanding the Error

The original error message:

```
Error: google-github-actions/auth failed with: retry function failed after 4 attempts: failed to generate Google Cloud access token for gke-wsa@$***.iam.gserviceaccount.com: (404) {
  "error": {
    "code": 404,
    "message": "Not found; Gaia id not found for email gke-wsa@$***.iam.gserviceaccount.com",
    "status": "NOT_FOUND"
  }
}
```

This error typically indicates that the service account could not be found or authenticated correctly. The `404 Not Found` error suggests that the Google Cloud platform could not recognize or locate the service account `gke-wsa@<YOUR_PROJECT_ID>.iam.gserviceaccount.com`.

### How the Command Resolved the Issue

The command you used:

```bash
gcloud auth activate-service-account gke-wsa@gke-project-439604.iam.gserviceaccount.com --key-file=gke-project-439604-55210b49e482.json
```

Here’s what happens when you run this command:

1. **Activating the Service Account**: 
   - This command explicitly authenticates your local environment (like Google Cloud Shell) with the credentials provided in the specified key file (`gke-project-439604-55210b49e482.json`). This means that your environment is now using the service account for authentication.

2. **Establishing Credentials**: 
   - When you activate the service account, it sets up the necessary authentication credentials that allow you to perform actions using that service account without running into issues like "not found" or "permission denied." This essentially tells the Google Cloud SDK to use this service account for any subsequent commands or actions.

3. **Fixing IAM Settings**:
   - By authenticating with the service account, you ensured that your environment is properly configured to interact with Google Cloud resources, including any APIs that may require access tokens or service account credentials. This might have resolved any underlying issues with the IAM setup that were preventing the service account from being recognized.

### Why It Was Necessary

- **Context of the Error**: When the GitHub Actions runner tried to authenticate with the service account using Workload Identity Federation, it failed to find the service account, likely because the configuration wasn't fully established or properly propagated in the Google Cloud IAM system.
  
- **Local Activation**: By activating the service account locally, you were able to bypass any issues in the GitHub Actions environment (which may not have the same configurations or permissions) and directly confirm that the service account and the key file were working correctly.

### Conclusion

In summary, activating the service account with the provided key file resolved the authentication issues because it established a clear and direct connection to Google Cloud resources using the service account's credentials. This ensured that you could perform actions as that service account without encountering issues related to its existence or permissions. 

If you have any further questions or need clarification on any related topics, feel free to ask!

Enables the necessary APIs at project level

![image](https://github.com/user-attachments/assets/b2b4db62-079b-4235-aea2-23e5d19be146)

The error message you're seeing indicates that the **IAM Service Account Credentials API** is not enabled for your Google Cloud project. To resolve this, you'll need to enable the API. Here’s how you can do that:

### Steps to Enable the IAM Service Account Credentials API

1. **Go to the Google Cloud Console**:
   Open the [Google Cloud Console](https://console.cloud.google.com/).

2. **Select Your Project**:
   Make sure to select the project where your service account is located. In your case, it seems to be project ID `189792038322`.

3. **Navigate to APIs & Services**:
   - In the left-hand menu, go to **APIs & Services > Dashboard**.
   - Click on **Enable APIs and Services** at the top.

4. **Search for the API**:
   - In the API Library, use the search bar to look for **IAM Service Account Credentials API**.
   - Click on it in the search results.

5. **Enable the API**:
   - Click the **Enable** button on the API overview page.

6. **Wait for Propagation**:
   After enabling the API, wait a few minutes for the changes to propagate. Sometimes, it can take a little while before the API is fully enabled and ready for use.

### Retry Your Workflow
Once you have enabled the IAM Service Account Credentials API, re-run your GitHub Actions workflow. It should now be able to generate access tokens without encountering the `403 PERMISSION_DENIED` error.

### Additional Considerations
- **Permissions**: Ensure that the service account `gke-wsa@<YOUR_PROJECT_ID>.iam.gserviceaccount.com` has the necessary permissions to use the IAM Service Account Credentials API. You might need to assign roles like `roles/iam.serviceAccountTokenCreator`.
  
- **IAM Policies**: Make sure the service account used by your GitHub Actions has appropriate IAM policies configured.

### Conclusion
Enabling the IAM Service Account Credentials API should resolve the issue you're encountering. If you run into any more errors or have questions, feel free to ask!


## no access to service account, Permission 'iam.serviceAccounts.getAccessToken' denied on resource (or it may not exist).

![image](https://github.com/user-attachments/assets/71bae1c4-b019-4e41-a1a4-d9a4692e91d1)

The error message indicates that the GitHub Actions runner does not have the necessary permissions to call the `iam.serviceAccounts.getAccessToken` method for the specified service account (`gke-wsa@<YOUR_PROJECT_ID>.iam.gserviceaccount.com`). This typically means that the identity used in your GitHub Actions workflow does not have the required IAM roles assigned.

### Steps to Resolve the Permission Denied Error

1. **Identify the GitHub Actions Identity**:
   If you're using Workload Identity Federation, the GitHub Actions runner uses a specific identity to authenticate with Google Cloud. Ensure that this identity has been granted the necessary permissions.

2. **Grant the Required Permissions**:
   You need to grant the `roles/iam.serviceAccountTokenCreator` role to the GitHub Actions identity for the service account `gke-wsa@<YOUR_PROJECT_ID>.iam.gserviceaccount.com`. Here’s how to do it:

   - Go to the [Google Cloud Console](https://console.cloud.google.com/).
   - Navigate to **IAM & Admin > IAM**.
   - Locate the identity associated with your GitHub Actions (this might be a Google-managed service account created for your Workload Identity Pool).
   - Click on **Edit** (the pencil icon) next to that identity.
   - Under **Add another role**, select **Service Account Token Creator** (this is the role that includes the `iam.serviceAccounts.getAccessToken` permission).
   - ![image](https://github.com/user-attachments/assets/30996737-3392-42ae-be9a-b18b092180e6)

   - In the **Condition** field, you may leave it blank or specify conditions based on your requirements.
   - Save the changes.

3. **Verify Service Account Existence**:
   Make sure that the service account `gke-wsa@<YOUR_PROJECT_ID>.iam.gserviceaccount.com` exists and is correctly set up.

4. **Wait for Changes to Propagate**:
   After making the changes, it may take a few minutes for the permissions to propagate. 

5. **Re-run Your GitHub Actions Workflow**:
   Once you've assigned the permissions, re-run your GitHub Actions workflow to check if the error is resolved.

### Example of Granting Permission via Command Line
If you prefer to do it via the command line, you can use the following `gcloud` command (replace the placeholders accordingly):

```bash
gcloud iam service-accounts add-iam-policy-binding gke-wsa@<YOUR_PROJECT_ID>.iam.gserviceaccount.com \
    --member="serviceAccount:<GITHUB_ACTIONS_IDENTITY_EMAIL>" \
    --role="roles/iam.serviceAccountTokenCreator"
```

Replace `<GITHUB_ACTIONS_IDENTITY_EMAIL>` with the email address of the identity being used by GitHub Actions.

### Conclusion
After ensuring that the necessary permissions are granted, you should be able to authenticate successfully without encountering the `403 PERMISSION_DENIED` error. If you have any more questions or run into further issues, feel free to ask!

