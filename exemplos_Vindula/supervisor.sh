#! /bin/sh
SUPERVISOR_PID="/opt/vindula/supervisor/var/supervisord.pid"
. /lib/lsb/init-functions

case "$1" in
    start)
        echo -n "Iniciando SUPERVISOR "
        /opt/vindula/supervisor/bin/supervisord
        log_end_msg $?
        ;;

    stop)
        echo -n "Parando SUPERVISOR"
        /opt/vindula/supervisor/bin/supervisorctl shutdown
        log_end_msg $?
        ;;
    status)
        if [ -f $SUPERVISOR_PID ]; then
            PID=`cat $SUPERVISOR_PID`
            echo "SUPERVISOR running - process $PID"
            /opt/vindula/supervisor/bin/supervisorctl status
        else
            echo "SUPERVISOR not running"
        fi
        ;;
    *)
        echo "Use: /etc/init.d/supervisord {start|stop|status}"
        exit 1
        ;;
esac

