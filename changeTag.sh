#!/bin/bash
sed "s/tagVersion/$1/g" pods.yml > aws-image-upload-pods.yml
