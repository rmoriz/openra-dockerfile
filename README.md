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

## FYI

Seems like an example server with RA-mod needs at least 500MB of memory, maybe even more.

## Copyright & License

Copyright © 2016 [Roland Moriz](https://roland.io), see LICENSE.txt
