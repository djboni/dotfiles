#!/bin/bash
set -e

usage() {
    echo "\
Usage: screen.sh [-c]
-c, --change       change the configuration
-f, --force-mirror force mirror
-h, --help         display help message

With no options, this program, loads the configuration and ajdusts the screen.

With the option --change (or -c), opens arandr to configura the screen, when
it closes, the configuration is read and saved.

The configuration is kept in the file ~/.config/scripts/cfg_screen.txt.
"
}

OPT_FILE=~/.config/scripts/cfg_screen.txt
OPT_CHANGE=
OPT_FORCE_MIRROR=

while [ $# -ne 0 ]; do
    case "$1" in
    -c | --change)
        OPT_CHANGE=1
        ;;
    -f | --force-mirror)
        OPT_FORCE_MIRROR=1
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

ALL_SCREENS="$(xrandr | grep -Ew 'connected' | sort -u | sed -E 's/(\w+) .*/\1/;s/$/\\n/g' | tr -cd '[:print:]')"
# Example: eDP-1\nHDMI-1-0\n

if [ ! -z "$OPT_FORCE_MIRROR" ]; then
    OLDIFS="$IFS"
    IFS=$'\n'
    XRANDR_CMD="xrandr"
    FIRST_SCREEN=
    for LINE in $(echo -ne "$ALL_SCREENS"); do
        SCREEN="$LINE"

        XRANDR_CMD="$XRANDR_CMD --output $SCREEN --auto"
        if [ -z "$FIRST_SCREEN" ]; then
            FIRST_SCREEN="$SCREEN"
        else
            XRANDR_CMD="$XRANDR_CMD --same-as $FIRST_SCREEN"
        fi
    done

    IFS="$OLDIFS"
    set -x
    $XRANDR_CMD
    { set +x; } 2>/dev/null

    if [ -z "$OPT_CHANGE" ]; then
        exit 0
    fi
fi

if [ ! -z "$OPT_CHANGE" ]; then
    arandr
    SCREEN_CONFIG="$(xrandr | grep -Ew 'connected' | sort -u | sed -E 's/(\w+) connected( primary)? ?([0-9x+]+)? .*/\1~\3/;s/$/\\n/g' | tr -cd '[:print:]')"
    # Example: eDP-1~1920x1080+2560+360\nHDMI-1-0~2560x1440+0+0\n

    CONFIG_LINE="$(
        grep -Fv "$ALL_SCREENS~" "$OPT_FILE" || true
        echo "$ALL_SCREENS~$SCREEN_CONFIG"
    )"
    echo "$CONFIG_LINE" >"$OPT_FILE"
else
    # Get the configuration for the current monitors.
    # We are using ~ as field separator.
    CONFIG_LINE="$(grep -F "$ALL_SCREENS~" "$OPT_FILE" || true)"

    # Extract the configuration
    if [ -z "$CONFIG_LINE" ]; then
        # The configuration for these monitors does not exist yet.
        # Use the default configuration (zero) and write it to the configuration
        # file.
        SCREEN_CONFIG="$(xrandr | grep -Ew 'connected' | sort -u | sed -E 's/(\w+) connected( primary)? ?([0-9x+]+)? .*/\1~\3/;s/$/\\n/g' | tr -cd '[:print:]')"
        echo "$ALL_SCREENS~$SCREEN_CONFIG" >>"$OPT_FILE"
    else
        SCREEN_CONFIG="$(echo "$CONFIG_LINE" | cut -f2- -d~)"
    fi
fi

OLDIFS="$IFS"
IFS=$'\n'
XRANDR_CMD="xrandr"
for LINE in $(echo -ne "$SCREEN_CONFIG"); do
    SCREEN="$(echo "$LINE" | cut -f1 -d'~')"
    CONFIG="$(echo "$LINE" | cut -f2 -d'~')"

    if [ -z "$CONFIG" ]; then
        XRANDR_CMD="$XRANDR_CMD --output $SCREEN --off"
    else
        MODE="$(echo "$CONFIG" | cut -f1 -d+)"
        POS="$(echo "$CONFIG" | cut -f2- -d+ | tr + x)"
        XRANDR_CMD="$XRANDR_CMD --output $SCREEN --auto --mode $MODE --pos $POS"
    fi
done

IFS="$OLDIFS"
set -x
$XRANDR_CMD
{ set +x; } 2>/dev/null
