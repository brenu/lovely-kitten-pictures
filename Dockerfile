FROM amd64/ubuntu:20.04

#Installing and configuring dependencies

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

RUN sed -i "s|KeepAlive On|KeepAlive Off |g" /etc/apache2/apache2.conf
RUN sed -i "s|Options Indexes FollowSymLinks|Options -Indexes |g" /etc/apache2/apache2.conf
RUN printf "ServerName localhost" >> /etc/apache2/apache2.conf

RUN sed -i "s|ServerTokens OS|ServerTokens Prod |g" /etc/apache2/conf-available/security.conf
RUN sed -i "s|ServerSignature On|ServerSignature Off |g" /etc/apache2/conf-available/security.conf

# Copying the project's content

COPY src /var/www/html
RUN chmod -R 755 /var/www/html && rm -rf /var/www/html/index.html

# Compiling Lovely Kitten Data

RUN go build -o /var/www/html/cat_info/main /var/www/html/cat_info/main.go

#Creating users

RUN groupadd -g 997 administrators \
    && useradd -u 997 -g 997 -d /home/admin/ -m -p admin -s /bin/bash admin

RUN groupadd -g 1000 commonusers \
    && useradd -u 1000 -g 1000 -d /home/level1/ -m -p level1 -s /bin/bash level1

RUN echo "admin:Ql6EjcgeU58DUrSTBmKsOk8uJKyIS6sf6sgMuMpK" | chpasswd
RUN echo "level1:J0ZzgRLCxu3WeWAzCI8Zd5QFOmMaPfSDkNlIrR8b" | chpasswd

RUN chmod 0550 /home/admin && chmod 0550 /home/level1

# Privesc

RUN echo "www-data ALL=(ALL) NOPASSWD:/bin/su level1" > /etc/sudoers.d/challenge
RUN echo "level1 ALL=(admin) NOPASSWD:/usr/bin/git pull" >> /etc/sudoers.d/challenge

# Adding nologin to root

RUN sed -i "s|root:x:0:0:root:/root:/bin/bash|root:x:0:0:root:/root:/sbin/nologin |g" /etc/passwd

# Adding flags

RUN printf "1337UP{K1TT3N_F1L3_R34D}" > /flag1.txt && chmod 0444 /flag1.txt
RUN echo "1337UP{K1TT3N_BYP4SS_W1TH_4T_CH4R4CT3R}" > /flag2.txt && chmod 0444 /flag2.txt
RUN echo "1337UP{SUP3R_34SY_K1TT3N_PR1V3SC}" > /home/level1/flag3.txt && chmod 0444 /home/level1/flag3.txt
RUN echo "1337UP{1TS_TH3_F1N4L_K1TT3N}" > /home/admin/flag4.txt && chmod 0444 /home/admin/flag4.txt

ENTRYPOINT service apache2 start && /bin/bash