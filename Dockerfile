FROM ubuntu:16.04
MAINTAINER Roland Moriz <roland@moriz.de>

ENV TZ="/usr/share/zoneinfo/UTC"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get -y upgrade\
  && apt-get install -y dirmngr\
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF\
  && echo "deb http://download.mono-project.com/repo/ubuntu stable-xenial main"  > /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && apt-get -y upgrade\
  && apt-get install -y --no-install-recommends \
          wget ca-certificates rsync \
          ca-certificates-mono mono-complete \
          locales tzdata \
	  libopenal1 libasound2 xdg-utils zenity libsdl2-2.0-0 liblua5.1\
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/archives/*

# http://www.openra.net/download/
ENV OPENRA_RELEASE_VERSION=20180218
ENV OPENRA_RELEASE=https://github.com/OpenRA/OpenRA/releases/download/release-${OPENRA_RELEASE_VERSION}/openra_release.${OPENRA_RELEASE_VERSION}_all.deb
RUN \
  cd /tmp && \
  wget $OPENRA_RELEASE -O /tmp/openra.deb && \
  dpkg -i openra.deb && \
  rm /tmp/openra.deb

RUN useradd -d /home/openra -m -s /sbin/nologin openra
RUN chown -R openra:openra /usr/lib/openra

RUN mkdir /home/openra/.openra && \
    mkdir /home/openra/.openra/Logs && \
    mkdir /home/openra/.openra/maps

RUN chown -R openra:openra /home/openra/

EXPOSE 1234

VOLUME ["/home/openra", "/usr/lib/openra", "/home/openra/.openra/Logs", "/home/openra/.openra/maps"]
USER openra

WORKDIR /usr/lib/openra
CMD [ "/usr/lib/openra/launch-dedicated.sh" ]
