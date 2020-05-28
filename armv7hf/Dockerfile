FROM balenalib/armv7hf-debian:buster
#FROM arm32v7/debian:buster

LABEL maintainer="Alexander Böhm" \ 
      url="<https://hshnet.hshproxy.duckdns.org"
	  
ENV DEBIAN_FRONTEND noninteractive

# Install prerequisites (as listed in iobroker installer.sh)
WORKDIR /etc/
COPY scripts/resolve.conf resolve.conf

WORKDIR /
RUN apt-get update && apt-get install -y \
    acl \
    apt-utils \
    build-essential \
    curl \
    git \
    jq \
    gnupg2 \
    gosu \
    libavahi-compat-libdnssd-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    libcap2-bin \
    libpam0g-dev \
    libudev-dev \
    locales \
    pkg-config \
    procps \
    python \
    python-dev \
    sudo \
    udev \
    unzip \
    wget \
    vim \
    nano \
    htop \
    mc \
    && rm -rf /var/lib/apt/lists/*

# Install node10
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get update && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Generating locales
RUN sed -i 's/^# *\(de_DE.UTF-8\)/\1/' /etc/locale.gen \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen

# Create scripts directorys and copy scripts
RUN mkdir -p /opt/scripts/ \
    && mkdir -p /opt/userscripts/ \
    && chmod 777 /opt/scripts/ \
    && chmod 777 /opt/userscripts/
WORKDIR /opt/scripts/
COPY scripts/iobroker_startup.sh iobroker_startup.sh
COPY scripts/setup_avahi.sh setup_avahi.sh
COPY scripts/setup_packages.sh setup_packages.sh
COPY scripts/setup_zwave.sh setup_zwave.sh
RUN chmod +x iobroker_startup.sh \
    && chmod +x setup_avahi.sh \
    && chmod +x setup_packages.sh \
    && chmod +x setup_zwave.sh
WORKDIR /opt/userscripts/
COPY scripts/userscript_firststart_example.sh userscript_firststart.sh
COPY scripts/userscript_everystart_example.sh userscript_everystart.sh

# Install ioBroker
WORKDIR /
RUN apt-get update \
    && curl -sL https://raw.githubusercontent.com/ioBroker/ioBroker/stable-installer/installer.sh | bash - \
    && echo $(hostname) > /opt/iobroker/.install_host \
    && echo $(hostname) > /opt/.firstrun \
    && rm -rf /var/lib/apt/lists/*

# Install node-gyp
WORKDIR /opt/iobroker/
RUN npm install -g node-gyp

# Backup initial ioBroker-folder
RUN tar -cf /opt/initial_iobroker.tar /opt/iobroker \
    && tar -cf /opt/initial_userscripts.tar /opt/userscripts

# Setting up iobroker-user (shell and home directory)
RUN chsh -s /bin/bash iobroker \
    && usermod --home /opt/iobroker iobroker

# Setting up ENVs
ENV IOB_ADMINPORT="8081" \
    IOB_OBJECTSDB_HOST="127.0.0.1" \
    IOB_OBJECTSDB_PORT="9001" \
    IOB_OBJECTSDB_TYPE="file" \
    AVAHI="true" \
    DEBIAN_FRONTEND="teletype" \
    UDEV="true" \
    LANG="de_DE.UTF-8" \
    LANGUAGE="de_DE:de" \
    LC_ALL="de_DE.UTF-8" \
    PACKAGES="ncdu pydf" \
    SETGID=1000 \
    SETUID=1000 \
    TZ="Europe/Berlin" \
    USBDEVICES="none" \
    ZWAVE="false" \
    IOB_STATESDB_HOST="172.21.10.2" \
    IOB_STATESDB_PORT="6379" \
    IOB_STATESDB_TYPE="redis"

# Run startup-script
ENTRYPOINT ["/bin/bash", "-c", "/opt/scripts/iobroker_startup.sh"]
