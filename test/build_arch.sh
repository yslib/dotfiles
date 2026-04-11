#!/bin/bash
sudo docker build -f Dockerfile.archlinux --build-arg "https_proxy=http://192.168.0.147:7890" --progress=plain --network host -t test:archlinux .
