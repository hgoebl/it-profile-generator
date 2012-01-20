#!/bin/bash
#
# Creates a new single-language profile for the IT CV/Profile Generator
#

# Check for proper number of command line args.
EXPECTED_ARGS=1

if [ $# -ne ${EXPECTED_ARGS} ]
then
    echo "Usage: `basename $0` {new-profile-name}"
    exit 1
fi

PROFILE=$1
CWD=$(pwd)
NEW_DIR=${CWD}/profiles/${PROFILE}

if [ -d ${NEW_DIR} ]; then
    echo "Directory alread exists: ${NEW_DIR}"
    exit 2
fi

mkdir ${NEW_DIR}

if [ ! -d ${NEW_DIR} ]; then
    echo "Unable to create new directory ${NEW_DIR}"
    exit 3
fi

cd ${NEW_DIR}

cp ../sample-singlelang/sample-singlelang.xml ./${PROFILE}.xml
cp ../sample-singlelang/.htaccess  .
cp ../sample-singlelang/mobile-content.xml .
cp ../sample-multilang/.gitignore .

cd ${CWD}
