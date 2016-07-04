# Dockerfile for OpenRA dedicated server

## Example
```sh

$ docker run -d -p 1234:1234 \
             -e Name="DOCKER SERVER" \
             -e Mod=ra \
             -e ListenPort="1234" \
             -e ExternalPort="1234" \
             --name openra \
             rmoriz/openra

```

see https://github.com/OpenRA/OpenRA/blob/bleed/launch-dedicated.sh for all options.

## FYI

Seems like an example server with RA-mod needs at least 500MB of memory, maybe even more.

## Copyright & License

Copyright © 2016 [Roland Moriz](https://roland.io), see LICENSE.txt
