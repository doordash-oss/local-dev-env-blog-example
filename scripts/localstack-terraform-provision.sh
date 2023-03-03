#!/bin/bash

# Based on https://baptiste.bouchereau.pro/tutorial/automatic-provisioning-of-localstack/

(docker events --filter 'event=create'  --filter 'event=start' --filter 'type=container' --filter 'container=localstack' --format '{{.Actor.Attributes.name}} {{.Status}}' &) | while read event_info

do
    event_infos=($event_info)
    container_name=${event_infos[0]}
    event=${event_infos[1]}

    echo "$container_name: status = ${event}"

    if [[ $event == "start" ]]; then
        sleep 10 # give localstack some time to start
        terraform init
        terraform apply --auto-approve
        echo "The terraform configuration has been applied."
        pkill -f "docker event.*"
    fi
done