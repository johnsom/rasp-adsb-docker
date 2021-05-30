#!/bin/bash

/usr/bin/piaware-config allow-mlat yes
/usr/bin/piaware-config mlat-results no
/usr/bin/piaware-config receiver-type relay
/usr/bin/piaware-config receiver-host dump1090
/usr/bin/piaware-config receiver-port 30005
/usr/bin/piaware-config uat-receiver-type sdr
/usr/bin/piaware-config uat-receiver-host dump978
/usr/bin/piaware-config uat-receiver-port 30978
/usr/bin/piaware-config feeder-id $FAFEEDERID

socat -U TCP-LISTEN:30005,fork TCP:dump1090:30005 &
socat -U TCP-LISTEN:30978,fork TCP:dump978:30978 &
/usr/bin/piaware -plainlog
