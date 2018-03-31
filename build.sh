##!/bin/bash
## Update tag
## bump container: https://github.com/treeder/dockers/tree/master/bump
set -ex

USERNAME='pvlns001'
IMAGE='elasticsearch'
DOCKER_REPO='https://hub.docker.com/r/pvlns001/elasticsearch/'

## Increment release tag
docker run --rm -i -v $PWD:/app -w /app treeder/bump --filename VERSION patch
VERSION=`cat VERSION`
echo "new version: $VERSION"

## Build latest
docker build -t $USERNAME/$IMAGE:$VERSION --build-arg CACHEBUST=$(date +%s) .

## Tag image
#echo "Creating tag ${USERNAME}/${IMAGE}:${VERSION}"
#docker tag ${USERNAME}/${IMAGE}:${VERSION} ${DOCKER_REPO}/${IMAGE}:${VERSION}

## Push image
echo "Pushing image to ${DOCKER_REPO}..."
docker push ${DOCKER_REPO}/${IMAGE}:${VERSION}
echo "Successfully pushed to ${DOCKER_REPO}/${IMAGE}:${VERSION}"

## Git commit
git add -A
git commit -m "Incrementing release to ${VERSION}"
