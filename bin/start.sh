#!/bin/bash

# see https://github.com/OpenRA/OpenRA/wiki/Dedicated
#
Name="${NAME:-"Dedicated-Server"}"
Mod=${MOD:-"ra"}
LockBots=${LOCK_BOTS:-"False"}
Ban=${BAN:-""}
Dedicated="True"
DedicatedLoop="True" # A new instance is spawned once previous game is finished
ListenPort=1234
ExternalPort="${EXTERNAL_PORT:-"1234"}"
AdvertiseOnline=${ADVERTISE_ONLINE:-"False"}
Map="${MAP}"
Password="${PASSWORD}"
MaxGameDurationMilliseconds="${MAX_GAME_DURATION_MILLISECONDS:-"7200000"}" # 2h x 60min x 60s x 1000

MOTD="${MOTD:-"welcome to a Docker based OpenRA server"}"
echo $MOTD > /home/openra/.openra/motd.txt

# if no maps volume is mounted, sync the latest maps from the community rsync service
[ "$(ls -A /home/openra/.openra/maps/)" ] && echo "will use existing maps" || rsync --delete -avp rsync://resource.openra.net/maps/ /home/openra/.openra/maps/

echo "=================================================================="
echo "MOD:              $Mod"
echo "BAN:              $Ban"
echo "MAP:              $Map"
echo "NAME:             $Name"
echo "PASSWORD:         $Password"
echo "LOCK_BOTS:        $LockBots"
echo "EXTERNAL_PORT:    $ExternalPort"
echo "ADVERTISE_ONLINE: $AdvertiseOnline"
echo "MAX_GAME_DURATION_MILLISECONDS: $MaxGameDurationMilliseconds"
echo "=================================================================="

mono --debug /usr/lib/openra/OpenRA.Game.exe Game.Mod=$Mod Server.Dedicated=$Dedicated Server.DedicatedLoop=$DedicatedLoop \
Server.Name="$Name" Server.ListenPort=$ListenPort Server.ExternalPort=$ExternalPort \
Server.LockBots=$LockBots \
Server.Ban="$Ban" \
Server.TimeOut="$MaxGameDurationMilliseconds" \
Server.AdvertiseOnline=$AdvertiseOnline \
Server.Map=$Map \
Server.Password=$Password