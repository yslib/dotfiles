#!/bin/bash

# Trigger the brew_udpate event when brew update or upgrade is run from cmdline
# e.g. via function in .zshrc

brew=(
  icon=􀐛
  label=?
  padding_right=10
  script="$PLUGIN_DIR/brew.sh"
)

sketchybar --add event brew_update \
           --add item brew center   \
           --set brew "${brew[@]}" \
           --subscribe brew brew_update


status_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$POPUP_BORDER_COLOR
  background.border_width=2
)
sketchybar --add bracket status brew github.bell volume_icon \
           --set status "${status_bracket[@]}"
