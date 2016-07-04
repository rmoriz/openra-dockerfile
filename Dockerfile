FROM ubuntu:16.04
MAINTAINER Roland Moriz <roland@moriz.de>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y --no-install-recommends wget ca-certificates rsync && \
  apt-get install -y --no-install-recommends libopenal1 mono-runtime mono-devel libmono-system-core4.0-cil \
                                             libmono-system-numerics4.0-cil libmono-system-runtime-serialization4.0-cil \
                                             libmono-system-xml-linq4.0-cil libmono-system-drawing4.0-cil libmono-system-windows-forms4.0-cil \
                                             libsdl2-2.0-0 \
                                             libfreetype6 libasound2 libgl1-mesa-glx libgl1-mesa-dri xdg-utils zenity liblua5.1  && \
  rm -rf /var/lib/apt/lists/* \
  rm -rf /var/cache/apt/archives/*

# http://www.openra.net/download/
ENV OPENRA_RELEASE=https://github.com/OpenRA/OpenRA/releases/download/release-20160508/openra_release.20160508_all.deb
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
