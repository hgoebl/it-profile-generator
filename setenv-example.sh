#!/bin/bash
#
# Setting environmental variables for the IT CV/Profile Generator
#
# Copy this file to 'setenv.sh' and modify the copy for your needs
#

# The command to start the Apache FOP processor
export FOP=/opt/fop-1.0/fop

# Command to execute Node.js
export NODE=node

# Command to encode something to a QR-Code image
# (if you don't have it or don't want it, use e.g. test
# export QRENCODE=test
export QRENCODE="qrencode -s 3 -m 3"
