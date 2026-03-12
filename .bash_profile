#
# ~/.bash_profile
#

# --- 1. Load Personal Aliases/Functions ---
# Documentation: login shells do not automatically load .bashrc.
# This ensures interactive settings are available after login.
[[ -f ~/.bashrc ]] && . ~/.bashrc

# --- 2. Wayland / Toolkit Settings ---
# These ensure apps use Wayland natively where supported.
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec start-hyprland
fi
