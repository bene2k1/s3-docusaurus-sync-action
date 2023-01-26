# GitHub Action to build docusaurus site and deploy it on Scaleway Object Storage

This is a customized version of the s3-sync-action that uses the [vanilla AWS CLI](https://docs.aws.amazon.com/cli/index.html) to sync a directory (either from your repository or generated during your workflow) with a remote S3 bucket. It also runs the command: yarn run build to build the docusaurs site for deployment.

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `SCW_ACCESS_KEY_ID` and `SCW_SECRET_ACCESS_KEY`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository's source code and CI logs.

| Key                   | Value                                                                                                                                                                                               | Suggested Type        | Required | Notes                                                                    |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- | -------- | ------------------------------------------------------------------------ |
| SCW_BUCKET_REGION    | The region where you created your bucket. Set to [Full list of regions here.](https://www.scaleway.com/en/docs/storage/object/concepts/#region-and-endpoint)) | `env`                 | Yes      |                                                                          |
| AWS_S3_BUCKET         | The bucket name you want to publish the site to                                                                                                                                                     | `env` or `secret env` | Yes      | This does not have to be in the secrets but it makes it easier to manage |
| SCW_ACCESS_KEY_ID     | Your Scaleway Access Key. [More info here.](https://www.scaleway.com/en/docs/identity-and-access-management/iam/api-cli/using-api-key-object-storage))                                                                                 | `secret env`          | Yes      |                                                                          |
| SCW_SECRET_ACCESS_KEY | Your Scaleway Secret Access Key. [More info here.](https://www.scaleway.com/en/docs/identity-and-access-management/iam/api-cli/using-api-key-object-storage)                                                                          | `secret env`          | Yes      |                                                                          |
