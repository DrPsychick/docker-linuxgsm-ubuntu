ARG UBUNTU_VERSION=latest
FROM ubuntu:$UBUNTU_VERSION

# for `monitor` command to work: 
# apt-get install -y npm + npm install gamedig -g (but it enlarges the image!)
RUN dpkg --add-architecture i386 \
  && export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  # preselect locale
  && echo "tzdata tzdata/Areas select Europe" | debconf-set-selections \
  && echo "tzdata tzdata/Zones/Etc select UTC" | debconf-set-selections \
  # preselect accept steamcmd license \
  && echo steamcmd steam/question select "I AGREE" | debconf-set-selections \
  && echo steamcmd steam/license: note '' | debconf-set-selections \
  && apt-get update \
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
    libcurl4:i386 \
    python3 \
    tmux \
    unzip \
    util-linux \
    wget \
    iproute2 \
    ethtool \
    netcat \
    net-tools \
    locales \
    steamcmd \
    git \
    python3-setuptools \
  #  expect \ # just makes steamcmd slower (consumes CPU)
  && locale-gen en_US.UTF-8 \
  # add MCRcon library for healthcheck
  && git clone https://github.com/barneygale/MCRcon \
  && (cd MCRcon; python3 setup.py install_lib) \
  && rm -rf MCRcon \
  && apt-get remove -y --purge git python3-setuptools \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/*

COPY entrypoint.sh \
     update_mods.sh \
     container_init.sh \
     container_warmup.sh \
     rcon.py \
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
  # to be removed when PR released: https://github.com/GameServerManagers/LinuxGSM/pull/3011
  && sed -i -e 's/+quit | tee -a/+quit | uniq | tee -a/' lgsm/functions/core_dl.sh \
  && rm -rf arkserver lgsm/config-* \
  && mkdir -p serverfiles

VOLUME ["/home/lgsm/serverfiles"]

ENV SERVERNAME="" \
    UPDATE_LGSM="" \
    UPDATE_SERVER="" \
    FORCE_VALIDATE="" \
    UPDATE_MODS="" \
    CONTAINER_INIT="" \
    CONTAINER_WARMUP="" \
    RCON_HOST="localhost" \
    RCON_PORT=27015 \
    RCON_PASSWORD=""
ENTRYPOINT ["/entrypoint.sh"]
CMD ["linuxgsm.sh"]
