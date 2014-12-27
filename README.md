# Dockerfile for OpenRA dedicated server

## Example
```sh
$ sudo docker pull rmoriz/openra

$ sudo docker run -e 'NAME=Docker_Server_1' \
           -e 'MOTD=Muß man wissen!' \
           -e 'ADVERTISE_ONLINE=True' \
           -p 1234:1234 \
           -d rmoriz/openra

$ sudo docker run -e 'NAME=Docker_Server_2' \
           -e 'MOTD=Muß man wissen!' \
           -e 'EXTERNAL_PORT=55555' \
           -e 'ADVERTISE_ONLINE=True' \
           -p 55555:1234 \
           -d rmoriz/openra 
```

Various options can be set by using environment variables, see:

https://github.com/rmoriz/openra-dockerfile/blob/master/bin/start.sh

## FYI

Seems like an example server with RA-mod needs at least 500MB of memory, maybe even more.

## Copyright & License

Copyright © 2014 [Roland Moriz](https://roland.io), see LICENSE.txt
