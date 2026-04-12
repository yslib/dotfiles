sudo docker build --build-arg "https_proxy=http://127.0.0.1:7897" --progress=plain --network host -t test:ubuntu .
