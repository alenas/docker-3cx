#!/bin/bash

VERSION=latest
USER=al3nas

docker run \
        -d \
        --name 3cx \
        --hostname voip.pir.lt \
        --memory 2g \
        --memory-swap 2g \
        --network host \
        --restart always \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -v 3cx_backup:/srv/backup \
        -v 3cx_recordings:/srv/recordings \
        -v 3cx_log:/var/log \
        --cap-add SYS_ADMIN \
        --cap-add NET_ADMIN \
        ${USER}/3cx:${VERSION}