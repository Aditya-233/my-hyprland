#!/bin/bash

# Use LLM to figure out how to use this script with a UDEV rule such that it happens whenever you plug, unplug the charger
STATE=$(cat /sys/class/power_supply/ACAD/online)

[[ "$STATE" -eq 1 ]] && powerprofilesctl set performance || powerprofilesctl set power-saver
