#!/bin/bash

if [ ! -z "$PROXY_SSL_CERT" ] && [ ! -z "$PROXY_SSL_KEY" ]; then
  echo Using certificates from PROXY_SSL_CERT and PROXY_SSL_KEY

  echo "$PROXY_SSL_CERT" > /root/proxy-cert.pem
  echo "$PROXY_SSL_KEY" > /root/proxy-key.pem

  cp /root/nginx_kong.lua /usr/local/share/lua/5.1/kong/templates/nginx_kong.lua
else
  echo Not using custom proxy SSL certificate. Override
  echo by defining PROXY_SSL_CERT and PROXY_SSL_KEY.
fi

dockerize -wait tcp://kong-database:5432 kong start
