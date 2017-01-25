#!/usr/bin/env bash

java -jar space-shuttle-demo.jar --server.port=80 --spring.profiles.active=kafka-input,web-scoring,influx-storage
