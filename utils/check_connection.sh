#!/usr/bin/env sh

source $(dirname `readlink -f "$0"`)/../utils/config.sh

ping -q -c 1 $REMOTE_HOST > /dev/null
if [ $? -ne 0 ]; then
  ERR_NO_CONNECTION="Cannot connect to $REMOTE_HOST. Please check your internet connection and ensure that the remote host is reachable."
  ERR_NO_CONNECTION_SHORT="Cannot connect to $REMOTE_HOST_SHORT"
  echo $ERR_NO_CONNECTION
  notify-send -c "network.disconnected" -i network-offline "$ERR_NO_CONNECTION_SHORT" "$ERR_NO_CONNECTION"
  exit 1
fi
