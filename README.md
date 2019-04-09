# Continuous integration/delivery
[![Build Status](https://travis-ci.org/fekad/deployment-test.svg?branch=master)](https://travis-ci.org/fekad/deployment-test)

Tutorials:
- https://cloud.google.com/solutions/continuous-delivery-with-travis-ci
- https://gist.github.com/mjackson/5887963e7d8b8fb0615416c510ae8857

Pre-requirements:
- GCP cluster 
- travis cli (for the encryption)
- gcloud and helm cli (for local interaction)

## Secrets
There are two different type of secrets stored in two different ways:
1. Encrypted credentials for making connection with GCP
2. "Hidden" environmental variables for the jupyterhub settings (secret token, password, etc.)


### 1. Creating credentials for GCP
To deploy the app to your GCP project, you must create an Service account credentials that enable the Cloud SDK to authenticate with your GCP project.

**Create a service account**

1. In the GCP Console, open the IAM Service Accounts page.
2. Click Create Service Account
3. Enter a Service account name, such as continuous-integration-test.
4. Click Create.
5. In the Role menu, select Kubernetes > Kubernetes Engine Admin.
6. Click Continue.
7. Click Create Key.
8. Under Key type, select JSON.
9. Move and rename (client-secret.json) this file to the root  of your GitHub repo.

***Encrypt the credentials for Travis CI to use***

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
5. Copy the output line that begins with openssl aes-256-cbc to the clipboard and update the corresponding line in the .travis.yml file
 
### 2. Store variables for the jupyterhub settings

Sensitive parameters can be passed as environmental variables. All of these variables can be stored in the settings (More options > Settings) of travis-ci. 

```bash 
# Jupyterhub secrets
SECRET_TOKEN='...'
USER_PASSWORD='...'

RELEASE=jhub
NAMESPACE=jhub
helm upgrade --dry-run --debug --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE  \
  --version=0.8.0 \
  --set proxy.secretToken=$SECRET_TOKEN \
  --set auth.dummy.password=$USER_PASSWORD \
  --values config.yaml
```
