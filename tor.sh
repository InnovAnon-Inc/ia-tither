#! /bin/bash
set -euvxo pipefail
(( $# == 1 ))
[[ -n "$1" ]]

export CPPFLAGS="-DCURL_STATICLIB $CPPFLAGS"

if (( $1 == 1 )) ; then
  FLAG=0
  for k in $(seq 5) ; do
    sleep 91
    git clone --depth=1 --recursive https://github.com/torproject/tor.git
    continue
    FLAG=1
    break
  done
  (( FLAG ))
fi
cd tor
./autogen.sh
./configure \
  --target=$CHOST \
  --host=$CHOST \
  --prefix=$PREFIX \
  --enable-static-openssl \
  --with-openssl-dir=$PREFIX \
  --enable-static-libevent \
  --with-libevent-dir=$PREFIX \
  --enable-static-zlib \
  --with-zlib-dir=$PREFIX \
  --enable-static-tor \
  --disable-system-torrc \
  --disable-manpage \
  --disable-html-manual \
  --disable-asciidoc \
  --disable-seccomp \
  --disable-libscrypt \
  --disable-module-relay \
  --disable-module-dirauth \
  --disable-largefile \
  --disable-unittests \
  --disable-gcc-hardening \
  --disable-linker-hardening \
  CPPFLAGS="$CPPFLAGS" \
  CXXFLAGS="$CXXFLAGS" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="$LDFLAGS" \
        CPATH="$CPATH"                                \
        C_INCLUDE_PATH="$C_INCLUDE_PATH"              \
        OBJC_INCLUDE_PATH="$OBJC_INCLUDE_PATH"        \
        LIBRARY_PATH="$LIBRARY_PATH"                  \
        LD_LIBRARY_PATH="$LD_LIBRARY_PATH"            \
        LD_RUN_PATH="$LD_RUN_PATH"                    \
        PKG_CONFIG_LIBDIR="$PKG_CONFIG_LIBDIR"        \
        PKG_CONFIG_PATH="$PKG_CONFIG_PATH"            \
        CC="$CC"                                      \
        CXX="$CXX"                                    \
        NM="$NM"                                      \
        AR="$AR"                                      \
        RANLIB="$RANLIB"
#make -j$(nproc)
make -j1
make install
if (( $1 == 1 )) ; then
  git reset --hard
  git clean -fdx
  git clean -fdx
fi
cd ..
if (( $1 == 2 )) ; then
  rm -rf tor
  rm -v "$0"
fi

