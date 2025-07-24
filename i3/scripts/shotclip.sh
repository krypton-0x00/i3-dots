#!/bin/bash
maim -s | xclip -selection clipboard -t image/png
notify-send "Screenshot" "Region copied to clipboard"

