FROM amd64/ubuntu:20.04

#Installing dependencies

ENV CONTAINER_TIMEZONE="Europe/Brussels"
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN apt update && apt install -y \
    apache2 \
    php \
    libapache2-mod-php \
    golang-go \
    wget \
    git \
    nano \
    sudo

#Creating users

RUN groupadd -g 997 administrators
RUN useradd -u 997 -g 997 -d /home/admin/ -m -p admin -s /bin/bash admin

RUN groupadd -g 1000 commonusers
RUN useradd -u 1000 -g 1000 -d /home/level1/ -m -p level1 -s /bin/bash level1

RUN echo "admin:Ql6EjcgeU58DUrSTBmKsOk8uJKyIS6sf6sgMuMpK" | chpasswd
RUN echo "level1:J0ZzgRLCxu3WeWAzCI8Zd5QFOmMaPfSDkNlIrR8b" | chpasswd

RUN chmod 750 /home/admin
RUN chmod 750 /home/level1

# Privesc

RUN echo "www-data ALL=(ALL) NOPASSWD:/bin/su level1" > /etc/sudoers.d/challenge
RUN echo "level1 ALL=(admin) NOPASSWD:/usr/bin/git pull" >> /etc/sudoers.d/challenge

# Adding nologin to root

RUN sed -i "s|root:x:0:0:root:/root:/bin/bash|root:x:0:0:root:/root:/sbin/nologin |g" /etc/passwd

# Adding flags

RUN printf "1337UP{K1TT3N_F1L3_R34D}" > /flag1.txt
RUN echo "1337UP{K1TT3N_BYP4SS_W1TH_4T_CH4R4CT3R}" > /flag2.txt
RUN echo "1337UP{SUP3R_34SY_K1TT3N_PR1V3SC}" > /home/level1/flag3.txt
RUN echo "1337UP{1TS_TH3_F1N4L_K1TT3N}" > /home/admin/flag4.txt

ENTRYPOINT service apache2 start && /bin/bash