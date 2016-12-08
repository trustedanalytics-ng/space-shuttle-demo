#!/bin/bash -x
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


export PYTHONPATH="${PYTHONPATH}:`dirname $0`/vendor"

if [[ -n $1 ]]; then
   HOSTNAME=$1
else
    echo $SERVICES_BOUND_GATEWAY | grep -q ,
    if [ $? == 0 ]; then
        echo "Faild too many gateways binded"
        exit 1
    fi
    HOSTNAME=$(printenv "$(echo  ${SERVICES_BOUND_GATEWAY^^} | tr - _ )_GATEWAY_SERVICE_NAME")
fi
python space_shuttle_client.py --gateway-url $HOSTNAME:8080

