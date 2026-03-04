#!/bin/bash

# 1. Variables
WALL_DIR="$HOME/Pictures/Wallpapers"
LINK_PATH="$HOME/.config/hypr/current_wallpaper"

# 2. Get Current Filename
CURRENT_WALL=$(basename "$(readlink -f "$LINK_PATH")")

# 3. Get the Next File
# We list files, find the current one, and take the 1 line after it (-A 1)
NEXT_WALL=$(ls -1 "$WALL_DIR" | grep -A 1 "^$CURRENT_WALL$" | tail -n 1)

# 4. Wrap Around Logic
# If NEXT_WALL is the same as CURRENT_WALL, we were at the end of the list.
# In that case, we just grab the very first file in the directory.
if [[ "$NEXT_WALL" == "$CURRENT_WALL" ]]; then
    NEXT_WALL=$(ls -1 "$WALL_DIR" | head -n 1)
fi

# 5. Apply
ln -sf "$WALL_DIR/$NEXT_WALL" "$LINK_PATH"
pkill swaybg
swaybg -i "$LINK_PATH" -m fill &
