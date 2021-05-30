#!/bin/bash
while true
do
socat -u TCP4:dump978:30978,forever,interval=5 STDOUT | /usr/bin/uat2esnt | socat -u STDIN TCP4:dump1090:30001,forever,interval=5
sleep 1
done
