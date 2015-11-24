#!/bin/bash

set -xe

source /etc/contrail/openstackrc
IMAGES="images/*.qcow2"
for IMAGE in $IMAGES;do
  FILE_NAME=${IMAGE##*/}
  NAME=${FILE_NAME%.qcow2}
  echo $NAME
  glance image-create --name "$NAME" \
                      --is-public true \
                      --disk-format qcow2 \
                      --container-format bare \
                      --file $IMAGE
done
