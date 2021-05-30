#!/bin/bash

docker build --build-arg CFLAGS="-mcpu=cortex-a53+crypto -mtune=cortex-a53" -t johnsom/dump1090-fa-docker:0.06 .
