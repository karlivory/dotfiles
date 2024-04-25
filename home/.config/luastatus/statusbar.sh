#!/bin/bash
# ~/.config/luastatus/module/apt.lua \

luastatus -b dwm -B separator= \
    ~/.config/luastatus/module/battery.lua \
    ~/.config/luastatus/module/volume.lua \
    ~/.config/luastatus/module/mem-usage.lua \
    ~/.config/luastatus/module/network-rate.lua \
    ~/.config/luastatus/module/time-date.lua

