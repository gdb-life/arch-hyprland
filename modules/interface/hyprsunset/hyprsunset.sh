#!/bin/bash

DAY_TEMP=6000
NIGHT_TEMP=4000

LATITUDE="53.9006N"
LONGITUDE="27.5590E"

get_times() {
    times=$(sunwait list civil $LATITUDE $LONGITUDE)
    sunrise=$(echo "$times" | grep -oE '[0-9]{2}:[0-9]{2}' | head -n 1)
    sunset=$(echo "$times" | grep -oE '[0-9]{2}:[0-9]{2}' | tail -n 1)
}

is_night() {
    now=$(date +%H:%M)
    if [[ "$now" > "$sunset" ]] || [[ "$now" < "$sunrise" ]]; then
        return 0 # night
    else
        return 1 # day
    fi
}

while true; do
    get_times
    if is_night; then
        hyprsunset --temperature $NIGHT_TEMP
    else
        hyprsunset --temperature $DAY_TEMP
    fi
    sleep 600
done

