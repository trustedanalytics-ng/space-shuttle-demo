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

VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[' | tail -1)
PROJECT_NAME=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.name | grep -v '\[' | tail -1)
PACKAGE_CATALOG="package-target"
JAR_NAME="${PROJECT_NAME}-${VERSION}.jar"

# build project
mvn clean package -Dmaven.test.skip=true

# create tmp catalog
rm -rf ${PACKAGE_CATALOG}
mkdir ${PACKAGE_CATALOG}

echo "Create space-shuttle-demo.tar.gz package"
tar czvf ${PACKAGE_CATALOG}/space-shuttle-demo.tar.gz -C target ${JAR_NAME} -C ../deploy run.sh deploy.sh manifest.json
echo "Space-shuttle-demo package created successfully"

# create space-shuttle-demo-client package
echo "Create space-shuttle-demo-client.tar.gz package"
pip install -r client/requirements.txt -t client/vendor
touch client/vendor/zope/__init__.py
tar czvf ${PACKAGE_CATALOG}/space-shuttle-demo-client.tar.gz -C client/ vendor/ client_config.py manifest.json requirements.txt run.sh shuttle_scale_cut_val.csv space_shuttle_client.py

echo "Space-shuttle-demo-client package created successfully"

# remove unused files
rm -Rf client/vendor

echo "Package for $PROJECT_NAME project in version $VERSION has been prepared."

