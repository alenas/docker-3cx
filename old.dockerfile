FROM jrei/systemd-debian:9

ENV LANG en_US.UTF-8
ENV LANGUAGE en

RUN    apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --allow-unauthenticated \
         apt-utils \
         gnupg2 \
         curl \
         locales \
    && sed -i 's/\# \(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && curl http://downloads.3cx.com/downloads/3cxpbx/public.key | apt-key add - \   
    && echo "deb http://downloads.3cx.com/downloads/debian stretch main" | tee /etc/apt/sources.list.d/3cxpbx.list \
    && apt-get update -y \
    && apt-get install -y --allow-unauthenticated \
       net-tools \
       $(apt-cache depends 3cxpbx | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ') \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/anaconda.target.wants/* \
    ## Clean up
    && apt-get -y clean all \
    && systemctl mask systemd-logind console-getty.service container-getty@.service getty-static.service getty@.service serial-getty@.service getty.target

VOLUME ["/sys/fs/cgroup", "/srv/backup", "/srv/recordings", "/var/log"]
EXPOSE 5015/tcp 5001/tcp 5060/tcp 5060/udp 5061/tcp 5090/tcp 5090/udp 8089 9000-9500/udp

## CMD is in jrei/systemd-debian image