#!/bin/bash

usage() {
    echo "\
Usage: adjust_orientation.sh [-c] [-r]

--change|-c  change the configuration
 --reset|-r  reset the configuration
  --help|-h  display help message

With no options, this program, loads the configuration and ajdusts the screen.

With the option --change (or -c), changes the configuration and adjusts the
screen. For one monitor there is only one configuration. For two monitors
there are a few: mirror, extended, swapped extended, only screen 1, only
screen 2.

With the option --reset (or -r), resets the configuration and adjusts the
screen.

The configuration is kept in the file ~/.config/scripts/adjust_orientation.cfg.
" >&2
}

ALL_MON="$(xrandr | grep -wE '(dis)?connected' | cut -d' ' -f1 | sort -u)"
ALL_NUM="$(echo "$ALL_MON" | wc -l)"
ALL_MON="$(echo $ALL_MON)"

#MON="$(xrandr --listmonitors | grep -E '^\s*[0-9]+:' | sed -E 's,.*\s(\S+),\1,')"
MON="$(xrandr | grep -wE 'connected' | cut -d' ' -f1 | sort -u)"
NUM="$(echo "$MON" | wc -l)"
MON="$(echo $MON)"

echo "ALL: $ALL_NUM ($ALL_MON)" >&2
echo "ACTIVE: $NUM ($MON)" >&2

OPT_FILE=~/.config/scripts/adjust_orientation.cfg
OPT_CHANGE=
OPT_RESET=

while [ $# -ne 0 ]; do
    case "$1" in
    -c | --change)
        OPT_CHANGE=1
        ;;
    -r | --reset)
        OPT_CHANGE=1
        OPT_RESET=1
        ;;
    -h | --help)
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
    # The configuration for these monitors does not exist yet.
    # Use the default configuration (zero) and write it to the configuration
    # file.
    CONFIG=0
    echo "$MON~$CONFIG" >>"$OPT_FILE"
else
    CONFIG="$(echo "$CONFIG_LINE" | cut -f2 -d~)"
fi

# Change the configuration if requested
if [ ! -z "$OPT_CHANGE" ]; then
    # Number of possible modes for each number of monitors
    case "$NUM" in
    2) MODES=6 ;; # 1x Custom + 2x Extended + 2x Single + 1x Mirror
    *) MODES=1 ;; # 1x Single
    esac

    # Reset the configuration if requested
    if [ ! -z "$OPT_RESET" ]; then
        CONFIG=0
    else
        CONFIG="$(((CONFIG + 1) % MODES))"
    fi

    CONFIG_LINE="$(
        grep -v "^$MON~" "$OPT_FILE"
        echo "$MON~$CONFIG"
    )"
    echo "$CONFIG_LINE" >"$OPT_FILE"
fi

# Print the current configuration
echo "CONFIG_LINE=\"$CONFIG_LINE\"" >&2

# Default handler (for 1 monitor or ANY number of monitors)
set_position_N() {
    set -x
    xrandr --auto
}

# Handler for 2 monitors
set_position_2() {
    case "$CONFIG" in
    # Custom per hostname
    0)
        case $(hostname -s) in
        butters)
            set -x
            case "$CONFIG" in
            # Extend
            0)
                #xrandr \
                #    --output $2 --auto --mode 3840x2160 --pos 0x0 \
                #    --output $1 --auto --mode 1920x1080 --pos 3840x1080
                xrandr \
                    --output $2 --auto --mode 2560x1440 --pos 0x0 \
                    --output $1 --auto --mode 1920x1080 --pos 2560x360
                #xrandr \
                #    --output $2 --auto --mode 1920x1080 --pos 0x0 \
                #    --output $1 --auto --mode 1920x1080 --pos 1920x0
                ;;
            # Mirror
            *) xrandr --output $2 --auto --output $1 --auto --same-as $2 ;;
            esac
            ;;
        esac
        ;;
    # Extend
    1) xrandr --output $2 --auto --output $1 --auto --right-of $2 ;;
    2) xrandr --output $2 --auto --output $1 --auto --left-of $2 ;;
    # Single screen
    3) xrandr --output $2 --auto --output $1 --off ;;
    4) xrandr --output $2 --off --output $1 --auto ;;
    # Mirror
    *) xrandr --output $2 --auto --output $1 --auto --same-as $2 ;;
    esac
}

# Update the monitors according to the configuration
case $NUM in
1) set_position_N $MON ;;
2) set_position_2 $MON ;;
*)
    echo "WARNING: Number of monitors $NUM not implemented. Using automatic mode." >&2
    set_position_N $MON
    ;;
esac
