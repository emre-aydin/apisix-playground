#!/usr/bin/env bash

REALM=myrealm
cd /opt/keycloak/bin || exit 1
./kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password admin
./kcadm.sh create realms -s realm=$REALM -s enabled=true
./kcadm.sh create clients \
  -r $REALM \
  -s clientId=apisix-client \
  -s 'redirectUris=["http://local.httpbin.org/anything/callback"]' \
  -s clientAuthenticatorType=client-secret \
  -s secret=d0b8122f-8dfb-46b7-b68a-f5cc4e25d000
./kcadm.sh create users \
  -r $REALM \
  -s username=testuser \
  -s email=test@example.com \
  -s enabled=true \
  -s emailVerified=true
./kcadm.sh set-password \
  -r $REALM \
  --username testuser \
  --new-password testpassword