#!/bin/bash
docker build -t img_star -f Dockerfile.star .
docker run --name subread_container -i -t img_star

