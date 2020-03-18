[Docker image: drpsychick/linuxgsm-ubuntu](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu)
=======================
[![Travis build status](https://travis-ci.org/DrPsychick/docker-linuxgsm-ubuntu.svg?branch=master)](https://travis-ci.org/DrPsychick/docker-linuxgsm-ubuntu)
[![DockerHub build status](https://img.shields.io/docker/cloud/build/drpsychick/linuxgsm-ubuntu.svg)](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu/builds)
[![DockerHub build](https://img.shields.io/docker/cloud/automated/drpsychick/linuxgsm-ubuntu.svg)](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu/tags)

* Source: https://github.com/DrPsychick/docker-linuxgsm-ubuntu
* Image: https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu
* Inspired by: https://github.com/GameServerManagers/LinuxGSM-Docker


#### Attention: by using this image, you accept the `steamcmd` license!
The license can be found within the image: `/usr/share/doc/steamcmd/copyright`

The license is auto-agreed in the `Dockerfile` with `echo steamcmd steam/question select "I AGREE" | debconf-set-selections` 

### Usage
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

Known Issues
------------
* Requires a user (`UID 750`) and group (`UID 750`) on the host. All server files must be owned by this user.
