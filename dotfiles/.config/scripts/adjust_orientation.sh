#!/bin/sh

usage() {
    echo "\
Usage: adjust_orientation.sh [-c]

  --help|-h  display help message
--change|-c  change the configuration
 --reset|-r  reset the configuration

Description:

The configuration is read from ~/.config/scripts/adjust_orientation.cfg.

Use the option -c to change the current configuration and update the file.
" >&2
}

ALL_MON="$(xrandr | grep connected | cut -d' ' -f1 | sort -u)"
ALL_NUM="$(echo "$ALL_MON" | wc -l)"
ALL_MON="$(echo $ALL_MON)"

#MON="$(xrandr --listmonitors | grep -E '^\s*[0-9]+:' | sed -E 's,.*\s(\S+),\1,')"
MON="$(xrandr | grep '\sconnected' | cut -d' ' -f1 | sort -u)"
NUM="$(echo "$MON" | wc -l)"
MON="$(echo $MON)"

echo "ALL: $ALL_NUM ($ALL_MON)" >&2
echo "ACTIVE: $NUM ($MON)" >&2

OPT_FILE=~/.config/scripts/adjust_orientation.cfg
OPT_CHANGE=
OPT_RESET=

while [ $# -ne 0 ]; do
    case "$1" in
        -c|--change)
            OPT_CHANGE=1
            ;;
        -r|--reset)
            OPT_CHANGE=1
            OPT_RESET=1
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

# Check if the configuration file exists
if [ ! -f "$OPT_FILE" ]; then
    touch "$OPT_FILE"
fi

# Get the configuration for the current monitors.
# We are using ~ as field separator.
CONFIG_LINE="$(grep "^$MON~" "$OPT_FILE")"

# Extract the configuration
if [ -z "$CONFIG_LINE" ]; then
    # The configuration for these monitors does not exit yet.
    # Use the default configuration (zero) and create the file.
    CONFIG=0
    echo "$MON~$CONFIG" >>"$OPT_FILE"
else
    CONFIG="$(echo "$CONFIG_LINE" | cut -f2 -d~)"
fi

# Change the configuration if requested
if [ ! -z "$OPT_CHANGE" ]; then
    # Modes is double the number of monitors because of (2*NUM) single monitor
    # and extended modes. Add one to the number (2*NUM+1) because of mirror
    # mode.
    case "$NUM" in
        2) MODES=5 ;; # 2x Extended + 2x Single + 1x Mirror
        *) MODES=1 ;; # 1x Extended
    esac

    # Reset the configuration if requested
    if [ ! -z "$OPT_RESET" ]; then
        CONFIG=0
    else
        CONFIG="$(( (CONFIG + 1) % MODES ))"
    fi

    CONFIG_LINE="$(grep -v "^$MON~" "$OPT_FILE"; echo "$MON~$CONFIG")"
    echo "$CONFIG_LINE" >"$OPT_FILE"
fi

# Print the current configuration
echo "CONFIG_LINE=$CONFIG_LINE" >&2

# 1 or ANY number of monitors
set_position_N() {
    set -x
    xrandr --auto
}

# 2 monitors
set_position_2() {
    set -x
    case "$CONFIG" in
        # Extend screens
        1) xrandr --auto && xrandr --output $1 --right-of $2 ;;
        2) xrandr --auto && xrandr --output $1 --left-of  $2 ;;
        # Single screen
        3) xrandr --auto && xrandr --output $1       --output $2 --off ;;
        4) xrandr --auto && xrandr --output $1 --off --output $2 ;;
        # Mirror screens
        *) xrandr --auto && xrandr --output $1 --same-as $2 ;;
    esac
}

# Update the monitors according to the configuration
case $NUM in
    1) set_position_N $MON ;;
    2) set_position_2 $MON ;;
    *) echo "WARNING: Number of monitors $NUM not implemented. Using automatic mode." >&2
       set_position_N $MON
       ;;
esac
