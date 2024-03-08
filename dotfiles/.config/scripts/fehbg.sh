#!/bin/sh

# Set a random background
for x in $(seq 10); do
    WALLPAPER="$(find ~/.config/wallpapers/ -type f ! -path '*/.git/*' | shuf -n1)"
    feh --bg-fill --no-fehbg "$WALLPAPER" 2>/dev/null &&
    break
done
