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

set -e

OUTPUT_DIR="artifacts"
if [ -n "$1" ]; then
  OUTPUT_DIR="$1"
fi

CLIENT_OUTPUT_DIR="$OUTPUT_DIR/client"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$CLIENT_OUTPUT_DIR"

cp client/manifest.json "$CLIENT_OUTPUT_DIR"
cp package-target/space-shuttle-demo-client.tar.gz "$CLIENT_OUTPUT_DIR"
cp deploy/manifest.json "$OUTPUT_DIR"
cp deploy/deploy.sh "$OUTPUT_DIR"
cp deploy/model.mar "$OUTPUT_DIR"
cp package-target/space-shuttle-demo.tar.gz "$OUTPUT_DIR"
