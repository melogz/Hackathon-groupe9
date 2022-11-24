#!/bin/bash
docker build -t img_star -f docker/Dockerfile.star .
docker run --name subread_container -t img_star

