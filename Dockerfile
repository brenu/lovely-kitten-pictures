FROM amd64/ubuntu:20.04

ENV CONTAINER_TIMEZONE="Europe/Brussels"

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN apt update
RUN apt install -y \
    apache2 \
    php \
    libapache2-mod-php \
    golang-go \
    wget \
    git \
    nano \
    sudo

RUN useradd -d /home/level1/ -m -p level1 -s /bin/bash level1
RUN useradd -d /home/level2/ -m -p level2 -s /bin/bash level2

RUN echo "level1:J0ZzgRLCxu3WeWAzCI8Zd5QFOmMaPfSDkNlIrR8b" | chpasswd
RUN echo "level2:Ql6EjcgeU58DUrSTBmKsOk8uJKyIS6sf6sgMuMpK" | chpasswd

RUN chmod 700 /home/level1
RUN chmod 700 /home/level2

# Privesc
RUN echo "www-data ALL=(ALL) NOPASSWD:/bin/su level1" > /etc/sudoers.d/challenge
RUN echo "level1 ALL=(ALL) NOPASSWD:/usr/bin/git pull" >> /etc/sudoers.d/challenge

RUN sudo passwd -l root

ENTRYPOINT service apache2 start && /bin/bash