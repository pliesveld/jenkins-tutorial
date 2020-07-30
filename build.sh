#!/bin/bash

docker pull jenkins/jenkins:lts
docker-compose build --no-cache --force-rm

