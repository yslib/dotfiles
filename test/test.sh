#!/bin/bash
MY_UID=$(id -u)
MY_GID=$(id -g)

sudo docker run --rm -it \
  -v "$(pwd):/test" \
  --network host \
  test:ubuntu \
  bash -c "groupadd -g $MY_GID tester && \
  useradd -m -u $MY_UID -g $MY_GID -s /bin/bash tester && \
  echo 'tester ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  su - tester"
