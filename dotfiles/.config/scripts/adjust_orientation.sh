#!/bin/sh

usage() {
    echo "\
Usage: adjust_orientation.sh [-r] [-H]

    --help|-h  display help message
 --reverse|-r  reverse left and right
--hostname|-H  use personal configuration for the hostname

Description:

When you have 2 monitors connected, they may not be in the correct
orientation in the display manager (left or right of eachother).

Try calling this script and if it does not fix try calling with -r.
"
}

ALL_MON="$(xrandr | grep connected | cut -d' ' -f1)"
ALL_NUM="$(echo "$ALL_MON" | wc -l)"
ALL_MON="$(echo $ALL_MON)"

#MON="$(xrandr --listmonitors | grep -E '^\s*[0-9]+:' | sed -E 's,.*\s(\S+),\1,')"
MON="$(xrandr | grep '\sconnected' | cut -d' ' -f1)"
NUM="$(echo "$MON" | wc -l)"
MON="$(echo $MON)"

ORIENTATION=--right-of

while [ $# -ne 0 ]; do
    case "$1" in
        -H|--hostname)
            case "$(hostname)" in
                stan*)
                    ORIENTATION=--right-of
                    ;;
                butters*)
                    ORIENTATION=--right-of
                    ;;
                *)
                    echo "Unknown hostname '$2'"
                    exit 1
                    ;;
            esac
            ;;
        -r|--reverse) # Reverse orientation
            if [ $ORIENTATION = --left-of ]; then
                ORIENTATION=--right-of
            else
                ORIENTATION=--left-of
            fi
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option '$1'"
            exit 1
            ;;
    esac
    shift
done

set_position_1() {
    : # Nothing to do
}

set_position_2() {
    set -x
    xrandr --output $1 --auto $ORIENTATION $2
}

echo "ALL: $ALL_NUM ($ALL_MON)"
echo "ACTIVE: $NUM ($MON)"

case $NUM in
    1)
        set_position_1 $MON
        ;;
    2)
        set_position_2 $MON
        ;;
    *)
        echo "Number of monitors $NUM not implemented"
        exit 1
        ;;
esac
