#!/bin/bash

exec java -jar space-shuttle-demo.jar --server.port=80 --spring.profiles.active=dummy-all
