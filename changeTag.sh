#!/bin/bash
sed "s/tagVersion/$1/g" nodejs-deployment.yml > node-app-pod.yml