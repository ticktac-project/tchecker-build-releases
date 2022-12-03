# TChecker releases build tools

This project provides scripts and Docker images to build binary releases of
TChecker. We currently provide methods to build:
- for the Linux/amd64 platform
- for the Darwin/arm64 platform
- a Docker image

## Building for Linux/amd64

This script requires Docker to run.

Run the script `build-linux-x86_64.sh` with an absolute path given as argument.
The script will build an archive containing all binaries, libraries and 
documentation of TChecker for the Linux operating system over amd64
architecture. The archive is output at the specified path.

## Building for Darwin/arm64

This script must be run from a computer running a Darwin kernel over an arm64
architecture.

Run the script `build-darwin-arm64.sh` with an absolute path given as the first
argument, and a path where a recent version of `bison` is installed (see
[TChecker wiki page](https://github.com/ticktac-project/tchecker/wiki/Installation-of-TChecker)
for details).
The script will build an archive containing all binaries, libraries and 
documentation of TChecker for the Darwin operating system over arm64
architecture. The archive is output at the specified path.

## Building a Docker image

Docker is needed to build the image and run a container from the image.

Run the command: `docker build -t tck -f Dockerfile.build-container .` to build
a Docker image `tck` containing an installed and ready-to-run version of
TChecker, based on the latest commit.

Then, a container can be run from the image by running: `docker run -it tck`.
