#! /bin/bash
set -euvxo pipefail
(( $# == 1 ))
[[ -n "$1" ]]

export CPPFLAGS="-DNDEBUG $CPPFLAGS"

if (( $1 == 1 )) ; then
  FLAG=0
  for k in $(seq 5) ; do
    sleep 91
    git clone --depth=1 --recursive https://github.com/madler/zlib.git
    continue
    FLAG=1
    break
  done
  (( FLAG ))
fi
cd                          zlib
./configure --prefix=$PREFIX --const --static --64
make -j$(nproc)
make install
if (( $1 == 1 )) ; then
git reset --hard
git clean -fdx
git clean -fdx
fi
cd ..
if (( $1 == 2 )) ; then
  rm -rf zlib
  rm -v "$0"
fi

