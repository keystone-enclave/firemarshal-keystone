#!/bin/sh

set -e

if [ $(command -v cmake3) ]; then
	echo "Using cmake3"
	alias cmake=cmake3
fi

if [ ! -d keystone ]; then
	git clone https://github.com/keystone-enclave/keystone keystone
fi

# set qemu -bios argument to bootrom.bin we will build
PWD=$(pwd)
sed -e 's#\-bios .*bootrom.bin#\-bios '$PWD'/keystone/build/bootrom.build/bootrom.bin#g' -i keystone.json

cd keystone
git checkout dev-firemarshal
./fast-setup.sh
source ./source.sh
mkdir -p build
cd build
cmake .. -Dfiresim=y
make patch
make bootrom
make qemu
make examples

