#!/bin/bash
IP='{{floating_ip_name}}'
TOKEN='{{lb_failover_hcloud_token}}'

n=0
while [ $n -lt 10 ]
do
    if [ "$(/opt/hcloud-ip -ip "$IP" -key $TOKEN)" == "Server called $HOSTNAME was found" ]; then
        break
    fi
    n=$((n+1))
    sleep 3
done