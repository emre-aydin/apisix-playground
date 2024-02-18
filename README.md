# APISIX Playground

This demo shows how to use Apisix together with KeyCloak to expose a service securely by using OpenID Connect for 
authentication. 

* Kind is used as the Kubernetes cluster.
* KeyCloak acts as the OpenID Connect identity provider.
* APISIX is used as the API gateway for exposing the service and handling the authentication flow.

To run the demo on your local, map `local.httpbin.org` to `127.0.0.1` in your `/etc/hosts` file.

## Create the Kind Kubernetes cluster

```shell
make create-cluster
```

## Deploy APISIX

```shell
make deploy-apisix
```

## Deploy APISIX OIDC Plugin

```shell
make deploy-oidc-plugin
```

## Deploy the demo service (httpbin)

```shell
make deploy-httpbin
```

## Deploy KeyCloak

```shell
make deploy-keycloak
```

## Create KeyCloak Client

```shell
make create-keycloak-client
```

## Test Access to Service

Open up your browser and navigate to http://local.httpbin.org. This will ask you to log in. Once you enter credentials
`testuser/testpassword`, you will be navigate to the main page.

APISIX OIDC plugin obtains the token and manages it in the cookie. You can open the page 
`http://local.httpbin.org/headers` and observe that `X-Access-Token` and `X-Userinfo` request headers are set. 

## Delete the Kind cluster

Once you're done, execute `make delete-cluster` to delete the kind cluster and clean up.
