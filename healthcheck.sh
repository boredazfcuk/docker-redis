#!/bin/ash

if [ "$(nc -z "$(hostname -i)" 6379; echo $?)" -ne 0 ]; then
   echo "Redis server not responding on port 6379"
   exit 1
fi

echo "Redis server responding on port 6379"
exit 0