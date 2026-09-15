#!/bin/bash

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="$HOME/Pictures/Screenshots"

if [[ ! -d "$OUTPUT_DIR" ]]; then
  notify-send "Screenshot directory does not exist: $OUTPUT_DIR" -u critical -t 3000
  exit 1
fi

if [ "$(command -v "hyprpicker")" ] >/dev/null 2>&1; then
    hyprpicker -r -z &
    sleep 0.2
    HYPRPICKER_PID=$!
fi

grim -g "$(slurp)" -t ppm - > /tmp/currentScreenshot
kill $HYPRPICKER_PID
satty --filename /tmp/currentScreenshot \
    --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
    --early-exit \
    --actions-on-enter save-to-clipboard \
    --save-after-copy \
    --copy-command 'wl-copy'
