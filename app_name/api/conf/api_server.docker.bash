#!/bin/bash

NAME="api_server"
APPDIR=/app/
SOCKFILE=/app/app_name/api/servers/run/gunicorn.sock
USER=root
GROUP=root
NUM_WORKERS=3
APPDIR=/app/app_name/api/servers/
NAME=api_server

echo "Starting $NAME as `whoami`"

export PYTHONPATH=$APPDIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
cd $APPDIR/app_name/api/servers
exec gunicorn api_server:app \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=debug \
  --log-file=/var/log/app_name/api.log \
  --limit-request-line 16376 \
  --timeout 120 --graceful-timeout 60 \
