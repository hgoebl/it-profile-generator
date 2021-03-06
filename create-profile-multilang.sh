#!/bin/bash
#
# Creates a new multi-language profile for the IT CV/Profile Generator
#

. ./setenv.sh

# Check for proper number of command line args.
EXPECTED_ARGS=1

if [ $# -ne ${EXPECTED_ARGS} ]
then
    echo "Usage: `basename $0` {new-profile-name}"
    exit 1
fi

PROFILE=$1
NEW_DIR=${_CWD}/profiles/${PROFILE}

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

cp ../sample-multilang/sample-multilang.multilang.xml ./${PROFILE}.multilang.xml
cp ../sample-multilang/.htaccess  .
cp ../sample-multilang/supported-languages.txt .
cp ../sample-multilang/mobile-content.multilang.xml .
cp ../sample-multilang/.gitignore .

cd ${_CWD}

unset _CWD
