#!/bin/bash
LOG_DIR=/var/log/server-stats
HISTORY_LEN=2016 # seconds
JSONIFY=tsm-jsonify-log
WWW_DATA=/var/www/server-stats
CPU_OUTPUT=$WWW_DATA/cpu.json
MEMORY_OUTPUT=$WWW_DATA/memory.json
HTTP_REQUEST_OUTPUT=$WWW_DATA/http.json
NOW=`date +%Y-%m`
LAST=`date --date="last month" +%Y-%m`
CPU_INPUT=cpu-$NOW.log cpu-$LAST.log
MEMORY_INPUT=memory-$NOW.log memory-$LAST.log
HTTP_REQUEST_INPUT=http-requests-$NOW.log http-requests-$LAST.log
# cpu
cat $CPU_INPUT | tail -n $HISTOR_LEN | $JSONIFY > $CPU_OUTPUT
# memory
cat $MEMORY_INPUT | tail -n $HISTOR_LEN | $JSONIFY > $MEMORY_OUTPUT
# http requests
cat $HTTP_REQUEST_INPUT | tail -n $HISTOR_LEN | $JSONIFY > $HTTP_REQUEST_OUTPUT
