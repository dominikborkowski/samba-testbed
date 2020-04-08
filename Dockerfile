FROM alpine:3.10
RUN apk --no-cache --update add samba-common-tools samba-client samba-server shadow && \
    sed -i '/^CREATE_MAIL_SPOOL/s/yes/no/' /etc/default/useradd && \
    mkdir -p /public/guest /shares/public /public/other && \
    rm -rf /var/cache/apk/*

# default settings, can be overwritten via docker-compose
ENV \
    SAMBA_USERS_FILE=/smb-users.csv

COPY entrypoint.sh /entrypoint.sh
COPY smb.conf /etc/samba/smb.conf
COPY samba-users.csv /samba-users.csv

EXPOSE 139 445

ENTRYPOINT ["/entrypoint.sh"]
