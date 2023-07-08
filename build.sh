#!/bin/sh

# This file is part of the TChecker-build-releases project
# 
# See AUTHORS and LICENSE for copyright details
#
# Build a release of TChecker
#
# Expects arguments:
# - <dir> is the directory where the built archive shall be written
#
# Expects an environment with:
# - all required dependecies
# - the directory ./tchecker/ containing a clone of the TChecker repository

if [ $# -ne 2 ];
then
    echo "Usage: $0 <dir> <cmake_flags>"
    echo "  where <dir> is the directory where the built archive is copied"
    echo " .      <cmake_flags> extra flags passed to CMake"
    exit
fi

ARCHIVE_DIR="$1"
EXTRA_CMAKE_FLAGS="$2"

# Update TChecker
cd tchecker
git pull
if [ ! -d build ];
then
    mkdir build
fi
cd ..

# Retrieve version number
cd tchecker/build
VERSION_MAJOR=`cmake -LA .. | grep VERSION_MAJOR | cut -f 2 -d '='`
VERSION_MINOR=`cmake -LA .. | grep VERSION_MINOR | cut -f 2 -d '='`
VERSION="${VERSION_MAJOR}.${VERSION_MINOR}"
cd ../..

# Set installation directory
TMP_DIR=`mktemp -d -t tck-XXXXXXXXXX`
TCHECKER_INSTALL_DIR="tchecker-${VERSION}"
INSTALL_DIR="${TMP_DIR}/${TCHECKER_INSTALL_DIR}"
mkdir ${INSTALL_DIR}

# Build and install TChecker
cd tchecker/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DLIBTCHECKER_ENABLE_SHARED=ON ${EXTRA_CMAKE_FLAGS}
make -j5
make doc
make install
cd ../..

# Build the archive
PLATFORM="`uname -s`_`uname -m`"
ARCHIVE="tchecker-${PLATFORM}-${VERSION}.tar.gz"
cd ${TMP_DIR}
tar zcvf "${ARCHIVE_DIR}/${ARCHIVE}" "${TCHECKER_INSTALL_DIR}"

# Clean
rm -rf ${TMP_DIR}
