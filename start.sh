#!/bin/bash

# Init log functions

log_info() {
    echo "$(date --rfc-3339=ns -u) INFO $1"
}

log_warning() {
    echo "$(date --rfc-3339=ns -u) WARNING $1"
}

log_error() {
    echo "$(date --rfc-3339=ns -u) ERROR $1"
}

# Check environment vars
log_info "Checking required environment variables"
if [[ -n "${DDSERVER}" || -n "${DDUSER}" || -n "${DDPASSWORD}" || -n "${DOMAINS}" || -n "${INTERVAL}"]]; then
 log_error "One or more variables have not been set, quitting..";
 exit 1
fi

# Creating ddclient config file
log_info "Creating ddclient configuration file"
cat << EOF > ddclient.cfg
daemon=${INTERVAL}
syslog=no
pid=/var/run/ddclient.pid
ssl=yes
use=web, web=checkip.dynu.com/, web-skip='IP Address'
server=${DDSERVER}
protocol=dyndns2
login=${DDUSERNAME}
password=${DDPASSWORD}
$(echo $DOMAINS | sed 's/,/\n/g')
EOF

echo "Starting ddclient in daemon mode"
ddclient -file ddclient.cfg &

# Wait for any process to exit
wait -n

# Exit with status of process
exit $?
