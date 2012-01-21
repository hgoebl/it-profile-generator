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

# Linux users:
export QRENCODE="qrencode -s 3 -m 3"

# Windows users (download from http://code.google.com/p/qrencode-win32/)
# export QRENCODE="C:\Programme\qrcode-win32-3.1.1\bin\qrcode.exe"

# Save the current working directory (hopefully w/o too many side-effects)

# Cygwin-Users:
# export _CWD=`cygpath -w $(pwd)`

# *nix users
export _CWD=$(pwd)
