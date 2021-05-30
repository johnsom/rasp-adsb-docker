#!/bin/bash

echo "$ADSBXUUID" > /boot/adsbx-uuid

/adsbexchange-stats/json-status
