#!/bin/bash
#
# Copyright (c) 2016 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
####################################################################################
#
# deploy.sh
# Script for pushing 'space-shuttle-demo' application to TAP platform
#
# Usage:
#   Params:
# $1 - path to tap-cli directory
#
#   How to run:
# ./deploy.sh <path_to_tap_cli_directory> E.g.: ./deploy.sh /home/centos/TAP-0.8
#
#   How it works:
# This script deploy sample application 'space-shuttle-demo' to Trusted Analytics
# Platform (TAP) using TAP CLI (Command Line Interface)
#
# Login to TAP instance using TAP CLI:
# ./<path-to-tap>/tap login <http://-https://-instance-address> <username> <password>
#
# Create needed service (influxdb and gateway):
# ./<path-to-tap>/tap service create --offering gateway --plan single --name space-shuttle-gateway
# ./<path-to-tap>/tap service create --offering influxdb-088 --plan single --name space-shuttle-db
#
# Push application to TAP Platform
# ./<path-to-tap>/tap application push --archive-path space-shuttle-demo.tar.gz
#
#

TAP=$1/tap

if [ -z "$1" ]; then
    echo -e "Usage: ./deploy.sh <path_to_tap_cli_directory>\nE.g.: ./deploy.sh /home/centos/TAP-0.8\n "
    exit
fi

function checkReturnCode() {
  if [ "$1" != 0 ]; then
    echo -e "\nFailed Ups! Something went wrong"
    exit 1
  fi
}

#Checking that service or application are present
function checkStatus() {
    count=$($TAP $1 list | grep " $2 "| wc -l)
    if [ $count -ne 0 ]; then
        echo -e "Failed Skipping: $1 $2\n"
        return 1
    fi
}

# create needed service
echo "Creating gateway instance..."
checkStatus "service" "space-shuttle-gateway"
if [ $? -eq 0 ]; then
    $TAP service create --offering gateway --plan single --name space-shuttle-gateway
    checkReturnCode $?
fi


echo "Creating influx-db instance..."
checkStatus "service" "space-shuttle-db"
if [ $? -eq 0 ]; then
    $TAP service create --offering influxdb-088 --plan single-small --name space-shuttle-db
    checkReturnCode $?
fi

echo "Creating scoring-engine instance..."
checkStatus "service" "space-shuttle-scoring-engine"
if [ $? -eq 0 ]; then
    $TAP service create --offering scoring-engine --plan single --name space-shuttle-scoring-engine
    checkReturnCode $?
    # Check if scoring-engine instance is running
    ready="NOT"
    counter=0
    while [ $ready != "RUNNING" ] && [ $counter -le 60 ]
    do
      sleep 2
      ready=$($TAP service info --name space-shuttle-scoring-engine | grep state | cut -d "\"" -f 4)
      counter=$((counter+1))
      printf '.'
    done
    echo $ready
    # Upload model to scoring-engine
    url=$($TAP service info --name space-shuttle-scoring-engine | grep http | cut -d "\"" -f 4)
    curl -X POST --data-binary @model.mar $url/uploadMarBytes
    if [ $? != 0 ]; then
      echo -e "\nFailed, scoring-engine didn't start"
      exit 1
    fi
fi

echo "Pushing application space-shuttle-demo..."
checkStatus "application" "space-shuttle-demo"
if [ $? -eq 0 ]; then
    $TAP application push --archive-path space-shuttle-demo.tar.gz
    checkReturnCode $?
fi

cd client

echo "Pushing application space-shuttle-demo-client..."
checkStatus "application" "space-shuttle-demo-client"
if [ $? -eq 0 ]; then
    $TAP application push --archive-path space-shuttle-demo-client.tar.gz
    checkReturnCode $?
fi

touch .log
echo -e "\nSuccessful"
