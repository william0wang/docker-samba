#
# Dockerfile for samba (without netbios)
#

FROM alpine:3.6

RUN apk add --update \
    samba-common-tools \
    samba-client \
    samba-server

EXPOSE 445/tcp

ENTRYPOINT ["smbd", "--foreground", "--log-stdout"]
CMD []