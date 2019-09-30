[Docker image: drpsychick/linuxgsm-ubuntu](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu)
=======================
[![DockerHub build status](https://img.shields.io/docker/build/drpsychick/linuxgsm-ubuntu.svg)](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu/tags)
[![DockerHub build](https://img.shields.io/docker/automated/drpsychick/linuxgsm-ubuntu.svg)](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu/timeline)

* Source: https://github.com/DrPsychick/docker-linuxgsm-ubuntu
* Image: https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu
* Inspired by: https://github.com/GameServerManagers/LinuxGSM-Docker

Usage
-----
Either run game server directly or build your own image based on this one

Run gameserver (mount directory to persist server files!)
```
cd myarkserver
mkdir serverfiles
docker run --rm -t \
  --mount type=bind,source=$PWD/serverfiles,target=/home/lgsm/serverfiles \
  --env SERVERNAME=arkserver \
  drpsychick/linuxgsm-ubuntu start
```
