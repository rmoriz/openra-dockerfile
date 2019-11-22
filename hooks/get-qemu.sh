#!/bin/bash

PACKAGE=http://ftp.de.debian.org/debian/pool/main/q/qemu/qemu-user-static_4.1-1+b4_amd64.deb

mkdir tmp/
cd tmp/
curl $PACKAGE -o $(basename ${PACKAGE})
dpkg-deb -X $(basename ${PACKAGE}) .
cp usr/bin/qemu-aarch64-static ..
cp usr/bin/qemu-arm-static ..
cd ..
rm -rf tmp
