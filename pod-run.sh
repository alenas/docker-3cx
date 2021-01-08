#!/bin/bash

podman run \
        --name 3cx \
        --hostname voip.pir.lt \
        --memory 2g \
        --memory-swap 2g \
        --network host \
        --restart always \
        -v 3cx_backup:/srv/backup \
        -v 3cx_recordings:/srv/recordings \
        -v 3cx_log:/var/log \
        -v 3cx-tmp:/tmp/run \
        --privileged \
        bytecity/3cx:16.0.7.1078
        
