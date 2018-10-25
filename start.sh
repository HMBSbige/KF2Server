#!/bin/bash
COMMAND="/opt/steamcmd/steamcmd.sh +@ShutdownOnFailedCommand 1  \
+login anonymous +force_install_dir /srv/kf2server/ +app_update 232130 +quit \
&& mkdir -p /srv/kf2server/KFGame/Cache"
eval $COMMAND
/srv/kf2server/Binaries/Win64/KFGameSteamServer.bin.x86_64