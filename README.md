# deployment-test

```bash 
RELEASE=jhub
NAMESPACE=jhub
SECRET_TOKEN='...'
USER_PASSWORD='...'

helm upgrade --dry-run --debug --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE  \
  --version=0.8.0 \
  --set proxy.secretToken=$SECRET_TOKEN \
  --set auth.dummy.password=$USER_PASSWORD \
  --values config.yaml
```

## Continuous integration
Tutorials:
- https://cloud.google.com/solutions/continuous-delivery-with-travis-ci
- https://gist.github.com/mjackson/5887963e7d8b8fb0615416c510ae8857

Pre-requirements:
- GCloud cluster deployed by helm
- GitHub account
- gcloud and travis cli

### Configuring Travis CI with your GitHub account
1. On the Travis CI page, sign in with your GitHub account.
2. On the Sign in to GitHub to continue to Travis CI page, enter your GitHub credentials and then click Sign In.
3. Click Authorize travis-pro.
4. On the GitHub Apps Integration page, click Activate.
5. Click Approve & Install.

### Creating credentials
To deploy the app to your GCP project, you must create two types of credentials:

- Service account credentials that enable the Cloud SDK to authenticate with your GCP project.
- A public API key that the App Engine app uses to communicate with the Books API.

### Create a service account
1. In the GCP Console, open the IAM Service Accounts page.
2. Click Create Service Account
3. Enter a Service account name, such as continuous-integration-test.
4. Click Create.
5. In the Role menu, select Kubernetes > Kubernetes Engine Admin.
6. Click Continue.
7. Click Create Key.
8. Under Key type, select JSON.
9. Move and rename (client-secret.json) this file to the root  of your GitHub repo.


## Encrypt the credentials for Travis CI to use
This credential is added to a public GitHub repository, and therefore need to be encrypted. You encrypt the files locally and configure Travis to decrypt them. For more information, see encrypting files for Travis CI.

Important: Don't commit this credential to the repository. The client-secret.json contains your private credentials. The project's .gitignore file is configured to ignore this file. If you change its name, you need to update the .gitignore file.

1. Log in to Travis CI.
    ```bash
    travis login --org
    ```
2. When asked to complete shell installation, enter Y and then enter your GitHub credentials.

3. Encrypt the file locally.
    ```bash
    travis encrypt-file client-secret.json --org
    ```
4. When prompted to overwrite the existing file, enter yes.
5. Copy the output line that begins with openssl aes-256-cbc to the clipboard.

In the .travis.yml file, replace the DECRYPT_COMMAND string with the previous console output by using the following command. Replace [YOUR_COMMAND_OUTPUT] with the console output you copied in the previous step.

sed -i 's/DECRYPT_COMMAND/[YOUR_COMMAND_OUTPUT]/g' .travis.yml
Edit the .travis.yml file and the e2e_test.py file to reflect your project name.

sed -i "s/continuous-deployment-python/${DEVSHELL_PROJECT_ID}/g" .travis.yml
sed -i "s/continuous-deployment-python/${DEVSHELL_PROJECT_ID}/g" e2e_test.py
Add the encrypted archive to the repository.

git add credentials.tar.gz.enc .travis.yml e2e_test.py
git commit -m "Adds encrypted credentials for Travis and updates project name"
