#!/bin/bash

BIN_TARGET=/usr/local/bin
LOG_DIR=/var/log/server-stats
TMP_FILE=tiny-server-monitor-tmp.tmp
HTTP_ACCESS_LOG=$LOG_DIR/http-requests.log
case $1 in
    nginx)
        # assuing nginx is installed into /etc/nginx/
	
        TEST=`grep -R "$HTTP_ACCESS_LOG" /etc/nginx/* | head -n 1`
        if [[ "$TEST" =~ access_log ]]
        then
            echo "Your nginx writes access log also into server-stats directory."
        else
            echo "Your nginx does not write access log into $LOG_DIR"
            echo "It is required for http request monitoring"
            echo "Note that your normal access logs are untouched"
            echo ""
            echo "To configure your nginx server, please add this following line next to your normal 'access_log' configuration"
            echo ""
            echo "  access_log  $HTTP_ACCESS_LOG;"
            echo ""
            echo "Note: do not remove anything from nginx configurations, you just need to add this line"
            exit
        fi;;
    *)
        echo "type 'install.sh nginx' for installing http request monitoring for nginx"
        exit;;
esac

# install binaries
echo "Copying binaries..."
cp bin/* $BIN_TARGET
if [ $? != 0 ]; then
    echo "Unable to copy binaries to $BIN_TARGET"
    exit;
fi
chmod a+x $BIN_TARGET/tsm-mem-stats
chmod a+x $BIN_TARGET/tsm-cpu-stats
chmod a+x $BIN_TARGET/tsm-http-stats
if [ $? != 0 ]; then
    echo "Unable to change attributes for binaries in $BIN_TARGET"
    exit;
fi
echo "Binaries copied to $BIN_TARGET"
# create log directory
mkdir -p $LOG_DIR
if [ $? != 0 ]; then
    echo "Unable to create directory $LOG_DIR"
    exit;
fi
chmod a+rx $LOG_DIR
echo "Directory for server logs created at $LOG_DIR"
# install crontab
echo "Installing cronjobs..."
crontab -l > $TMP_FILE
cp $TMP_FILE crontab.original
echo "# Following lines are added by tiny-server-monitor (http://github.com/tuomasj/tiny-server-monitor)" >> $TMP_FILE
echo "*/5 * * * * $BIN_TARGET/tsm-cpu-stats > /dev/null 2>&1" >> $TMP_FILE
echo "*/5 * * * * $BIN_TARGET/tsm-mem-stats > /dev/null 2>&1" >> $TMP_FILE
echo "*/5 * * * * $BIN_TARGET/tsm-http-stats > /dev/null 2>&1" >> $TMP_FILE
crontab $TMP_FILE
if [ $? != 0 ]; then
    echo "Unable to replace crontab from file $TMP_FILE"
    exit;
fi
rm $TMP_FILE
echo "Added three cronjobs"
echo "Original crontab file saved as crontab.original"
echo "---"
echo "Everything is done"
echo "Please restart your webserver"
