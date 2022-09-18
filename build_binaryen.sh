#!/usr/bin/env bash

set -ex

DIR=$PWD/binaryen
JOBS=8

export CC="$(which zig) cc"
export CXX="$(which zig) c++"

pushd $DIR
  cmake . -DBUILD_STATIC_LIB=on -DBUILD_TESTS=off -DBUILD_TOOLS=off
  make -j $JOBS
popd
