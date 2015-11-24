#!/bin/bash

set -xe
source /etc/contrail/openstackrc

CONTRAIL_HOST=localhost
AUTH_TOKEN=$(keystone token-get | awk '/ id / {print $4}')

function ensure_net {
  set +xe
  local name=$1
  local cidr=$2
  neutron net-list | grep $name
  if [[ $? != 0  ]]; then
    echo "ok"
    neutron net-create $name
    neutron subnet-create $name $cidr
  fi
  set -xe
}

function contrail_list {
  set +xe
  local path=$1
  curl -s -H "X-Auth-Token: $AUTH_TOKEN" $CONTRAIL_HOST:8082/$path?detail=True | python -mjson.tool
  set -xe
}

function contrail_post {
  set +xe
  local path=$1
  local file=$2
  curl -vvv -X POST \
       -H "Content-Type: application/json; charset=UTF-8" \
       -H "X-Auth-Token: $AUTH_TOKEN" \
       -d @$file \
       $CONTRAIL_HOST:8082/$path | python -mjson.tool
  set -xe
}

function contrail_get {
  set +xe
  local path=$1
  local id=$2
  curl -s -H "X-Auth-Token: $AUTH_TOKEN" $CONTRAIL_HOST:8082/$path/$id | python -mjson.tool
  set -xe
}

# ensure_net red 10.0.0.0/24
# ensure_net blue 20.0.0.0/24
# contrail_post virtual-networks jsons/transitive_network.json

# contrail_post service-templates jsons/service_template_transparent.json
# contrail_post service-templates jsons/service_template_in_network.json
# contrail_list service-instances > jsons/service_instances.json
contrail_post service-instances jsons/service_instance_red-a.json
contrail_post service-instances jsons/service_instance_blue-a.json



