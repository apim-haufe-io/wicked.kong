#!/usr/local/bin/dumb-init !/bin/bash

if [ ! -z "$PROXY_SSL_CERT" ] && [ ! -z "$PROXY_SSL_KEY" ]; then
  echo Using certificates from PROXY_SSL_CERT and PROXY_SSL_KEY

  echo "$PROXY_SSL_CERT" > /root/proxy-cert.pem
  echo "$PROXY_SSL_KEY" > /root/proxy-key.pem

  cp /root/nginx_kong.lua /usr/local/share/lua/5.1/kong/templates/nginx_kong.lua
else
  echo Not using custom proxy SSL certificate. Override
  echo by defining PROXY_SSL_CERT and PROXY_SSL_KEY.
fi

if [ ! -z "$KONG_DATABASE_SERVICE_HOST" ]; then
  echo Kubernetes Mode, picking up database host from env var.
  unset KONG_PG_HOST
  export KONG_PG_HOST=$KONG_DATABASE_SERVICE_HOST
fi

echo Using kong database host: $KONG_PG_HOST

dockerize -wait tcp://kong-database:5432 kong start
