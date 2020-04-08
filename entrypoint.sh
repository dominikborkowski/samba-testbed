#!/bin/sh
# Start Samba service

# Write nicely formatted log lines
log() { if [[ "$@" ]]; then echo "[CR Samba $(date +'%T')] $@"; else echo; fi; }

# Prepend lines with something
prepend() { while read line; do echo "${1}${line}"; done; }

log "Starting setup for Samba: "

# Add users from a CSV file
if [ -f ${SAMBA_USERS_FILE} ]; then
    # Protect the file, just in case if a user explores the filesystem
    chmod 600 ${SAMBA_USERS_FILE}
    # Read users, passwords, and optional content of a flag file
    while IFS="," read -r user password flag; do
        log "User: $user, password: $password, flag: $flag"
        log " Executing: useradd -m -p $(mkpasswd "$password") $user"
        useradd -m -p $(mkpasswd "$password") ${user}
        # (echo ${password}; echo ${password}) | smbpasswd -s
        echo -ne "${password}\n${password}\n" | smbpasswd -a -s ${user}

        # Create flag file in given user's home dir
        if [ ! -z ${flag} ]; then
            log " Creating ~${user}/flag.txt with following content: ${flag}"
            flag_file=$(eval "echo ~$user")/flag.txt
            echo "${flag}" >${flag_file}
            chown ${user}:${user} ${flag_file}
            chmod 600 ${flag_file}
        else
            log "NO FLAG"
        fi
    done <${SAMBA_USERS_FILE}
else
    log "User file not provided, skipping user creation"
fi

cat <<EOB
    SERVER SETTINGS
	---------------
EOB

# Print all other samba server settings
egrep -v '^#|^;|^$' /etc/samba/smb.conf | prepend "  "


# Run Samba:
log "Starting Samba daemon with:"
log " /usr/sbin/smbd --foreground --log-stdout"
/usr/sbin/smbd --foreground --log-stdout
