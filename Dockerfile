FROM ubuntu:14.04
MAINTAINER Roland Moriz <roland@moriz.de>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y --no-install-recommends wget ca-certificates rsync && \
  apt-get install -y --no-install-recommends libopenal1 mono-runtime libmono-corlib2.0-cil libmono-system-core4.0-cil \
                                             libmono-system-drawing4.0-cil libmono-system-windows-forms4.0-cil \
                                             libfreetype6 libasound2 libgl1-mesa-glx libgl1-mesa-dri xdg-utils zenity && \
  rm -rf /var/lib/apt/lists/* \
  rm -rf /var/cache/apt/archives/*

# http://www.openra.net/download/
# https://github.com/OpenRA/OpenRA/releases/download/release-20141029/openra_release.20141029_all.deb
RUN \
  cd /tmp && \
  wget https://github.com/OpenRA/OpenRA/releases/download/release-20141029/openra_release.20141029_all.deb && \
  dpkg -i openra_release.20141029_all.deb && \
  rm /tmp/openra_release.20141029_all.deb

RUN useradd -d /home/openra -m -s /sbin/nologin openra
RUN chown -R openra:openra /usr/lib/openra

ADD bin/start.sh /home/openra/start.sh
RUN mkdir /home/openra/.openra && \
    mkdir /home/openra/.openra/Logs && \
    mkdir /home/openra/.openra/maps

RUN chown -R openra:openra /home/openra && chmod 755 /home/openra/start.sh

EXPOSE 1234:1234
VOLUME ["/home/openra", "/usr/lib/openra", "/home/openra/.openra/Logs", "/home/openra/.openra/maps"]

USER openra
CMD [ "/home/openra/start.sh" ]
