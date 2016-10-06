#!/bin/bash

if [ -z "$WICKED_KONG_IMAGE" ]; then
    echo Please first set the WICKED_KONG_IMAGE env variable to select which
    echo Kong image to use for wicked.
    exit 1
fi

if [ -z "$DOCKER_PREFIX" ]; then
    echo "The env variable DOCKER_PREFIX is not set."
    echo "For Haufe github:"
    echo "  export DOCKER_PREFIX=haufelexware/wicked."
    echo "For Haufe bitbucket:"
    echo "  export DOCKER_PREFIX=registry.haufe.io/wicked/"
    exit 1
fi

if [ -z "$DOCKER_TAG" ]; then
    echo "The env variable DOCKER_TAG is not set."
    echo "Specify the tag to set, e.g. latest, dev,..."
    exit 1
fi

echo Writing Dockerfile from template...
perl -pe 's;(\\*)(\$([a-zA-Z_][a-zA-Z_0-9]*)|\$\{([a-zA-Z_][a-zA-Z_0-9]*)\})?;substr($1,0,int(length($1)/2)).($2&&length($1)%2?$2:$ENV{$3||$4});eg' Dockerfile.template > Dockerfile

docker build -t ${DOCKER_PREFIX}kong:${DOCKER_TAG} .
