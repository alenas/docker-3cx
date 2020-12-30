#!/bin/bash

VERSION=1
USER=al3nas

podman rmi ${USER}/3cx:${VERSION}

podman build \
        --force-rm \
        --no-cache \
        -t 3cx_stage1 .

podman run \
        -d \
        --privileged \
        --name 3cx_stage1_c 3cx_stage1

podman exec 3cx_stage1_c bash -c \
        "   systemctl mask systemd-logind console-getty.service container-getty@.service getty-static.service getty@.service serial-getty@.service getty.target \
         && systemctl enable nginx \
         && systemctl enable exim4 \
         && systemctl enable postgresql \
         && echo 1 | apt-get -y install 3cxpbx"

podman stop 3cx_stage1_c

podman commit 3cx_stage1_c ${USER}/3cx:${VERSION}

podman rm 3cx_stage1_c

podman rmi 3cx_stage1