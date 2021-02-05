FROM innovanon/void-base as builder
RUN sleep 127         \
 && xbps-install -Suy \
 && xbps-install wget

ARG CPPFLAGS
ARG   CFLAGS
ARG CXXFLAGS
ARG  LDFLAGS

ENV CHOST=x86_64-linux-musl

ENV CPPFLAGS="$CPPFLAGS"
ENV   CFLAGS="$CFLAGS"
ENV CXXFLAGS="$CXXFLAGS"
ENV  LDFLAGS="$LDFLAGS"

#ENV PREFIX=/usr/local
ENV PREFIX=/opt/cpuminer

ARG ARCH=native
ENV ARCH="$ARCH"

ENV CPPFLAGS="-DUSE_ASM $CPPFLAGS"
ENV   CFLAGS="-march=$ARCH -mtune=$ARCH $CFLAGS"

# Debug
#ENV CPPFLAGS="-DNDEBUG $CPPFLAGS"
ENV   CFLAGS="-Ofast -g0 $CFLAGS"

# Static
#ENV  LDFLAGS="$LDFLAGS -static -static-libgcc -static-libstdc++"

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
#ENV   CLANGFLAGS="-ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants $CFLAGS"
#ENV       CFLAGS="-fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all $CLANGFLAGS"
ENV CFLAGS="-fmerge-all-constants $CFLAGS"
#ENV CLANGXXFLAGS="$CLANGFLAGS $CXXFLAGS"
ENV CXXFLAGS="$CFLAGS $CXXFLAGS"

WORKDIR /tmp

#COPY    ./libevent.sh    ./
#RUN     ./libevent.sh  1
#COPY    ./tor.sh         ./
#RUN     ./tor.sh       1

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
SHELL      ["/bin/sh", "-c"]
ENTRYPOINT ["/tmp/profile.sh"]

