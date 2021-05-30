#!/bin/bash

docker build --build-arg CFLAGS="-mcpu=cortex-a53+crypto -mtune=cortex-a53" -t johnsom/adsbx-mlat-docker:0.01 .
