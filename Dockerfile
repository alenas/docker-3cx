FROM debian:stretch

ARG BUILD_STRING
ARG BUILD_DATE
ARG BUILD_TIME

LABEL build.string $BUILD_STRING
LABEL build.date   $BUILD_DATE
LABEL build.time   $BUILD_TIME

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en
ENV container docker

RUN    apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --allow-unauthenticated \
         apt-utils \
         gnupg2 \
         curl \
         systemd \
         locales \
    && sed -i 's/\# \(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && curl http://downloads.3cx.com/downloads/3cxpbx/public.key | apt-key add - \   
    && echo "deb http://downloads.3cx.com/downloads/debian stretch main" | tee /etc/apt/sources.list.d/3cxpbx.list \
    && apt-get update -y \
    && apt-get install -y --allow-unauthenticated \
       net-tools \
       $(apt-cache depends 3cxpbx | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ') \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/anaconda.target.wants/* \
    ## Clean up
    && apt-get -y clean all \
    && apt-get -y autoremove
    ## 3cx permissions fix for docker namespaces
    #&& curl -o /usr/local/bin/3cx_fix_perms.sh https://raw.githubusercontent.com/ekondayan/docker-3cx/main/assets/3cx_fix_perms.sh \
    #&& chmod +x /usr/local/bin/3cx_fix_perms.sh \
    #&& curl -o /usr/lib/systemd/user/3cx_fix_perms.service https://raw.githubusercontent.com/ekondayan/docker-3cx/main/assets/3cx_fix_perms.service \
    #&& systemctl enable 3cx_fix_perms.service

VOLUME ["/sys/fs/cgroup", "/srv/backup", "/srv/recordings", "/var/log"]
EXPOSE 5015/tcp 5001/tcp 5060/tcp 5060/udp 5061/tcp 5090/tcp 5090/udp 9000-9500/udp

CMD ["/lib/systemd/systemd"]