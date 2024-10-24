Thanks for sharing the repository link. Now, based on your GitHub repository URL, you should consider the format of the `sub` claim in the GitHub Actions OIDC token, which often follows this structure:

```
repo:<owner>/<repo>:ref:refs/heads/<branch>
```

In your case, it might look something like:
```
repo:akatore/GCP-projects:ref:refs/heads/main
```

### Recommended Steps:

1. **Ensure Correct Attribute Mapping:**
   Since you're working with GitHub Actions, your OIDC token will likely include a `sub` claim (subject) that specifies the GitHub repository and branch. You might want to map it like this:
   ```bash
   --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.actor=assertion.actor,attribute.aud=assertion.aud"
   ```

2. **Verifying `sub` Claim:**
   The `sub` claim should represent the repo and branch, so make sure it includes the correct repository name, like:
   ```
   repo:akatore/GCP-projects
   ```

3. **Adjust Conditions Based on the Repo:**
   If you want to restrict access based on the repository, you can add a condition to the Workload Identity Pool provider that checks if the token’s `sub` claim matches your repository. You could use a condition like this:
   ```bash
   --attribute-condition="attribute.repository=='akatore/GCP-projects'"
   ```

### Example Command:
Here’s how the full command might look, with proper mapping based on your repo:

```bash
gcloud iam workload-identity-pools providers create-oidc "k8s-provider" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="k8s-pool" \
  --display-name="k8s provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-condition="attribute.repository=='akatore/GCP-projects'"
```

This should map the necessary attributes and link them to your repository. Let me know how it goes or if you encounter further issues!