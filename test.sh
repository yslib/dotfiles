#!/bin/bash
# 1. 获取你当前的 UID 和 GID
MY_UID=$(id -u)
MY_GID=$(id -g)

# 2. 启动容器，创建指定 UID 的用户
sudo docker run --rm -it \
  -v "$(pwd):/test" \
  -e http_proxy="http://192.168.0.147:7897" \
  -e https_proxy="http://192.168.0.147:7897" \
  --network host \
  docker.m.daocloud.io/library/ubuntu:22.04 \
  bash -c "apt-get update && apt-get install -y curl git sudo unzip tar && \
  groupadd -g $MY_GID tester && \
  useradd -m -u $MY_UID -g $MY_GID -s /bin/bash tester && \
  echo 'tester ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  su - tester"
