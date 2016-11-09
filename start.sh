#!/usr/bin/env bash

rm -rf src/app-deployment-lib && mvn package -Dmaven.test.skip=true
java -jar ./target/space-shuttle-demo-0.5.34.jar --server.port=8090 --spring.profiles.active=dummy-all --logging.level.org.trustedanalytics=DEBUG
