#!/bin/bash

docker build --build-arg CFLAGS="-mcpu=cortex-a53+crypto -mtune=cortex-a53" -t johnsom/uat2esnt-fa-docker:0.01 .
