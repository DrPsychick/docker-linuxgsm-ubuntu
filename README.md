# [Docker image: drpsychick/linuxgsm-ubuntu](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu)

[![Docker image](https://img.shields.io/docker/image-size/drpsychick/linuxgsm-ubuntu?sort=date)](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu/tags)
[![Travis build status](https://app.travis-ci.com/DrPsychick/docker-linuxgsm-ubuntu.svg?branch=master)](https://app.travis-ci.com/github/DrPsychick/docker-linuxgsm-ubuntu)
[![DockerHub pulls](https://img.shields.io/docker/pulls/drpsychick/linuxgsm-ubuntu.svg)](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu/)
[![DockerHub stars](https://img.shields.io/docker/stars/drpsychick/linuxgsm-ubuntu.svg)](https://hub.docker.com/r/drpsychick/linuxgsm-ubuntu/)
[![license](https://img.shields.io/github/license/drpsychick/docker-linuxgsm-ubuntu.svg)](https://github.com/drpsychick/docker-linuxgsm-ubuntu/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/drpsychick/docker-linuxgsm-ubuntu.svg)](https://github.com/drpsychick/docker-linuxgsm-ubuntu)
[![Paypal](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FTXDN7LCDWUEA&source=url)
[![GitHub Sponsor](https://img.shields.io/badge/github-sponsor-blue?logo=github)](https://github.com/sponsors/DrPsychick)

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
