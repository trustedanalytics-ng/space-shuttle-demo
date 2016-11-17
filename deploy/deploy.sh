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
# ./<path-to-tap>/tap cs gateway     free space-shuttle-gateway
# ./<path-to-tap>/tap cs influxdb088 free space-shuttle-db
#
# Push application to TAP Platform
# ./<path-to-tap>/tap push space-shuttle-demo.tar.gz
#
#

TAP=$1/tap

if [ -z "$TAP" ]; then
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
    count=$($TAP $1 | grep " $2 "| wc -l)
    if [ $count -ne 0 ]; then
        echo -e "Failed Skipping: $1 $2\n"
        return 1
    fi
}

# create needed service
echo "Creating gateway instance..."
checkStatus "svcs" "space-shuttle-gateway"
if [ $? -eq 0 ]; then
    $TAP cs gateway free space-shuttle-gateway
    checkReturnCode $?
fi


echo "Creating influx-db instance..."
checkStatus "svcs" "space-shuttle-db"
if [ $? -eq "0" ]; then
    $TAP cs influxdb088 free space-shuttle-db
    checkReturnCode $?
fi


echo "Pushing application..."
checkStatus "apps" "space-shuttle-demo"
if [ $? -eq 0 ]; then
    $TAP push space-shuttle-demo.tar.gz
    checkReturnCode $?
fi


touch .log
echo -e "\nSuccessful"

if [ $? -nq 0 ]; then
    echo -e "\nbut cannot double some services or applications"
    exit 1
fi
