#!/bin/bash

INTERFACE=ens10  # replace with your interface
TIMEOUT=60  # timeout in seconds

while [ $TIMEOUT -gt 0 ]; do
  if ip link show $INTERFACE | grep -q "state UP"; then
    exit 0
  fi
  sleep 1
  TIMEOUT=$((TIMEOUT-1))
done

exit 1