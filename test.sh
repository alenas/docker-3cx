docker network create -d macvlan --subnet 192.168.1.0/24 --gateway 192.168.1.1 -o parent=venet0 mv_0

docker run -d --name 3cx \
    --hostname voip.pir.lt \
    --network host \
    --restart unless-stopped \
    -v 3cx_backup:/mnt/backup \
    -v 3cx_recordings:/mnt/recordings \
    -v 3cx_log:/var/log \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --cap-add SYS_ADMIN \
    --cap-add NET_ADMIN \
        farfui/3cx:16.0.6.655