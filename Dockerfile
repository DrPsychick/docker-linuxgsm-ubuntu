ARG UBUNTU_VERSION=latest
FROM ubuntu:$UBUNTU_VERSION

RUN dpkg --add-architecture i386 \
  && apt-get update \
  # preselect accept steamcmd license \
  && echo steamcmd steam/question select "I AGREE" | debconf-set-selections \
  && echo steamcmd steam/license: note '' | debconf-set-selections \
  && apt-get install -y \
    bc \
    binutils \
    bsdmainutils \
    bzip2 \
    ca-certificates \
    curl \
    file \
    gzip \
    jq \
    lib32gcc1 \
    libstdc++6:i386 \
    lib32stdc++6 \
    python3 \
    tmux \
    unzip \
    util-linux \
    wget \
    iproute2 \
    ethtool \
    netcat \
    steamcmd \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/*

COPY entrypoint.sh \
     update_mods.sh \
     container_init.sh \
     container_warmup.sh \
     /
RUN chmod +x /entrypoint.sh /update_mods.sh /container_*.sh

# setup lgsm user
# keep compatibility with https://github.com/GameServerManagers/LinuxGSM-Docker
RUN groupadd -g 750 lgsm \
  && useradd -g 750 -u 750 -m -s /bin/bash -G tty lgsm \
  && wget https://linuxgsm.com/dl/linuxgsm.sh \
  && chmod +x /linuxgsm.sh \
  && cp /linuxgsm.sh /update_mods.sh /home/lgsm/ \
  && chown lgsm:lgsm /home/lgsm/*.sh

USER lgsm
WORKDIR /home/lgsm
ENV PATH=$PATH:/home/lgsm

# make sure lgsm is part of the image
RUN linuxgsm.sh arkserver \
  && arkserver update-lgsm \
  && rm -rf arkserver lgsm/config-* \
  && mkdir -p serverfiles

VOLUME ["/home/lgsm/serverfiles"]

ENV SERVERNAME=""
ENV UPDATE_LGSM="" UPDATE_SERVER="" FORCE_VALIDATE="" UPDATE_MODS=""
ENV CONTAINER_INIT="" CONTAINER_WARMUP=""
ENTRYPOINT ["/entrypoint.sh"]
CMD ["linuxgsm.sh"]
