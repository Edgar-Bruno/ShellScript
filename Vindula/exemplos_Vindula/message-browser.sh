#!/bin/bash

### BEGIN INIT INFO
# Provides:          scriptname
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

c=1
while [ "$c" -eq 1 ]
do
	nc -z localhost 8080
	c=$?

	if [ "$c" -eq 0 ]; then
		/usr/bin/firefox --display=:0.0 -new-window http://vindula.intranet
	fi
	sleep 1
done

