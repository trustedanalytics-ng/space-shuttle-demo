#!/usr/bin/env bash

rm -rf src/app-deployment-lib && mvn package -Dmaven.test.skip=true
cp ./target/space-shuttle-demo-0.5.35.jar ./tap/space-shuttle-demo.jar
cd tap
./run.sh
