#!/bin/sh

# This file is part of the TChecker-build-releases project
# 
# See AUTHORS and LICENSE for copyright details
#
# This tool builds an archive containing binary files, libraries and 
# documentation for a ready-to-run version of TChecker for architecture
# Darwin/arm64
#
# Expects arguments:
# - <dir> a directory where the archive shall be written
# - <bison_dir> path to a recent version of the bison tool

if [ $# -ne 2 ];
then
    echo "Usage: $0 <dir> <bison_dir>"
    echo "  where <dir> is the directory where the archive will be written"
    echo "        <bison_dir> is the directory containing the bison tool"
    exit 1
fi

OUTPUT_DIR="$1"
BISON_PATH="$2"

CURRENT_DIR="`pwd`"

# Create temporary directory for building TChecker
BUILD_DIR=`mktemp -d -t tck-build-dir`

echo "--- Build directory: ${BUILD_DIR}"

# Copy build script to build directory
cp build.sh "${BUILD_DIR}"

# Clone TChecker
cd "${BUILD_DIR}"
git clone https://github.com/ticktac-project/tchecker.git

# Build TChecker
mkdir tchecker/build
./build.sh "${OUTPUT_DIR}" "-DCMAKE_PREFIX_PATH=${BISON_PATH}"

# Clean
rm -rf "${BUILD_DIR}"

cd ${CURRENT_DIR}
