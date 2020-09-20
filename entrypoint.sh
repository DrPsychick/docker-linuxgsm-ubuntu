#!/bin/bash

# handle graceful shutdown (saveworld)
if [ -x /home/lgsm/container_stop.sh ]; then
  trap /home/lgsm/container_stop.sh INT TERM KILL
fi

if [ -z "$SERVERNAME" ]; then
  # execute command given
  "$@"
else
  # run the server (update if needed)
  if [ ! -x "$HOME/$SERVERNAME" ]; then
    linuxgsm.sh $SERVERNAME
  fi
  if [ -n "$UPDATE_LGSM" -o ! -d "$HOME/lgsm/functions" ]; then
    $SERVERNAME update-lgsm
  fi
  if [ ! -d "$HOME/serverfiles/steamapps" ]; then
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

  # keep this process running
  if [ "$1" = "start" ]; then
    # tail server log in a sub process
    tail -fF log/server/ShooterGame.log &

    # wait for tmux to quit - do this in this shell for trap to take effect
    tmux_pid=$(tmux display-message -pF '#{pid}')
    while (true); do
      ps $tmux_pid >/dev/null
      if [ $? -ne 0 ]; then
        break
      fi
      sleep 2
    done
  fi
fi
