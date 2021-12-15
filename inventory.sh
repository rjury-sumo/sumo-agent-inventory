#!/bin/bash
set -e

POST="${SUMO_POST:-true}"

FILE='./inventory.txt'
if test -f "$FILE"; then
    echo "removing output file: $FILE exists."
    rm "$FILE"
fi

ENDPOINT="${SUMO_ENDPOINT:=https://api.au.sumologic.com/api/v1/}"
ID="${SUMO_ACCESS_ID:=provide_a_valid_SUMO_ACCESS_ID}"
KEY="${SUMO_ACCESS_KEY:=provide_a_valid_SUMO_ACCESS_KEY}"
HTTP="${SUMO_HTTPS:=provide_a_valid_SUMO_HTTPS}"

PARAMS="-listVersions -output=json"

if [ -z "$SUMO_FILTER" ]; then echo "NULL"; else PARAMS="$PARAMS -filter $SUMO_FILTER"; fi

echo "endpoint: $ENDPOINT ID: $ID POST: $HTTP"
echo "params: $PARAMS"
echo "SUMO_POST: $POST"
python sumo_mgmt.py -url=$ENDPOINT -accessid=$ID -accesskey=$KEY $PARAMS &> $FILE

if $POST ; then curl -X POST -T $FILE $HTTP ; fi