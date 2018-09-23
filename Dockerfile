FROM ubuntu:18.04
MAINTAINER Roland Moriz <roland@moriz.de>

ENV TZ="/usr/share/zoneinfo/UTC"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get -y upgrade\
  && apt-get install -y dirmngr\
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF\
  && echo "deb http://download.mono-project.com/repo/ubuntu stable-bionic main"  > /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && apt-get -y upgrade\
  && apt-get install -y --no-install-recommends \
          wget ca-certificates rsync \
          ca-certificates-mono mono-complete \
          locales tzdata \
          libgl1-mesa-glx \
	  libopenal1 libasound2 xdg-utils zenity libsdl2-2.0-0 liblua5.1 fuse\
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/archives/*

RUN useradd -d /home/openra -m -s /sbin/nologin openra
USER openra
WORKDIR /home/openra

# http://www.openra.net/download/
ENV OPENRA_RELEASE_VERSION=20180923
ENV OPENRA_RELEASE=https://github.com/OpenRA/OpenRA/releases/download/release-${OPENRA_RELEASE_VERSION}/OpenRA-Red-Alert-x86_64.AppImage
RUN \
  mkdir /home/openra/tmp && \
  cd /home/openra/tmp && \
  wget $OPENRA_RELEASE -O /home/openra/tmp/crapimage && \
  chmod 755 /home/openra/tmp/crapimage && \
  /home/openra/tmp/crapimage --appimage-extract && \
  mv /home/openra/tmp/squashfs-root/* /home/openra/ && \
  rm -rf /home/openra/tmp/

COPY --chown=openra:openra launch-dedicated.sh /home/openra/usr/lib/openra

RUN mkdir /home/openra/.openra && \
    mkdir /home/openra/.openra/Logs && \
    mkdir /home/openra/.openra/maps && \
    chmod 755 /home/openra/usr/lib/openra/launch-dedicated.sh

EXPOSE 1234

WORKDIR /home/openra/usr/lib/openra

VOLUME ["/home/openra", "/usr/lib/openra", "/home/openra/.openra/Logs", "/home/openra/.openra/maps"]
CMD [ "/home/openra/usr/lib/openra/launch-dedicated.sh" ]
