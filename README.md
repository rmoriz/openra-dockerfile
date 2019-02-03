# Dockerfile for an OpenRA dedicated server

### News 02/2019

  - image is now based on the official mono base image which is based on Debian Stretch
  - image is available for amd64, arm32v5 and aarch64

### Build FAQ

  - Images are built on Docker Hub for various architectures (see `hooks/.config`)
  - Build is triggered by git a push to https://github.com/rmoriz/openra-dockerfile
  - Manual build (without multiarch): `./hooks/build` (works on Mac)
  - Manual build (with multiarch on Debian/Ubuntu Linux):
    ```shell
    apt-get install qemu-user-static
    cp /usr/bin/qemu-{aarch64,arm,x86_64}-static .
    ./hooks/build
    ```

## Usage Example
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

## Kubernetes Example

```
kubectl apply -f k8s.yml
```
If you have a l7 load balancing nginx with tcp services enabled you can add this to the configmap, the format is: port for key, value is namespace/servicename:port
`1234 -> openra/openra-service:1234`

You can also add a nodeport to the service descriptor:
```
  type: NodePort
  ports:
   - port: <1234>
     # nodePort: <31514>
```
If the nodePort is not specified, k8s will assign you one but it will be random.

## Multi-arch Image

The latest release is available for amd64/x86_64 and arm32v5. Usually docker
should automatically download the right image.

`docker pull rmoriz/openra:<TAG>` should just work (tm)


Naming schema:

```
rmoriz/openra:<TAG> = Manifest with all versions
rmoriz/openra:<TAG>-amd64 = Image for x86
rmoriz/openra:<TAG>-arm = Image for arm32v5 (Raspberry Pi 1, Zero or better)
rmoriz/openra:<TAG>-aarch64 = Image for aarch64/ARMv8 (Raspberry Pi 3b, 3b+ with 64bit distro, does not work on stock Raspbian yet)
```

## FYI

Seems like an example server with RA-mod needs at least 500MB of memory, maybe even more.


## Copyright & License

Copyright © 2019 [Roland Moriz](https://roland.io), see LICENSE.txt
