#
# Dockerfile for samba (without netbios)
#

FROM alpine:3.6

RUN apk add --update \
    samba-common-tools \
    samba-client \
    samba-server

# install samba and supervisord and clear the cache afterwards
RUN apk add samba samba-common-tools supervisor && rm -rf /var/cache/apk/*

# create a dir for the config and the share
RUN mkdir /config /shared

# copy config files from project folder to get a default config going for samba and supervisord
COPY *.conf /config/

# add a non-root user and group called "hsb" with no password, no home dir, no shell, and gid/uid set to 1000
RUN addgroup -g 1000 hsb && adduser -D -H -G hsb -s /bin/false -u 1000 hsb

# create a samba user matching our user from above with a very simple password ("bjhsb")
RUN echo -e "bjhsb\nbjhsb" | smbpasswd -a -s -c /config/smb.conf hsb

EXPOSE 137/udp 138/udp 139 445

# volume mappings
VOLUME /config /shared

ENTRYPOINT ["supervisord", "-c", "/config/supervisord.conf"]