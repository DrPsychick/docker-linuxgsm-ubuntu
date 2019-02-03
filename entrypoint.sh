#!/bin/bash

## Because of a limitation in LinuxGSM script it must be run from the directory
## It is installed in.
##
## If one wants to use a volume for the data directory, which is the home directory
## then we must keep a backup copy of the script on local drive
if [ ! -e ~/linuxgsm.sh ]; then
  echo "Initializing Linuxgsm User Script in New Volume"
  cp /linuxgsm.sh ./linuxgsm.sh
fi

if [ -z "$SERVERNAME" ]; then
  # execute command given
  "$@"
else
  # run the server (update if needed)
  if [ ! -x "~/$SERVERNAME" ]; then
    linuxgsm.sh $SERVERNAME
  fi
  if [ -n "$UPDATE_LGSM" -o ! -d "~/lgsm/functions" ]; then
    $SERVERNAME update-lgsm
  fi
  if [ ! -d "~/serverfiles/steamapps" ]; then
    $SERVERNAME auto-install
    CONTAINER_INIT="yes"
  fi
  # hook for initial start
  if [ -n "$CONTAINER_INIT" ]; then
    container_init.sh
  fi
  if [ -n "$UPDATE_SERVER" ]; then
    $SERVERNAME update
  fi
  if [ -n "$FORCE_VALIDATE" ]; then
    $SERVERNAME validate
  fi
  # hook for mods
  if [ -n "$UPDATE_MODS" ]; then
    update_mods.sh
  fi
  # hook for every start
  if [ -n "$CONTAINER_WARMUP" ]; then
    container_warmup.sh
  fi

  # run the command
  $SERVERNAME $@

  # attempt to attach to tmux gameserver session to keep the server running
  # requires -t (tty)
  tmux set -g status off && tmux attach 2> /dev/null
fi
