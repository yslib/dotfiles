#!/bin/bash
MY_UID=$(id -u)
MY_GID=$(id -g)

sudo docker run --rm -it \
  -v "$(pwd):/test" \
  -e http_proxy="http://127.0.0.1:7897" \
  -e https_proxy="http://127.0.0.1:7897" \
  --network host \
  test:ubuntu \
  bash -c "groupadd -g $MY_GID tester && \
  useradd -m -u $MY_UID -g $MY_GID -s /bin/bash tester && \
  echo 'tester ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  su - tester"
