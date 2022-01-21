FROM amd64/ubuntu:20.04

ENV CONTAINER_TIMEZONE="Europe/Brussels"

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN apt update

RUN apt install -y \
    apache2 \
    php \
    libapache2-mod-php

RUN useradd -d /home/level1/ -m -p level1 -s /bin/bash level1
RUN echo "level1:level1" | chpasswd

ENTRYPOINT service apache2 start && /bin/bash