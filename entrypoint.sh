#!/bin/ash

##### Functions #####
Initialise(){
   lan_ip="$(hostname -i)"
   echo
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # ***** Configuring Redis container launch environment *****"
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # $(cat /etc/*-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/"//g')"
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Listening IP Address: ${lan_ip}"
   if [ "${REDIS_HOST_PASSWORD}" ]; then
      echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Redis password: ${REDIS_HOST_PASSWORD}"
   else
      echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Error - Please configure Redis password. Container will restart in 5 minutes"
      sleep 300
      exit 1
   fi
}

Configure(){
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Bind to listening address"
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Disable UNIX sockets"
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Log to /dev/stdout"
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Set size of tcp backlog queue"
   sed -i \
      -e "s/^bind .*$/bind ${lan_ip}/" \
      -e 's/^\(unixsocket.*\)$/# \1/g' \
      -e 's#^logfile /var/log/.*#logfile /dev/stdout#' \
      -e "s#^tcp-backlog .*#tcp-backlog $(cat /proc/sys/net/core/somaxconn)#" \
      "/etc/redis.conf"
}

LaunchRedis(){
   echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # ***** Configuration of Redis container launch environment complete *****"
   if [ -z "${1}" ]; then
      echo "$$:E $(date '+%d %b %Y %H:%M:%S.%3N') # Start Redis"
      exec redis-server /etc/redis.conf --requirepass "${REDIS_HOST_PASSWORD}" 
   else
      exec "$@"
   fi
}

##### Script #####
Initialise
Configure
LaunchRedis