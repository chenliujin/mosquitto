FROM centos:latest

MAINTAINER chenliujin <liujin.chen@qq.com>

# 1.修改时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
 
RUN adduser mosquitto

ENV MOSQUITTO_VERSION=v1.4.14

RUN buildDeps='git make gcc gcc-c++ openssl-devel c-ares-devel libwebsockets-devel libuuid-devel libxslt docbook-style-xsl'; \
    mkdir -p /var/lib/mosquitto && chown -R mosquitto:mosquitto /var/lib/mosquitto/ && \
    mkdir -p /var/log/mosquitto && chown -R mosquitto:mosquitto /var/log/mosquitto/ && \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y $buildDeps libwebsockets libuuid c-ares openssl && \
    git clone https://github.com/eclipse/mosquitto.git && \
    cd mosquitto && \
    git checkout ${MOSQUITTO_VERSION} -b ${MOSQUITTO_VERSION} && \
    sed -i "s@/usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl@/usr/share/sgml/docbook/xsl-stylesheets-1.78.1/manpages/docbook.xsl@" man/manpage.xsl && \
    make WITH_WEBSOCKETS=yes && \
    make install && \
    cd / && rm -rf mosquitto && \
    yum erase -y epel-release $buildDeps && \
    yum clean all; 

COPY ./etc/mosquitto		/etc/mosquitto
COPY ./etc/systemd			/etc/systemd
#COPY /etc/mosquitto/mosquitto.conf		/etc/mosquitto/mosquitto.conf
#COPY /etc/mosquitto/mosquitto.passwd		/etc/mosquitto/mosquitto.passwd
#COPY /etc/mosquitto/mosquitto.acl		/etc/mosquitto/mosquitto.acl
#COPY /etc/mosquitto/ssl/server.crt		/etc/mosquitto/ssl/server.crt
#COPY /etc/mosquitto/ssl/server.key		/etc/mosquitto/ssl/server.key
#COPY /usr/lib/systemd/system/mosquitto.service 	/usr/lib/systemd/system/mosquitto.service

RUN systemctl enable mosquitto

VOLUME ["/var/lib/mosquitto", "/etc/mosquitto", "/var/log/mosquitto"]

EXPOSE 1883 8883 9001 9002

CMD ["/usr/sbin/init"]

#RUN exit;
#
#RUN addgroup -S mosquitto && \
#    adduser -S -H -h /var/empty -s /sbin/nologin -D -G mosquitto mosquitto
#
#ENV PATH=/usr/local/bin:/usr/local/sbin:$PATH
#ENV MOSQUITTO_VERSION=v1.4.14
#
#COPY run.sh /
#COPY libressl.patch /
##RUN buildDeps='git build-base alpine-sdk openssl-dev libwebsockets-dev c-ares-dev util-linux-dev hiredis-dev curl-dev libxslt docbook-xsl'; \
#RUN buildDeps='git build-base libressl-dev libwebsockets-dev c-ares-dev util-linux-dev hiredis-dev curl-dev docbook-xsl'; \
#    chmod +x /run.sh && \
#    mkdir -p /var/lib/mosquitto && \
#    touch /var/lib/mosquitto/.keep && \
#    mkdir -p /etc/mosquitto.d && \
#    apk update && \
#    apk add $buildDeps hiredis libwebsockets libuuid c-ares libressl curl ca-certificates && \
#    git clone https://github.com/eclipse/mosquitto.git && \
#    cd mosquitto && \
#    git checkout ${MOSQUITTO_VERSION} -b ${MOSQUITTO_VERSION} && \
#    sed -i -e "s|(INSTALL) -s|(INSTALL)|g" -e 's|--strip-program=${CROSS_COMPILE}${STRIP}||' */Makefile */*/Makefile && \
#    sed -i "s@/usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl@/usr/share/xml/docbook/xsl-stylesheets-1.79.1/manpages/docbook.xsl@" man/manpage.xsl && \
#    sed -i 's/ -lanl//' config.mk && \
#    patch -p1 < /libressl.patch && \
#    make WITH_MEMORY_TRACKING=no WITH_SRV=yes WITH_WEBSOCKETS=yes WITH_TLS_PSK=no && \
#    make install && \
#    git clone git://github.com/jpmens/mosquitto-auth-plug.git && \
#    cd mosquitto-auth-plug && \
#    cp config.mk.in config.mk && \
#    sed -i "s/BACKEND_REDIS ?= no/BACKEND_REDIS ?= yes/" config.mk && \
#    sed -i "s/BACKEND_HTTP ?= no/BACKEND_HTTP ?= yes/" config.mk && \
#    sed -i "s/BACKEND_MYSQL ?= yes/BACKEND_MYSQL ?= no/" config.mk && \
#    sed -i "s/MOSQUITTO_SRC =/MOSQUITTO_SRC = ..\//" config.mk && \
#    sed -i "s/EVP_MD_CTX_new/EVP_MD_CTX_create/g" cache.c && \
#    sed -i "s/EVP_MD_CTX_free/EVP_MD_CTX_destroy/g" cache.c && \
#    make && \
#    cp auth-plug.so /usr/local/lib/ && \
#    cp np /usr/local/bin/ && chmod +x /usr/local/bin/np && \
#    cd / && rm -rf mosquitto && rm /libressl.patch && \
#    apk del $buildDeps && rm -rf /var/cache/apk/*
#
#ADD mosquitto.conf /etc/mosquitto/mosquitto.conf
#
#ENTRYPOINT ["/run.sh"]
#CMD ["mosquitto"]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#FROM debian:jessie
#
#RUN apt-get update -y && apt-get upgrade -y
#RUN apt-get install -y curl
#
## add Mosquitto repository key
#RUN curl http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -
#
## add repository to sources.list.d
#RUN curl http://repo.mosquitto.org/debian/mosquitto-jessie.list > /etc/apt/sources.list.d/mosquitto-jessie.list
#RUN apt-get update -y
#
## finally install 
#RUN apt-get install -y --no-install-recommends mosquitto mosquitto-clients
#
## add a user
#RUN adduser --system --disabled-password --disabled-login mosquitto
#RUN mkdir /config && chown mosquitto -R /config
#USER mosquitto
#
## expose a volumne for config and certs
#VOLUME /config
#
## expose ports (normal unencrypted, TLS encrypted, WS encrypted)
#EXPOSE 1883 8883 8080
#
## start mosquitto as main process
#CMD ["mosquitto", "-c", "/config/mosquitto.conf"]
