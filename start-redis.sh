#!/bin/ash

##### Functions #####
Initialise(){
   LANIP="$(hostname -i)"
   echo -e "\n"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    ***** Starting Redisr container *****"
#   if [ -z "${STACKUSER}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: User name not set, defaulting to 'stackman'"; STACKUSER="stackman"; fi
#   if [ -z "${STACKPASSWORD}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Password not set, defaulting to 'Skibidibbydibyodadubdub'"; STACKPASSWORD="Skibidibbydibyodadubdub"; fi
#   if [ -z "${UID}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: User ID not set, defaulting to '1000'"; UID="1000"; fi
#   if [ -z "${GROUP}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Group name not set, defaulting to 'group'"; GROUP="group"; fi
#   if [ -z "${GID}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Group ID not set, defaulting to '1000'"; GID="1000"; fi
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Local user: ${STACKUSER}:${UID}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Local group: ${GROUP}:${GID}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    CouchPotato application directory: ${APPBASE}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    CouchPotato configuration directory: ${CONFIGDIR}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Listening IP Address: ${LANIP}"
}

Configure(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure redis"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Add host setting"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Set unrar path: /usr/bin/unrar"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure library refresh interval to 12hr"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Disable usenet and torrent searchers"
   sed -i \
      -e "s/^bind .*$/bind ${LANIP}/" \
      -e 's/^\(unixsocket.*\)$/# \1/g' \
      -e 's#^logfile /var/log/.*#logfile /dev/stdout#' \
      -e "s#^tcp-backlog .*#tcp-backlog $(cat /proc/sys/net/core/somaxconn)#" \
      -e "s#^vm.overcommit_memory = .*#vm.overcommit_memory = 1#" \
      "/etc/redis.conf"
#      -e 's/^\(daemonize .*\)$/# \1/' \
}

LaunchRedis(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Starting Redis"
   redis-server /etc/redis.conf
#   su -m "${STACKUSER}" -c 'python '"${APPBASE}/CouchPotato.py"' --data_dir '"${CONFIGDIR}"' --config_file '"${CONFIGDIR}/couchpotato.ini"' --console_log'
}

##### Script #####
Initialise
Configure
LaunchRedis