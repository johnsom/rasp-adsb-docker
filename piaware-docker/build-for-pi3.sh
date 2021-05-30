#!/bin/bash

docker build --build-arg CFLAGS="-mcpu=cortex-a53+crypto -mtune=cortex-a53" --build-arg CXXFLAGS="-mcpu=cortex-a53+crypto -mtune=cortex-a53 --param ggc-min-expand=1 --param ggc-min-heapsize=32768" -t johnsom/piaware-docker:0.01 .
