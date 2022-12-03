#!/bin/sh

# This file is part of the TChecker-build-releases project
# 
# See AUTHORS and LICENSE for copyright details
#
# This tool builds an archive containing binary files, libraries and 
# documentation for a ready-to-run version of TChecker for architecture
# Linux/amd64
#
# Expects argument:
# - <dir> a directory where the archive shall be written

if [ $# -ne 1 ];
then
    echo "Usage: $0 <dir>"
    echo "  where <dir> is the directory where the archive will be written"
    exit 1
fi

OUTPUT_DIR="$1"

# Build TChecker for Linux/x86_64 using Docker

DOCKER_FILE="Dockerfile.build-linux_amd64"
LINUX_IMAGE="tchecker-build-linux_x86_64"

docker images | grep "${LINUX_IMAGE}" 2>&1 > /dev/null

if [ $? -eq 0 ];
then
    echo "The Docker image ${LINUX_IMAGE} already exists. Delete and rebuild it? [yes/no]"
    select answer in yes no;
    do
        if [ "$answer" = "yes" ];
        then
            docker rmi "${LINUX_IMAGE}"
            docker build -t "${LINUX_IMAGE}" -f ${DOCKER_FILE} .
            break
        elif [ "$answer" = "no" ];
        then
            echo "Using existing image ${LINUX_IMAGE}"
            break
        else
            echo "Wrong answer";
            exit 1
        fi
    done
else
    docker build -t "${LINUX_IMAGE}" -f ${DOCKER_FILE} .
fi

docker run --platform=linux/amd64 -it --rm -v "${OUTPUT_DIR}:/mnt" "${LINUX_IMAGE}"
