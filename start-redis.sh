#!/bin/ash

##### Functions #####
Initialise(){
   lan_ip="$(hostname -i)"
   echo -e "\n"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    ***** Starting Redisr container *****"
#   if [ -z "${stack_user}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: User name not set, defaulting to 'stackman'"; stack_user="stackman"; fi
#   if [ -z "${stack_password}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Password not set, defaulting to 'Skibidibbydibyodadubdub'"; stack_password="Skibidibbydibyodadubdub"; fi
#   if [ -z "${user_id}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: User ID not set, defaulting to '1000'"; user_id="1000"; fi
#   if [ -z "${GROUP}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Group name not set, defaulting to 'group'"; GROUP="group"; fi
#   if [ -z "${GID}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: Group ID not set, defaulting to '1000'"; GID="1000"; fi
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Local user: ${stack_user}:${user_id}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Local group: ${GROUP}:${GID}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    CouchPotato application directory: ${app_base_dir}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    CouchPotato configuration directory: ${config_dir}"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Listening IP Address: ${lan_ip}"
}

Configure(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure redis"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Add host setting"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Set unrar path: /usr/bin/unrar"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure library refresh interval to 12hr"
#   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Disable usenet and torrent searchers"
   sed -i \
      -e "s/^bind .*$/bind ${lan_ip}/" \
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
#   su -m "${stack_user}" -c 'python '"${app_base_dir}/CouchPotato.py"' --data_dir '"${config_dir}"' --config_file '"${config_dir}/couchpotato.ini"' --console_log'
}

##### Script #####
Initialise
Configure
LaunchRedis