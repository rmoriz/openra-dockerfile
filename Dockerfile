ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}mono

# see hooks/post_checkout
ARG ARCH

# HACK: don't fail when no qemu binary provided
COPY .gitignore qemu-${ARCH}-static* /usr/bin/

# https://www.openra.net/download/
ENV OPENRA_RELEASE_VERSION=20190314
ENV OPENRA_RELEASE=https://github.com/OpenRA/OpenRA/releases/download/release-${OPENRA_RELEASE_VERSION}/OpenRA-release-${OPENRA_RELEASE_VERSION}-source.tar.bz2

RUN set -xe; \
        \
        apt-get update; \
        apt-get -y upgrade; \
        apt-get install -y --no-install-recommends \
                    ca-certificates \
                    curl \
                    liblua5.1 \
                    make \
                    patch \
                    unzip \
                    xdg-utils \
                  ; \
        useradd -d /home/openra -m -s /sbin/nologin openra; \
        mkdir /home/openra/source; \
        cd /home/openra/source; \
        curl -L $OPENRA_RELEASE | tar xj; \
# HACK to fix hard coded paths in upstream in old releases.
# bleed status: https://github.com/OpenRA/OpenRA/blob/bleed/thirdparty/configure-native-deps.sh
        mkdir -p /opt/lib; \
        liblua=$(find /usr/lib -name liblua5.1.so); \
        ln -s $liblua /opt/lib; \
        ls -la /opt/lib/*.so; \
# /HACK
# PATCH 'SERVER FULL' BUG
        if [ "$OPENRA_RELEASE_VERSION" = "20181215" ]; then \
           curl -L https://github.com/OpenRA/OpenRA/commit/c6d5bc9511cf983b8b7a769ab3064ed45fc4fb02.diff | patch -p1; \
        fi; \
# /PATCH
        make dependencies; \
        make all; \
        make prefix= DESTDIR=/home/openra install; \
        cd .. && rm -rf /home/openra/source; \
        chmod 755 /home/openra/lib/openra/launch-dedicated.sh; \
        mkdir /home/openra/.openra \
              /home/openra/.openra/Logs \
              /home/openra/.openra/maps \
            ;\
        chown -R openra:openra /home/openra/.openra; \
        apt-get purge -y curl make patch unzip; \
        rm -rf /var/lib/apt/lists/* \
               /var/cache/apt/archives/*

EXPOSE 1234

USER openra

WORKDIR /home/openra/lib/openra
VOLUME ["/home/openra/.openra"]

# see https://github.com/OpenRA/OpenRA/blob/release-20181215/launch-dedicated.sh
CMD [ "/home/openra/lib/openra/launch-dedicated.sh" ]

# annotation labels according to
# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.title="OpenRA dedicated server"
LABEL org.opencontainers.image.description="Image to run a server instance for OpenRA"
LABEL org.opencontainers.image.url="https://github.com/rmoriz/openra-dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/rmoriz/openra-dockerfile#readme"
LABEL org.opencontainers.image.version=${OPENRA_RELEASE_VERSION}
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.authors="Roland Moriz"
