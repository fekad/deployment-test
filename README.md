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
- https://medium.com/coinmonks/continuous-integration-with-google-application-engine-and-travis-d822b751fb47
- https://www.softserveinc.com/en-us/blogs/kubernetes-travis-ci/