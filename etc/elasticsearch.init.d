#! /bin/sh
### BEGIN INIT INFO
# Provides:          elasticsearch
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts elasticsearch
# Description:       Starts elasticsearch using start-stop-daemon
### END INIT INFO

ES_HOME=/usr/local/elasticsearch
ES_MIN_MEM=256m
ES_MAX_MEM=2g
DAEMON=$ES_HOME/bin/elasticsearch
NAME=elasticsearch
DESC=elasticsearch
PID_FILE=/var/run/$NAME.pid
LOG_DIR=/var/log/$NAME
DATA_DIR=/var/lib/$NAME
WORK_DIR=/tmp/$NAME
CONFIG_FILE=/etc/$NAME/elasticsearch.yml
DAEMON_OPTS="-p $PID_FILE -Des.config=$CONFIG_FILE -Des.path.home=$ES_HOME -Des.path.logs=$LOG_DIR -Des.path.data=$DATA_DIR -Des.path.work=$WORK_DIR"


test -x $DAEMON || exit 0

set -e

case "$1" in
  start)
    echo -n "Starting $DESC: "
    mkdir -p $LOG_DIR $DATA_DIR $WORK_DIR
    if start-stop-daemon --start --pidfile $PID_FILE --startas $DAEMON -- $DAEMON_OPTS
    then
        echo "started."
    else
        echo "failed."
    fi
    ;;
  stop)
    echo -n "Stopping $DESC: "
    if start-stop-daemon --stop --pidfile $PID_FILE
    then
        echo "stopped."
    else
        echo "failed."
    fi
    ;;
  restart|force-reload)
    ${0} stop
    sleep 0.5
    ${0} start
    ;;
  *)
    N=/etc/init.d/$NAME
    echo "Usage: $N {start|stop|restart|force-reload}" >&2
    exit 1
    ;;
esac

exit 0