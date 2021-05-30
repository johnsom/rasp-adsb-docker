#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "The install script must be run as root."
  exit 1
fi

mkdir -p /var/log/containers
if ! grep -q '/var/log/containers' /etc/fstab; then
    echo "tmpfs   /var/log/containers     tmpfs   rw,size=1G,nodev,nosuid,noexec,uid=root,gid=syslog,mode=775 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_978-html/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_978-html/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_978-html/_data     tmpfs   rw,size=50M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_978json-data/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_978json-data/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_978json-data/_data tmpfs   rw,size=100M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_adsbx-data/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_adsbx-data/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_adsbx-data/_data   tmpfs   rw,size=100M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_collectd/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_collectd/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_collectd/_data     tmpfs   rw,size=100M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_graphs1090_graphs/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_graphs1090_graphs/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_graphs1090_graphs/_data    tmpfs   rw,size=50M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_graphs1090_html/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_graphs1090_html/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_graphs1090_html/_data      tmpfs   rw,size=10M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_json-data/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_json-data/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_json-data/_data    tmpfs   rw,size=100M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_public-html/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_public-html/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_public-html/_data  tmpfs   rw,size=50M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_tar1090_data/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_tar1090_data/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_tar1090_data/_data tmpfs   rw,size=100M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mkdir -p /var/lib/docker/volumes/rasp-adsb-docker_tar1090_html/_data
if ! grep -q '/var/lib/docker/volumes/rasp-adsb-docker_tar1090_html/_data' /etc/fstab; then
    echo "tmpfs   /var/lib/docker/volumes/rasp-adsb-docker_tar1090_html/_data tmpfs   rw,size=50M,nodev,nosuid,noexec,uid=root,gid=root,mode=755 0 0" >> /etc/fstab
fi

mount -a
cp 31-adsb-uat-rsyslog.conf /etc/rsyslog.d
cp adsb-uat-logrotate /etc/logrotate.d
systemctl restart rsyslog
