FROM innovanon/void-base as builder

ARG CPPFLAGS
ARG   CFLAGS
ARG CXXFLAGS
ARG  LDFLAGS

ENV CHOST=x86_64-linux-musl
ENV CC=$CHOST-gcc
ENV CXX=$CHOST-g++
#ENV FC=$CHOST-gfortran
ENV NM=$CC-nm
ENV AR=$CC-ar
ENV RANLIB=$CC-ranlib
#ENV LD=$CC-ld
#ENV AS=$CC-as
#ENV STRIP=$CHOST-strip

ENV CPPFLAGS="$CPPFLAGS"
ENV   CFLAGS="$CFLAGS"
ENV CXXFLAGS="$CXXFLAGS"
ENV  LDFLAGS="$LDFLAGS"

#ENV PREFIX=/usr/local
ENV PREFIX=/opt/cpuminer
ENV CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
ENV CPATH="$PREFIX/incude:$CPATH"
ENV    C_INCLUDE_PATH="$PREFIX/include:$C_INCLUDE_PATH"
ENV OBJC_INCLUDE_PATH="$PREFIX/include:$OBJC_INCLUDE_PATH"

ENV LDFLAGS="-L$PREFIX/lib $LDFLAGS"
ENV    LIBRARY_PATH="$PREFIX/lib:$LIBRARY_PATH"
ENV LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
ENV     LD_RUN_PATH="$PREFIX/lib:$LD_RUN_PATH"

ENV PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig:$PKG_CONFIG_LIBDIR"
ENV PKG_CONFIG_PATH="$PREFIX/share/pkgconfig:$PKG_CONFIG_LIBDIR:$PKG_CONFIG_PATH"

ARG ARCH=native
ENV ARCH="$ARCH"

ENV CPPFLAGS="-DUSE_ASM $CPPFLAGS"
ENV   CFLAGS="-march=$ARCH -mtune=$ARCH $CFLAGS"

# FDO
ENV   CFLAGS="-fipa-profile -fprofile-reorder-functions -fvpt  $CFLAGS"
ENV  LDFLAGS="-fipa-profile -fprofile-reorder-functions -fvpt $LDFLAGS"

# Debug
#ENV CPPFLAGS="-DNDEBUG $CPPFLAGS"
ENV   CFLAGS="-Ofast -g0 $CFLAGS"

# Static
ENV  LDFLAGS="$LDFLAGS -static -static-libgcc -static-libstdc++"

# LTO
ENV   CFLAGS="-fuse-linker-plugin -flto $CFLAGS"
ENV  LDFLAGS="-fuse-linker-plugin -flto $LDFLAGS"
##ENV   CFLAGS="-fuse-linker-plugin -flto -ffat-lto-objects $CFLAGS"
##ENV  LDFLAGS="-fuse-linker-plugin -flto -ffat-lto-objects $LDFLAGS"

# Dead Code Strip
ENV   CFLAGS="-ffunction-sections -fdata-sections $CFLAGS"
ENV  LDFLAGS="-Wl,-s -Wl,-Bsymbolic -Wl,--gc-sections $LDFLAGS"
##ENV  LDFLAGS="-Wl,-Bsymbolic -Wl,--gc-sections $LDFLAGS"

# Optimize
ENV   CLANGFLAGS="-ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants $CFLAGS"
ENV       CFLAGS="-fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all $CLANGFLAGS"

ENV CLANGXXFLAGS="$CLANGFLAGS $CXXFLAGS"
ENV CXXFLAGS="$CFLAGS $CXXFLAGS"

WORKDIR /tmp

# ----- sanity check -----
RUN command -v "$CC"
RUN command -v "$CXX"
#RUN command -v "$FC"
RUN command -v "$NM"
RUN command -v "$AR"
RUN command -v "$RANLIB"
#RUN command -v "$LD"
#RUN command -v "$AS"
#RUN command -v "$STRIP"
RUN test -n "$PREFIX"

COPY    ./fingerprint.sh ./
RUN     ./fingerprint.sh

COPY    ./zlib.sh        ./
RUN     ./zlib.sh      1

COPY    ./openssl.sh     ./
RUN     ./openssl.sh   1

COPY    ./curl.sh        ./
RUN     ./curl.sh      1

COPY    ./libevent.sh    ./
RUN     ./libevent.sh  1

COPY    ./tor.sh         ./
RUN     ./tor.sh       1

COPY    ./libuv.sh       ./
RUN     ./libuv.sh     1

COPY    ./hwloc.sh       ./
RUN     ./hwloc.sh     1

COPY    ./xmrig.sh               \
        ./donate.h.sed           \
        ./DonateStrategy.cpp.sed \
        ./Config_default.h       \
                                 ./
RUN     ./xmrig.sh     1

#FROM scratch as squash
#COPY --from=builder / /
#RUN chown -R tor:tor /var/lib/tor
#SHELL ["/usr/bin/bash", "-l", "-c"]
#ARG TEST
#
#FROM squash as test
#ARG TEST
#RUN tor --verify-config \
# && sleep 127           \
# && xbps-install -S     \
# && exec true || exec false
#
#FROM squash as final
#VOLUME /var/cpuminer
#ENTRYPOINT []

COPY    ./profile.sh ./
VOLUME /var/cpuminer
ENTRYPOINT ["/tmp/profile.sh"]

