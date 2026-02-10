FROM  docker.m.daocloud.io/library/ubuntu:22.04
RUN apt-get update && apt-get install -y curl git sudo unzip tar make

# sudo docker build --build-arg "https_proxy=http://192.168.0.147:7890" --progress=plain --network host -t test:ubuntu .
